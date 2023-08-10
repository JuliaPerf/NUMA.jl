# Example: Allocate on NUMA nodes

## Specific node(s)

In the following example, we explicitly allocate an array on a **specific NUMA node**.

```julia
julia> using NUMA, Random

julia> x = Vector{Float64}(numanode(3), 10); rand!(x);

julia> which_numa_node(x)
3
```

Below we demonstrate the same for a bunch of arrays:

```julia
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
```

```
$ julia --project -t 8 numa_node_alloc.jl
Size of each array: 76.294 MiB
Requested memory for arrays from nodes: [1, 2, 3, 4, 5, 6, 7, 8]
Filled the arrays from (random) nodes:  [7, 2, 8, 6, 3, 6, 1, 1]
Queried locations of memory pages:      [1, 2, 3, 4, 5, 6, 7, 8]
```

## Local node(s)

We can also allocate on the **local NUMA node**, that is, the node closest to the CPU-thread/core we're currently running on.

```julia
julia> using NUMA, ThreadPinning, Random

julia> numa_node_of_cpu(32)
2

julia> pinthread(32);

julia> current_cpu()
32

julia> current_numa_node()
2

julia> x = Vector{Float64}(numalocal(), 10); rand!(x);

julia> which_numa_node(x)
2
```

Demonstrating the same for multiple threads pinned to separate NUMA domains (in random order):

```julia
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
```

```
$ julia --project -t 8 numa_node_alloc_local.jl
Size of each array: 76.294 MiB
Requested memory for arrays from nodes: [1, 3, 5, 8, 7, 6, 2, 4]
Filled the arrays from (random) nodes:  [8, 5, 7, 6, 1, 3, 2, 4]
Queried locations of memory pages:      [1, 3, 5, 8, 7, 6, 2, 4]
```