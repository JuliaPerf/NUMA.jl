const WRAPPER_DIRECT = [
    "numa_max_node", # zero-based index
    "numa_preferred", # zero-based index
    "numa_set_localalloc",
    "numa_pagesize",
    "numa_max_possible_node",
    "numa_num_possible_nodes",
    "numa_num_possible_cpus",
    "numa_num_configured_nodes",
    "numa_num_configured_cpus",
    "numa_num_task_cpus",
    "numa_num_thread_cpus",
]
for name in names(LibNuma; all=true)
    if string(name) in WRAPPER_DIRECT
        @eval $(name)() = LibNuma.$(name)()
    end
end

# arity 0 functions
const WRAPPER_RETURNS_BITMASK_ARITY0 = [
    "numa_get_interleave_mask",
    "numa_allocate_nodemask", # TODO: add finalizer?
    "numa_allocate_cpumask", # TODO: add finalizer?
    "numa_get_membind",
    "numa_get_mems_allowed",
    "numa_get_run_node_mask"
]
for name in names(LibNuma; all=true)
    if string(name) in WRAPPER_RETURNS_BITMASK_ARITY0
        expr = quote
            function $(name)()
                bmptr = LibNuma.$(name)()
                return bitmaskptr_to_NUMABitmask(bmptr)
            end
        end
        eval(expr)
    end
end

numa_free(arr::AbstractArray) = LibNuma.numa_free(arr, sizeof(arr))

"Is this a NUMA system?"
numa_available() = LibNuma.numa_available() != -1

# arity 1 functions
numa_node_of_cpu(cpu=current_cpu()) = LibNuma.numa_node_of_cpu(cpu)
