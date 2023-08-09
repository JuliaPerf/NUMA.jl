using Test
using NUMA

@testset "NUMA.jl" begin
    @testset "General" begin
        # arity 0
        @test numa_max_node() isa Integer
        @test numa_preferred() isa Integer
        @test isnothing(numa_set_localalloc())
        @test numa_pagesize() isa Integer
        @test numa_max_possible_node() isa Integer
        @test numa_num_possible_nodes() isa Integer
        @test numa_num_possible_cpus() isa Integer
        @test numa_num_configured_nodes() isa Integer
        @test numa_num_configured_cpus() isa Integer
        @test numa_num_task_cpus() isa Integer
        @test numa_num_thread_cpus() isa Integer
        @test numa_get_interleave_mask() isa Bitmask
        @test numa_allocate_nodemask() isa Bitmask
        @test numa_allocate_cpumask() isa Bitmask
        @test numa_get_membind() isa Bitmask
        @test numa_get_mems_allowed() isa Bitmask
        @test numa_get_run_node_mask() isa Bitmask
        @test numa_available() isa Bool
        @test numa_node_of_cpu() isa Integer

        # arity 1
        @test numa_node_size() isa NamedTuple{(:memtot, :memfree),Tuple{Int64,Int64}}
        @test numa_node_size(1) isa NamedTuple{(:memtot, :memfree),Tuple{Int64,Int64}}
        @test isnothing(numa_set_membind([1]))
        bm = Bitmask()
        bm[1] = 1
        @test isnothing(numa_set_membind(bm))
    end

    @testset "Bitmask" begin
        bm = numa_bitmask_alloc(4)
        @test isnothing(numa_bitmask_setbit!(bm, 1))
        @test bm[1] == 1
        @test isnothing(numa_bitmask_clearbit!(bm, 1))
        @test bm[1] == 0
        @test isnothing(numa_bitmask_setall!(bm))
        @test all(isone, bm)
        @test isnothing(numa_bitmask_clearall!(bm))
        @test all(iszero, bm)

        bm = numa_bitmask_alloc(4)
        @test bm isa Bitmask
        @test all(iszero, bm)
        @test bm[1] == 0
        bm[1] = 1
        @test bm[1] == 1
        fill!(bm, 0)
        @test all(iszero, bm)
        fill!(bm, 1)
        @test all(isone, bm)
        @test collect(bm) isa Vector{eltype(bm)}
        @test length(collect(bm)) == length(bm)
        @test length(bm) == bm.size
    end

    @testset "Array allocation" begin
        for allocator in (numanode(1), numalocal())
            let v = Vector{Float64}(allocator, 32)
                v .= 1 # necessary for which_numa_node to work properly
                @test v isa Vector{Float64}
                @test which_numa_node(v; variant=:move_pages) == which_numa_node(v; variant=:get_mempolicy)
                @test which_numa_node(v, 1) == which_numa_node(v, 2)
            end
        end
    end
end
