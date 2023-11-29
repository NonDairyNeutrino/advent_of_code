# Advent of Code 2022, day 2

"""
The main idea is to first parse the input into a vector of Game objects. Then add all their scoreGame values.
"""

mutable struct Game
    shapeOpp :: Char # opponent's shape
    shapeYou :: Char # your shape
    scoreYou :: Int  # the score for your shape
    scoreGame :: Int # the score for the state of the game (e.g. L, D, W)
    state :: Char    # the state of the game lose = L, draw = D, win = W
end


"""
    shapeToScore(shape :: Char)

Get the score associated with your shape.

Examples
========
```jldoctest
julia> shapeToScore('X')
1

julia> shapeToScore('Y')
2

julia> shapeToScore('Z')
3
```
"""
function shapeToScore(shape :: Char)
    if shape == 'X'
        score = 1
    elseif shape == 'Y'
        score = 2
    elseif shape == 'Z'
        score = 3
    end
    return score
end

"""
    getGameState(game :: Game)

TBW
"""
function getGameState(game :: Game)
    if game.shapeOpp == 'A'
        if game.shapeYou == 'X'
            game.state = 'D'
            game.scoreGame =
        end
    end
end

function main()
    # begin parsing input to data structure
    roundVector = readlines("day2/input2.txt")
end