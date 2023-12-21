function parseInput(path :: String)
    return [(n -> parse(Int, n)).(split(line)) for line in eachline(path)]
end

function differences(list :: Vector{T}) :: Vector{T} where T <: Number
    return list[2:end] - list[1:end-1]
end

function predict(history :: Vector{Int}) :: Int
    if !allequal(history)
        return history[end] + predict(differences(history))
    else
        return history[1]
    end
end

function main()
    return sum(predict(history) for history in parseInput("input.txt"))
end

main() |> display
