const cardStrengthDict = Dict("A" => 13, "K" => 12, "Q" => 11, "J" => 10, "T" => 9, "9" => 8, "8" => 7, "7" => 6, "6" => 5, "5" => 4, "4" => 3, "3" => 2, "2" => 1)

struct Card
    value :: String
    strength :: Int
    function Card(cardLetter :: String)
        return new(cardLetter, strength(cardLetter))
    end
end

struct Hand
    cardVector :: Vector{Card}
    strength :: Rational
    rank :: Int
    function Hand(cardVector :: Vector{Card})
        new(cardVector, strength(cardVector), 0)
    end
end

function strength(cardLetter::String)::Int
    return cardStrengthDict[cardLetter]
end

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

function parseInput(path :: String) #= :: Vector{Vector{Union{Hand, Int}}} =#
    parsedInput = Dict{String, Union{Hand, Int}}[]
    for line in eachline(path)
        cardString, bid = split(line)
        cardVector = Card.(string.(split(cardString, "")))
        push!(parsedInput, Dict(["hand" => Hand(cardVector), "bid" => parse(Int, bid)]))
    end
    return parsedInput
end

function handSort(leftHand :: Hand, rightHand :: Hand)
    if leftHand.strength != rightHand.strength
        return leftHand.strength < rightHand.strength
    else
        for (leftCard, rightCard) in zip(leftHand.cardVector, rightHand.cardVector)
            if leftCard.strength != rightCard.strength
                return leftCard.strength < rightCard.strength
            end
        end
    end
end

function main()
    handBidDictVector = parseInput("input_test.txt")
    rankVector = sortperm(handBidDictVector, by=(handBidDict -> handBidDict["hand"]), lt = handSort)
    return sum(handBidDict["bid"] * rank for (handBidDict, rank) in zip(handBidDictVector, rankVector))
end

main() |> display
