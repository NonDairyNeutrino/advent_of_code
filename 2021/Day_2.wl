(* ::Package:: *)

(* ::Title:: *)
(*Advent of Code: Day 2*)


(* ::Section:: *)
(*Input*)


input = MapAt[ToExpression, #, {All, 2}] & @ StringSplit@StringSplit[#, "\n"]&@Import@"Day_2_input.txt"


(* ::Section:: *)
(*Code*)


(* ::Subsection:: *)
(*Part 1*)


(* ::Text:: *)
(*What do you get if you multiply your final horizontal position by your final depth?*)


horizontal = Total@Cases[input, {"forward", n_} :> n]
depth = Cases[input /. {"up", n_} :> {"down", -n}, {"down", n_} :> n] // Total
horizontal*depth


(* ::Subsection:: *)
(*Part 2*)


(* ::Text:: *)
(*What do you get if you multiply your final horizontal position by your final depth?*)


Block[
	{hor = 0, depth = 0, aim = 0},
	Switch[#1, "forward", hor += #2; depth += aim #2, "down", aim += #2]& @@@ (input /. {"up", n_} :> {"down", -n});
	hor depth
]


SplitBy[input /. {"up", n_} :> {"down", -ToExpression@n}, First]
