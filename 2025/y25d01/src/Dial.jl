mutable struct Dial{T}
    bound :: T
    loc   :: T
    passes :: T
    function Dial{T}(bound :: T, loc :: T, passes :: T) where T <: Integer
        @assert 0 <= loc < bound
        return new{T}(bound, loc, passes)
    end
end
Dial{T}(bound, loc) where T = Dial{T}(bound, loc, zero(T))

Base.show(io :: IO, dial :: Dial) = print(io, "0<", dial.passes, "+", dial.loc, "<", dial.bound)

function spin!(dial :: Dial{T}, move :: T) :: Dial{T} where T <: Integer
    spins_from_zero, spun_loc = divrem(dial.loc + move, dial.bound, RoundDown)
    nspins = spins_from_zero - dial.passes
    @debug "Spin State" dial move spun_loc
    dial.loc = spun_loc
    dial.passes += abs(nspins) + iszero(spun_loc)
    return dial
end

spin(dial, move) = (d = Dial{Int}(dial.bound, dial.loc); spin!(d, move))

spin!(dial :: Dial) = Base.Fix1(spin!, dial)
