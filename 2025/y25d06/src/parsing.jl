function parse_input(input :: AbstractString) :: Vector{Problem}
    argnv..., opv = split(input, '\n')

    argm          = split.(argnv) |> stack # [arg1prob1 arg1prob2, ...; arg2prob1, arg2prob2, ...; ...]
    argm          = parse.(Int, argm)

    opv           = split(opv)
    opv           = Symbol.(opv)

    probs         = Problem.(opv, eachrow(argm))
    return probs
end
