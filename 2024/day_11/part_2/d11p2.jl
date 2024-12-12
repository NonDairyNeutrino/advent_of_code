# Day 11, Part 1
#=
Plan of Attack:
1. Step one description.
2. Step two description.
3. Additional steps...
=#

using DelimitedFiles

struct Splicer{T}
    value :: Vector{T}
end

Base.:length(s :: Splicer) = length(s.value)

Base.:setindex!(v :: Vector{T} where T, s :: Splicer{T} where T, index :: Int) :: Vector{T} where T = begin
    # println("v = $v, index = $index, s.value = $(s.value)")
    v[index] = 0
    splice!(v, index, s.value)
    return v
end

function hasEvenDigit(n :: Int) :: Bool
    return floor(Int, log10(n)) + 1 |> iseven
end

function splitIn2(string :: String) :: Vector{String}
    halfIndex = floor(Int, length(string) / 2)
    left  = SubString(string, 1, halfIndex)
    right = SubString(string, halfIndex + 1)
    return [left, right]
end

function applyRules(stoneValue :: Int) :: Vector{Int}
    # println(stoneValue)
    if stoneValue == 0
        return [1]
    elseif hasEvenDigit(stoneValue)
        stoneValueString = string(stoneValue)
        return parse.(Int, splitIn2(stoneValueString)) # |> Splicer
    else
        return [stoneValue * 2024]
    end
end

function main()
    stoneVector = readdlm("input.txt", ' ', Int, '\n') |> vec |> Base.Lockable
    blinkCount = 25
    for blink in 1:blinkCount
        # println("stoneVector: ")
        # display(stoneVector)
        println("Blink: $blink, stoneCount: ", @lock(stoneVector, length(stoneVector)))

        tempVector = Base.Lockable(Int[])
        for stone in stoneVector
            @lock(tempVector, append!(tempVector[], applyRules(stone)))
        end
        stoneVector = tempVector
    end

    return stoneVector |> length
end

main()