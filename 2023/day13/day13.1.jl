function parseInput(path :: String) :: Vector{Matrix{String}}
    patternMatrixVector = []
    patternMatrix = []
    for line in eachline(path)
        # if line isn't empty push it to a temporary vector
        if line != ""
            push!(patternMatrix, string.(split(line, "")))
        else
            push!(patternMatrixVector, stack(patternMatrix) |> permutedims)
            empty!(patternMatrix)
        end
    end
    push!(patternMatrixVector, stack(patternMatrix) |> permutedims)
    return patternMatrixVector
end

"""
    findHorizontalReflection(patternMatrix :: Matrix{String}) :: Float64

Find the vertical line that results in a horizontal reflection.
"""
function findHorizontalReflection(patternMatrix :: Matrix{String}) :: Float64
    patternMatrixWidth = size(patternMatrix)[2]
    # for each area in between the columns
    for inbetween in 1.5 : patternMatrixWidth
        distanceLeft  = floor(Int, inbetween)
        distanceRight = ceil(Int, patternMatrixWidth - inbetween)
        radius        = min(distanceLeft, distanceRight)
        matrixLeft    = patternMatrix[CartesianIndices((1:size(patternMatrix)[1], ceil(Int, inbetween - radius) : floor(Int, inbetween)))] 
        matrixRight   = patternMatrix[CartesianIndices((1:size(patternMatrix)[1], ceil(Int, inbetween) : floor(Int, inbetween + radius)))]
        # println("inbetween: $inbetween, radius: $radius, isReflection: $(matrixLeft == reverse(matrixRight, dims=2))")
        if matrixLeft == reverse(matrixRight, dims=2)
            return inbetween
        end
    end
    # should only get here if no reflection is found
    return 0
end

"""
    findVerticalReflection(patternMatrix :: Matrix{String}) :: Float64

Find the horizontal line that results in a vertical reflection.
"""
function findVerticalReflection(patternMatrix :: Matrix{String}) :: Float64
    patternMatrixHeight, patternMatrixWidth = size(patternMatrix)
    # for each area in between the columns
    for inbetween in 1.5 : patternMatrixHeight
        distanceLeft  = floor(Int, inbetween)
        distanceRight = ceil(Int, patternMatrixHeight - inbetween)
        radius        = min(distanceLeft, distanceRight)
        matrixTop     = patternMatrix[CartesianIndices((ceil(Int, inbetween - radius) : floor(Int, inbetween), 1:patternMatrixWidth))]
        matrixBot     = patternMatrix[CartesianIndices((ceil(Int, inbetween) : floor(Int, inbetween + radius), 1:patternMatrixWidth))]
        # println("inbetween: $inbetween, radius: $radius, isReflection: $(matrixLeft == reverse(matrixRight, dims=2))")
        if matrixTop == reverse(matrixBot, dims=1)
            return inbetween
        end
    end
    # should only get here if no reflection is found
    return 0
end

function findReflection(patternMatrix :: Matrix{String}) :: Dict{String, Float64}
    reflectionHorizontal = findHorizontalReflection(patternMatrix)
    reflectionVertical   = findVerticalReflection(patternMatrix)
    return Dict("horizontal" => reflectionHorizontal, "vertical" => reflectionVertical)
end

function main()
    patternMatrixVector = parseInput("input.txt")
    reflectionVector    = findReflection.(patternMatrixVector)
    sum(iszero(reflection["vertical"]) ? floor(Int, reflection["horizontal"]) : 100 * floor(Int, reflection["vertical"]) for reflection in reflectionVector) |> display
end

main()