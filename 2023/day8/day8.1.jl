mutable struct Node
    name :: String
    childLeft :: Union{Node, Nothing}
    childRight :: Union{Node, Nothing}
    function Node(name :: String)
        return new(name, nothing, nothing)
    end
    function Node(name :: String, childLeft :: Node, childRight :: Node)
        return new(name, childLeft, childRight)
    end
end

function parseInput(path::String)
    lineVector = readlines(path)
    stepVector = String.(split(lineVector[1], ""))
    nodeDict = Dict{String, Dict{String, String}}()
    for nodeString in lineVector[3:end]
        nodeName, nodeLeft, nodeRight = string.(match(r"(?<nodeName>\w+) = .(?<leftNode>\w+), (?<rightNode>\w+).", nodeString))
        push!(nodeDict, nodeName => Dict("L" => nodeLeft, "R" => nodeRight))
    end
    return (steps = Iterators.cycle(stepVector), graph = nodeDict)
end

function main()
    stepIterator, graph = parseInput("input.txt")
    node = "AAA"
    for (stepNumber, stepDirection) in enumerate(stepIterator)
        # display(node)
        if node != "ZZZ"
            node = graph[node][stepDirection]
        else
            display(stepNumber - 1)
            break
        end
    end
end

main()