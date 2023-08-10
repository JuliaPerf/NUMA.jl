using Documenter
using NUMA

const ci = get(ENV, "CI", "") == "true"
const src = "https://github.com/JuliaPerf/NUMA.jl"

@info "make.jl: Generating Documenter.jl site"
makedocs(;
         sitename = "NUMA.jl",
         authors = "Carsten Bauer",
         modules = [NUMA],
         checkdocs = :exports,
         doctest = false,
         pages = [
             "NUMA" => "index.md",
             "Examples" => [
                 "Querying NUMA properties" => "examples/querying.md",
                 "Allocate on NUMA nodes" => "examples/numa_node_alloc.md",
                 "First-touch policy" => "examples/numa_first_touch.md",
             ],
             "References" => [
                 "API" => "refs/api.md",
                #  "LibNuma" => "refs/libnuma.md",
             ],
         ],
         repo = "$src/blob/{commit}{path}#{line}",
         # assets = ["assets/custom.css", "assets/custom.js"]
        #  format = Documenter.HTML(; collapselevel = 1)
)

if ci
    @info "make.jl: Deploying documentation to GitHub"
    deploydocs(;
               repo = "github.com/JuliaPerf/NUMA.jl.git",
               devbranch = "main",
               push_preview=true,
               )
end
