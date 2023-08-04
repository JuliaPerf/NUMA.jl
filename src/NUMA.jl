module NUMA

include("utils.jl")
include("libnuma.jl")
include("julia.jl")
include("arrayalloc.jl")

# exports
const PREFIXES = ["numa", "MPOL_"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

export current_numa_node,
       current_cpu,
       current_numa_nodes,
       current_cpus,
       numainfo,
       numa_isavailable,
       nnumanodes,
       ncpus,
       numanode,
       numalocal,
       which_numa_node

end # module NUMA
