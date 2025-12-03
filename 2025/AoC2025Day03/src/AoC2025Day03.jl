module AoC2025Day03
export run_example, main1

function find_max_joltage(bank :: Vector{Char}) :: Int
    isempty(bank) && return 0
    m1, i = findmax(bank)

    if i == lastindex(bank)
        head = bank[begin:i-1]
        m2 = maximum(head)
        joltage = m2 * m1
    else
        tail = bank[i+1:end]
        m2 = maximum(tail)
        joltage = m1*m2
    end
    joltage = parse(Int, joltage)
    return joltage
end

find_max_joltage(banks :: Vector{Vector{Char}}) :: Int = sum(find_max_joltage, banks)

function main1(input :: String) :: BigInt
    banks   = split(input, '\n') .|> collect
    joltage = find_max_joltage(banks)
    return joltage
end

function run_example()
    input = """
987654321111111
811111111111119
234234234234278
818181911112111"""
    @info "Example answer: $(main1(input))"
end

end
