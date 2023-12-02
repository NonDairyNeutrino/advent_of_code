# Advent of Code 2023 Day 1 part 2

const numStringSet = Set(["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"])
const numDigitSet  = Set(string.(0:9))
const numString    = Dict("one" => 1, "two" => 2, "three" => 3, "four" => 4, "five" => 5, "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9)

function stringToNum(str :: String)
    if length(str) == 1
        return parse(Int, str)
    else
        return numString[str]
    end
end

function fromDigits(digitVector :: Vector{Int}, base :: Int = 10)
    return sum(digitVector[end - k + 1] * base^(k-1) for k in 1:length(digitVector))
end

calibrationSum = 0
for line in eachline("input.txt")
    numVector = []
    for head in 1:length(line)
        for tail in 1:length(line)
            substring = SubString(line, head:tail) |> string
            if substring in union(numStringSet, numDigitSet)
                push!(numVector, substring)
                break
            end
        end
    end
    global calibrationSum += stringToNum.(numVector[[1, end]]) |> fromDigits
end

println(calibrationSum)
