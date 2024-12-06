# Day 03, Part 2
#=
Plan of Attack:
1. Step one description.
2. Step two description.
3. Additional steps...
=#
using Test
testInput= "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))don't()mul(999,999)do()mul(273,273)" # * "don't()asdfmul(999,999)"

mulPat  = r"mul\((?<left>\d+),(?<right>\d+)\)"
headPat = r"^.*?(?=don't\(\))"
bodyPat = r"(?<=do\(\)).*(?=don't\(\))"
tailPat = r"(?<!don't\(\)).*(?<=do\(\))\K.*$"

"""
    getHeadMatches(input :: String) :: Vector{RegexMatch}

TBW
"""
function getHeadMatches(input :: String) :: Vector{RegexMatch}
    headMatch = match(headPat, input).match
    return eachmatch(mulPat, headMatch) |> collect
end

@testset "getHeadMatches" begin
@test getproperty.(getHeadMatches(testInput), :match) == ["mul(2,4)"]
end
###############################################################################
"""
    getTailMatches(input :: String) :: Vector{RegexMatch}

TBW
"""
function getTailMatches(input :: String) :: Vector{RegexMatch}
    tailMatch = match(tailPat, input).match
    return eachmatch(mulPat, tailMatch) |> collect
end

@testset "getTailMatches" begin
    @test getproperty.(getTailMatches(testInput), :match) == ["mul(273,273)"]
end
###############################################################################
"""
    getBodyMatches(input :: String) :: Vector{RegexMatch}

TBW
"""
function getBodyMatches(input :: String) :: Vector{RegexMatch}
    mulVector = RegexMatch[]
    for doMatch in eachmatch(bodyPat, input)
        append!(mulVector, eachmatch(mulPat, doMatch.match))
    end
    return mulVector
end

@testset "getBodyMatches" begin
    @test getproperty.(getBodyMatches(testInput), :match) == ["mul(8,5)"]
end

function main(input :: String) :: Nothing    
    total :: Int = 0
    for foo in (getHeadMatches, getBodyMatches, getTailMatches)
        matches       :: Vector{RegexMatch}                                = foo(input)
        captureVector :: Vector{Vector{Union{Nothing, SubString{String}}}} = getproperty.(matches, :captures)
        numVector     :: Vector{Vector{Int}}                               = (capture -> parse.(Int, capture)).(captureVector)
        total += prod.(numVector) |> sum
    end
    println()
    println("Solution: $total")
    return
end
@test main()
main()

# there's only 1 head, so don't have to use eachmatch
# println("Head muls")
# for mul in eachmatch(mulPat |> Regex, match(headPat, testInput).match)
#     println(mul)
# end

# println("Body do()s")
# for doMatch in eachmatch(bodyPat, input)
#     println("do() muls")
# #     for mul in eachmatch(mulPat |> Regex, doMatch.match)
# #         println(mul)
# #         # global total += parse.(Int, mul.captures) |> prod
# #         # println(total)
# #     end
# end

# println("Tail muls")
# for mul in eachmatch(mulPat |> Regex, match(tailPat, input).match)
#     println(mul)
# end
# total += parse.(Int, match(tailPat, input).captures) |> prod
# println("Final Total: $total")
