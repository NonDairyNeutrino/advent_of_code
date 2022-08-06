(* ::Package:: *)

(* ::Title:: *)
(*Day 7: Handy Haversacks*)


SetDirectory@NotebookDirectory[];
<<"aoc_day7_input.wl"


(* ::Section:: *)
(*Parsing*)


parseBag[str_String]:=parseBag@StringSplit[StringTrim[str]];
parseBag[name:{_,_}]:=StringRiffle[name];
parseBag[{count_,name1_,name2_}]:={ToExpression[count],parseBag[{name1,name2}]};


StringSplit[
"vibrant aqua bags contain 2 shiny magenta bags, 9 faded blue bags.",
{"bags contain no other bags.","bags contain",("bags"|"bag")~~(","|".")}]
parseBag/@%


parsedRules = parseBag/@StringSplit[
		#,
		{"bags contain no other bags.","bags contain",("bags"|"bag")~~(","|".")}
] & /@ StringSplit[day[7], "\n"];


(*Exmaple of structure of each parsed rules*)
parsedRules[[1]]


(* ::Section:: *)
(*Code*)


(* ::Section:: *)
(*Part 1*)


(* ::Text:: *)
(*Bottom up version*)


Select[parsedRules, MemberQ["shiny gold"]@Level[#, {-1}]&]
%[[;;, 1]]
MemberQ[{_, Alternatives@@%}]/@parsedRules
(*Select[parsedRules, MemberQ[{_, Alternatives@@%}]]//Column*)


(* ::Text:: *)
(*Top to bottom*)


(* ::Section:: *)
(*Part 2*)
