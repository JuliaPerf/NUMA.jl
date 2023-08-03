function numa_free(arr::AbstractArray)
    numa_free(arr, sizeof(arr))
end

current_numa_node() = numa_node_of_cpu(sched_getcpu())

current_cpu() = sched_getcpu()

nnumanodes() = numa_max_node()+1

ncpus() = numa_num_task_cpus()

numa_isavailable() = numa_available() != -1

function numainfo()
    numcpus = ncpus()
    println("numa available: ", numa_isavailable())
    println("num numa nodes: ", nnodes())
    println("num cpus: ", numcpus)
    numa_set_localalloc();

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

function which_numa_node(arr::AbstractArray, i=1; kwargs...)
    which_numa_node(pointer(arr, i); kwargs...)
end

function which_numa_node(ptr::Ptr{T}; variant=:move_pages) where {T}
    if !(variant in (:move_pages, :get_mempolicy))
        throw(ArgumentError("Unknown variant. Allowed variants are `:move_pages` and `:get_mempolicy`."))
    end
    which_numa_node(Val(variant), ptr)
end

function which_numa_node(::Val{:move_pages}, ptr::Ptr{T}) where {T}
    if !(T == Nothing)
        ptr_nothing = Ptr{Nothing}(ptr)
    else
        ptr_nothing = ptr
    end
    status = fill(Cint(-1), 1)
    ret = move_pages(0, 1, Ref(ptr_nothing), C_NULL, status, 0)
    if ret != 0
        error("Received non-zero return code, indicating failure.")
    end
    return status[1]
end

function which_numa_node(::Val{:get_mempolicy}, ptr::Ptr{T}) where {T}
    if !(T == Nothing)
        ptr_nothing = Ptr{Nothing}(ptr)
    else
        ptr_nothing = ptr
    end
    numa_node = Ref(Cint(-1))
    get_mempolicy(numa_node, C_NULL, 0, ptr_nothing, MPOL_F_NODE | MPOL_F_ADDR)
    return numa_node[]
end
