# Day 06, Part 1
#=
Plan of Attack:
1. Step one description.
2. Step two description.
3. Additional steps...
=#
using Test

function parseInput(path :: String) :: Matrix{SubString{String}}
    lineVector :: Vector{String} = readlines(path)
    return split.(lineVector, "") |> stack |> permutedims
end

# mutable struct Gaurd
#     # north = im
#     # south = -im
#     # east  = 1
#     # west  = -1
#     facing :: Complex
#     gridPosition :: CartesianIndex
#     laneFacing   :: Int
#     lanePosition :: Int
#     function Gaurd(facing :: Complex, gridPosition :: CartesianIndex)
#         new(facing, gridPosition, , 0)
#     end
# end

# function getLane!(grid :: Matrix{SubString{String}}, gaurd :: Gaurd) :: Vector{SubString{String}}
#     position = gaurd.gridPosition

#     if gaurd.facing == im || gaurd.facing == -im
#         gaurd.lanePosition = position[1]
#         lane = grid[:, gaurd.lanePosition]
#     else
#         gaurd.lanePosition = position[2]
#         lane = grid[gaurd.lanePosition, :]
#     end
#     return lane
# end

# function getObstructionPosition(lane :: Vector{SubString{String}}, gaurd :: Gaurd) :: Int
#     direction = gaurd.facing
#     if direction == im || direction == -1
#         search = findprev
#     elseif direction == -im || direction == 1
#         search = findnext
#     end

#     return search(==("#"), lane, gaurd.lanePosition)
# end

# function main()
#     grid = parseInput("input_test.txt")

#     position = findfirst(c -> c == "^", grid)
#     direction = im # start facing north
#     gaurd = Gaurd(direction, position)
#     lane = getLane!(grid, gaurd)
#     getObstructionPosition(lane, gaurd)
# end

function getNodeVector(grid :: Matrix{SubString{String}}, obstructionVector :: Vector{CartesianIndex{2}})
    nodeVector = [ob .+ [CartesianIndex(0, 1), CartesianIndex(-1, 0), CartesianIndex(0, -1), CartesianIndex(1, 0)] for ob in obstructionVector]
    filter!.(ind -> 1 <= ind[1] <= size(grid, 1) && 1 <= ind[2] <= size(grid, 2), nodeVector)
    return nodeVector |> Iterators.flatten |> collect
end

function getAdjacencyMatrix(nodeVector :: Vector{CartesianIndex{2}}) :: Matrix{CartesianIndices}
    adjacencyMatrix = Matrix{CartesianIndices}(undef, length(nodeVector), length(nodeVector))
    for (i, nodeI) in enumerate(nodeVector)
        for (j, nodeJ) in enumerate(nodeVector)
            if any(Tuple(nodeI) .== Tuple(nodeJ)) # do they share a lane?
                edge = nodeI : nodeJ # vector of indices between them
                if !any(node in edge for node in nodeVector) # is there an obstruction between them?
                    adjacencyMatrix[i, j] = edge
                    # instead of a numeric edge weight
                    # use the set of positions between the nodes
                    # important later when checking for duplicates
                end
            end
        end
    end
    return adjacencyMatrix
end

function graphMain()
    grid = parseInput("input_test.txt")
    obstructionVector = findall(==("#"), grid)
    # get node vector i.e. vertex set
    nodeVector = getNodeVector(grid, obstructionVector)
    # connect the nodes
    adjacencyMatrix = getAdjacencyMatrix(nodeVector)


    positionStart = findfirst(==("^"), grid)
    # facing north means stop at row below obstruction
    firstNode     = findprev(==("#"), grid, positionStart) + CartesianIndex(1, 0)
end

graphMain()
