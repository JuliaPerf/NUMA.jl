module LibNuma
# Autogenerated with Clang.jl, see /gen

using NUMA_jll

const __pid_t = Cint

const pid_t = __pid_t

struct nodemask_t
    n::NTuple{2, Culong}
end

struct bitmask
    size::Culong
    maskp::Ptr{Culong}
end

function numa_bitmask_isbitset(arg1, arg2)
    ccall((:numa_bitmask_isbitset, libnuma), Cint, (Ptr{bitmask}, Cuint), arg1, arg2)
end

function numa_bitmask_setall(arg1)
    ccall((:numa_bitmask_setall, libnuma), Ptr{bitmask}, (Ptr{bitmask},), arg1)
end

function numa_bitmask_clearall(arg1)
    ccall((:numa_bitmask_clearall, libnuma), Ptr{bitmask}, (Ptr{bitmask},), arg1)
end

function numa_bitmask_setbit(arg1, arg2)
    ccall((:numa_bitmask_setbit, libnuma), Ptr{bitmask}, (Ptr{bitmask}, Cuint), arg1, arg2)
end

function numa_bitmask_clearbit(arg1, arg2)
    ccall((:numa_bitmask_clearbit, libnuma), Ptr{bitmask}, (Ptr{bitmask}, Cuint), arg1, arg2)
end

function numa_bitmask_nbytes(arg1)
    ccall((:numa_bitmask_nbytes, libnuma), Cuint, (Ptr{bitmask},), arg1)
end

function numa_bitmask_weight(arg1)
    ccall((:numa_bitmask_weight, libnuma), Cuint, (Ptr{bitmask},), arg1)
end

function numa_bitmask_alloc(arg1)
    ccall((:numa_bitmask_alloc, libnuma), Ptr{bitmask}, (Cuint,), arg1)
end

function numa_bitmask_free(arg1)
    ccall((:numa_bitmask_free, libnuma), Cvoid, (Ptr{bitmask},), arg1)
end

function numa_bitmask_equal(arg1, arg2)
    ccall((:numa_bitmask_equal, libnuma), Cint, (Ptr{bitmask}, Ptr{bitmask}), arg1, arg2)
end

function copy_nodemask_to_bitmask(arg1, arg2)
    ccall((:copy_nodemask_to_bitmask, libnuma), Cvoid, (Ptr{nodemask_t}, Ptr{bitmask}), arg1, arg2)
end

function copy_bitmask_to_nodemask(arg1, arg2)
    ccall((:copy_bitmask_to_nodemask, libnuma), Cvoid, (Ptr{bitmask}, Ptr{nodemask_t}), arg1, arg2)
end

function copy_bitmask_to_bitmask(arg1, arg2)
    ccall((:copy_bitmask_to_bitmask, libnuma), Cvoid, (Ptr{bitmask}, Ptr{bitmask}), arg1, arg2)
end

function nodemask_zero(mask)
    ccall((:nodemask_zero, libnuma), Cvoid, (Ptr{nodemask_t},), mask)
end

function nodemask_zero_compat(mask)
    ccall((:nodemask_zero_compat, libnuma), Cvoid, (Ptr{nodemask_t},), mask)
end

function nodemask_set_compat(mask, node)
    ccall((:nodemask_set_compat, libnuma), Cvoid, (Ptr{nodemask_t}, Cint), mask, node)
end

function nodemask_clr_compat(mask, node)
    ccall((:nodemask_clr_compat, libnuma), Cvoid, (Ptr{nodemask_t}, Cint), mask, node)
end

function nodemask_isset_compat(mask, node)
    ccall((:nodemask_isset_compat, libnuma), Cint, (Ptr{nodemask_t}, Cint), mask, node)
end

function nodemask_equal(a, b)
    ccall((:nodemask_equal, libnuma), Cint, (Ptr{nodemask_t}, Ptr{nodemask_t}), a, b)
end

function nodemask_equal_compat(a, b)
    ccall((:nodemask_equal_compat, libnuma), Cint, (Ptr{nodemask_t}, Ptr{nodemask_t}), a, b)
end

function numa_available()
    ccall((:numa_available, libnuma), Cint, ())
end

function numa_max_node()
    ccall((:numa_max_node, libnuma), Cint, ())
end

function numa_max_possible_node()
    ccall((:numa_max_possible_node, libnuma), Cint, ())
end

function numa_preferred()
    ccall((:numa_preferred, libnuma), Cint, ())
end

function numa_node_size64(node, freep)
    ccall((:numa_node_size64, libnuma), Clonglong, (Cint, Ptr{Clonglong}), node, freep)
end

function numa_node_size(node, freep)
    ccall((:numa_node_size, libnuma), Clonglong, (Cint, Ptr{Clonglong}), node, freep)
end

function numa_pagesize()
    ccall((:numa_pagesize, libnuma), Cint, ())
end

function numa_bind(nodes)
    ccall((:numa_bind, libnuma), Cvoid, (Ptr{bitmask},), nodes)
end

function numa_set_interleave_mask(nodemask)
    ccall((:numa_set_interleave_mask, libnuma), Cvoid, (Ptr{bitmask},), nodemask)
end

function numa_get_interleave_mask()
    ccall((:numa_get_interleave_mask, libnuma), Ptr{bitmask}, ())
end

function numa_allocate_nodemask()
    ccall((:numa_allocate_nodemask, libnuma), Ptr{bitmask}, ())
end

function numa_free_nodemask(b)
    ccall((:numa_free_nodemask, libnuma), Cvoid, (Ptr{bitmask},), b)
end

function numa_set_preferred(node)
    ccall((:numa_set_preferred, libnuma), Cvoid, (Cint,), node)
end

function numa_set_localalloc()
    ccall((:numa_set_localalloc, libnuma), Cvoid, ())
end

function numa_set_membind(nodemask)
    ccall((:numa_set_membind, libnuma), Cvoid, (Ptr{bitmask},), nodemask)
end

function numa_get_membind()
    ccall((:numa_get_membind, libnuma), Ptr{bitmask}, ())
end

function numa_get_mems_allowed()
    ccall((:numa_get_mems_allowed, libnuma), Ptr{bitmask}, ())
end

function numa_get_interleave_node()
    ccall((:numa_get_interleave_node, libnuma), Cint, ())
end

function numa_alloc_interleaved_subset(size, nodemask)
    ccall((:numa_alloc_interleaved_subset, libnuma), Ptr{Cvoid}, (Csize_t, Ptr{bitmask}), size, nodemask)
end

function numa_alloc_interleaved(size)
    ccall((:numa_alloc_interleaved, libnuma), Ptr{Cvoid}, (Csize_t,), size)
end

function numa_alloc_onnode(size, node)
    ccall((:numa_alloc_onnode, libnuma), Ptr{Cvoid}, (Csize_t, Cint), size, node)
end

function numa_alloc_local(size)
    ccall((:numa_alloc_local, libnuma), Ptr{Cvoid}, (Csize_t,), size)
end

function numa_alloc(size)
    ccall((:numa_alloc, libnuma), Ptr{Cvoid}, (Csize_t,), size)
end

function numa_realloc(old_addr, old_size, new_size)
    ccall((:numa_realloc, libnuma), Ptr{Cvoid}, (Ptr{Cvoid}, Csize_t, Csize_t), old_addr, old_size, new_size)
end

function numa_free(mem, size)
    ccall((:numa_free, libnuma), Cvoid, (Ptr{Cvoid}, Csize_t), mem, size)
end

function numa_interleave_memory(mem, size, mask)
    ccall((:numa_interleave_memory, libnuma), Cvoid, (Ptr{Cvoid}, Csize_t, Ptr{bitmask}), mem, size, mask)
end

function numa_tonode_memory(start, size, node)
    ccall((:numa_tonode_memory, libnuma), Cvoid, (Ptr{Cvoid}, Csize_t, Cint), start, size, node)
end

function numa_tonodemask_memory(mem, size, mask)
    ccall((:numa_tonodemask_memory, libnuma), Cvoid, (Ptr{Cvoid}, Csize_t, Ptr{bitmask}), mem, size, mask)
end

function numa_setlocal_memory(start, size)
    ccall((:numa_setlocal_memory, libnuma), Cvoid, (Ptr{Cvoid}, Csize_t), start, size)
end

function numa_police_memory(start, size)
    ccall((:numa_police_memory, libnuma), Cvoid, (Ptr{Cvoid}, Csize_t), start, size)
end

function numa_run_on_node_mask(mask)
    ccall((:numa_run_on_node_mask, libnuma), Cint, (Ptr{bitmask},), mask)
end

function numa_run_on_node_mask_all(mask)
    ccall((:numa_run_on_node_mask_all, libnuma), Cint, (Ptr{bitmask},), mask)
end

function numa_run_on_node(node)
    ccall((:numa_run_on_node, libnuma), Cint, (Cint,), node)
end

function numa_get_run_node_mask()
    ccall((:numa_get_run_node_mask, libnuma), Ptr{bitmask}, ())
end

function numa_set_bind_policy(strict)
    ccall((:numa_set_bind_policy, libnuma), Cvoid, (Cint,), strict)
end

function numa_set_strict(flag)
    ccall((:numa_set_strict, libnuma), Cvoid, (Cint,), flag)
end

function numa_num_possible_nodes()
    ccall((:numa_num_possible_nodes, libnuma), Cint, ())
end

function numa_num_possible_cpus()
    ccall((:numa_num_possible_cpus, libnuma), Cint, ())
end

function numa_num_configured_nodes()
    ccall((:numa_num_configured_nodes, libnuma), Cint, ())
end

function numa_num_configured_cpus()
    ccall((:numa_num_configured_cpus, libnuma), Cint, ())
end

function numa_num_task_cpus()
    ccall((:numa_num_task_cpus, libnuma), Cint, ())
end

function numa_num_thread_cpus()
    ccall((:numa_num_thread_cpus, libnuma), Cint, ())
end

function numa_num_task_nodes()
    ccall((:numa_num_task_nodes, libnuma), Cint, ())
end

function numa_num_thread_nodes()
    ccall((:numa_num_thread_nodes, libnuma), Cint, ())
end

function numa_allocate_cpumask()
    ccall((:numa_allocate_cpumask, libnuma), Ptr{bitmask}, ())
end

function numa_free_cpumask(b)
    ccall((:numa_free_cpumask, libnuma), Cvoid, (Ptr{bitmask},), b)
end

function numa_node_to_cpus(arg1, arg2)
    ccall((:numa_node_to_cpus, libnuma), Cint, (Cint, Ptr{bitmask}), arg1, arg2)
end

function numa_node_to_cpu_update()
    ccall((:numa_node_to_cpu_update, libnuma), Cvoid, ())
end

function numa_node_of_cpu(cpu)
    ccall((:numa_node_of_cpu, libnuma), Cint, (Cint,), cpu)
end

function numa_distance(node1, node2)
    ccall((:numa_distance, libnuma), Cint, (Cint, Cint), node1, node2)
end

function numa_error(wherestr)
    ccall((:numa_error, libnuma), Cvoid, (Ptr{Cchar},), wherestr)
end

function numa_migrate_pages(pid, from, to)
    ccall((:numa_migrate_pages, libnuma), Cint, (Cint, Ptr{bitmask}, Ptr{bitmask}), pid, from, to)
end

function numa_move_pages(pid, count, pages, nodes, status, flags)
    ccall((:numa_move_pages, libnuma), Cint, (Cint, Culong, Ptr{Ptr{Cvoid}}, Ptr{Cint}, Ptr{Cint}, Cint), pid, count, pages, nodes, status, flags)
end

function numa_sched_getaffinity(arg1, arg2)
    ccall((:numa_sched_getaffinity, libnuma), Cint, (pid_t, Ptr{bitmask}), arg1, arg2)
end

function numa_sched_setaffinity(arg1, arg2)
    ccall((:numa_sched_setaffinity, libnuma), Cint, (pid_t, Ptr{bitmask}), arg1, arg2)
end

function numa_parse_nodestring(arg1)
    ccall((:numa_parse_nodestring, libnuma), Ptr{bitmask}, (Ptr{Cchar},), arg1)
end

function numa_parse_nodestring_all(arg1)
    ccall((:numa_parse_nodestring_all, libnuma), Ptr{bitmask}, (Ptr{Cchar},), arg1)
end

function numa_parse_cpustring(arg1)
    ccall((:numa_parse_cpustring, libnuma), Ptr{bitmask}, (Ptr{Cchar},), arg1)
end

function numa_parse_cpustring_all(arg1)
    ccall((:numa_parse_cpustring_all, libnuma), Ptr{bitmask}, (Ptr{Cchar},), arg1)
end

function numa_set_interleave_mask_compat(nodemask)
    ccall((:numa_set_interleave_mask_compat, libnuma), Cvoid, (Ptr{nodemask_t},), nodemask)
end

# undefinied symbol?
function numa_get_interleave_mask_compat()
    ccall((:numa_get_interleave_mask_compat, libnuma), nodemask_t, ())
end

function numa_bind_compat(mask)
    ccall((:numa_bind_compat, libnuma), Cvoid, (Ptr{nodemask_t},), mask)
end

function numa_set_membind_compat(mask)
    ccall((:numa_set_membind_compat, libnuma), Cvoid, (Ptr{nodemask_t},), mask)
end

# undefinied symbol?
function numa_get_membind_compat()
    ccall((:numa_get_membind_compat, libnuma), nodemask_t, ())
end

function numa_alloc_interleaved_subset_compat(size, mask)
    ccall((:numa_alloc_interleaved_subset_compat, libnuma), Ptr{Cvoid}, (Csize_t, Ptr{nodemask_t}), size, mask)
end

function numa_run_on_node_mask_compat(mask)
    ccall((:numa_run_on_node_mask_compat, libnuma), Cint, (Ptr{nodemask_t},), mask)
end

# undefinied symbol?
function numa_get_run_node_mask_compat()
    ccall((:numa_get_run_node_mask_compat, libnuma), nodemask_t, ())
end

function numa_interleave_memory_compat(mem, size, mask)
    ccall((:numa_interleave_memory_compat, libnuma), Cvoid, (Ptr{Cvoid}, Csize_t, Ptr{nodemask_t}), mem, size, mask)
end

function numa_tonodemask_memory_compat(mem, size, mask)
    ccall((:numa_tonodemask_memory_compat, libnuma), Cvoid, (Ptr{Cvoid}, Csize_t, Ptr{nodemask_t}), mem, size, mask)
end

function numa_sched_getaffinity_compat(pid, len, mask)
    ccall((:numa_sched_getaffinity_compat, libnuma), Cint, (pid_t, Cuint, Ptr{Culong}), pid, len, mask)
end

function numa_sched_setaffinity_compat(pid, len, mask)
    ccall((:numa_sched_setaffinity_compat, libnuma), Cint, (pid_t, Cuint, Ptr{Culong}), pid, len, mask)
end

function numa_node_to_cpus_compat(node, buffer, buffer_len)
    ccall((:numa_node_to_cpus_compat, libnuma), Cint, (Cint, Ptr{Culong}, Cint), node, buffer, buffer_len)
end

function get_mempolicy(mode, nmask, maxnode, addr, flags)
    ccall((:get_mempolicy, libnuma), Clong, (Ptr{Cint}, Ptr{Culong}, Culong, Ptr{Cvoid}, Cuint), mode, nmask, maxnode, addr, flags)
end

function mbind(start, len, mode, nmask, maxnode, flags)
    ccall((:mbind, libnuma), Clong, (Ptr{Cvoid}, Culong, Cint, Ptr{Culong}, Culong, Cuint), start, len, mode, nmask, maxnode, flags)
end

function set_mempolicy(mode, nmask, maxnode)
    ccall((:set_mempolicy, libnuma), Clong, (Cint, Ptr{Culong}, Culong), mode, nmask, maxnode)
end

function migrate_pages(pid, maxnode, frommask, tomask)
    ccall((:migrate_pages, libnuma), Clong, (Cint, Culong, Ptr{Culong}, Ptr{Culong}), pid, maxnode, frommask, tomask)
end

function move_pages(pid, count, pages, nodes, status, flags)
    ccall((:move_pages, libnuma), Clong, (Cint, Culong, Ptr{Ptr{Cvoid}}, Ptr{Cint}, Ptr{Cint}, Cint), pid, count, pages, nodes, status, flags)
end

const LIBNUMA_API_VERSION = 2

const NUMA_NUM_NODES = 128

const MPOL_DEFAULT = 0

const MPOL_PREFERRED = 1

const MPOL_BIND = 2

const MPOL_INTERLEAVE = 3

const MPOL_LOCAL = 4

const MPOL_MAX = 5

const MPOL_F_NODE = 1 << 0

const MPOL_F_ADDR = 1 << 1

const MPOL_F_MEMS_ALLOWED = 1 << 2

const MPOL_MF_STRICT = 1 << 0

const MPOL_MF_MOVE = 1 << 1

const MPOL_MF_MOVE_ALL = 1 << 2

end # module
