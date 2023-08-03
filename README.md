# NUMA.jl

## Example: NUMA node allocation

In the following example, we explicitly allocate arrays in specific NUMA nodes.

```julia
julia> using NUMA, Random

julia> x = Vector{Float64}(numanode(0), 10); rand!(x);

julia> which_numa_node(x)
0

julia> x = Vector{Float64}(numanode(1), 10); rand!(x);

julia> which_numa_node(x)
1

julia> x = Vector{Float64}(numanode(2), 10); rand!(x);

julia> which_numa_node(x)
2

julia> x = Vector{Float64}(numanode(3), 10); rand!(x);

julia> which_numa_node(x)
3

julia> x = Vector{Float64}(numanode(4), 10); rand!(x);

julia> which_numa_node(x)
4

julia> x = Vector{Float64}(numanode(5), 10); rand!(x);

julia> which_numa_node(x)
5

julia> x = Vector{Float64}(numanode(6), 10); rand!(x);

julia> which_numa_node(x)
6

julia> x = Vector{Float64}(numanode(7), 10); rand!(x);

julia> which_numa_node(x)
7
```

## Example: NUMA first-touch policy

In the following example, parts of an array are (equally) distributed among all 8 NUMA domains.

```julia
julia> using NUMA, ThreadPinning, Base.Threads

julia> pinthreads(:cores)

julia> x = Vector{Float64}(undef, 10^7);

julia> @threads :static for i in eachindex(x)
           x[i] = threadid()
       end

julia> which_numa_node(x, 1)
0

julia> which_numa_node(x, 1250000)
1

julia> which_numa_node(x, 2500000)
2

julia> which_numa_node(x, 3750000)
3

julia> which_numa_node(x, 5000000)
4

julia> which_numa_node(x, 6250000)
5

julia> which_numa_node(x, 7500000)
6

julia> which_numa_node(x, 8750000)
7
```
