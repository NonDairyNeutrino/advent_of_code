const cardStrengthDict = Dict("A" => 13, "K" => 12, "Q" => 11, "J" => 10, "T" => 9, "9" => 8, "8" => 7, "7" => 6, "6" => 5, "5" => 4, "4" => 3, "3" => 2, "2" => 1)

"""
    Card(cardValue :: String)

Give a card object with its value and strength.

# Examples
```jldoctest
julia> Card("A")
Card("A", 13)
```
See also: `cardStrengthDict`
"""
struct Card
    value :: String
    strength :: Int
    function Card(cardLetter :: String)
        return new(cardLetter, strength(cardLetter))
    end
end

"""
    Hand(cardVector :: Vector{Hand})

Give hand object with its vector of cards and strength.

# Examples
```jldoctest
julia> Hand(Card[Card("A"), Card("A"), Card("A"), Card("A"), Card("A")])
Hand(Card[Card("A", 13), Card("A", 13), Card("A", 13), Card("A", 13), Card("A", 13)], 5//1)
```
See also: `strength`
"""
struct Hand
    cardVector :: Vector{Card}
    strength :: Rational
    function Hand(cardVector :: Vector{Card})
        new(cardVector, strength(cardVector))
    end
end

"""
    strength(cardLetter :: String) :: Int

Give the strength of the given card value.

# Examples
```jldoctest
julia> strength("A")
13

julia> strength("K")
12

julia> strength("9")
8

julia> strength(2)
1
```
See also: `cardStrengthDict`
"""
function strength(cardLetter::String)::Int
    return cardStrengthDict[cardLetter]
end

"""
    strength(cardVector :: Vector{Card}) :: Rational

Give the strength of the given vector of cards.

# Examples

```jldoctest
julia> strength(Card[Card("A"), Card("A"), Card("A"), Card("A"), Card("A")])
5//1
```
See also: `unique`
"""
function strength(cardVector::Vector{Card})::Rational
    distinctCardVector = unique(cardVector)
    countDistinct = length(distinctCardVector)
    if countDistinct == 1
        return 5
    elseif countDistinct == 2
        subCount = Set(count(card -> distinctCard === card, cardVector) for distinctCard in distinctCardVector)
        if subCount == Set([4, 1])
            return 4.5
        elseif subCount == Set([3, 2])
            return 4
        end
    elseif countDistinct == 3
        subCount = Set(count(card -> distinctCard === card, cardVector) for distinctCard in distinctCardVector)
        if subCount == Set([3, 1, 1])
            return 3.5
        elseif subCount == Set([2, 2, 1])
            return 3
        end
    elseif countDistinct == 4
        return 2
    elseif countDistinct == 5
        return 1
    end
end

"""
    parseInput(path :: String)

Transform the file at the given path to a structured collection of hands and bids.

# Examples

```jldoctest
julia> parseInput()
```
See also: `Dict`, `eachline`, `split`, `Card`, `parse`
"""
function parseInput(path :: String) #= :: Vector{Vector{Union{Hand, Int}}} =#
    parsedInput = Dict{String, Union{Hand, Int}}[]
    for line in eachline(path)
        cardString, bid = split(line)
        cardVector = Card.(string.(split(cardString, "")))
        push!(parsedInput, Dict(["hand" => Hand(cardVector), "bid" => parse(Int, bid)]))
    end
    return parsedInput
end

"""
    Base.isless(leftHand :: Hand, rightHand :: Hand)

Determines if one hand is less than another

# Examples
```jldoctest
julia> hand = Hand(Card[Card("A"), Card("A"), Card("A"), Card("A"), Card("A")]);
julia> isless(hand, hand)
false

julia> hand1 = Hand(Card[Card("A"), Card("A"), Card("A"), Card("A"), Card("A")]);
julia> hand2 = Hand(Card[Card("A"), Card("A"), Card("A"), Card("A"), Card("K")]);
julia> isless(hand1, hand2)
false
julia> isless(hand2, hand1)
true
```
"""
function Base.isless(leftHand :: Hand, rightHand :: Hand)
    if leftHand.strength != rightHand.strength
        return leftHand.strength < rightHand.strength
    else
        for (leftCard, rightCard) in zip(leftHand.cardVector, rightHand.cardVector)
            if leftCard.strength != rightCard.strength
                return leftCard.strength < rightCard.strength
            end
        end
        # only get here if all cards are equal i.e. hands are identical
        return false
    end
end

function main()
    handBidDictVector = parseInput("input.txt")
    handBidDictVectorSorted = sort(handBidDictVector, by=(handBidDict -> handBidDict["hand"])) # unsorted rank vector
    return sum(handBidDict["bid"] * rank for (rank, handBidDict) in enumerate(handBidDictVectorSorted))
end

main() |> display
