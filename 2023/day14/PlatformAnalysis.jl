using Test

struct Platform
    diagram      :: Matrix{Char}
    boundary     :: Vector{Cube}
    internalCube :: Vector{Cube}
    cubeSet      :: Vector{Cube}
    function Platform(platformDiagram :: Matrix{Char})
        diagram       = copy(platformDiagram)
        boundary      = findBoundary(platformDiagram)
        internalCubes = findInternalCubes(platformDiagram)
        cubeSet       = union(boundary, internalCubes)
        return new(diagram, boundary, internalCubes, cubeSet)
    end
end

struct Cube
    position  :: CartesianIndex{2}
    cubeNorth :: Cube
    cubeSouth :: Cube
    cubeEast  :: Cube
    cubeWest  :: Cube
    # function Cube()

    # end
end

function parseInput(path :: String) :: Matrix{Char}
    return [[line...] for line in eachline(path)] |> stack |> permutedims
end

function findBoundary(platformDiagram :: Matrix{Char}) :: Vector{CartesianIndex{2}}
    numRows, numCols = size(platformDiagram)
    boundaryNorth   = CartesianIndices((0:0, 1:numCols))
    boundaryWest    = CartesianIndices((1:numRows, 0:0))
    boundarySouth   = CartesianIndices((numRows + 1, numCols))
    boundaryEast    = CartesianIndices((numRows, numCols + 1))
    return sort(union(boundaryNorth, boundaryWest, boundarySouth, boundaryEast))
end

function findInternalCubes(platformDiagram :: Matrix{Char}) :: Set{CartesianIndex{2}}
    return findall(==('#'), platformDiagram) |> Set
end

function findCubes(platformDiagram :: Matrix{Char}) :: Set{CartesianIndex{2}}
    return union(findBoundary(platformDiagram), findInternalCubes(platformDiagram))
end

function findAdjacentCubes(cubePosition :: CartesianIndex{2}, platform :: Platform)
    
end

function testSuite()
    @testset verbose=true begin
        platform = parseInput("inputTest.txt")
        @testset "Cubes" begin
            boundaryManual      = union(CartesianIndices((0:0, 1:10)), CartesianIndices((1:10, 0:0)), CartesianIndices((11, 10)), CartesianIndices((10, 11)))
            internalCubesManual = Set([CartesianIndex(1, 6), CartesianIndex(2, 5), CartesianIndex(2, 10), CartesianIndex(3, 6), CartesianIndex(3, 7), CartesianIndex(4, 4), CartesianIndex(5, 9), CartesianIndex(6, 3), CartesianIndex(6, 8), CartesianIndex(6, 10), CartesianIndex(7, 6), CartesianIndex(9, 1), CartesianIndex(9, 6), CartesianIndex(9, 7), CartesianIndex(9, 8), CartesianIndex(10, 1), CartesianIndex(10, 6)])
            @test findBoundary(platform)      == boundaryManual
            @test findInternalCubes(platform) == internalCubesManual
            @test findCubes(platform)         == union(boundaryManual, internalCubesManual)
        end

    end
end

testSuite()