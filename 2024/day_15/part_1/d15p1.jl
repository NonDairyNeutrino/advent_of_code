# Day 15, Part 1
#=
Plan of Attack:
check(position in front of robot){
  if(space in front of robot is empty){
    move forward i.e. update robot.position
  elseif object in front of robot is wall
    don't move
  elseif object in front of robot is box
    check(position in front of box)
  }
}
=#

function move!(
    boxSetRef :: Base.RefValue{Set{CartesianIndex{2}}}, 
    position :: CartesianIndex{2}, 
    direction :: CartesianIndex{2}
    )
    replace!(boxSetRef[], position=>(position + direction))
end

function tryMove!(
    wallSetRef :: Base.RefValue{Set{CartesianIndex{2}}}, 
    boxSetRef  :: Base.RefValue{Set{CartesianIndex{2}}}, 
    position   :: CartesianIndex{2}, 
    direction  :: CartesianIndex{2}
    ) :: Bool
    if position in boxSetRef[]
        if tryMove!(wallSetRef, boxSetRef, position + direction, direction)
            move!(boxSetRef, position, direction)
            return true
        else
            return false
        end
    elseif position in wallSetRef[]
        # do nothing
        # or effectively
        # replace!(boxSetRef[], position=>position)
        println("Wall encountered!")
        return false
    else # position is empty
        move!(boxSetRef, position, direction)
        # now position is empty!
        return true
    end
end

function main()
    grid = split.(readlines("map_small.txt"), "") |> stack |> permutedims .|> String
    moveVector = split(readline("moves_small.txt"), "") .|> String
    moveDict = Dict(
        ">" => CartesianIndex(0, 1), # east
        "^" => CartesianIndex(-1,0), # north
        "<" => CartesianIndex(0,-1), # west
        "v" => CartesianIndex(1,0)  # south
    )

    wallSet = findall(==("#"), grid) |> Set
    wallSetRef = Ref(wallSet)
    boxSet  = findall(==("O"), grid) |> Set
    boxSetRef = Ref(boxSet)
    robot   = findfirst(==("@"), grid)
    push!(boxSet, robot)

    for move in moveVector
        println("Move: ", move)
        # display(boxSet)
        direction = moveDict[move]
        tryMove!(wallSetRef, boxSetRef, robot, direction)
    end
    println("Robot position: ", robot)
    println("Final Layout")
    return boxSet
end

main()