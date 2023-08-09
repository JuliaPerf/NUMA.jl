function sched_getcpu()
    return ccall(:sched_getcpu, Cint, ())
end

"""
    lineage_finalizer(f, x)

Attach a finalizer function `f` to `x` or an ancestor of `x` using
`parent`.
"""
function lineage_finalizer(f, x)
    try
        finalizer(f, x)
    catch err
        if applicable(parent, x)
            lineage_finalizer(f, parent(x))
        else
            rethrow(err)
        end
    end
end

_mask_to_bits(mask::UInt, masksize::Integer) = reverse(digits(mask; base=2, pad=masksize))
_mask_to_string(mask::UInt, masksize::Integer) = join(_mask_to_bits(mask, masksize))
