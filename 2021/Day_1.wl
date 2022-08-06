(* ::Package:: *)

(* ::Title:: *)
(*Advent of Code: Day 1*)


(* ::Text:: *)
(*How many measurements are larger than the previous measurement?*)


(* ::Section:: *)
(*Input*)


input=ToExpression/@StringSplit@Import@"Day_1_input.txt"


(* ::Section:: *)
(*Code*)


(* ::Subsection:: *)
(*Part 1*)


Total@Boole@Positive@Differences@input


(* ::Subsection:: *)
(*Part 2*)


Total@Boole@Positive@Differences@Total[Partition[input, 3, 1], {2}]
