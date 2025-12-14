mutable struct Dial{T}
    bound :: T
    loc   :: T
    function Dial{T}(bound :: T, loc :: T) where T <: Integer
        @assert 0 <= loc < bound
        return new{T}(bound, loc)
    end
end

Base.show(io :: IO, dial :: Dial) = print(io, "0<", dial.loc, "<", dial.bound)

function spin!(dial :: Dial{T}, move :: T) :: Dial{T} where T <: Integer
    spun_loc = mod(dial.loc + move, dial.bound)
    @debug "Spin State" dial move spun_loc
    dial.loc = spun_loc
    return dial
end

spin(dial, move) = (d = Dial{Int}(dial.bound, dial.loc); spin!(d, move))

spin!(dial :: Dial) = Base.Fix1(spin!, dial)
