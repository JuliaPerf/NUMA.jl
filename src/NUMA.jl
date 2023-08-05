module NUMA

using DocStringExtensions

include("LibNuma.jl")
import .LibNuma
include("utils.jl")
include("julia_structs.jl")
include("julia.jl")
include("extra.jl")
include("arrayalloc.jl")

# exports
const PREFIXES = ["numa", "MPOL_"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

# julia.jl (that doesn't start with "numa")
# export numa_available

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
