using AoC2025Day03
using BenchmarkTools

SUITE = BenchmarkGroup()
SUITE["rand"] = @benchmarkable rand(10)

# Write your benchmarks here.
