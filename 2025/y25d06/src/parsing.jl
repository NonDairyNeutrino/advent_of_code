function parse_args(argnv)
    argm          = split.(argnv) |> stack # [arg1prob1 arg1prob2, ...; arg2prob1, arg2prob2, ...; ...]
    argm          = parse.(Int, argm)
    return argm
end

function parse_ops(opv)
    opv           = split(opv)
    opv           = Symbol.(opv)
    return opv
end

function parse_input(input :: AbstractString) :: Vector{Problem}
    argnv..., opv = split(input, '\n')
    argm  = parse_args(argnv)
    opv   = parse_ops(opv)
    probs = Problem.(opv, eachrow(argm))
    return probs
end
