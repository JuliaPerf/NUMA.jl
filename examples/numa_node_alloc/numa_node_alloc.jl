# Run with as many threads as there are NUMA domains, e.g.:
#   julia --project -t 8 numa_node_alloc.jl [power]
using NUMA
using ThreadPinning
using Base.Threads
using Random

pinthreads(:random) # to demonstrate that the pinning is irrelevant

N = length(ARGS) != 0 ? 10^(parse(Int, first(ARGS))) : 10^7 # optional cmdline arg

xs = Vector{Vector{Float64}}(undef, nthreads());

targets = 1:nnumanodes()
for i in 1:nthreads()
    xs[i] = Vector{Float64}(numanode(targets[i]), N)
end

first_touch_from = current_numa_nodes()
@threads :static for i in 1:nthreads()
    rand!(xs[i])
end

println("Size of each array: ", Base.format_bytes(sizeof(Float64) * N))
println("Requested memory for arrays from nodes:\t", collect(targets))
println("Filled the arrays from (random) nodes:\t", first_touch_from)
println("Queried locations of memory pages:\t", which_numa_node.(xs))
