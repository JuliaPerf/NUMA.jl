module NUMA

using DocStringExtensions

include("utils.jl")
include("LibNuma.jl")
using .LibNuma
include("julia_bitmask.jl")
include("julia.jl")
include("julia_extra.jl")
include("julia_arrayalloc.jl")

# exports
const PREFIXES = ["numa", "MPOL_"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end
export Bitmask

# julia.jl (that doesn't start with "numa")

# extra.jl + arrayalloc.jl
export current_numa_node,
       current_cpu,
       current_numa_nodes,
       current_cpus,
       numainfo,
       nnumanodes,
       ncpus,
       numanode,
       numalocal,
       which_numa_node

end # module NUMA
