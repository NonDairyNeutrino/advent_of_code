(* ::Package:: *)

(* ::Title:: *)
(*Advent of Code: Day 3*)


(* ::Section:: *)
(*Input*)


SetDirectory@NotebookDirectory[];
Clear@input; input = Characters /@ StringSplit[#, "\n"] &@Import@"Day_3_input.txt"(*"00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010"*) // ToExpression;


(* ::Section:: *)
(*Code*)


Clear@binaryToDecimal
binaryToDecimal[bin : {(0|1)..}] := bin.(2^Reverse@Range[0, Length@bin - 1])
binaryToDecimal[bin : {{(0|1)..}..}] := bin.(2^Reverse@Range[0, Length@Transpose@bin - 1])


Clear@leastCommonest
leastCommonest[list_List] := MinimalBy[Tally@list, #[[2]]&][[;;, 1]]


(* ::Subsection:: *)
(*Part 1*)


(* ::Text:: *)
(*What is the power consumption of the submarine?*)


SortBy[Tally@#, Last]& /@ Transpose@input
Clear@minsAndMaxes; minsAndMaxes = AssociationThread[{"mins", "maxes"}, Transpose@%[[;;, ;;, 1]]]
Times@@binaryToDecimal@Values@minsAndMaxes


(* ::Subsection:: *)
(*Part 2*)


(* ::Subsubsection:: *)
(*Procedural Method*)


Clear@echo
echo[x_] := (Print[x]; x)


oxygenRating = binaryToDecimal@Block[
	{n = 0},
	NestWhile[
		Function[
			binList,
			n++; 
			Select[
				binList,
				#[[n]] == If[
					Length@Commonest@binList[[;;, n]] > 1,
					1,
					First@Commonest@binList[[;;, n]]
				] &
			]
		],
		input,
		Length@# > 1 &,
		1,
		Length@Transpose@input
	]
]

carbonRating = binaryToDecimal@Block[
	{n = 0},
	NestWhile[
		Function[
			binList,
			n++; 
			Select[
				binList,
				#[[n]] == If[
					Length@leastCommonest@binList[[;;, n]] > 1,
					0,
					First@leastCommonest@binList[[;;, n]]
				] &
			]
		],
		input,
		Length@# > 1 &,
		1,
		Length@Transpose@input
	]
]

oxygenRating carbonRating
