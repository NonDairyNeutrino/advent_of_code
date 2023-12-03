struct rucksack
    compartment1 :: Set
    compartment2 :: Set
end

function main()
    compartmentVector = [Set.([sack[1 : end/2], sack[end/2 + 1 : end]]) for sack in eachline("day3/input3.txt")]
    rucksackVector = [rucksack(compartment...) for compartment in compartmentVector]
    
end