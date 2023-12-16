function getTimeCount(parameterDictionary::Dict)::Int
    dr = parameterDictionary["record distance"]
    tm = parameterDictionary["max time"]
    acceleration = parameterDictionary["acceleration"]

    a = -acceleration
    b = acceleration * tm
    c = -dr

    discriminant = sqrt(b^2 - 4 * a * c)
    denominator = 2 * a

    lowerBound, upperBound = (-b .+ ([1, -1] .* discriminant)) ./ denominator |> extrema
    try
        convert(Int, lowerBound) # check if lowerBound is an integer
        return (upperBound - 1) - (lowerBound + 1) + 1
    catch
        return round(upperBound, RoundDown) - round(lowerBound, RoundUp) + 1
    end
end

function parseInput(path::String)::Dict{String, Int}
    timeVectorString, distanceVectorString = match(r"\w+:\s+(?<times>[\d\s]+)\r\n\w+:\s+(?<distances>[\d\s]+)", readchomp(path))
    time = parse(Int, replace(timeVectorString, r"\s" => ""))
    distance = parse(Int, replace(distanceVectorString, r"\s" => ""))
    return Dict("time" => time, "distance" => distance)
end

echo(x) = (display(x); x)

function main()
    parsedInput = parseInput("input.txt")
    time = parsedInput["time"]
    distance = parsedInput["distance"]

    parameterDictionary = Dict("max time" => time, "record distance" => distance, "acceleration" => 1)
    timeCount = getTimeCount(parameterDictionary)
    return timeCount
end

main() |> display
