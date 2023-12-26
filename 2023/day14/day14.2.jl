using Test
using LinearAlgebra
using Dates

@enum Direction north east south west

function parseInput(path :: String) :: Matrix{Char}
    return [[line...] for line in eachline(path)] |> stack |> permutedims
end

function direction(dir :: Direction)
    if dir == north
        return CartesianIndex(-1, 0)
    elseif dir == east
        return CartesianIndex(0, 1)
    elseif dir == south
        return CartesianIndex(1, 0)
    elseif dir == west
        return CartesianIndex(0, -1)
    end
end

function inBounds(platform::Matrix{Char}, rockPosition :: CartesianIndex{2}) :: Bool
    return rockPosition in CartesianIndices(platform)
end

function isOnNextEdge(platform::Matrix{Char}, tiltDir::Direction, rockPosition::CartesianIndex{2}) :: Bool
    rockRowNumber, rockColNumber = rockPosition |> Tuple
    platformSouthEdge, platformEastEdge = size(platform)

    if tiltDir == north
        return rockRowNumber == 1
    elseif tiltDir == south
        return rockRowNumber == platformSouthEdge
    elseif tiltDir == east
        return rockColNumber == platformEastEdge
    elseif tiltDir == west
        return rockColNumber == 1
    end
end

function findNextCube(platform :: Matrix{Char}, tiltDir :: Direction, rockPosition :: CartesianIndex{2}) :: CartesianIndex{2}
    rockRowNumber, rockColNumber = rockPosition |> Tuple

    if tiltDir == north || tiltDir == south
        colPartial = platform[:,  rockColNumber]

        if tiltDir == north
            cubePosition = findprev(==('#'), colPartial, rockRowNumber) # returns nothing if no cube
            if isnothing(cubePosition)
                return CartesianIndex(0, rockColNumber)
            end
        elseif tiltDir == south
            cubePosition = findnext(==('#'), colPartial, rockRowNumber) # returns nothing if no cube
            if isnothing(cubePosition)
                return CartesianIndex(size(platform)[1] + 1, rockColNumber)
            end
        end

        return CartesianIndex(cubePosition, rockColNumber)
    else
        rowPartial = platform[rockRowNumber, :]

        if tiltDir == east
            cubePosition = findnext(==('#'), rowPartial, rockColNumber) # returns nothing if no cube
            if isnothing(cubePosition)
                return CartesianIndex(rockRowNumber, size(platform)[2] + 1)
            end
        elseif tiltDir == west
            cubePosition = findprev(==('#'), rowPartial, rockColNumber) # returns nothing if no cube
            if isnothing(cubePosition)
                return CartesianIndex(rockRowNumber, 0)
            end
        end
        return CartesianIndex(rockRowNumber, cubePosition)
    end
end

function countNextRocks(platform :: Matrix{Char}, tiltDir :: Direction, rockPosition :: CartesianIndex{2}) :: Int
    if isOnNextEdge(platform, tiltDir, rockPosition)
        return 0
    else
        cubePosition = findNextCube(platform, tiltDir, rockPosition)
        if !inBounds(platform, cubePosition)
            cubePosition -= direction(tiltDir)
        end
        mn, mx = sort([rockPosition, cubePosition], by=(ind -> norm(Tuple(ind))))
        slice  = platform[mn:mx]
        return count(==('O'), slice) - 1 # minus one because it counts itself
    end
end

function rollRock(platform :: Matrix{Char}, tiltDir :: Direction, rockPosition :: CartesianIndex{2}) :: CartesianIndex{2}
    nextCubePosition = findNextCube(  platform, tiltDir, rockPosition)
    newCubeDistance  = countNextRocks(platform, tiltDir, rockPosition) + 1
    rockPositionNew  = nextCubePosition - newCubeDistance * direction(tiltDir)
    return rockPositionNew
end

function rollRock(platform :: Matrix{Char}, tiltDir :: Direction)
    return (rockPosition -> rollRock(platform, tiltDir, rockPosition))
end

function tilt(platform :: Matrix{Char}, tiltDir :: Direction) :: Matrix{Char}
    rockPositionVector    = findall(==('O'), platform)

    rockPositionVectorNew = CartesianIndex{2}[]
    Threads.@threads for rockPosition in rockPositionVector
        @lock ReentrantLock() push!(rockPositionVectorNew, rollRock(platform, tiltDir, rockPosition))
    end

    # rockPositionVectorNew = rollRock(platform, tiltDir).(rockPositionVector)
    platformNew           = deepcopy(platform)
    platformNew[rockPositionVector]    .= '.'
    platformNew[rockPositionVectorNew] .= 'O'
    return platformNew
end

function calculateLoad(platform :: Matrix{Char}, rockPosition :: CartesianIndex{2}) :: Int
    return size(platform)[1] - rockPosition[1] + 1
end

function cycle(platform :: Matrix{Char}, n = 1 :: Int) :: Matrix{Char}
    platformNew = deepcopy(platform)
    start = now()
    t0 = start
    for i in 1:n
        for tiltDir in [north, west, south, east]
            platformNew = tilt(platformNew, tiltDir)
        end
        if iszero(i % (n/10^4))
            t = now()
            # println("Current time: $t, Previous Time: $t0, Difference: $((t - t0).value / 1000) seconds")
            # dt               = (t - t0).value / 1000 # seconds / 10^5 steps
            percentCompleted = 100 * i / n
            stepsLeft        = n - i
            # timeRemaining    = dt * 10^5 * stepsLeft
            timeElapsed      = round((t - start).value / 1000 / 60, sigdigits = 2)

            println("$percentCompleted% completed; Elapsed time: $timeElapsed") #; Estimated Remaining Time: $timeRemaining")
            t0 = now()
        end
    end
    return platformNew
end

echo(x) = (display(x); x)
function testSuite()
    platform = parseInput("inputTest.txt")
    rockPositionVector = findall(==('O'), platform)
    @testset verbose = true begin #= for rockPosition in rockPositionVector =#
        rockPosition = rockPositionVector[10]
        println("Testing for rock at $rockPosition")
        @testset "isOnNextEdge" begin
            @test isOnNextEdge(platform, north, rockPosition) == false
            @test isOnNextEdge(platform, east,  rockPosition) == false
            @test isOnNextEdge(platform, south, rockPosition) == true
            @test isOnNextEdge(platform, west,  rockPosition) == false
        end
        @testset "findNextCube" begin
            @test findNextCube(platform, north, rockPosition) == CartesianIndex(6, 3)
            @test findNextCube(platform, east,  rockPosition) == CartesianIndex(10, 6)
            @test findNextCube(platform, south, rockPosition) == CartesianIndex(11, 3)
            @test findNextCube(platform, west,  rockPosition) == CartesianIndex(10, 1)
        end
        @testset "countNextRocks" begin
            @test countNextRocks(platform, north, rockPosition) == 1
            @test countNextRocks(platform, east,  rockPosition) == 0
            @test countNextRocks(platform, south, rockPosition) == 0
            @test countNextRocks(platform, west,  rockPosition) == 1
        end
        @testset "rollRock" begin
            @test rollRock(platform, north, rockPosition) == CartesianIndex(8, 3)
            @test rollRock(platform, east,  rockPosition) == CartesianIndex(10, 5)
            @test rollRock(platform, south, rockPosition) == CartesianIndex(10, 3)
            @test rollRock(platform, west,  rockPosition) == CartesianIndex(10, 3)
        end
        @testset "tilt" begin
            # println("Test input")
            # display(platform)

            # println("Test output")
            # display(parseInput("outputTest.txt"))

            # println("Calculated output")
            @test tilt(platform, north) == parseInput("outputTest.txt")
        end
        @testset "cycle$n" for n in 1:3 
            @test cycle(platform, n) == parseInput("inputTestCycle$n.txt")
        end
    end
end

#= 
1. find positions of all rocks
2. for each rock, find the nearest cube in given Direction
3. for each rock, find the number of rocks n_r between it and nearest cube in given Direction
4. for each rock, move to site n_r + 1 in opposite direction of rock
=#
function main()
    platform = parseInput("inputTest.txt")
    platformNew = cycle(platform, 10^9)
    rockPositionVectorNew = findall(==('O'), platformNew)
    return sum(calculateLoad(platformNew, rockPositionNew) for rockPositionNew in rockPositionVectorNew)
end

# testSuite()
main() |> display
