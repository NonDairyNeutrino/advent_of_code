const cardStrengthDict = Dict(
    "A" => 13, "K" => 12, "Q" => 11, "T" => 9, "9" => 8, "8" => 7,
    "7" => 6,  "6" => 5,  "5" => 4,  "4" => 3,  "3" => 2, "2" => 1, "J" => 0
)

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

julia> Hand("JKKK2")
Hand(Card[Card("J", 0), Card("K", 12), Card("K", 12), Card("K", 12), Card("2", 1)], 9//2)
```
See also: `strength`
"""
struct Hand
    cardVector :: Vector{Card}
    strength :: Rational
    function Hand(cardVector :: Vector{Card})
        new(cardVector, strength(cardVector))
    end
    function Hand(handString :: String)
        cardVector = Card.(string.(split(handString, "")))
        Hand(cardVector)
    end
end

"""
    countEach(v :: Vector{T}) :: Dict{T, Int} where T <: Any

Returns the pairs of values and their counts.

# Examples
```jldoctest
julia> countEach([1,1,2,3])
Dict{Int64, Int64} with 3 entries:
  2 => 1
  3 => 1
  1 => 2

julia> countEach(["a", "b", "c"])
Dict{String, Int64} with 3 entries:
  "c" => 1
  "b" => 1
  "a" => 1

julia> countEach([1, "b", ['c']])
Dict{Any, Int64} with 3 entries:
  "b"   => 1
  ['c'] => 1
  1     => 1
```
See also: `unique`, `count`, `==`, `Dict`, 
"""
function countEach(v :: Vector{T}) :: Dict{T, Int} where T <: Any
    uniqueItemVector = unique(v)
    return Dict([uniqueItem => count(==(uniqueItem), v) for uniqueItem in uniqueItemVector])
end

"""
    mode(v :: Vector{T}) :: T where {T <: Any}

Return the item that occurs most.

# Examples
```jldoctest
julia> mode([1,1,2,3])
1

julia> mode([1,2,3])
[1,2,3]

julia> mode([1])
1
```
"""
function mode(v :: Vector{T}) :: Union{T, Vector{T}} where {T <: Any}
    thing = countEach(v)
    valueVector = collect(values(thing))
    try
        all(Bool[valueVector...]) # throws an error if there is more than one of a single value
        return v[1]
    catch
        index = argmax(valueVector)
        return collect(keys(thing))[index]
    end
end

"""
    strength(cardLetter :: String) :: Int

Give the strength of the given card value.

# Examples
```jldoctest
julia> strength("A")
13
```
See also: `cardStrengthDict`
"""
function strength(cardLetter::String)::Int
    return cardStrengthDict[cardLetter]
end

echo(x) = (display(x); x)

"""
    strength(cardVector :: Vector{Card}) :: Rational

Give the strength of the given vector of cards, with wild joker.

# Examples

```jldoctest
julia> strength(Card[Card("A"), Card("A"), Card("A"), Card("A"), Card("A")])
5//1

julia> strength(Card[Card("A"), Card("A"), Card("A"), Card("A"), Card("J")])
5//1

julia> strength(Card[Card("J"), Card("J"), Card("J"), Card("J"), Card("2")])
5//1

julia> strength(Card[Card("J"), Card("J"), Card("J"), Card("J"), Card("J")])
5//1

julia> strength(Card[Card("A"), Card("K"), Card("Q"), Card("J"), Card("T")])
1//1

julia> strength(Card[Card("A"), Card("K"), Card("Q"), Card("J"), Card("J")])
```
See also: `unique`
"""
function strength(cardVector :: Vector{Card}) :: Rational
    # have to remove the joker cards before taking the mode
    # otherwise the mode could itself be a joker
    cardVectorNoJoker = filter(!=(Card("J")), cardVector)
    # if hand only has jokers, then joker is an ace
    jokerReplacement = isempty(cardVectorNoJoker) ? Card("A") : mode(cardVectorNoJoker)
    # only replace jokers to calculate strength and not actually replace the card in the hand
    cardVectorReplaced = replace(cardVector, Card("J") => jokerReplacement)

    distinctCardVector = unique(cardVectorReplaced)
    countDistinct = length(distinctCardVector)
    # five of a kind
    if countDistinct == 1
        return 5
    # four of a kind OR full house
    elseif countDistinct == 2
        subCount = Set(count(card -> distinctCard === card, cardVectorReplaced) for distinctCard in distinctCardVector)
        # four of a kind
        if subCount == Set([4, 1])
            return 4.5
            # full house
        elseif subCount == Set([3, 2])
            return 4
        end
    # three of a kind OR two pair
    elseif countDistinct == 3
        subCount = Set(count(card -> distinctCard === card, cardVectorReplaced) for distinctCard in distinctCardVector)
        # three of a kind
        if subCount == Set([3, 1, 1])
            return 3.5
        # two pair
        elseif subCount == Set([2, 2, 1])
            return 3
        end
    # one pair
    elseif countDistinct == 4
        return 2
    # high card
    elseif countDistinct == 5
        return 1
    end
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

julia> handJoker = Hand(Card[Card("A"), Card("A"), Card("A"), Card("A"), Card("J")]);
julia> handNotJoker = Hand(Card[Card("A"), Card("A"), Card("A"), Card("A"), Card("A")]);
julia> isless(handJoker, handNotJoker)
true
julia> isless(handNotJoker, handJoker)
false
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

"""
    parseInput(path :: String)

Transform the file at the given path to a structured collection of hands and bids.

# Examples

```jldoctest
julia> parseInput()
```
See also: `Dict`, `eachline`, `split`, `Card`, `parse`
"""
function parseInput(path::String) #= :: Vector{Vector{Union{Hand, Int}}} =#
    parsedInput = Dict{String,Union{Hand,Int}}[]
    for line in eachline(path)
        cardString, bid = split(line)
        push!(parsedInput, Dict(["hand" => Hand(string(cardString)), "bid" => parse(Int, bid)]))
    end
    return parsedInput
end

function main()
    handBidDictVector = parseInput("input.txt")
    handBidDictVectorSorted = sort(handBidDictVector, by=(handBidDict -> handBidDict["hand"]))
    return sum(handBidDict["bid"] * rank for (rank, handBidDict) in enumerate(handBidDictVectorSorted))
end

main() |> display
