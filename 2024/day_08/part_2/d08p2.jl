# Day 08, Part 2
#=
Plan of Attack:
1. Step one description.
2. Step two description.
3. Additional steps...
=#

struct Antinode
    frequency :: String
    position :: CartesianIndex
end

function distance(p1 :: CartesianIndex, p2 :: CartesianIndex = CartesianIndex(0,0)) :: Int
    # if only one point is given, effectively returns the size of that vector
    return mapreduce(abs, +, p1 - p2) # manhattan distance
end

function inBounds(bounds :: Dims{2}, position :: CartesianIndex) :: Bool
    return all((1,1) .<= Tuple(position) .<= bounds)
end

function showAntinodes(grid :: Matrix{SubString{String}}, antinodeVector :: Vector{Antinode})
    for antinode in antinodeVector
        f = antinode.frequency
        grid[antinode.position] = "#$f"
    end
    return grid
end

function main()
    grid = split.(readlines("input.txt"), "") |> stack |> permutedims
    bounds = size(grid)
    frequencyVector = unique(grid) |> freqVector -> deleteat!(freqVector, [findfirst(==("."), freqVector)#= , findfirst(==("#"), freqVector) =#])
    antennaMap = [(freq, CartesianIndex[]) for freq in frequencyVector] |> Dict
    for freq in keys(antennaMap)
        antennaMap[freq] = findall(==(freq), grid)
    end
    
    antinodeVector = Antinode[]
    for freq in keys(antennaMap)
        apVector = antennaMap[freq]
        for (ap1, ap2) in Iterators.product(apVector, apVector)
            if ap1 != ap2
                displacement :: CartesianIndex = ap2 - ap1

                anp = ap1
                while inBounds(bounds, anp)
                    push!(antinodeVector, Antinode(freq, anp))
                    anp -= displacement
                end
                
                anp = ap2
                while inBounds(bounds, anp)
                    push!(antinodeVector, Antinode(freq, anp))
                    anp += displacement
                end
            end
        end
    end

    filter!(an -> inBounds(bounds, an.position), antinodeVector)
    unique!(an -> an.position, antinodeVector)
    println("Number of antinodes: ", length(antinodeVector))
    return showAntinodes(grid, antinodeVector)
end

main()

# using DelimitedFiles
# open("solution.txt", "w") do io
#     writedlm(io, sol, " ")
# end