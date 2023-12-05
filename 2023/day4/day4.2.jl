# Advent of Code day 4 part 1
struct Card
    id       :: Int
    winCount :: Int
    function Card(cardString :: String)
        idString, winString, yourString = strip.(split(cardString, r"[:|]"))
        id       = parse(Int, split(idString)[2])
        winSet   = (char -> parse(Int, char)).(split(winString)) |> Set
        yourSet  = (char -> parse(Int, char)).(split(yourString)) |> Set
        winCount = intersect(winSet, yourSet) |> length
        return new(id, winCount)
    end
    function Card(id :: Vector{Int}, winCount :: Int)
        return new(id, winCount)
    end
end

mutable struct Node
    value :: Vector{Int} # vector of card IDs representing the path to the node in the tree
    childVector :: Vector{Node}
    function Node(value :: Vector{Int}, childVector = Node[])
        return new(value, childVector)
    end
end

"""
    buildCardVector(path :: String) :: Vector{Card}

Get the collection of cards for the given input file.
"""
function buildCardVector(path :: String) :: Vector{Card}
    return Card.(readlines(path))
end

function main(path :: String)
    cardVector = buildCardVector(path) # cardVector is a seperate object to be referenced
    card = cardVector[1] # for card in cardVector

    root = Node([card.id])
    winningIDVector = (root.value)[end] .+ (1 : cardVector[(root.value)[end]].winCount)
    root.childVector = [Node([root.value...; winnerID]) for winnerID in winningIDVector]
end

main("input_test.txt") |> display