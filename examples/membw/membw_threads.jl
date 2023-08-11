# Run with as many threads as NUMA domains:
#   julia --project -t 8 membw_threads.jl
using BenchmarkTools
using NUMA
using ThreadPinning
using Base.Threads: nthreads, @threads
using CpuId
using Random

@assert nthreads() == nnumanodes()
pinthreads(:numa)

const N = 4 * ceil(Int, last(cachesize()) / sizeof(Float64))
println("L3 cache size: ", Base.format_bytes(cachesize()[3]))
println("Choosing array size: ", Base.format_bytes(N * sizeof(Float64)), "\n")

function axpy_kernel!(ys, a, xs)
    @threads :static for tid in 1:nthreads()
        x = xs[tid]
        y = ys[tid]
        for i in eachindex(x,y)
            @inbounds y[i] = a * x[i] + y[i]
        end
    end
end

function measure_membw(naive) # init
    a = 3.141
    xs = Vector{Vector{Float64}}(undef, nthreads())
    ys = Vector{Vector{Float64}}(undef, nthreads())
    if naive == true
        # naive approach will put all arrays in first NUMA node
        for i in 1:nthreads()
            xs[i] = rand(N)
            ys[i] = rand(N)
        end
    else
        # put arrays explicitly in thread-local NUMA nodes
        threadnodes = current_numa_nodes()
        for i in 1:nthreads()
            xs[i] = Vector{Float64}(numanode(threadnodes[i]), N)
            ys[i] = Vector{Float64}(numanode(threadnodes[i]), N)
            rand!(xs[i])
            rand!(ys[i])
        end
    end

    t = @belapsed axpy_kernel!($ys, $a, $xs) evals=2 samples=10
    mem_rate = 3 * sizeof(Float64) * nthreads() * N * 1e-9 / t
    return mem_rate
end

membw_nonlocal = measure_membw(true)
membw_local = measure_membw(false)
println("Arrays in thread-local NUMA nodes:\t", round(membw_local; digits = 2), " GB/s")
println("Arrays all in first NUMA node (naive):\t", round(membw_nonlocal; digits = 2), " GB/s")
