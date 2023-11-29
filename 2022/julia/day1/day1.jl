# Advent of Code 2022
# Day 1

"""
    parseInput(path :: String)

Parse input file into structured data.

Examples
========
```jldoctest
julia> parseInput("test.txt")
5-element Vector{Vector{Int64}}:
 [1000, 2000, 3000]
 [4000]
 [5000, 6000]
 [7000, 8000, 9000]
 [10000]
```
"""
function parseInput(path :: String)
    # first check if the given path is valid
    if isfile(path)
        # create empty lists to populate with items and then push them onto a 
        elfList = Vector{Int}[]
        itemList = Int[]
        # pull data from file
        for item in eachline(path)
            # put all items into a box
            if !isempty(item) # check if line is an elf seperator
                push!(itemList, parse(Int, item))
            # put the item box into a bigger box
            else
                push!(elfList, itemList |> deepcopy)
                empty!(itemList)
            end
        end
        # the above loop doesn't push the last itemList, so do that here
        push!(elfList, itemList)
        return elfList
    else
        return "$path not found."
    end
end

function countCalories(elf :: Vector{Int})
    return sum(elf)
end

function main()
    data = parseInput("input1.txt")
    calorieSumVector = [countCalories(elf) for elf in data]
    # part 2
    top3 = sort(calorieSumVector, by = sum)[end:-1:end-2]
    top3total = sum(top3)
    return "The most calories: $(maximum(calorieSumVector)). The total of the 3 topmost: $top3total."
end

main() |> println