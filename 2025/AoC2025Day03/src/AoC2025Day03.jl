module AoC2025Day03
export run_example, main1, main

const EXAMPLE = """
987654321111111
811111111111119
234234234234278
818181911112111\
"""

function find_max_joltage(bank :: AbstractArray, len :: Int, digit :: Int = 0) :: AbstractString
    digit += 1

    if digit > len || isempty(bank)
        joltage = ""
    else
        joltage, i = findmax(bank) # finds the leftmost occurence of max in bank

        # if max is at the end, and len is >= 2, max by itself will be less than any two
        #
        if i == lastindex(bank)
            bank = @view bank[begin:i-1]
            jolt = find_max_joltage(bank, len, digit)
            joltage = jolt * joltage # jolt comes before joltage so prepend
        else
            bank = @view bank[i+1:end]
            jolt = find_max_joltage(bank, len, digit)
            joltage = joltage * jolt # jolt comes after joltage so append
        end
    end
    return joltage
end

function solve(input :: AbstractString, max_dig :: Int) :: Int
    banks   = split(input, '\n') .|> collect
    joltage = sum(banks) do bank
        joltage = find_max_joltage(bank, max_dig)
        return parse(Int, joltage)
    end
    return joltage
end
solve1 = Base.Fix2(solve, 2)
solve2 = Base.Fix2(solve, 12)

function solve_day(input :: AbstractString = EXAMPLE) :: Tuple{Int, Int}
    p1 = solve1(input)
    p2 = solve2(input)
    return p1, p2
end

function main() :: Nothing
    p1, p2 = solve_day()
    @info "Example answers" p1 p2

    input  = read("input.txt", String) |> strip
    p1, p2 = solve_day(input)
    @info "Real answers" p1 p2

    return nothing
end

end
