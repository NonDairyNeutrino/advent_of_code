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

function getNodeVector(grid :: Matrix{SubString{String}}, obstructionVector :: Vector{CartesianIndex{2}})
    nodeVector = [ob .+ [CartesianIndex(0, 1), CartesianIndex(-1, 0), CartesianIndex(0, -1), CartesianIndex(1, 0)] for ob in obstructionVector]
    filter!.(ind -> 1 <= ind[1] <= size(grid, 1) && 1 <= ind[2] <= size(grid, 2), nodeVector)
    return nodeVector |> Iterators.flatten |> collect
end

function getAdjacencyMatrix(nodeVector :: Vector{CartesianIndex{2}}) :: Matrix{CartesianIndices}
    dim = length(nodeVector) # DOUG DIMMADOME DEEZ NUTZ
    adjacencyMatrix = Matrix{CartesianIndices}(undef, dim, dim) # fill(Set{CartesianIndex{2}}(), dim, dim)
    for (i, nodeI) in enumerate(nodeVector)
        for (j, nodeJ) in enumerate(nodeVector)
            if any(Tuple(nodeI) .== Tuple(nodeJ)) # do they share a lane?
                edge = nodeI : nodeJ # vector of indices between them
                if !any(node in edge for node in nodeVector) # is there an obstruction between them?
                    adjacencyMatrix[i, j] = edge
                end
            end
        end
    end
    return adjacencyMatrix
end

function graphMain()
    grid = parseInput("input_test.txt")
    display(grid)
    obstructionVector = findall(==("#"), grid)
    # get node vector i.e. vertex set
    # each node has a value equal to the CartesianIndex of its position in the grid
    nodeVector = getNodeVector(grid, obstructionVector)
    # connect the nodes
    # each entry in the adjacencyMatrix is the set of CartesianIndex positions between
    # it and another node
    adjacencyMatrix = getAdjacencyMatrix(nodeVector)

    positionStart = findfirst(==("^"), grid)
    # facing north means stop at row below obstruction
    firstNodeValue = findprev(==("#"), grid, positionStart) + CartesianIndex(1, 0)
    firstNode = findfirst(==(firstNodeValue), nodeVector)
    # now that we're at a node, how to travel to next node
    adjacencyMatrix
end

graphMain()
