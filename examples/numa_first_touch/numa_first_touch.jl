# Example is designed for a system with 8 NUMA domains.
# Run as: julia --project -t 8 numa_first_touch.jl [power]
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
