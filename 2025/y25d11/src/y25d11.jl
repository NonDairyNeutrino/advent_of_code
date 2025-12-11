module y25d11
export main

include("Graph.jl")
include("parsing.jl")

function main1(input)

end

function main1(input)

end

function main()
    example = readchomp("example.txt")
    input   = readchomp("input.txt")

    p1e     = main1(example)
    p1      = main1(input)
    @info "Part 1" p1e p1
end

end # module y25d11
