# Run with as many threads as there are NUMA domains, e.g.:
#   julia --project -t 8 numa_node_alloc_local.jl [power]
using NUMA
using ThreadPinning
using Base.Threads
using Random

@assert nthreads() == nnumanodes()

# pin each thread to a random NUMA domain but each to a different one
pinthreads(shuffle!(first.(cpuids_per_numa())))

N = length(ARGS) != 0 ? 10^(parse(Int, first(ARGS))) : 10^7 # optional cmdline arg

xs = Vector{Vector{Float64}}(undef, nthreads());

@threads :static for i in 1:nthreads()
    xs[i] = Vector{Float64}(numanode(current_numa_node()), N) # works
    # xs[i] = Vector{Float64}(numalocal(), N) # doesn't quite work?!
end

first_touch_from = shuffle(current_numa_nodes()) # randomize
@threads :static for i in 1:nthreads()
    rand!(xs[first_touch_from[i]])
end

println("Size of each array: ", Base.format_bytes(sizeof(Float64) * N))
println("Requested memory for arrays from nodes:\t", current_numa_nodes())
println("Filled the arrays from (random) nodes:\t", first_touch_from)
println("Queried locations of memory pages:\t", which_numa_node.(xs))
