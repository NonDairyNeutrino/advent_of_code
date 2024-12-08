# Day 07, Part 1
#=
Plan of Attack:
1. construct 2 binary trees
1.1 the root node for each tree is eq.operand[1] + eq.operand[2] or eq.operand[1] * eq.operand[2]
1.2 each level is composed of nodes with values parentNode.value + eq.operand[i] or parentNode.value * eq.operand[i]
2. traverse each tree
2.1 test each node if node.value == eq.test
2.2 immediately return true if true
=#
using Test

struct Equation
    test :: Int
    operands :: Vector{Int}
end

abstract type AbstractNode end

struct Leaf <: AbstractNode
    id :: String
    value :: Int
end

struct Node <: AbstractNode
    id :: String
    value :: Int
    children :: Vector{Union{Node, Leaf}}
end

function parseInput(path :: String) :: Vector{Equation}
    equationVector :: Vector{Equation} = Vector{Equation}(undef, countlines(path))
    for (i, line) in enumerate(readlines(path))
        test, operandsString = split(line, ": ")
        operandVector :: Vector{Int} = parse.(Int, split(operandsString))
        equationVector[i] = Equation(parse(Int, test), operandVector)
    end
    return equationVector
end

# TODO: use Refs and views
function makeTree(leafVector :: Vector{Leaf}, id :: String, value :: Int, operandVector :: Vector{Int}, operatorVector :: Vector{T}) where T <: Function # :: T where T <: AbstractNode
    children = similar(operatorVector, Union{Node, Leaf})
    if isempty(operandVector)
        node = Leaf(id, value)
        push!(leafVector, node)
    else
        operand, rest = Iterators.peel(operandVector)
        rest = collect(rest)
        for (i, op) in enumerate(operatorVector)
            childValue = op(value, operand)
            children[i] = makeTree(leafVector, id * ".$i", childValue, rest, operatorVector)
        end
        node = Node(id, value, children)
    end
    return node
end

function printTree(root :: Leaf, io:: IO = stdout)
    println(io, "Leaf: ", root.id, " value: ", root.value)
end

function printTree(root :: Node, io:: IO = stdout)  :: Nothing
    println(io, "Node: ", root.id, " value: ", root.value)
    for (i, child) in enumerate(root.children)
        printTree(child, io)
    end
end

function makeForest(operandVector :: Vector{Int}, operatorVector :: Vector{T}) :: Tuple{Vector{Union{Node, Leaf}}, Vector{Leaf}} where T <: Function
    forest = similar(operatorVector, Union{Node, Leaf})
    leafVector = Leaf[]

    operand1, rest = Iterators.peel(operandVector)
    operand2, rest = Iterators.peel(rest)
    rest = collect(rest)
    for (i, op) in enumerate(operatorVector)
        value = op(operand1, operand2)
        forest[i] = makeTree(leafVector, "$i", value, rest, operatorVector)
    end
    return (forest, leafVector)
end

function printForest(forest :: Vector{Union{Node, Leaf}}, io :: IO = stdout) :: Nothing
    for tree in forest
        printTree(tree, io)
        println(io)
    end
    return nothing
end

function main() :: Nothing
    fileName = "input"
    ext      = ".txt"
    path             = fileName * ext

    operatorVector = [+, *]
    equationVector = parseInput(path)
    rm(fileName * "_tree" * ext, force=true)
    totalCalibration = 0
    for eq in equationVector
        operandVector  = eq.operands
        forest, leafVector = makeForest(operandVector, operatorVector) # makeForest([1, 2, 3], [+, *])
        if eq.test in getproperty.(leafVector, :value)
            totalCalibration += eq.test
        end
        # uncomment to print tree
        # println("operandVector: $operandVector")
        # printForest(forest)

        # uncomment below to save output to a file
        # open(fileName * "_tree" * ext, "a") do io
        #     println(io, "operandVector: $operandVector")
        #     printForest(forest, io)
        # end
    end
    println("Total Calibration Result: ", totalCalibration)
    return nothing
end

main()
