# Functionality for the Problem structure

struct Problem
    op   :: Symbol
    args :: Vector{Int}
    res  :: Int
end

function Problem(op, args)
    # @info "State" op args
    expr = Expr(:call, op, args...)
    res  = eval(expr)
    prb  = Problem(op, args, res)
    return prb
end

(p :: Problem)() = p.res # eval(Expr(:call, p.op, p.args...))

function Base.show(io :: IO, prob :: Problem) :: Nothing
    print(io, prob.op, "(")
    join(io, prob.args, ", ")
    print(io, ") = ", prob.res)
    return nothing
end
