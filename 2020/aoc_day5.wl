(* ::Package:: *)

(* ::Section:: *)
(*Day 5: Binary Boarding*)


SetDirectory@NotebookDirectory[];
<<"aoc_day5_input.wl"


(* ::Subsection:: *)
(*Code*)


(* ::Text:: *)
(*First we create the structure of the plane as an array with each element being the seat indexed under the binary partioning scheme.*)


Clear@plane
plane=ArrayReshape[Array[seat,{128,8},0],ConstantArray[2,10]];


(* ::Text:: *)
(*Then for a given boarding pass "pass", we replace the string with a list of binary indices.  For example a seat in the front of the back section designated by "BF" would go to {2,1}.*)


ClearAll@passToIndex
SetAttributes[passToIndex, Listable]
passToIndex[pass_String]:=Characters@pass/.{"F"|"L"->1,"B"|"R"->2}


(* ::Text:: *)
(*Since the plane is structured in binary partitions, we take the appropriate index and map it to the "flat" seat. Then we take that index within the array to get the seat on the plane.*)


Clear@indexToSeat
indexToSeat[inds_]:=Extract[plane,inds];


(* ::Text:: *)
(*Then we can compose these to make things a little more direct and readable.*)


Clear@passToSeat
passToSeat=indexToSeat@*passToIndex;


(* ::Text:: *)
(*Then we parse our input/set of boarding passes to get a list of the corresponding indices in the partitioned array.*)


Clear@seats
seats=passToSeat@StringSplit@day[5];


Clear@seatToID
seatToID=Apply[8#1+#2&];


(* ::Subsubsection:: *)
(*Tests*)


(* ::Input:: *)
(*passToSeat@"FBFBBFFRLR"*)
(*(*Should be {44,5}*)*)


(* ::Input:: *)
(*passToSeat@{"BFFFBBFRRR","FFFBBBFRRR","BBFFBBFRLL"}*)


(* ::Input:: *)
(*seatToID@*passToSeat/@{"BFFFBBFRRR", "FFFBBBFRRR", "BBFFBBFRLL"}*)
(*(*Should be {567, 119, 820}*)*)


(* ::Subsubsection:: *)
(*Part 1*)


(* ::Text:: *)
(*Find the highest seat ID on a boarding pass.*)


seatToID/@seats//Max


(* ::Subsubsection:: *)
(*Part 2*)


(* ::Text:: *)
(*What is my seat ID?*)


(* ::Text:: *)
(*Identify all the seats in the plane structure that are taken.  Since the seats next to me will be taken, my partition will either {taken, my seat} or {my seat, taken}.*)


plane /. Thread[seats -> "taken"] (*Identify all the seats in the plane structure that are taken*);
Cases[%, {OrderlessPatternSequence[myseat : _seat, "taken"]} :> myseat, \[Infinity]][[1]]
seatToID@%
