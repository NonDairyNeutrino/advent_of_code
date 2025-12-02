using AoC2025Day02
using Test
using Aqua
using JET

include("../src/parse.jl")

@testset "AoC2025Day02.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(AoC2025Day02, deps_compat = false)
    end
    @testset "Code linting (JET.jl)" begin
        JET.test_package(AoC2025Day02)
    end

    @testset "Parsing" begin
        @test parse_interval("10-100") == (10, 100)
        @test parse_interval("1-0") == (1, 0)
    end

    @testset "Example Input" begin
        input = "\
            11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,\
            446443-446449,38593856-38593862,565653-565659,824824821-824824827,\
            2121212118-2121212124"
        @test parse_input(input) == [
            (11, 22),
            (95, 115),
            (998, 1012),
            (1188511880, 1188511890),
            (222220, 222224),
            (1698522, 1698528),
            (446443, 446449),
            (38593856, 38593862),
            (565653, 565659),
            (824824821, 824824827),
            (2121212118, 2121212124)
        ]
    end
end
