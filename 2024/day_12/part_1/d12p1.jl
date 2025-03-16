# Day 12, Part 1
#=
Plan of Attack:
1. Step one description.
2. Step two description.
3. Additional steps...
=#

function areAdjacent(x :: CartesianIndex, y :: CartesianIndex) :: Bool
    sincospi.()
end

function main()
    grid = split.(readlines("input_test_sml.txt"), "") |> stack |> permutedims .|> only
    plantTypeVector = unique(grid)
    Dict(plantType => findall(==(plantType), grid) for plantType in plantTypeVector)
end

main()