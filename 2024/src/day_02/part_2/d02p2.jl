# Day 02, Part 2
#=
Plan of Attack:
1. import data as matrix of ints
2. get test each row if safe
=#
using Test

const RECORDVECTOR = readlines("input.txt") .|> (line -> parse.(Int, split(line)))
const CHANGEMIN = 1
const CHANGEMAX = 3
const FAULTTOLERANCE = 1

function isMonotonic(record :: Vector{Int}) :: Bool
    direction = record[1] < record[2] ? isless : Base.isgreater
    for i in 1:length(record)-1
        left, right = record[i:i+1]
        !direction(left, right) && return false
    end
    return true
end

# isMonotonic test
@testset "isMonotonic testing" begin
@test isMonotonic([1,2,3,4]) == true
@test isMonotonic([4,3,2,1]) == true
@test isMonotonic([1,2,2,1]) == false
@test isMonotonic([1,1,1,1]) == false
@test isMonotonic([1,2,3,2,1]) == false
end

"""
    isSafe!(record :: Vector{Int}, faultCount = 0) :: Bool

Determines if a record is safe by recursivey testing it without faulting elements.
"""
function isSafe!(record :: Vector{Int}, faultCount = 0) :: Bool
    # base case
    # test if fault tolerance has been met
    # or record has become empty (in case FAULTTOLERANCE > length(record))
    (faultCount == FAULTTOLERANCE + 1 || isempty(record)) && return false
    # determine if the record SHOULD be increasing or decreasing
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

# filter(!isSafe!, RECORDVECTOR)