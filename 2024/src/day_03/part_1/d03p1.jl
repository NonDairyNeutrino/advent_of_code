# Day 03, Part 1
#=
Plan of Attack:
1. Step one description.
2. Step two description.
3. Additional steps...
=#

input = readline("input.txt")
pat = r"mul\((?<left>\d+),(?<right>\d+)\)"
sum(parse.(Int, mat.captures) |> prod for mat in eachmatch(pat, input))
