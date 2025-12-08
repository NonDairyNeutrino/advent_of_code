module y25d06
export main

include("Problem.jl")
include("parsing.jl")

function main1(input :: AbstractString)
    probv = parse_input(input) :: Vector{Problem}
    total = sum(p -> p(), probv) :: Int
    return total
end

function main2(input :: AbstractString)

end

function main()
    example = readchomp("example.txt")
    input   = readchomp("input.txt")

    p1ex = main1(example)
    p1   = main1(input)
    @info "Part 1" p1ex p1

    p2ex = main2(example)
    p2   = main2(input)
    @info "Part 2" p2ex p2
end

end # module y25d06
