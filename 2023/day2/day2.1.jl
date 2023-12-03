# Advent of Code 2023 day 2 part 1
"""
main idea
1) Have a Game structure with the game id and the maps of colors to amounts
2) Create Game objects for each line of input
2.1) Split each line of input by natural delimeters
2.2) Parse each split into game id and color maps
3) Test each game object for validity
3.1) A game is valid if for every draw, all colors are under their respective limits
3.2) Color limits are defined by the global Cube enum
4) Sum all ids of valid games
"""

"""
    Draw(drawString :: String) :: Draw

Construct an object with red, blue, and green counts of the draw.

# Examples

```jldoctest
julia> Draw("3 blue, 4 red")
Draw(4, 3, 0)

julia> Draw("1 red, 2 green, 6 blue")
Draw(1, 6, 2)

julia> Draw("2 green")
Draw(0, 0, 2)
```

See also: `split`, `@r_str`, `parse`
"""
struct Draw
    red   :: Int
    blue  :: Int
    green :: Int
    function Draw(drawString :: AbstractString) :: Draw
        countColorVector = split(drawString, (@r_str "[,\\s]"), keepempty = false) # split input into alternating #, color
        colorCountPairVector = [countColorVector[[i + 1, i]] for i in 1:(length(countColorVector) - 1)] # pair up counts and colors
        red = blue = green = 0
        for colorCountPair in colorCountPairVector
            if colorCountPair[1] == "red"
                red = parse(Int, colorCountPair[2])
            elseif colorCountPair[1] == "blue"
                blue = parse(Int, colorCountPair[2])
            elseif colorCountPair[1] == "green"
                green = parse(Int, colorCountPair[2])
            end
        end
        new(red, blue, green)
    end
end

"""
    Game(gameString :: String) :: Game

Create a game object with its ID, draws, and matrix of color counts.

# Examples

```jldoctest
julia> Game("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")
Game(1, Draw[Draw(4, 3, 0), Draw(1, 6, 2), Draw(0, 0, 2)])

julia> Game("Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue")
Game(2, Draw[Draw(0, 1, 2), Draw(1, 4, 3), Draw(0, 1, 1)])

julia> Game("Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red")
Game(3, Draw[Draw(20, 6, 8), Draw(4, 5, 13), Draw(1, 0, 5)])
```
See also: `@r_str`, `split`, `parse`, `broadcast`
"""
struct Game
    id :: Int
    drawVector :: Vector{Draw}
    colorMatrix :: Matrix{Int}
    function Game(line::AbstractString) :: Game
        fieldVector = split(line, @r_str "[:;]") # seperate game id from draws
        id = parse(Int, split(fieldVector[1])[2])     # convert id string to number
        drawVector = Draw.(fieldVector[2:end])
        colorMatrix = [[draw.red, draw.blue, draw.green] for draw in drawVector] |> stack |> permutedims
        return new(id, drawVector, colorMatrix)
    end
end

"""
    isValid(game :: Game, maxColorCount :: Vector{Int}) :: Bool

Determines if a game is valid based on the given maximum number of colors.

# Examples
```jldoctest
julia> game = Game("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green");

julia> maxColorCount = Dict("red" => 12, "green" => 13, "blue" => 14);

julia> isValid(game, maxColorCount)
true
```
See also: `maximum`, `&&`
"""
function isValid(game :: Game, maxColorCount :: Dict) :: Bool
    validRed   = maximum(game.colorMatrix[:, 1]) <= maxColorCount["red"]
    validBlue  = maximum(game.colorMatrix[:, 2]) <= maxColorCount["blue"]
    validGreen = maximum(game.colorMatrix[:, 3]) <= maxColorCount["green"]
    return validRed && validBlue && validGreen
end

function main(path :: String)
    maxColorCount = Dict("red" => 12, "green" => 13, "blue" => 14)
    sum(Game(gameString).id for gameString in eachline(path) if isValid(Game(gameString), maxColorCount)) |> display
end

main("input.txt")
