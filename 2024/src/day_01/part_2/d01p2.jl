#= 
plan of attack
1. get both columns
2. for each element e in left list
    count number n of times e occurs in right list
3. add together n_e * e
=#

using DelimitedFiles, LinearAlgebra
# get both columsn
left, right = readdlm("input.txt", Int) |> eachcol

# for each element e in left list
#     count number n of times e occurs in right list
countVector = map(l -> count(r -> r == l, right), left)

# add together n_e e
dot(countVector, left)