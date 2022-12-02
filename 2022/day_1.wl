(* ::Package:: *)

(* ::Title:: *)
(*Advent of Code Day 1*)


(* ::Section:: *)
(*Part 1*)


(* ::Subsection:: *)
(*Input parsing*)


SetDirectory@NotebookDirectory[];


input=Import[FileNameJoin[{Directory[],"day1_input.txt"}]];


(* ::Text:: *)
(*How many calories is the the most calories?*)


elfList=Map[ToExpression,StringSplit[StringSplit[input,"\n\n"],"\n"],{-1}];


(* ::Subsection:: *)
(*Solution*)


Max@Total[elfList,{2}]


(* ::Section:: *)
(*Part 2*)


Total[MaximalBy[elfList,Total,3],2]
