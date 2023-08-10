# NUMA.jl

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://juliaperf.github.io/NUMA.jl/dev

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://juliaperf.github.io/NUMA.jl/stable

[ci-img]: https://github.com/JuliaPerf/NUMA.jl/actions/workflows/CI.yml/badge.svg
[ci-url]: https://github.com/JuliaPerf/NUMA.jl/actions/workflows/CI.yml

[cov-img]: https://codecov.io/gh/JuliaPerf/NUMA.jl/branch/main/graph/badge.svg?token=Ze61CbGoO5
[cov-url]: https://codecov.io/gh/JuliaPerf/NUMA.jl

[lifecycle-img]: https://img.shields.io/badge/lifecycle-maturing-green.svg

[code-style-img]: https://img.shields.io/badge/code%20style-blue-4495d1.svg
[code-style-url]: https://github.com/invenia/BlueStyle

<!--
![Lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-retired-orange.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-archived-red.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-dormant-blue.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)
-->

*NUMA tools (from [libnuma](https://github.com/numactl/numactl)) for Julia*

| **Documentation**                                                               | **Build Status**                                                                                |  **Quality**                                                                                |
|:-------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] | [![][ci-img]][ci-url] [![][cov-img]][cov-url] | ![][lifecycle-img] |

## Example: Allocating on a specific NUMA node

In the following basic example, we explicitly allocate arrays on **specific NUMA nodes**.

```julia
julia> using NUMA, Random

julia> x = Vector{Float64}(numanode(1), 10); rand!(x);

julia> which_numa_node(x)
1

julia> y = Vector{Float64}(numanode(6), 10); rand!(y);

julia> which_numa_node(y)
6
```

## Documentation

For more information, please check out the [package documentation](https://juliaperf.github.io/NUMA.jl/stable).

## Useful Resources

* [NUMA (Non-Uniform Memory Access): An Overview](https://queue.acm.org/detail.cfm?id=2513149) (by Christoph Lameter)
* [What is NUMA?](https://www.kernel.org/doc/html/v4.18/vm/numa.html) (from the linux kernel documentation)
* [NUMA](https://hpc-wiki.info/hpc/NUMA) (from the HPC wiki)

## Acknowledgements

* [ArrayAllocators.jl](https://github.com/mkitti/ArrayAllocators.jl) and specifically [NumaAllocators.jl](https://github.com/mkitti/ArrayAllocators.jl/tree/main/NumaAllocators) has served as an inspiration (and provides similar functionality).
