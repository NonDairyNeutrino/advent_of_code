(* ::Package:: *)

(* ::Section:: *)
(*Day 1: Report Repair*)


SetDirectory@NotebookDirectory[];
<<"aoc_day1_input.wl"


(* ::Subsection:: *)
(*Code*)


(*If the sum of the smallest two and biggest elements is greater than 2020, 
then the last element cannot be added to any other elements to equal 2020, and thus can be removed*)
Clear@getValids
getValids[list:{__?NumericQ},numofterms_Integer,bound_?NumericQ]:=With[
	{sortedList = Sort@list},
	NestWhile[
		Most,
		sortedList,
		Max@#+Total@*sortedList[[;;numofterms-1]]@#>bound&
	]
]


(*Rename to make the result more contextual*)
Clear@combos
combos[list_,len_]:=Subsets[list,{len}]


Clear@getCombo
getCombo[list:{__?NumericQ},numofterms_Integer,bound_?NumericQ]:=First@Select[
	getValids[list,numofterms,bound]~combos~numofterms,
	Total@#==bound&
]


(* ::Subsubsection:: *)
(*Part 1*)


Times@@getCombo[day[1],2,2020]


(* ::Subsubsection:: *)
(*Part 2*)


Times@@getCombo[day[1],3,2020]
