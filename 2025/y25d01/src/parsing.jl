function parse_input(input) :: Vector{Int}
    spinv = split(input)
    spinv = map(spinv) do spin_str
        dir_str, mag_str... = spin_str
        direction = dir_str == 'R' ? 1 : -1
        magnitude = parse(Int, mag_str)
        spin = direction * magnitude
        @debug "Parse" dir_str mag_str direction magnitude spin
        return spin
    end
    return spinv
end
