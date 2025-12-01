using AoC2025Day01
using Test
using Aqua
using JET

@testset "AoC2025Day01.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(AoC2025Day01)
    end
    @testset "Code linting (JET.jl)" begin
        JET.test_package(AoC2025Day01)
    end

    @testset "Example Tests" begin
        input = IOBuffer("""
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
""")
        @test parse_input(input) == [-68, -30, 48, -5, 60, -55, -1, -99, 14, -82]
        @test main1(input) == 3
    end
end
