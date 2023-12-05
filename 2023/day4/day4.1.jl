# Advent of Code day 4 part 1
struct Card
    id      :: Int
    winSet  :: Set{Int}
    yourSet :: Set{Int}
end

score = 0
for cardString in readlines("input.txt")
    idString, winString, yourString = strip.(split(cardString, r"[:|]"))
    id = parse(Int, split(idString)[2])
    winSet = (char -> parse(Int, char)).(split(winString)) |> Set
    yourSet = (char -> parse(Int, char)).(split(yourString)) |> Set
    card = Card(id, winSet, yourSet)
    winCount = intersect(card.winSet, card.yourSet) |> length
    global score += winCount == 0 ? 0 : 2^(winCount - 1)
end

score |> display