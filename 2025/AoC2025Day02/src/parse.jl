"""
    parse_interval(int_str :: AbstractString) :: Tuple{<: Integer, <: Integer}

Parse the string "aaa-bbb" into an interval (aaa, bbb), where aaa and bbb are integers.

# Examples

```jldoctest
julia> parse_interval("10-100")
(10, 100)

julia> parse_interval("1-0")
(1, 0)
```
"""
function parse_interval(int_str :: AbstractString) :: Tuple{<: Integer, <: Integer}
    lo_str, up_str = split(int_str, '-')
    lb = parse(Int, lo_str)
    ub = parse(Int, up_str)
    interval = (lb, ub)
    return interval
end

"""
    parse_input(input :: AbstractString) :: Vector{Tuple{<: Integer, <: Integer}}

Parse the problem input into a vector of intervals.
"""
function parse_input(input :: AbstractString) :: Vector{Tuple{<: Integer, <: Integer}}
    # interval_regex = r"(?<interval>(?<lower>\d+)-(?<upper>\d+))(?=,)"
    # match_itr = eachmatch(interval_regex, input)
    # interval_str_vec = getindex.(match_itr, "interval")
    int_str_vec = split(input, ',')
    int_vec     = parse_interval.(int_str_vec)
    return int_vec
end
