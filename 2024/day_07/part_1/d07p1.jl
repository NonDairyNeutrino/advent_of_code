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

function Base.:(==)(leafX :: Leaf, leafY :: Leaf)
    return leafX.value == leafY.value
end

struct Node <: AbstractNode
    id :: String
    value :: Int
    children :: Vector{Union{Node, Leaf}}
end

Base.:(==)(node :: Node, leaf :: Leaf) = false

function Base.:(==)(nodeX :: Node, nodeY :: Node)
    nodeX.value != nodeY.value && return false # values need to be the same
    println("THIS FUNCTIONALITY IS NOT COMPLETE; RETURING MISSING.")
    return missing
    # all(nodeX.children[i] == nodeY.children[i] for i in eachindex())
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
function makeTree(id :: String, value :: Int, operandVector :: Vector{Int}, operatorVector :: Vector{T}) where T <: Function # :: T where T <: AbstractNode
    children = similar(operatorVector, Union{Node, Leaf})
    operand, rest = Iterators.peel(operandVector)
    if isempty(rest)
        node = Leaf(id * , value)
    else
        rest = collect(rest)
        for (i, op) in enumerate(operatorVector)
            childValue = op(value, operand)
            children[i] = makeTree(childValue, rest, operatorVector)
        end
        node = Node(id, value, children)
    end
    return node
end

function printTree(root :: Leaf)
    println("leaf: ", root.value)
end

function printTree(root :: Node)  :: Nothing
    println("value: ", root.value)
    println("children: ")
    for (i, child) in enumerate(root.children)
        println("child: ", i)
        printTree(child)
    end
end

# @tesset "makeTree" begin
#     @test makeTree(1, [2, 3], [+]) == 
# end

function makeForest(operandVector :: Vector{Int}, operatorVector :: Vector{T}) :: Vector{Node} where T <: Function
    forest = similar(operatorVector, Node)
    for (i, op) in enumerate(operatorVector)
        value = op(operandVector[1:2]...)
        forest[i] = makeTree(value, operandVector, operatorVector)
    end
    return forest
end

function printForest(forest :: Vector{Node}) :: Nothing
    for tree in forest
        printTree(tree)
        println()
    end
    return nothing
end

function main() :: Nothing
    path   = "input_test.txt"
    operatorVector = [+, *]
    equationVector = parseInput(path)
    eq             = equationVector[1]
    operandVector  = eq.operands

    forest = makeForest([1, 2, 3], [+, *])
    printForest(forest)
    return nothing
    # makeForest(operandVector, operatorVector)
end

main()
