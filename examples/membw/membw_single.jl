# Run as: julia --project membw_single.jl
using BenchmarkTools
using NUMA
using ThreadPinning
using Random
using CpuId

pinthread(0)
@assert current_numa_node() != nnumanodes() # we need more than one NUMA node for this example

const N = 4 * ceil(Int, last(cachesize()) / sizeof(Float64))
println("L3 cache size: ", Base.format_bytes(cachesize()[3]))
println("Choosing array size: ", Base.format_bytes(N * sizeof(Float64)), "\n")

function axpy_kernel!(y, a, x)
    for i in eachindex(x,y)
        @inbounds y[i] = a * x[i] + y[i]
    end
end

function measure_membw(targetnode)
    a = 3.141
    x = Vector{Float64}(numanode(targetnode), N)
    y = Vector{Float64}(numanode(targetnode), N)
    rand!(x)
    rand!(y)
    t = @belapsed axpy_kernel!($y, $a, $x) evals=2 samples=3
    mem_rate = 3 * sizeof(Float64) * N * 1e-9 / t
    return mem_rate
end

membw_local = measure_membw(current_numa_node())
membw_distant = measure_membw(nnumanodes())

println("Arrays in local NUMA node:\t", round(membw_local; digits = 2), " GB/s")
println("Arrays in distant NUMA node:\t", round(membw_distant; digits = 2), " GB/s")
