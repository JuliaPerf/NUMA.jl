struct NUMABitmask
    size::Int64
    maskp::UInt64
end

function bitmaskptr_to_NUMABitmask(bmptr)
    bm = unsafe_load(bmptr)
    mask = unsafe_load(bm.maskp)
    return NUMABitmask(bm.size, mask)
end
