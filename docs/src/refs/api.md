# API

!!! warning "Important note"
    In contrast to the C-interface, we use one-based indices for the "high-level" API. Hence,
    the first NUMA node is NUMA node 1 (not 0). Consequently, on a system with 8 NUMA domains, `numa_max_node()` returns 8 (not 7).

## Index

```@index
Pages   = ["api.md"]
Order   = [:function, :type]
```

## References - Add-ons
```@autodocs
Modules = [NUMA]
Pages   = ["julia_extra.jl", "julia_arrayalloc.jl"]
```

## References - Bitmask
```@autodocs
Modules = [NUMA]
Pages   = ["julia_bitmask.jl"]
```

## References
```@autodocs
Modules = [NUMA]
Pages   = ["julia.jl"]
```

