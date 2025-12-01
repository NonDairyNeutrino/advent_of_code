module AoC2025Day01
export parse_input, main1

include("parse.jl")

mutable struct Dial
    position :: Int
end

function rotate!(dial :: Dial, displacement :: Integer; bound :: Integer = 100) :: Nothing
    dial.position = (dial.position + displacement) % bound
    return nothing
end

function main1(input)
    start = 50
    dial = Dial(start)

    disps = parse_input(input)
    path = cumsum([start; disps])
    cnt = count(iszero, path)
    return cnt
end

end
