# Advent of Code 2023 day 5 part 1
struct Map # not a good name as it conflicts with `map`
    srcCat :: String
    dstCat :: String
    mapFunction :: Function
    function Map(srcCat, dstCat, rangeVectorVector :: Vector{Vector{Int}})
        function mapFunction(x :: Int) :: Int
            for rangeVector in rangeVectorVector
                dstStart, srcStart, rangeLength = rangeVector
                if x in (srcStart .+ (0:(rangeLength - 1)))
                    return dstStart + (x - srcStart)
                end
            end
            # only gets here if input isn't any range
            return x
        end
        new(srcCat, dstCat, mapFunction)
    end
end

function parseInput(path :: String) :: Vector{Map}
    sourceCategoryRegexString = raw"(?<source>\w+)"
    destinationCategoryRegexString = raw"(?<destination>\w+)"
    rangeRegexString = raw"(?<ranges>[\d \s]+)"
    fullRegex = Regex("$sourceCategoryRegexString-to-$destinationCategoryRegexString.+\n$rangeRegexString")

    matchIterator = eachmatch(fullRegex, readchomp(path))
    mapVector = []
    for match in matchIterator
        rangeStringVectorVector = split.(split(match["ranges"], "\r\n", keepempty=false))
        rangeVectorVector = [(n -> parse(Int, n)).(rangeStringVector) for rangeStringVector in rangeStringVectorVector]
        push!(mapVector, Map(match["source"], match["destination"], rangeVectorVector))
    end
    return mapVector
end

function main()
    filePath   = "input.txt"
    seedStringVector = match(r"seeds: (?<seeds>[\d ]+)", readline(filePath))["seeds"] |> split
    mapVector  = parseInput(filePath)
    seedLocationVector = []
    for seedString in seedStringVector
        val = parse(Int, seedString)
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
        push!(seedLocationVector, Dict("seed" => parse(Int, seedString), "location" => val))
    end
    min([seedLocation["location"] for seedLocation in seedLocationVector]...)
end

main() |> display