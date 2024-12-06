# Day 04, Part 1
#=
Plan of Attack:
1. 
=#
using Test
test = """MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX"""

const east  = CartesianIndex(1,0)
const ne    = CartesianIndex(1,-1)
const north = CartesianIndex(0, -1)
const nw    = CartesianIndex(-1,-1)
const west  = CartesianIndex(-1,0)
const sw    = CartesianIndex(-1,1)
const south = CartesianIndex(0, 1)
const se    = CartesianIndex(1,1)

grid :: Matrix{Char} = readlines("input.txt") .|> collect |> stack

function getLetter(grid :: Matrix{Char}, position :: CartesianIndex, length :: Int, direction :: CartesianIndex) :: Char
    displacement :: CartesianIndex  = length * direction
    positionFinal :: CartesianIndex = position + displacement
    try
        return grid[positionFinal]
    catch e
        println("Edge detected; Returning 'E'")
        return 'E'
    end
end

mat = ['a' 'b' 'c'; 'd' 'e' 'f'; 'g' 'h' 'i']
display(mat)
center = CartesianIndex(2,2)
length = 1
@testset "getLetter" begin
    dirVector = [east, ne, north, nw, west, sw, south, se]
    @testset "Unit Direction: $dir" for (dir, res) in zip(dirVector, ['f', 'c', 'b', 'a', 'd', 'g', 'h', 'i'])
        @test getLetter(mat, center, length, dir) == res
    end
end

# function getWord(grid :: Matrix{Char}, position :: CartesianIndex, length :: Int, direction :: CartesianIndex)
#     for r in 1:length
#         index :: CartesianIndex = position + r * direction
#         grid[]
# end

# posVector :: Vector{CartesianIndex{2}} = findall(c -> c == 'X', grid)
# posVector .+ CartesianIndex()

# function getDirections(index :: CartesianIndex) :: Vector{String}
#     getEast()
#     getNE()
#     getNorth()
#     getNW()
#     getWest()
#     getSW()
#     getSouth()
#     getSE()
# end
