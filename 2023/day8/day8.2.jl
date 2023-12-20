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

function period(graph :: Dict, stepIterator, node :: String) :: Int
    for (stepNumber, stepDirection) in enumerate(stepIterator)
        if endswith(node, "Z") # all(endswith("Z"), nodeVector)
            return stepNumber - 1
        else
            node = graph[node][stepDirection] # nodeVector = [graph[node][stepDirection] for node in nodeVector]
        end
    end
end

# solution is the least common multiple for step numbers
function main()
    stepIterator, graph = parseInput("input.txt")
    nodeVector = filter(endswith("A"), string.(collect(keys(graph))))
    periodDict = Dict{String, Int}(node => 0 for node in nodeVector)

    #= Threads.@threads  =#for node in nodeVector
        periodDict[node] = period(graph, stepIterator, node)
    end
    return lcm(collect(values(periodDict)))
end

main() |> display