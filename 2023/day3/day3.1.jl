# Advent of Code 2023 day 3 part 1

struct Part
    value :: Int
    position :: CartesianIndex
end

struct Symbol
    position :: CartesianIndex
    value :: Char
    partVector :: Vector{Part}
end

"""
1) find positions of all symbols
2) check adjacent sites for digits
3) if site has digit, add pair (digit, direction) to list and update location
4) repeat steps 2-3 for all symbols
"""

"""
    isSymbol(str :: String) :: Bool

Determine if given string is a symbol.

# Examples
```jldoctest
julia> isSymbol("*")
true

julia> isSymbol("3")
false

julia> isSymbol(".")
false
```
See also: `match`, `@r_str`
"""
function isSymbol(char :: Char) :: Bool
    return match(r"[^\d.]", string(char)) !== nothing
end

"""
    adjacentIndices(index :: CartesianIndex) :: CartesianIndices

Get the indices of the 9 positions around an index, including itself.

# Examples
```jldoctest
julia> adjacentIndices(CartesianIndex(0,0))
CartesianIndices((-1:1, -1:1))
```
See also: `CartesianIndex`, `CartesianIndices`.
"""
function adjacentIndices(index :: CartesianIndex) :: CartesianIndices
    return index .+ CartesianIndices((-1:1, -1:1))
end

"""
    digitTestPushLeft(charMatrix :: Matrix{Char}, index :: CartesianIndex, digitVector :: Vector{Int} = Int[]) :: Vector{Int}

Recursively test and push a digit character to a list, moving to the left.
"""
function digitTestPushLeft(charMatrix :: Matrix{Char}, index :: CartesianIndex, digitVector :: Vector{Int} = Int[]) :: Vector{Int}
    try
        char = charMatrix[index]
        if isdigit(char)
            push!(digitVector, parse(Int, char))
            return digitTestPushLeft(charMatrix, index + CartesianIndex(0, -1), digitVector)
        else
            return digitVector
        end
    catch _
        return digitVector
    end
end

"""
    digitTestPushRight(charMatrix::Matrix{Char}, index::CartesianIndex, digitVector::Vector{Int}=Int[])::Vector{Int}

Recursively test and push a digit character to a list, moving to the right.
"""
function digitTestPushRight(charMatrix::Matrix{Char}, index::CartesianIndex, digitVector::Vector{Int}=Int[])::Vector{Int}
    try
        char = charMatrix[index]
        if isdigit(char)
            push!(digitVector, parse(Int, char))
            return digitTestPushRight(charMatrix, index + CartesianIndex(0, 1), digitVector)
        else
            return digitVector
        end
    catch _
        return digitVector
    end
end

"""
    fromDigits(digitVector :: Vector{Int}, base = 10)

Create a number from a vector of digits in a given base.
"""
function fromDigits(digitVector :: Vector{Int}, base = 10)
    return sum(digitVector[end - k] * base^k for k in 0:length(digitVector) - 1)
end

"""
    digitTestPush(charMatrix::Matrix{Char}, index::CartesianIndex) :: Union{Vector{Int}, Nothing}

Get the digit vector of a number around a given index.
"""
function getPart(charMatrix::Matrix{Char}, index::CartesianIndex) :: Union{Part, Nothing}
    head =  digitTestPushLeft(charMatrix, index) |> reverse
    tail = digitTestPushRight(charMatrix, index)
    startingIndex = index - CartesianIndex(0, length(head) - 1)
    if length(head) == length(tail) == 1
        digitVector = head # could also be tail, since they're the same
    elseif length(head) == 1
        digitVector = tail
    elseif length(tail) == 1
        digitVector = head
    else
        digitVector = append!(head, tail[2:end])
    end
    if length(digitVector) != 0
        return Part(fromDigits(digitVector), startingIndex)
    end
end

function getSymbolParts(charMatrix :: Matrix{Char}, symbolPosition :: CartesianIndex{2}) :: Vector{Part}
    adjacentIndexMatrix = adjacentIndices(symbolPosition)
    symbolPartVector = Part[]
    for adjacentIndex in adjacentIndexMatrix
        part = getPart(charMatrix, adjacentIndex)
        if part ∉ symbolPartVector && part !== nothing # TODO: probably needs a custom Part comparison
            push!(symbolPartVector, part)
        end
    end
    return symbolPartVector
end

function main()
    charMatrix           = readlines("input.txt") |> stack |> permutedims # convert input into a matrix of characters
    symbolPositionVector = findall(isSymbol, charMatrix)                       # find positions of all symbols
    symbolVector         = Symbol[]                                            # make somewhere to put part numbers
    for symbolPosition   in symbolPositionVector                               # start going through each symbol
        symbolPartVector = getSymbolParts(charMatrix, symbolPosition)
        symbolvalue      = charMatrix[symbolPosition]
        symbol           = Symbol(symbolPosition, symbolvalue, symbolPartVector)
        push!(symbolVector, symbol)
    end
    return sum(sum(part.value for part in symbol.partVector) for symbol in symbolVector)
end

main() |> display