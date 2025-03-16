# Day 11, Part 1
#=
Plan of Attack:
1. Step one description.
2. Step two description.
3. Additional steps...
=#

using DelimitedFiles

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
        return parse.(Int, splitIn2(stoneValueString))
    else
        return [stoneValue * 2024]
    end
end

function main() :: Nothing
    stoneVector = readdlm("input.txt", ' ', Int, '\n') |> vec |> Base.Lockable
    blinkCount = 37
    for blink in 1:blinkCount
        # println("stoneVector: ")
        # display(stoneVector)
        print("Blink: $blink, stoneCount: ", @lock(stoneVector, length(stoneVector[])), "\r")

        tempVector = Base.Lockable(Int[])
        @lock(stoneVector, begin
            Threads.@threads for stone in stoneVector[]
                @lock(tempVector, append!(tempVector[], applyRules(stone)))
            end
            stoneVector = tempVector
        end)
    end

    println()
    println("Final number of stones: ", @lock(stoneVector, stoneVector[] |> length))
    return nothing
end

main()