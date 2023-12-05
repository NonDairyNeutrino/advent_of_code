# Advent of Code day 4 part 1
mutable struct Card
    id       :: Int
    winCount :: Int
    instanceCount :: Int
    function Card(cardString :: String)
        idString, winString, yourString = strip.(split(cardString, r"[:|]"))
        id       = parse(Int, split(idString)[2])
        winSet   = (char -> parse(Int, char)).(split(winString)) |> Set
        yourSet  = (char -> parse(Int, char)).(split(yourString)) |> Set
        winCount = intersect(winSet, yourSet) |> length
        return new(id, winCount, 0) # initialize instanceCount at 0 to only count during tree traversal
    end
    function Card(id :: Vector{Int}, winCount :: Int)
        return new(id, winCount)
    end
end

struct Node
    card :: Card
    childVector :: Vector{Node}
    function Node(card :: Card)
        if card.winCount != 0
            winningIDRange = card.id .+ (1 : card.winCount)
            childVector = Node.(cardVector[winningIDRange])
        else
            childVector = Node[]
        end
        return new(card, childVector)
    end
end

"""
    buildCardVector(path :: String) :: Vector{Card}

Get the collection of cards for the given input file.
"""
function buildCardVector(path :: String) :: Vector{Card}
    return Card.(readlines(path))
end

function isLeaf(node :: Node)
    return node.childVector === Node[]
end

function traverse!(root :: Node)
    if isLeaf(root)
        root.card.instanceCount += 1
        return 
    else
        root.card.instanceCount += 1
        traverse!.(root.childVector)
    end
end

function main()
     # cardVector is a seperate object to be referenced
    #= card = cardVector[1] =# for card in cardVector
        root = Node(card)
        traverse!(root)
    end
    sum(card.instanceCount for card in cardVector)
end

const cardVector = buildCardVector("input.txt")
main() |> display