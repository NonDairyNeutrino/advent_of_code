# Day 13, Part 1
#=
Plan of Attack:
1. Step one description.
2. Step two description.
3. Additional steps...
=#
using LinearAlgebra

function main()
    offset = 10000000000000
    aCost = 3
    bCost = 1
    costVector = [aCost, bCost]
    machinePattern = r"""Button A: X\+(?<Ax>\d+).+Y\+(?<Ay>\d+)
Button B: X\+(?<Bx>\d+).+Y\+(?<By>\d+)
Prize: X=(?<Px>\d+).+Y=(?<Pb>\d+)"""
    totalCost = 0
    for machine in eachmatch(machinePattern, read("input_test.txt", String))
        Ax, Ay, Bx, By, Px, Py = parse.(Int, machine)
        sol = [Ax Bx; Ay By] \ ([Px, Py] + offset * [1,1]) #.|> Float32
        display(sol)
        if all(isinteger.(sol)) # && all(sol .< 100)
            totalCost += dot(Int.(sol), costVector) isinteger
        end
    end
    return totalCost
end

main()