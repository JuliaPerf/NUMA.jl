abstract type NUMAAlloc end

struct NUMANode <: NUMAAlloc
    node::Int
end
"""
$(TYPEDSIGNATURES)
Returns an array initializer that represents a specific NUMA node.
To be used as, e.g., `Vector{Float64}(numanode(1), 1024)`.
"""
numanode(i::Integer) = NUMANode(i)

struct NUMALocal <: NUMAAlloc end
"""
$(TYPEDSIGNATURES)
Returns an array initializer that represents the local NUMA node.
To be used as, e.g., `Vector{Float64}(numalocal(), 1024)`.
"""
numalocal() = NUMALocal()


# Allocate arrays when the dims are given as arguments rather than as a tuple
function (::Type{ArrayType})(alloc::NUMAAlloc, dims...) where {T, ArrayType <: AbstractArray{T}}
    return ArrayType(alloc, dims)
end

function (::Type{ArrayType})(alloc::NUMANode, dims) where {T, ArrayType <: AbstractArray{T}}
    num_bytes = sizeof(T) * prod(dims)
    ptr = Ptr{T}(LibNuma.numa_alloc_onnode(num_bytes, alloc.node-1))
    return wrap_numa(ArrayType, ptr, dims)
end

function (::Type{ArrayType})(alloc::NUMALocal, dims) where {T, ArrayType <: AbstractArray{T}}
    num_bytes = sizeof(T) * prod(dims)
    ptr = Ptr{T}(LibNuma.numa_alloc_local(num_bytes))
    # ptr = Ptr{T}(LibNuma.numa_alloc_onnode(num_bytes, current_numa_node()))
    return wrap_numa(ArrayType, ptr, dims)
end

function wrap_numa(::Type{ArrayType}, ptr::Ptr{T}, dims) where {T, ArrayType <: AbstractArray{T}}
    if ptr == C_NULL
        throw(OutOfMemoryError())
    end
    arr = unsafe_wrap(ArrayType, ptr, dims; own = false)
    lineage_finalizer(numa_free, arr)
    return arr
end

numa_free(arr::AbstractArray) = LibNuma.numa_free(arr, sizeof(arr))
