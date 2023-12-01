# Advent of Code 2023 Day 1
sum(parse(Int, strip(!isdigit, salt)[[1, end]]) for salt in eachline("input.txt")) |> println