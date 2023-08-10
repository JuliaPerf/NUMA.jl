# arity 0 functions
"$(TYPEDSIGNATURES)Highest node number available on the system"
numa_max_node() = Int(LibNuma.numa_max_node() + 1)
"$(TYPEDSIGNATURES)Preferred NUMA node of the current task"
numa_preferred() = Int(LibNuma.numa_preferred() + 1)
"$(TYPEDSIGNATURES)Sets the memory allocation policy for the calling task to local allocation"
numa_set_localalloc() = (LibNuma.numa_set_localalloc())
"$(TYPEDSIGNATURES)Returns the number of bytes in a page"
numa_pagesize() = Int(LibNuma.numa_pagesize())
"$(TYPEDSIGNATURES)Number of the highest possible node in a system"
numa_max_possible_node() = Int(LibNuma.numa_max_possible_node() + 1)
"""
$(TYPEDSIGNATURES)
Returns the size of kernel's node mask, i.e. large enough to represent the maximum number of
nodes that the kernel can handle
"""
numa_num_possible_nodes() = Int(LibNuma.numa_num_possible_nodes())
numa_num_possible_cpus() = Int(LibNuma.numa_num_possible_cpus())
numa_num_configured_nodes() = Int(LibNuma.numa_num_configured_nodes())
numa_num_configured_cpus() = Int(LibNuma.numa_num_configured_cpus())
numa_num_task_cpus() = Int(LibNuma.numa_num_task_cpus())
numa_num_thread_cpus() = Int(LibNuma.numa_num_thread_cpus())
"$(TYPEDSIGNATURES)Is this a NUMA system?"
numa_available() = LibNuma.numa_available() != -1

numa_get_interleave_mask() = Bitmask(LibNuma.numa_get_interleave_mask())
"""
$(TYPEDSIGNATURES)
Returns a bitmask of a size equal to the kernel's node mask.
In other words, large enough to represent all nodes.
"""
numa_allocate_nodemask() = Bitmask(LibNuma.numa_allocate_nodemask()) # TODO: finalizer?
"""
$(TYPEDSIGNATURES)
Returns a bitmask of a size equal to the kernel's cpu mask.
In other words, large enough to represent all cpus.
"""
numa_allocate_cpumask() = Bitmask(LibNuma.numa_allocate_cpumask())  # TODO: finalizer?
"$(TYPEDSIGNATURES)Returns the mask of nodes from which memory can currently be allocated"
numa_get_membind() = Bitmask(LibNuma.numa_get_membind())
"""
$(TYPEDSIGNATURES)
Returns the mask of nodes from which the process is allowed to allocate memory in it's
current cpuset context
"""
numa_get_mems_allowed() = Bitmask(LibNuma.numa_get_mems_allowed())
numa_get_run_node_mask() = Bitmask(LibNuma.numa_get_run_node_mask())

# arity 1 functions
"$(TYPEDSIGNATURES)Returns the NUMA node that the cpu with the given id (starting at zero) belongs to."
numa_node_of_cpu(cpuid::Integer=current_cpu()) = LibNuma.numa_node_of_cpu(cpuid) + 1

"""
$(TYPEDSIGNATURES)
Returns a named tuple holding the total memory and free memory of the given NUMA node.
If no node index is provided as an argument, `current_numa_node()` is used.
"""
function numa_node_size(node::Integer=current_numa_node())
    @boundscheck if node < 0 || node > nnumanodes()
        throw(ArgumentError("Invalid NUMA node index. Must be >= 1 and <= $(nnumanodes())."))
    end
    freep = Ref(zero(Clonglong))
    nodesize = LibNuma.numa_node_size(node - 1, freep)
    if nodesize == -1 || freep[] == -1
        throw(ErrorException("Couldn't query size of NUMA node (libnuma returned -1). Did you perhaps provide an illegal NUMA index?"))
    end
    return (memtot=nodesize, memfree=freep[])
end

"""
$(TYPEDSIGNATURES)
Allocates a bitmask structure and its associated bit mask. The memory allocated for the bit
mask contains enough words (type `UInt64`) to contain `n` bits.
If `n` isn't provided, `nnumanodes()` is used.

The bit mask is zero-filled.
"""
numa_bitmask_alloc(n::Integer=nnumanodes()) = Bitmask(LibNuma.numa_bitmask_alloc(n))

"$(TYPEDSIGNATURES)Set the `n`-th bit of the given `Bitmask`."
function numa_bitmask_setbit!(bm::Bitmask, n::Integer)
    @boundscheck if n > bm.size
        throw(BoundsError(bm, n))
    end
    LibNuma.numa_bitmask_setbit(bm.ptr, n - 1)
    return nothing
end

"$(TYPEDSIGNATURES)Clear the `n`-th bit of the given `Bitmask`."
function numa_bitmask_clearbit!(bm::Bitmask, n::Integer)
    @boundscheck if n > bm.size
        throw(BoundsError(bm, n))
    end
    LibNuma.numa_bitmask_clearbit(bm.ptr, n - 1)
    return nothing
end

"$(TYPEDSIGNATURES)Set all bits in the given `Bitmask` to zero."
function numa_bitmask_clearall!(bm::Bitmask)
    LibNuma.numa_bitmask_clearall(bm.ptr)
    return nothing
end

"$(TYPEDSIGNATURES)Set all bits in the given `Bitmask` to one."
function numa_bitmask_setall!(bm::Bitmask)
    LibNuma.numa_bitmask_setall(bm.ptr)
    return nothing
end

"""
$(TYPEDSIGNATURES)
Sets the memory allocation mask. The task will only allocate memory from the nodes set in
the given nodemask. Passing an empty nodemask or a nodemask that contains nodes other than
those in the mask returned by `numa_get_mems_allowed()` will result in an error.
"""
function numa_set_membind(bm::Bitmask)
    LibNuma.numa_set_membind(bm.ptr)
    return nothing
end
function numa_set_membind(nodes::AbstractVector{<:Integer})
    @boundscheck if !all(n -> n > 0 && n <= nnumanodes(), nodes)
        throw(ArgumentError("Invalid node number encountered."))
    end
    bm = numa_allocate_nodemask()
    for n in nodes
        bm[n] = 1
    end
    return numa_set_membind(bm)
end

numa_bitmask_free(bm::Bitmask) = LibNuma.numa_bitmask_free(bm.ptr)
