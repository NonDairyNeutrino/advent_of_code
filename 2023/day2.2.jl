# Advent of Code 2023 day 2 part 1
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
        red = blue = green = 0 # initialize color counts
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

Create a game object with its ID, draws, matrix of color counts, and power.

# Examples

```jldoctest
julia> Game("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")
Game(1, Draw[Draw(4, 3, 0), Draw(1, 6, 2), Draw(0, 0, 2)], [[4, 1, 0], [3, 6, 0], [0, 2, 2]], 48)

julia> Game("Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue")
Game(2, Draw[Draw(0, 1, 2), Draw(1, 4, 3), Draw(0, 1, 1)], [[0, 1, 0], [1, 4, 1], [2, 3, 1]], 12)

julia> Game("Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red")
Game(3, Draw[Draw(20, 6, 8), Draw(4, 5, 13), Draw(1, 0, 5)], [[20, 4, 1], [6, 5, 0], [8, 13, 5]], 1560)
```
See also: `Draw`, `@r_str`, `split`, `parse`, `broadcast`
"""
struct Game
    id :: Int
    drawVector :: Vector{Draw}
    colorMatrix :: Vector{Vector{Int}}
    power :: Int
    function Game(line::AbstractString) :: Game
        fieldVector = split(line, @r_str "[:;]")  # seperate game id from draws
        id = parse(Int, split(fieldVector[1])[2]) # convert id string to number
        drawVector = Draw.(fieldVector[2:end])
        colorMatrix = [[getfield(draw, color) for draw in drawVector] for color in fieldnames(Draw)]
        power = maximum.(colorMatrix) |> prod
        return new(id, drawVector, colorMatrix, power)
    end
end

"""
    powersum(path :: String) :: Int

Sum the powers of the games for the given input file.

# Examples
```jldoctest
julia> powersum("input_test.txt")
2286
```
See also: `Game`, `eachline`
"""
function powersum(path :: String) :: Int
    sum(Game(gameString).power for gameString in eachline(path))
end

powersum("input_test.txt") |> display
