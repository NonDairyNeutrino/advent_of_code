module Maps
include("Intervals.jl")
using .Intervals
using Test

struct Map # not a good name as it conflicts with `map`
    domainName::String
    domain::IntervalUnion
    codomainName::String
    codomain::IntervalUnion
    mapping::Function
    function Map(domainName::String, domain::IntervalUnion, codomainName::String, codomain::IntervalUnion)

        function mapping(x::Real)
            # go through each interval for the map
            for (intervalDomain, intervalCodomain) in zip(domain.intervals, codomain.intervals)
                if x in intervalDomain
                    return intervalCodomain.lowerBound + (x - intervalDomain.lowerBound)
                end
            end
            # if the input isn't in the domain intervals, return itself
            return x
        end

        function mapping(inputInterval::Interval)
            # initialize vectors you're going to put stuff into
            mappedIntervalVector = Intervals.AbstractInterval[]
            inputIntervalRemaining = IntervalUnion([deepcopy(inputInterval)])

            for (intervalDomain, intervalCodomain) in zip(domain.intervals, codomain.intervals)
                # first get the chunk of the input interval that overlaps with the domain interval for the current mapping
                overlapInterval = intersect(inputIntervalRemaining, intervalDomain)

                if overlapInterval isa EmptyInterval || overlapInterval == IntervalUnion(Interval[])
                    # if there is no overlap between the input interval and the domain interval, the image of the input interval is empty
                    mappedInterval = Interval()
                else
                    # if there is an overlap, map the overlap
                    mappedInterval = intervalCodomain + (overlapInterval - intervalDomain)
                end

                # store the image of the overlap
                push!(mappedIntervalVector, mappedInterval)
                # kick out the overlapping chunk from the inputInterval
                inputIntervalRemaining = intervalDiff(inputIntervalRemaining, overlapInterval)
            end
            return IntervalUnion([mappedIntervalVector..., inputIntervalRemaining])
        end
        return new(domainName, domain, codomainName, codomain, mapping)
    end
end

if (@__FILE__) == PROGRAM_FILE || contains(PROGRAM_FILE, "debug")
    tempMap = Map("seed", IntervalUnion([Interval(98, 99), Interval(50, 97)]), "soil", IntervalUnion([Interval(50, 51), Interval(52, 99)]))
    (@test tempMap.mapping(79) == 81) |> display
    (@test tempMap.mapping(14) == 14) |> display
    (@test tempMap.mapping(Interval(98, 99)) == IntervalUnion(Interval[Interval(50, 51)])) |> display
    (@test tempMap.mapping(Interval(50, 97)) == IntervalUnion(Interval[Interval(52, 99)])) |> display
    #= (@test =# tempMap.mapping(Interval(0, 99)) #= == IntervalUnion(Interval[Interval(0, 49), Interval(52, 99), Interval(50, 51)])) =# |> display
end
end