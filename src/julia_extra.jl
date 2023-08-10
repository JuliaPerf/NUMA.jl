"""
Returns the ID (starting at zero) of the CPU-thread on which the calling Julia thread is
currently running on.
"""
current_cpu() = sched_getcpu()

"""
Returns the IDs (starting at zero) of the CPU-threads on which the Julia threads are
currently running on.
"""
function current_cpus()
    nt = Threads.nthreads()
    cpuids = zeros(Int, nt)
    Threads.@threads :static for i in 1:nt
        cpuids[i] = current_cpu()
    end
    return cpuids
end

"""
Returns the NUMA node associated with the CPU-thread on which the calling Julia thread is
currently running on.
"""
current_numa_node() = numa_node_of_cpu(current_cpu())

"""
Returns the NUMA nodes associated with the CPU-threads on which the Julia threads are
currently running on.
"""
function current_numa_nodes()
    nt = Threads.nthreads()
    numanodes = zeros(Int, nt)
    Threads.@threads :static for i in 1:nt
        numanodes[i] = current_numa_node()
    end
    return numanodes
end

"Returns the number of NUMA nodes available on this system."
nnumanodes() = numa_num_configured_nodes()

"Returns the number CPU-threads available on this system."
ncpus() = numa_num_configured_cpus()

function numainfo()
    numcpus = ncpus()
    println("numa available: ", numa_available())
    println("num numa nodes: ", nnodes())
    println("num cpus: ", numcpus)
    # numa_set_localalloc();

    # bm_ptr = numa_bitmask_alloc(numcpus)
    # bm = unsafe_load(bm_ptr)
    # for i in 0:numa_max_node()
    #     numa_node_to_cpus(i, bm_ptr)
    #     println("numa node $i: ", bm)
    #     # println("numa node $i: ", bm, " (node size: ", numa_node_size(i, 0), ")")
    # end
    # numa_bitmask_free(bm_ptr)
    return nothing
end

"""
$(TYPEDSIGNATURES)
Query on which NUMA node the given array is allocated (assuming that it is allocated on a
single node).

Technically only the address of a single element is checked (by default the first one).
The optional second integer argument can be used to specify this element.

The optional keyword argument `variant` can be used to switch between methods used to
determine the NUMA node. Valid options are `:move_pages` (default) and `:get_mempolicy`.

Note: Returned NUMA node IDs start at zero!
"""
function which_numa_node(arr::AbstractArray, i=1; kwargs...)
    which_numa_node(pointer(arr, i); kwargs...)
end

"""
$(TYPEDSIGNATURES)
Query on which NUMA node the page associated with the given memory address (pointer) is
located.

The optional keyword argument `variant` can be used to switch between methods used to
determine the NUMA node. Valid options are `:move_pages` (default) and `:get_mempolicy`.

Note: Returned NUMA node IDs start at zero!
"""
function which_numa_node(ptr::Ptr{T}; variant=:move_pages) where {T}
    if !(variant in (:move_pages, :get_mempolicy))
        throw(ArgumentError("Unknown variant. Allowed variants are `:move_pages` and `:get_mempolicy`."))
    end
    return which_numa_node(Val(variant), ptr)
end

function which_numa_node(::Val{:move_pages}, ptr::Ptr{T}) where {T}
    if !(T == Nothing)
        ptr_nothing = Ptr{Nothing}(ptr)
    else
        ptr_nothing = ptr
    end
    status = fill(Cint(-1), 1)
    ret = LibNuma.move_pages(0, 1, Ref(ptr_nothing), C_NULL, status, 0)
    result = Int(status[1] + 1)
    if ret != 0
        error("Received non-zero return code, indicating failure.")
    end
    if result < 0
        error("Couldn't retrieve NUMA node. Is the memory fully initialized, i.e. have you written to it yet?")
    end
    return result
end

function which_numa_node(::Val{:get_mempolicy}, ptr::Ptr{T}) where {T}
    if !(T == Nothing)
        ptr_nothing = Ptr{Nothing}(ptr)
    else
        ptr_nothing = ptr
    end
    numa_node = Ref(Cint(-1))
    ret = LibNuma.get_mempolicy(numa_node, C_NULL, 0, ptr_nothing, LibNuma.MPOL_F_NODE | LibNuma.MPOL_F_ADDR)
    result = Int(numa_node[] + 1)
    # TODO: return code handling
    if result < 0
        error("Couldn't retrieve NUMA node. Is the memory fully initialized, i.e. have you written to it yet?")
    end
    return result
end
