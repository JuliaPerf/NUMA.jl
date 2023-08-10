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
         pages = [
             "NUMA" => "index.md",
             "References" => [
                 "API" => "refs/api.md",
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
