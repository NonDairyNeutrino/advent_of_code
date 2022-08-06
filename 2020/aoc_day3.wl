(* ::Package:: *)

(* ::Section:: *)
(*Day 3: Toboggan Trajectory*)


SetDirectory@NotebookDirectory[];
<<"aoc_day3_input.wl"


(* ::Subsection:: *)
(*Code*)


Clear@parsed
parsed=List@@@StringReplace[StringSplit@day[3],{"."->0,"#"->1}];


Clear@tos(*trees on slope*)
tos[slope:{__Integer?Positive}(*{right,down}*)/;Length@slope==2]:=Total@MapIndexed[#1[[Mod[1+slope[[1]](Sequence@@#2-1),Length@#1,1]]]&,parsed[[;;;;slope[[2]]]]]


(* ::Subsubsection:: *)
(*Part 1*)


tos[{3,1}]


(* ::Subsubsection:: *)
(*Part 2*)


tos/@{{1,1},{3,1},{5,1},{7,1},{1,2}}
Times@@%
