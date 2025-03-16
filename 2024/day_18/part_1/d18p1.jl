# Day 18, Part 1
#= 
Notes:
- Non-Euclidean metric
- in fact, it's the Manhattan Metric
=#
#=
Plan of Attack:

=#

function drawGrid(dims :: Dims{2}, pillarVector :: Vector{CartesianIndex{2}}) :: Matrix{Char}
    grid = fill('.', dims)
    setindex!.(Ref(grid), '#', pillarVector)
    return grid |> permutedims
end

function main()
    dims = (7,7)
    path = "input_test.txt"
    pillarVector = [CartesianIndex(parse.(Int, split(line, ","))...) + CartesianIndex(1,1) for line in eachline(path)]
    return drawGrid(dims, pillarVector)
end

main()