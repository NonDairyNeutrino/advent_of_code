
#= 
Plan of attack
1. sort each column
2. sort each pair
3. dot with negative matrix
=#

using DelimitedFiles, LinearAlgebra
left, right = readdlm("./part_01/input.txt", Int) |> eachcol
sort!.((left, right))
mapreduce((left, right) -> abs(left - right), +, left, right)