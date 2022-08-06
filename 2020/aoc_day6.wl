(* ::Package:: *)

(* ::Title:: *)
(*Day 6: Custom Customs*)


SetDirectory@NotebookDirectory[]
<<"aoc_day6_input.wl"


(* ::Section:: *)
(*Parsing*)


parsedInput = StringSplit[StringSplit[day[6], "\n\n"](*Split into groups*), "\n"](*Split into people*) // Characters;


(* ::Section:: *)
(*Part 1*)


Union@@@parsedInput (*Unique questions answered yes to for each group*);
Length/@% //Total


(* ::Section:: *)
(*Part 2*)


Intersection@@@parsedInput;
Length/@%//Total
