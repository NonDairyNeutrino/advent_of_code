# Day 05, Part 1
#=
Plan of Attack:
1. find all valid updates
    1.1 filter rules based on update members
    1.2 test update for each filtered rule
2. find middle page number
3. add all middle page numbers
=#

updateVector :: Vector{Vector{Int}} = readlines("updates.txt") .|> (line -> split(line, ",")) .|> (update -> parse.(Int, update))
ruleVector   :: Vector{Vector{Int}} = readlines("rules.txt") .|> (line -> split(line, "|")) .|> (rule -> parse.(Int, rule))

function filterRules(update :: Vector{Int}) :: Vector{Vector{Int}}
    return filter(issubset(update), ruleVector)
end

function isInOrder(update :: Vector{Int}, rule :: Vector{Int}) :: Bool
    return intersect(update, rule) == rule
end

function getCenter(update :: Vector{Int}) :: Int
    return update[cld(length(update), 2)]
end

function main() :: Nothing
    sortedTotal = 0
    unsortedTotal = 0
    for update in updateVector
        # println(ruleVector)
        filteredRules :: Vector{Vector{Int}} = filterRules(update)
        if all(rule -> isInOrder(update, rule), filteredRules)
            sortedTotal += getCenter(update)
        else
            sortedUpdate = sort(update, lt=((left, right) -> [left, right] in ruleVector))
            unsortedTotal += getCenter(sortedUpdate)
        end
    end
    println("sortedTotal: $sortedTotal, unsortedTotal: $unsortedTotal")
    return
end

main()
