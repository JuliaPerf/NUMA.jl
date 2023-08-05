# NUMA.jl

## Examples

### First-things first: Get an overview of the system

Basic information can be obtained directly:

```julia
julia> nnumanodes()
8

julia> ncpus()
128

julia> current_cpu()
22

julia> current_numa_node() # NUMA node IDs start at zero! (so this result means the second node)
1
```

However, to get a more detailed overview it is highly recommended to use [ThreadPinning.jl](https://github.com/carstenbauer/ThreadPinning.jl) and `threadinfo(; groupby=:numa)` specifically.

<img width="800" alt="Screenshot 2023-08-05 at 07 06 32" src="https://github.com/JuliaPerf/NUMA.jl/assets/187980/aa3b801f-d909-4dd0-b864-5b29220b59c2">


### Allocating on specific NUMA node

In the following example, we explicitly allocate arrays in specific NUMA nodes.

```julia
julia> using NUMA, Random

julia> x = Vector{Float64}(numanode(0), 10); rand!(x);

julia> which_numa_node(x)
0

julia> x = Vector{Float64}(numanode(1), 10); rand!(x);

julia> which_numa_node(x)
1

julia> x = Vector{Float64}(numanode(3), 10); rand!(x);

julia> which_numa_node(x)
3

julia> x = Vector{Float64}(numanode(6), 10); rand!(x);

julia> which_numa_node(x)
6

julia> x = Vector{Float64}(numanode(7), 10); rand!(x);

julia> which_numa_node(x)
7
```

We can also allocate on the local NUMA node, that is, the node closest to the CPU-thread/core we're currently running on.

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

Demonstrating the same for multiple threads pinned to separate NUMA domains:

```julia
julia> using NUMA, ThreadPinning, Base.Threads, Random

julia> pinthreads(:numa)

julia> current_cpus(), current_numa_nodes()
([0, 16, 32, 48, 64, 80, 96, 112], [0, 1, 2, 3, 4, 5, 6, 7])

julia> xs = Vector{Vector{Float64}}(undef, nthreads());

julia> @threads :static for i in 1:nthreads()
           xs[i] = Vector{Float64}(numalocal(), 123)
           rand!(xs[i])
       end

julia> which_numa_node.(xs) |> print
Int32[0, 1, 2, 3, 4, 5, 6, 7]
```

### NUMA first-touch policy

In the following example, parts of an array are (equally) distributed among all 8 NUMA nodes, because different threads - pinned to cores in different NUMA domains via [ThreadPinning.jl](https://github.com/carstenbauer/ThreadPinning.jl) - perform the first touch, i.e. the first write operation.

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

## Useful Resources

* [NUMA (Non-Uniform Memory Access): An Overview](https://queue.acm.org/detail.cfm?id=2513149) (by Christoph Lameter)
* [What is NUMA?](https://www.kernel.org/doc/html/v4.18/vm/numa.html) (from the linux kernel documentation)
* [NUMA](https://hpc-wiki.info/hpc/NUMA) (from the HPC wiki)

## Acknowledgements

* [ArrayAllocators.jl](https://github.com/mkitti/ArrayAllocators.jl) and specifically [NumaAllocators.jl](https://github.com/mkitti/ArrayAllocators.jl/tree/main/NumaAllocators) has served as an inspiration (and provides similar functionality).
