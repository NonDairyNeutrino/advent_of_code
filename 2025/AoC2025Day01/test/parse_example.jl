function parse_example(input :: String) :: String
    path, io = mktemp()
    write(path, input)
    return path
end
