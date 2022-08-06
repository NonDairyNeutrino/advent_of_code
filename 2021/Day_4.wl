(* ::Package:: *)

(* ::Title:: *)
(*Advent of Code: Day 4*)


(* ::Section:: *)
(*Input*)


SetDirectory@NotebookDirectory[];
{order, boards} = {#1, {##2}}& @@ StringSplit[#, "\n"]&@StringSplit[#, "\n\n"] &@Import@"Day_4_input.txt";
order = First@ToExpression@StringSplit[order, ","];
boards = StringSplit[#, Whitespace]& /@ boards // ToExpression;


(* ::Section:: *)
(*Code*)


(* ::Subsection:: *)
(*Part 1*)


Block[
	{n = 0},
	NestWhile[
		(n++; # /. order[[n]] -> marked@order[[n]]) &,
		boards,
		Count[#, {__marked}, \[Infinity]] == 0 &
	];
	
]
