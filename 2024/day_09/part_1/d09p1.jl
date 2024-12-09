# Day 09, Part 1
#=
Plan of Attack:
1. Step one description.
2. Step two description.
3. Additional steps...
=#

# mutable struct File
#     id :: Int
#     position :: Int
#     size :: Int
# end

# mutable struct EmptyFile
#     position :: Int
#     size :: Int
# end

# FileOrEmptyFile = Union{File, EmptyFile}

# function main()
#     # DECOMPRESS
#     path = "input_test.txt"
#     io = open(path, "r")
#     fileCount = filesize(path) # assuming there are an even number of digits
#     fileVector = Vector{FileOrEmptyFile}(undef, fileCount)
#     for i in 1:fileCount
#         runLength = parse(Int, read(io, Char))
#         if iseven(i - 1)
#             fileVector[i] = File((i - 1) / 2, i, runLength)
#         else
#             fileVector[i] = EmptyFile(i, runLength)
#         end
#     end
#     close(io)
#     return fileVector
#     # MOVE STARTS HERE
# end

function main()
    path = "input_test.txt"
    memoryCompressed = readline(path)
    memory :: String = ""
    for i in eachindex(memoryCompressed)
        runLength = SubString(memoryCompressed, i)
        id = i - 1
        if iseven(id)
            memory = memory * 
end

main()