using Test
using Dates
using Memoization
using Profile

@enum Direction north east south west

function parseInput(path :: String) :: Matrix{Char}
    return [[line...] for line in eachline(path)] |> stack |> permutedims
end

@memoize function direction(dir :: Direction)
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

function findNextCubeCol(platform :: Matrix{Char}, tiltDir :: Direction, rockPosition :: CartesianIndex{2})
    rockRowNumber, rockColNumber = rockPosition |> Tuple
    colPartial = view(platform, :, rockColNumber)

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
end

function findNextCubeRow(platform::Matrix{Char}, tiltDir::Direction, rockPosition::CartesianIndex{2})
    rockRowNumber, rockColNumber = rockPosition |> Tuple
    rowPartial = view(platform, rockRowNumber, :)

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

function findNextCube(platform :: Matrix{Char}, tiltDir :: Direction, rockPosition :: CartesianIndex{2}) :: CartesianIndex{2}
    if tiltDir == north || tiltDir == south
        return findNextCubeCol(platform, tiltDir, rockPosition)
    else
        return findNextCubeRow(platform, tiltDir, rockPosition)
    end
end

function countNextRocksCore(platform::Matrix{Char}, tiltDir::Direction, rockPosition::CartesianIndex{2}, cubePosition::CartesianIndex{2})::Int
    if !inBounds(platform, cubePosition)
        cubePosition -= direction(tiltDir)
    end
    if rockPosition[1]^2 + rockPosition[2]^2 < cubePosition[1]^2 + cubePosition[2]^2
        mn, mx = rockPosition, cubePosition
    else
        mx, mn = rockPosition, cubePosition
    end
    slice = view(platform, mn:mx)
    return count(==('O'), slice) - 1 # minus one because it counts itself
end

function countNextRocks(platform :: Matrix{Char}, tiltDir :: Direction, rockPosition :: CartesianIndex{2}) :: Int
    if isOnNextEdge(platform, tiltDir, rockPosition)
        return 0
    else
        cubePosition = findNextCube(platform, tiltDir, rockPosition)
        return countNextRocksCore(platform, tiltDir, rockPosition, cubePosition)
    end
end

function countNextRocks(platform :: Matrix{Char}, tiltDir :: Direction, rockPosition :: CartesianIndex{2}, cubePosition :: CartesianIndex{2}) :: Int
    if isOnNextEdge(platform, tiltDir, rockPosition)
        return 0
    else
        return countNextRocksCore(platform, tiltDir, rockPosition, cubePosition)
    end
end

function rollRock(platform :: Matrix{Char}, tiltDir :: Direction, rockPosition :: CartesianIndex{2}) :: CartesianIndex{2}
    nextCubePosition = findNextCube(  platform, tiltDir, rockPosition)
    newCubeDistance  = countNextRocks(platform, tiltDir, rockPosition, nextCubePosition) + 1
    rockPositionNew  = nextCubePosition - newCubeDistance * direction(tiltDir)
    return rockPositionNew
end

function rollRock(platform :: Matrix{Char}, tiltDir :: Direction)
    return (rockPosition -> rollRock(platform, tiltDir, rockPosition))
end

function tilt!(platform :: Matrix{Char}, tiltDir :: Direction) :: Tuple{Matrix{Char}, Vector{CartesianIndex{2}}}
    rockPositionVector            = findall(==('O'), platform)
    rollRockFunction              = rollRock(copy(platform), tiltDir)
    platform[rockPositionVector] .= '.'
    rockPositionVector            = rollRockFunction.(rockPositionVector)
    platform[rockPositionVector] .= 'O'
    return platform, rockPositionVector
end

function tilt!(platform :: Matrix{Char}, tiltDir :: Direction, rockPositionVector :: Vector{CartesianIndex{2}}) :: Tuple{Matrix{Char}, Vector{CartesianIndex{2}}}
    rollRockFunction              = rollRock(copy(platform), tiltDir)
    platform[rockPositionVector] .= '.'
    # println(tiltDir)
    # println("==============")
    # display(rockPositionVector)
    Threads.@threads for index in eachindex(rockPositionVector)
        rockPositionVector[index] = rollRockFunction(rockPositionVector[index])
    end
    # rockPositionVector            .= rollRockFunction.(rockPositionVector)
    # display(rockPositionVector)
    # println()
    platform[rockPositionVector] .= 'O'
    return platform, rockPositionVector
end

function tilt(platform :: Matrix{Char}, tiltDir :: Direction) :: Matrix{Char}
    rockPositionVector    = findall(==('O'), platform)
    rollRockFunction      = rollRock(platform, tiltDir)
    rockPositionVectorNew = rollRockFunction.(rockPositionVector)
    platformNew           = deepcopy(platform)
    platformNew[rockPositionVector]    .= '.'
    platformNew[rockPositionVectorNew] .= 'O'
    return platformNew
end

#= function cycle!(platform :: Matrix{Char}) :: Matrix{Char}
    rockPositionVector = findall(==('O'), platform)
    for tiltDir in [north, west, south, east]
        tilt!(platform, tiltDir, rockPositionVector)
    end
    return platform
end =#

function cycle!(platform :: Matrix{Char}, rockPositionVector :: Vector{CartesianIndex{2}}) :: Matrix{Char}
    for tiltDir in [north, west, south, east]
        tilt!(platform, tiltDir, rockPositionVector)
    end
    return platform
end

function cycle!(platform :: Matrix{Char}, n :: Int; progress=false) :: Matrix{Char}
    start = now()
    t0 = start
    rockPositionVector = findall(==('O'), platform)
    for i in 1:n
        cycle!(platform, rockPositionVector)

        reportPercent = 0.01
        reportSteps   = (reportPercent / 100) * n
        if progress && iszero(i % reportSteps)
            t = now()
            percentCompleted = 100 * i / n
            stepsRemaining   = n - i
            timeRemaining    = round(Int64, (((t - t0).value / reportSteps #= average milliseconds per report =#) * stepsRemaining) #= milliseconds =# / 1000 / 60) |> Minute # minutes left
            timeElapsed      = round(Int64, (t - start).value / 1000 / 60) |> Minute # minutes

            println("$percentCompleted% completed; Elapsed time: $timeElapsed; Estimated Remaining Time: $timeRemaining")
            t0 = now()
        end
    end
    return platform
end

function cycle(platform :: Matrix{Char}) :: Matrix{Char}
    platformNew = deepcopy(platform)
    for tiltDir in [north, west, south, east]
        platformNew = tilt(platformNew, tiltDir)
    end
    return platformNew
end

function cycle(platform :: Matrix{Char}, n :: Int; progress=false :: Bool) :: Matrix{Char}
    platformNew = deepcopy(platform)
    start = now()
    t0 = start
    for i in 1:n
        platformNew = cycle(platformNew)
        if progress && iszero(i % (n/10^4))
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

function calculateLoad(platform::Matrix{Char}, rockPosition::CartesianIndex{2})::Int
    return size(platform)[1] - rockPosition[1] + 1
end

echo(x) = (display(x); x)
function testSuite()
    @testset verbose = true failfast = true begin #= for rockPosition in rockPositionVector =#
        platform0          = parseInput("inputTest.txt")
        platform           = deepcopy(platform0)
        rockPositionVector = findall(==('O'), platform)
        rockPosition       = rockPositionVector[10]

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
            platformFinal = parseInput("outputTest.txt")
            @test tilt(platform, north)     == platformFinal
            platformNew = deepcopy(platform)
            @test tilt!(platformNew, north)[1] == platformFinal
        end
        @testset "cycle $n" for n in 1:3 
            platformCycle = parseInput("inputTestCycle$n.txt")
            @test cycle(platform, n) == platformCycle
            # println("input")
            # display(platform)
            # println("calculated output")
            @test #= echo( =#cycle!(platform, n)#= ) =# == (#= println("test output"); echo(=#platformCycle)#= ) =#
            platform = deepcopy(platform0)
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
    platformNew = cycle!(platform, 10^9, progress = true)
    rockPositionVectorNew = findall(==('O'), platformNew)
    return sum(calculateLoad(platformNew, rockPositionNew) for rockPositionNew in rockPositionVectorNew)
end

testSuite()
# platform = parseInput("inputTest.txt")
# @profview cycle!(platform, 10^5, progress=false)
main() |> display
