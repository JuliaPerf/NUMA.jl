# NUMA.jl

[NUMA.jl](https://github.com/JuliaPerf/NUMA.jl) provides tools for querying and controlling [NUMA (non-uniform memory access)](https://en.wikipedia.org/wiki/Non-uniform_memory_access#NUMA_vs._cluster_computing) policies in Julia applications. It is based on [libnuma](https://github.com/numactl/numactl).

## Install

NUMA.jl is registered in Julia's General package registry. You can add it to your Julia environment by executing
```julia
using Pkg
Pkg.add("NUMA")
```

## Why care?

Because not caring about NUMA can negatively impact performance, in particular for computations that are limited by memory-bandwidth. To give a simple [example](https://github.com/JuliaPerf/NUMA.jl/tree/main/examples/membw/membw_single.jl), consider a [DAXPY](https://netlib.org/lapack/explore-html/de/da4/group__double__blas__level1_ga8f99d6a644d3396aa32db472e0cfc91c.html) kernel, which operates on two Julia arrays. We benchmark the memory bandwidth (i.e. how fast we can read and write data) of this kernel under two different circumstances: The arrays are allocated in the local NUMA node or in a distant NUMA node. By "local" we mean local to the CPU core that is hosting the Julia thread performing the computation. The benchmark results - on a system with 2x AMD Milan 7763 CPUs and 8 NUMA domains - are:

```
Array in local NUMA node:       37.19 GB/s
Array in distant NUMA node:     23.24 GB/s
```

Note that the memory bandwidth is 60% higher for the local case. This NUMA effect is even more pronounced when using multithreading ([example code](https://github.com/JuliaPerf/NUMA.jl/tree/main/examples/membw/membw_threads.jl)).

```
Arrays in thread-local NUMA nodes:      286.08 GB/s
Arrays all in first NUMA node (naive):  38.7 GB/s
```

Here, we see a ~**7.4x** improvement of the memory bandwidth (i.e. ∝ the number of NUMA domains) .

## Useful background information

* [NUMA (Non-Uniform Memory Access): An Overview](https://queue.acm.org/detail.cfm?id=2513149) (by Christoph Lameter)
* [What is NUMA?](https://www.kernel.org/doc/html/v4.18/vm/numa.html) (from the linux kernel documentation)
* [NUMA](https://hpc-wiki.info/hpc/NUMA) (from the HPC wiki)

## Acknowledgements

* [ArrayAllocators.jl](https://github.com/mkitti/ArrayAllocators.jl) and specifically [NumaAllocators.jl](https://github.com/mkitti/ArrayAllocators.jl/tree/main/NumaAllocators) has served as an inspiration (and provides similar functionality).