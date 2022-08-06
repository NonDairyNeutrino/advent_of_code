(* ::Package:: *)

(* ::Section:: *)
(*Day 2: Password Philosophy*)


SetDirectory@NotebookDirectory[];
<<"aoc_day2_input.wl"


(* ::Subsection:: *)
(*Code*)


Clear@parsed
parsed=MapAt[ToExpression,#,{{1},{2}}]&/@DeleteCases[#,"",{2}]&@Partition[#,5]&@StringSplit[#,Whitespace|"-"|":"]&@day[2];


(* ::Subsubsection:: *)
(*Part 1*)


#1<=StringCount[#4,#3]<=#2&@@@parsed//Total@*Boole


(* ::Subsubsection:: *)
(*Part 2*)


Count[StringTake[#4,{{#1},{#2}}],#3]==1&@@@parsed//Total@*Boole
