# Advent of Code 2023 day 5 part 1
include("Maps.jl")
using .Maps
using Test

#= function parseInput(path :: String) :: Vector{Map}
    sourceCategoryRegexString = raw"(?<source>\w+)"
    destinationCategoryRegexString = raw"(?<destination>\w+)"
    rangeRegexString = raw"(?<ranges>[\d \s]+)"
    fullRegex = Regex("$sourceCategoryRegexString-to-$destinationCategoryRegexString.+\n$rangeRegexString")

    matchIterator = eachmatch(fullRegex, readchomp(path))
    mapVector = []
    for match in matchIterator
        rangeStringVectorVector = split.(split(match["ranges"], "\r\n", keepempty=false))
        rangeVectorVector = [(n -> parse(Int, n)).(rangeStringVector) for rangeStringVector in rangeStringVectorVector]
        intervalVector = [[Interval()]]
        
        push!(mapVector, Map(match["source"], match["destination"], rangeVectorVector))
    end
    return mapVector
end

function main()
    filePath = "input_test.txt"
    seedRangeVector = [parse(Int, match["start"]) .+ (0:(parse(Int, match["length"]) - 1)) for match in eachmatch(r"(?<start>\d+) (?<length>\d+)", readline(filePath))]

    mapVector = parseInput(filePath)
    seedLocationVector = []
    for seedRange in seedRangeVector
        val = seedRange
        for map in mapVector
            val = map.mapFunction(val)
            #= if newVal == val && map.dstCat == "location"
                push!(seedLocationVector, Dict("seed" => parse(Int, seedString), "value" => newVal))
            elseif newVal == val
                "Ended at $(map.dstCat)" |> println
                break
            else
                val = newVal
            end =#
        end
        push!(seedLocationVector, Dict("seed" => seedRange, "location" => val))
    end
    return seedLocationVector
    #min([seedLocation["location"] for seedLocation in seedLocationVector]...)
end

main() |> display =#