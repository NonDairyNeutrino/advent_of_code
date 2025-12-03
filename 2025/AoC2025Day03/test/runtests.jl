using AoC2025Day03
using Test
using Aqua
using JET

@testset "AoC2025Day03.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(AoC2025Day03)
    end
    @testset "Code linting (JET.jl)" begin
        JET.test_package(AoC2025Day03; target_defined_modules = true)
    end
    # Write your tests here.
end
