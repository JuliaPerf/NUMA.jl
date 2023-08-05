abstract type NUMAAlloc end

struct NUMANode <: NUMAAlloc
    node::Int
end
numanode(i) = NUMANode(i)

struct NUMALocal <: NUMAAlloc end
numalocal() = NUMALocal()


# Allocate arrays when the dims are given as arguments rather than as a tuple
function (::Type{ArrayType})(alloc::NUMAAlloc, dims...) where {T, ArrayType <: AbstractArray{T}}
    return ArrayType(alloc, dims)
end

function (::Type{ArrayType})(alloc::NUMANode, dims) where {T, ArrayType <: AbstractArray{T}}
    num_bytes = sizeof(T) * prod(dims)
    ptr = Ptr{T}(LibNuma.numa_alloc_onnode(num_bytes, alloc.node))
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
