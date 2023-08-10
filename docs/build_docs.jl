# @info "Instantiating project"
# using Pkg
# Pkg.activate(joinpath(@__DIR__, ".."))
# Pkg.instantiate()
# Pkg.activate(@__DIR__)
# Pkg.instantiate()
# push!(LOAD_PATH, joinpath(@__DIR__, ".."))
# deleteat!(LOAD_PATH, 2)
# @info "Building documentation"
# include(joinpath(@__DIR__, "make.jl"))

using Pkg
@info "Instantiating doc environment"
Pkg.activate(@__DIR__)
Pkg.develop(PackageSpec(path=joinpath(@__DIR__, "..")))
Pkg.instantiate()
@info "Building documentation"
include(joinpath(@__DIR__, "make.jl"))
