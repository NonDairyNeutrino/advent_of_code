#= 
Plan of attack
1. sort each column
2. sort each pair
3. dot with negative matrix
=#

using DelimitedFiles, LinearAlgebra
mat = readdlm("input.txt", Int)
mat = sortslices(mat, dims=2) # sort columns
mat = sortslices(mat, dims=1, rev=true) # sort rows
left, right = eachcol(mat)

dot(left, -I(size(mat, 1)), right)
