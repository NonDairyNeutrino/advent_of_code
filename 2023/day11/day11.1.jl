using LinearAlgebra

function parseInput(path :: String) :: Matrix{Char}
    return readlines(path) |> stack |> permutedims
end

function findGalaxies(universe :: Matrix{Char}) :: Vector{CartesianIndex}
    return findall(==('#'), universe)
end

function findExpansions(universe :: Matrix{Char})
    expansionRowVector = findall(allequal, eachrow(universe))
    expansionColVector = findall(allequal, eachcol(universe))
    return Dict("rows" => expansionRowVector, "cols" => expansionColVector)
end

function manhattanMetric(p1 :: CartesianIndex, p2 :: CartesianIndex) :: Int
    return abs(p1[1] - p2[1]) + abs(p1[2] - p2[2])
end

function distanceMatrix(galaxyLocationVector :: Vector, expansionLocationDict :: Dict; metric = manhattanMetric, spaceDensity = 1) :: Matrix
    expansionRowVector, expansionColVector = values(expansionLocationDict)
    distanceMatrix = Matrix{Int}(undef, length(galaxyLocationVector), length(galaxyLocationVector))
    for i in eachindex(galaxyLocationVector)
        for j in eachindex(galaxyLocationVector)
            g1, g2 = galaxyLocationVector[[i, j]]
            # count number of expansions the geodesic crosses
            countRow = count(in(((l, u) -> l : u)(minmax(g1[1], g2[1])...)), expansionRowVector)
            countCol = count(in(((l, u) -> l : u)(minmax(g1[2], g2[2])...)), expansionColVector)
            distance = metric(g1, g2) + (spaceDensity - 1) * (countRow + countCol)
            distanceMatrix[i, j] = distance
        end
    end
    return distanceMatrix
end

function main()
    universe              = parseInput("input.txt")
    galaxyLocationVector  = findGalaxies(universe)
    expansionLocationDict = findExpansions(universe)
    dMat = distanceMatrix(galaxyLocationVector, expansionLocationDict, spaceDensity = 2)
    distanceVector = filter(!iszero, triu(dMat, 1))
    return sum(distanceVector)
end

main() |> display
