# Day 02, Part 1
#=
Plan of Attack:
1. import data as matrix of ints
2. get test each row if safe
=#

const RECORDVECTOR = readlines("input.txt") .|> (line -> parse.(Int, split(line)))
const CHANGEMIN = 1
const CHANGEMAX = 3

function isSafe(record :: Vector{Int}) :: Bool
    direction = record[1] < record[2] ? isless : Base.isgreater
    for i in 1:length(record)-1
        # when levels don't keep same direction, break
        left, right = record[i:i+1]
        !direction(left, right) && return false
        !(CHANGEMIN <= abs(left - right) <= CHANGEMAX) && return false
    end
    return true
end

count(isSafe, RECORDVECTOR)