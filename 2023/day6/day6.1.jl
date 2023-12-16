function getTimeCount(parameterDictionary :: Dict) :: Int
    dr = parameterDictionary["record distance"]
    tm = parameterDictionary["max time"]
    acceleration  = parameterDictionary["acceleration"]

    a = -acceleration
    b = acceleration*tm
    c = -dr

    discriminant = sqrt(b^2 - 4*a*c)
    denominator  = 2*a

    lowerBound, upperBound = (-b .+ ([1,-1] .* discriminant)) ./ denominator |> extrema
    try
        convert(Int, lowerBound) # check if lowerBound is an integer
        return (upperBound - 1) - (lowerBound + 1) + 1
    catch
        return round(upperBound, RoundDown) - round(lowerBound, RoundUp) + 1
    end
end

function parseInput(path :: String) :: Dict
    timeVector, distanceVector = match(r"\w+:\s+(?<times>[\d\s]+)\r\n\w+:\s+(?<distances>[\d\s]+)", readchomp(path))
    timeVector = (nString -> parse(Int, nString)).(split(timeVector))
    distanceVector = (nString -> parse(Int, nString)).(split(distanceVector))
    return Dict("timeVector" => timeVector, "distanceVector" => distanceVector)
end

echo(x) = (display(x); x)

function main()
    parsedInput = parseInput("input.txt")
    timeVector = parsedInput["timeVector"]
    distanceVector = parsedInput["distanceVector"]

    timeProduct = 1
    for (time, distance) in zip(timeVector, distanceVector)
        parameterDictionary = Dict("max time" => time, "record distance" => distance, "acceleration" => 1)
        timeCount = getTimeCount(parameterDictionary)
        println("time: $time, distance: $distance, timeCount: $timeCount")
        timeProduct *= timeCount
    end
    return timeProduct
end

main() |> display
