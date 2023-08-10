# NUMA.jl

[NUMA.jl](https://github.com/JuliaPerf/NUMA.jl) is based on [libnuma](https://github.com/numactl/numactl) and provides tools for querying and controlling NUMA policies in Julia applications.

## Install

```julia
using Pkg
Pkg.add("NUMA")
```

## Useful Resources

* [NUMA (Non-Uniform Memory Access): An Overview](https://queue.acm.org/detail.cfm?id=2513149) (by Christoph Lameter)
* [What is NUMA?](https://www.kernel.org/doc/html/v4.18/vm/numa.html) (from the linux kernel documentation)
* [NUMA](https://hpc-wiki.info/hpc/NUMA) (from the HPC wiki)

## Acknowledgements

* [ArrayAllocators.jl](https://github.com/mkitti/ArrayAllocators.jl) and specifically [NumaAllocators.jl](https://github.com/mkitti/ArrayAllocators.jl/tree/main/NumaAllocators) has served as an inspiration (and provides similar functionality).