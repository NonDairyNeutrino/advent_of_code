# Day 02, Part 2
#=
Plan of Attack:
1. import data as matrix of ints
2. get test each row if safe
=#

const RECORDVECTOR = readlines("input.txt") .|> (line -> parse.(Int, split(line)))
const CHANGEMIN = 1
const CHANGEMAX = 3
const FAULTTOLERANCE = 1

function isSafe!(record :: Vector{Int}, faultCount = 0) :: Bool
    # base case
    (faultCount == FAULTTOLERANCE + 1 || isempty(record)) && return false
    # determine if it SHOULD be increasing or decreasing
    direction = record[1] < record[2] ? isless : Base.isgreater

    for i in 1:length(record)-1
        left, right = record[i:i+1]
        if !direction(left, right)
            faultCount += 1
            return isSafe!(deleteat!(record, i+1), faultCount)
        end
        if !(CHANGEMIN <= abs(left - right) <= CHANGEMAX)
            faultCount += 1
            return isSafe!(deleteat!(record, i+1), faultCount)
        end
    end
    return true
end

count(record -> (!isSafe!(record) && println("record: $record "); isSafe!(record)), RECORDVECTOR)