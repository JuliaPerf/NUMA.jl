# Example: NUMA first-touch policy

In the following example, parts of an array are (equally) distributed among 8 NUMA nodes of a system, because different threads - pinned to cores in different NUMA domains via [ThreadPinning.jl](https://github.com/carstenbauer/ThreadPinning.jl) - perform the first touch, i.e. the first write operation.

```julia
# Example is designed for a system with 8 NUMA domains.
# Run as: julia --project -t 8 numa_first_touch.jl [N]
using NUMA
using ThreadPinning
using Base.Threads

@assert nthreads() >= 8
pinthreads(:numa)

# allocate a large array (you might need to adjust the size for your system)
N = length(ARGS) != 0 ? 10^(parse(Int, first(ARGS))) : 10^7
x = Vector{Float64}(undef, N);
println("Array size: ", Base.format_bytes(sizeof(x)))

# "touch" contiguous parts of the array from different threads
# (which are pinned to cores in different NUMA domains)
@threads :static for i in eachindex(x)
    x[i] = threadid()
end

# query on which node the memory pages are located
blocksize = length(x) ÷ nnumanodes()
for i in 1:8
    println("Block $i on NUMA node ", which_numa_node(x, (i-1)*blocksize+1))
end
```

```
$ julia --project -t 8 numa_first_touch.jl
Array size: 76.294 MiB
Block 1 on NUMA node 1
Block 2 on NUMA node 2
Block 3 on NUMA node 3
Block 4 on NUMA node 4
Block 5 on NUMA node 5
Block 6 on NUMA node 6
Block 7 on NUMA node 7
Block 8 on NUMA node 8
```
