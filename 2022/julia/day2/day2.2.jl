# Advent of Code 2022, day 2
@enum Shape rock = 1 paper = 2 scissors = 3
@enum State lose = 0 draw  = 3 win      = 6

"""
    rps(shapeTheirs :: Shape, shapeYours :: Shape)

Determines the win state for a given game of rock, paper, scissors.

Examples
========
```jldoctest
julia> rps(rock, paper)
lose

julia> rps(scissors, paper)
win

julia> rps(paper, paper)
draw
```
See also: Shape
"""
function rpsShape(shapeTheirs :: Shape, shapeYours :: Shape)
    stateMatrix = [[draw, win, lose], [lose, draw, win], [win, lose, draw]] |> stack |> permutedims
    state = stateMatrix[Int(shapeTheirs), Int(shapeYours)]
    return state
end

function rpsState(shapeTheirs :: Shape, state :: State)
    shapeMatrix = [[scissors, rock, paper], [rock, paper, scissors], [paper, scissors, rock]] |> stack |> permutedims
    shapeYours  = shapeMatrix[Int(shapeTheirs), Int(Int(state) / 3) + 1]
    return shapeYours
end

struct Game
    shapeOpp :: Shape # opponent's shape
    shapeYou :: Shape # your shape
    scoreYou :: Int   # the score for your shape
    state    :: State # the state of the game lose, draw, win
    scoreGame:: Int   # the score for the state of the game
    function Game(shapeOpp :: Shape, shapeYou :: Shape)
        scoreYou = Int(shapeYou)
        state    = rpsShape(shapeOpp, shapeYou)
        scoreGame= Int(state)
        new(shapeOpp, shapeYou, scoreYou, state, scoreGame)
    end
    function Game(shapeOpp :: Shape, state :: State)
        shapeYou = rpsState(shapeOpp, state)
        scoreYou = Int(shapeYou)
        scoreGame = Int(state)
        new(shapeOpp, shapeYou, scoreYou, state, scoreGame)
    end
end

const letterToShape = Dict('A' => rock, 'B' => paper, 'C' => scissors)
const letterToState = Dict('X' => lose, 'Y' => draw,  'Z' => win)

function main()
    shapeStateVector = [[letterToShape[game[1]], letterToState[game[3]]] for game in eachline("day2/input2.txt")]
    gameVector = [Game(shapePair...) for shapePair in shapeStateVector]
    totalPoints = sum(game.scoreYou + game.scoreGame for game in gameVector)
    return totalPoints
end

main() |> println