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

mask_to_bits(mask::UInt) = digits(mask; base=2)
mask_to_string(mask::UInt) = join(digits(mask; base=2))
