struct Node
    id  :: Int
    val :: String
end

struct Edge
    from :: Node
    to   :: Node
end

struct Graph
    nodes :: Vector{Node}
    edges :: Vector{Edge}
end
