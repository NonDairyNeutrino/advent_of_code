module y25d01
export main

include("parsing.jl")
include("Dial.jl")

function main1(input)
    bound = 100
    start = 50
    dial = Dial{Int}(bound, start)
    movev = parse_input(input)

    dial_seq  = accumulate((dial, move) -> spin(dial, move), movev; init = dial)
    nzeros = count(dial -> iszero(dial.loc), dial_seq)
    @debug "" dial_seq
    return nzeros
end

function main2(input)

end

function main()
    example = readchomp("example.txt")
    input   = readchomp("input.txt")

    p1e     = main1(example)
    p1      = main1(input)
    @info "Part 1" p1e p1
end

end # module y25d01
