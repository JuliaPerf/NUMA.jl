# Bitmask struct
"""
Represents a bit mask. To be used to indicate, e.g., node masks or cpu masks.

**Example:**
```julia
julia> bm = Bitmask()
Bitmask (trunc): 00000000

julia> fill!(bm, 1); bm
Bitmask (trunc): 11111111

julia> bm[2] = 0; bm
Bitmask (trunc): 11111101

julia> numa_set_membind(bm)

julia> numa_get_membind()
Bitmask (trunc): 11111101
```
"""
mutable struct Bitmask <: AbstractVector{Int}
    ptr::Ptr{LibNuma.bitmask}

    function Bitmask(ptr::Ptr{LibNuma.bitmask})
        bm = new(ptr)
        finalizer(bm) do x
            # @async println("Finalizing bitmask")
            LibNuma.numa_bitmask_free(x.ptr)
        end
        return bm
    end
    Bitmask(n=nnumanodes()) = Bitmask(LibNuma.numa_bitmask_alloc(n))
end

function Base.getproperty(bm::Bitmask, s::Symbol)
    if s === :ptr
        return getfield(bm, :ptr)
    else
        ptr = getfield(bm, :ptr)
        bmobj = unsafe_load(ptr)
        if s === :size
            return Int(bmobj.size)
        elseif s === :maskp
            return bmobj.maskp
        elseif s === :mask
            return UInt(unsafe_load(bmobj.maskp))
        end
    end
end

Base.propertynames(::Bitmask) = (:ptr, :size, :mask, :maskp)

function Base.iterate(bm::Bitmask, i=nothing)
    if isnothing(i)
        return (bm[1], 1)
    elseif i + 1 <= length(bm)
        return (bm[i+1], i + 1)
    else
        return nothing
    end
end
Base.eltype(::Bitmask) = Int
Base.size(bm::Bitmask) = (bm.size,)
Base.length(bm::Bitmask) = bm.size
Base.keys(bm::Bitmask) = Base.OneTo(length(bm))
Base.lastindex(bm::Bitmask) = length(bm)
Base.firstindex(bm::Bitmask) = 1
function Base.fill!(bm::Bitmask, v::Int64)
    if iszero(v)
        LibNuma.numa_bitmask_clearall(bm.ptr)
    elseif isone(v)
        LibNuma.numa_bitmask_setall(bm.ptr)
    else
        throw(ArgumentError("Bitmask entries can only be set to zero or one!"))
    end
    return bm
end

Base.@propagate_inbounds function Base.getindex(bm::Bitmask, i::Integer)
    @boundscheck if i <= 0 || i > bm.size
        throw(BoundsError(bm, i))
    end
    # getmaskbits(bm)[i]
    return Int(LibNuma.numa_bitmask_isbitset(bm.ptr, i - 1))
end

function Base.setindex!(bm::Bitmask, v::Integer, i::Integer)
    @boundscheck if i <= 0 || i > bm.size
        throw(BoundsError(bm, i))
    end
    if isone(v)
        LibNuma.numa_bitmask_setbit(bm.ptr, i - 1)
    elseif iszero(v)
        LibNuma.numa_bitmask_clearbit(bm.ptr, i - 1)
    else
        throw(ArgumentError("Bitmask entries can only be set to zero or one!"))
    end
    return v
end

function Base.show(io::IO, ::MIME"text/plain", bm::Bitmask)
    # n = bm.mask
    # uint_str = string("0x", string(n, pad = (sizeof(n)<<1), base = 16))
    print(io, "Bitmask (trunc): ", getmaskstr(bm; truncate=true))
    return nothing
end

function getmaskstr(bm::Bitmask; truncate=false)
    if truncate
        join(bm[i] for i in nnumanodes():-1:firstindex(bm))
    else
        join(bm[i] for i in lastindex(bm):-1:firstindex(bm))
    end
end
