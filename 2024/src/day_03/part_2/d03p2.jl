# Day 03, Part 2
#=
Plan of Attack:
1. Step one description.
2. Step two description.
3. Additional steps...
=#

input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))don't()mul(1,1)"
# input = readline("input.txt")

garbage = ".*?"
mulPat  = raw"mul\((?<left>\d+),(?<right>\d+)\)"
headPat = string("^", garbage, mulPat, garbage, raw"(?=don't\(\))") |> Regex 
bodyPat = string(raw"(?<=do\(\))", garbage, mulPat, garbage, raw"(?=don't\(\))") |> Regex
tailPat = string(raw"(?<=do\(\))", garbage, mulPat, garbage, raw"(?!don't\(\))$") |> Regex

total = 0

# there's only 1 head, so don't have to use eachmatch
println("Head muls")
for mul in eachmatch(mulPat |> Regex, match(headPat, input).match)
    println(mul)
end

println("Body do()s")
for doMatch in eachmatch(bodyPat, input)
    println("do() muls")
#     for mul in eachmatch(mulPat |> Regex, doMatch.match)
#         println(mul)
#         # global total += parse.(Int, mul.captures) |> prod
#         # println(total)
#     end
end

println("Tail muls")
for mul in eachmatch(mulPat |> Regex, match(tailPat, input).match)
    println(mul)
end
# total += parse.(Int, match(tailPat, input).captures) |> prod
# println("Final Total: $total")
