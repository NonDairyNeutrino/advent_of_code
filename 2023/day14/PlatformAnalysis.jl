using Test

struct Cube
    position  :: CartesianIndex{2}
    cubeNorth :: Cube
    cubeSouth :: Cube
    cubeEast  :: Cube
    cubeWest  :: Cube
    # function Cube()

    # end
end

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

function parseInput(path :: String) :: Matrix{Char}
    return [[line...] for line in eachline(path)] |> stack |> permutedims
end

"""
    findBoundary(platformDiagram :: Matrix{Char}) :: Vector{CartesianIndex{2}}

Return the surrounding boundary of the "open" platform diagram.

# Examples

```jldoctest
julia> platform = ['#' '.'; '#' 'O'];

julia> findBoundary(platform)
8-element Vector{CartesianIndex{2}}:
 CartesianIndex(0, 1)
 CartesianIndex(0, 2)
 CartesianIndex(1, 0)
 CartesianIndex(2, 0)
 CartesianIndex(3, 1)
 CartesianIndex(3, 2)
 CartesianIndex(1, 3)
 CartesianIndex(2, 3)
```
See also: `findInternalCubes`, `findCubes`, `union`.
"""
function findBoundary(platformDiagram :: Matrix{Char}) :: Vector{CartesianIndex{2}}
    numRows, numCols = size(platformDiagram)
    boundaryNorth   = CartesianIndices((0:0, 1 : numCols))
    boundaryWest    = CartesianIndices((1 : numRows, 0:0))
    boundarySouth   = CartesianIndices(((i -> i : i)(numRows + 1), 1 : numCols))
    boundaryEast    = CartesianIndices((1 : numRows, (i -> i : i)(numCols + 1)))
    return union(boundaryNorth, boundaryWest, boundarySouth, boundaryEast)
end

"""
    findInternalCubes(platformDiagram :: Matrix{Char}) :: Vector{CartesianIndex{2}}

Return the positions of the cubes on the platform.

# Examples
```jldoctest
julia> platform = ['#' '.'; '#' 'O'];

julia> findInternalCubes(platform)
2-element Vector{CartesianIndex{2}}:
 CartesianIndex(1, 1)
 CartesianIndex(2, 1)
 ```
 See also: `findBoundary`, `findall`.
"""
function findInternalCubes(platformDiagram :: Matrix{Char}) :: Vector{CartesianIndex{2}}
    return findall(==('#'), platformDiagram) # ordered by column
end

"""
    findCubes(platformDiagram :: Matrix{Char}) :: Vector{CartesianIndex{2}}

Return the positions of all cubes on the "closed" platform, sorted by column.

# Examples
```jldoctest
julia> platform = ['#' '.'; '#' 'O'];

julia> findCubes(platform)
10-element Vector{CartesianIndex{2}}:
 CartesianIndex(1, 0)
 CartesianIndex(2, 0)
 CartesianIndex(0, 1)
 CartesianIndex(1, 1)
 CartesianIndex(2, 1)
 CartesianIndex(3, 1)
 CartesianIndex(0, 2)
 CartesianIndex(3, 2)
 CartesianIndex(1, 3)
 CartesianIndex(2, 3)
````
See also: `findBoundary`, `findInternalCubes`.
"""
function findCubes(platformDiagram :: Matrix{Char}) :: Vector{CartesianIndex{2}}
    return union(findBoundary(platformDiagram), findInternalCubes(platformDiagram)) |> sort # ordered by column
end

function findAdjacentCubes(platform :: Platform, cube :: Cube)
    
end

function testSuite()
    @testset verbose=true begin
        platform = parseInput("inputTest.txt")
        @testset "Cubes" begin
            boundaryManual = union(
                CartesianIndices((0:0, 1:10)),   # north boundary
                CartesianIndices((1:10, 0:0)),   # west boundary
                CartesianIndices((11:11, 1:10)), # south boundary
                CartesianIndices((1:10, 11:11))  # east boundary
            )
            internalCubesManual = CartesianIndex{2}[
                CartesianIndex(9, 1), CartesianIndex(10, 1), CartesianIndex(6, 3), CartesianIndex(4, 4),
                CartesianIndex(2, 5), CartesianIndex(1, 6),  CartesianIndex(3, 6), CartesianIndex(7, 6),
                CartesianIndex(9, 6), CartesianIndex(10, 6), CartesianIndex(3, 7), CartesianIndex(9, 7),
                CartesianIndex(6, 8), CartesianIndex(9, 8),  CartesianIndex(5, 9), CartesianIndex(2, 10), CartesianIndex(6, 10)
            ]
            @test findBoundary(platform)      == boundaryManual
            @test findInternalCubes(platform) == internalCubesManual
            @test findCubes(platform)         == union(boundaryManual, internalCubesManual) |> sort
        end

    end
end

testSuite()