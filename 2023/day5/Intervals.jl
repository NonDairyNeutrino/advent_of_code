module Intervals
export EmptyInterval, Interval, IntervalUnion, in, issubset, isdisjoint, +, -, ==, intervalDiff, intersect

"""
   AbstractInterval

A type encompassing the types `Interval`, `EmptyInterval`, and `IntervalUnion`
"""
abstract type AbstractInterval end

"""
    EmptyInterval()

Create an empty interval.
"""
struct EmptyInterval <: AbstractInterval
end

"""
    Interval(start, finish)

Create a closed interval.
"""
struct Interval <: AbstractInterval
    lowerBound :: Real
    upperBound :: Real
    # TODO: add "open" field with sides; takes care of endpoint inlcusion in differencing
    function Interval(lowerBound :: T, upperBound :: S) where {T <: Real, S <: Real}
        try
            @assert lowerBound <= upperBound
            if upperBound != lowerBound
                return new(lowerBound, upperBound)
            else
                return EmptyInterval()
            end
        catch _
            display("Upper bound is less than lower bound")
        end
    end
    function Interval()
        return EmptyInterval()
    end
end

"""
    IntervalUnion(intervalVector :: Vector{Interval})

Create a union of intervals.
"""
struct IntervalUnion <: AbstractInterval
    intervals :: Vector{Interval}
    function IntervalUnion(intervalVector :: Vector{T}) where T <: AbstractInterval
        if isempty(intervalVector)
            return EmptyInterval()
        else
            intervalVectorFiltered = Interval[]
            for thing in intervalVector
                # If constructed with IntervalUnions, flatten into a single IntervalUnion
                if thing isa IntervalUnion
                    push!(intervalVectorFiltered, thing.intervals...)
                # If constructed with EmptyIntervals, don't include them
                elseif thing isa EmptyInterval
                    continue
                # By default, if it's an interval, store it
                else
                    push!(intervalVectorFiltered, thing)
                end
            end
            return new(intervalVectorFiltered)
        end
    end
    function IntervalUnion()
        return EmptyInterval()
    end
end

# Every following method takes the argument form (interval, element), where element is probably an interval

# MEMBERSHIP
Base.in(x :: Real, interval :: Interval)      = interval.lowerBound <= x <= interval.upperBound # don't change call syntax for infix notation
Base.in(x :: Interval, y :: Interval)         = issubset(x, y)
Base.in(x :: IntervalUnion, y :: Any)         = any(y in interval for interval in x.intervals) # short circuits (good); don't broadcast
Base.issubset(x :: Interval, y :: Interval)   = y.lowerBound in x && y.upperBound in x
Base.issubset(x :: Interval, y :: EmptyInterval)   = true
Base.isdisjoint(x :: Interval, y :: Interval) = !(y.lowerBound in x) && !(y.upperBound in x)
Base.:(==)(x :: IntervalUnion, y :: IntervalUnion) = Set(x.intervals) == Set(y.intervals)
Base.length(x :: Interval)                         = fieldcount(Interval)
Base.length(x :: IntervalUnion)                    = length(x.intervals)
Base.length(x :: EmptyInterval)                    = 0

function Base.intersect(x::Interval, y::Interval) :: Union{Interval, EmptyInterval}
    if issubset(x, y)
        return deepcopy(y)
    elseif isdisjoint(x, y)
        return Interval()
    elseif y.lowerBound in x
        return Interval(y.lowerBound, x.upperBound)
    elseif y.upperBound in x
        return Interval(x.lowerBound, y.upperBound)
    end
end

function Base.intersect(::EmptyInterval, ::Union{Interval,EmptyInterval}) :: EmptyInterval
    return Interval()
end

function Base.intersect(::Union{Interval,EmptyInterval}, ::EmptyInterval) :: EmptyInterval
    return Interval()
end

function Base.intersect(intervalunion :: IntervalUnion, inputInterval :: Interval) :: IntervalUnion
    return IntervalUnion([intersect(interval, inputInterval) for interval in intervalunion.intervals])
end

function Base.intersect(x :: IntervalUnion, y :: IntervalUnion) :: IntervalUnion
    return [intersect(x, interval) for interval in y.intervals]
end

# ARITHMETIC
Base.:+(x :: Interval, y :: Interval)         = Interval(x.lowerBound + y.lowerBound, x.upperBound + y.upperBound)
Base.:+(x :: Interval, :: EmptyInterval)      = deepcopy(x)
Base.:+(x :: IntervalUnion, y :: Interval)    = isempty(x.intervals) ? IntervalUnion() : IntervalUnion([interval + y for interval in x.intervals])
Base.:+(x :: Interval, y :: IntervalUnion)    = y + x
Base.:-(x :: Interval, y :: Interval)         = Interval(x.lowerBound - y.lowerBound, x.upperBound - y.upperBound)
Base.:-(x :: Interval, :: EmptyInterval)      = deepcopy(x)
Base.:-(x :: IntervalUnion, y :: Interval)    = isempty(x.intervals) ? IntervalUnion() : IntervalUnion([interval - y for interval in x.intervals])
#Base.:-(x :: IntervalUnion, y :: IntervalUnion) = 

function intervalDiff(x :: Interval, y :: Interval) :: IntervalUnion
    if issubset(x, y)
        return IntervalUnion([Interval(x.lowerBound, y.lowerBound), Interval(y.upperBound, x.upperBound)]) # leaves endpoints when they should be removed; also due to closed intevals
    elseif y.lowerBound in x
        return IntervalUnion([Interval(x.lowerBound, y.lowerBound), Interval()])
    elseif y.upperBound in x
        return IntervalUnion([Interval()                          , Interval(y.upperBound, x.upperBound)])
    elseif isdisjoint(x, y)
        return IntervalUnion([deepcopy(x)                         , Interval()])
    end
end

function intervalDiff(x :: T, :: EmptyInterval) :: IntervalUnion where T <: AbstractInterval
    return IntervalUnion([deepcopy(x)])
end

function intervalDiff(x :: IntervalUnion, y :: Interval) :: IntervalUnion
    return IntervalUnion([intersect(interval, y) for interval in x.intervals])
end

function intervalDiff(x :: IntervalUnion, y :: IntervalUnion) :: Union{IntervalUnion, EmptyInterval}
    return IntervalUnion([intervalDiff(x, interval) for interval in y.intervals])
end
end

# testing and debugging
if (@__FILE__) === PROGRAM_FILE || contains(PROGRAM_FILE, "debug")
    using .Intervals
end