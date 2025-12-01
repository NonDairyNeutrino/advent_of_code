function parse_input(input :: Union{String, IOBuffer}) :: Vector{Int}
    rot_str_seq  = readlines(input)
    @show rot_str_seq
    rot_seq      = map(rot_str_seq) do rot
        distance = parse(Int, rot[2:end])
        dir      = startswith(rot, "L") ? -1 : 1
        displacement = distance * dir
    end
    @show rot_seq
    return rot_seq
end
