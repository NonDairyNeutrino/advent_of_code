(* ::Package:: *)

(* ::Section:: *)
(*Day 4: Passport Processing*)


SetDirectory@NotebookDirectory[];
<<"aoc_day4_input.wl"


(* ::Subsection:: *)
(*Code*)


Clear@parser
parser[input_String]:=StringSplit[#,":"]&/@Fold[StringSplit,input,{"\n\n","\n"|" "}]


Clear@parsed
parsed=parser@day[4];


(* ::Subsubsection:: *)
(*Part 1*)


If[Length@#==8||Length@#==7&&FreeQ[#,"cid"],1,0]&/@parsed[[;;,;;,1]]//Total


(* ::Subsubsection:: *)
(*Part 2*)


Clear@conds
conds=Alternatives[
{"byr",val_/;1920<=ToExpression@val<=2002},
{"iyr",val_/;2010<=ToExpression@val<=2020},
{"eyr",val_/;2020<=ToExpression@val<=2030},
{"hgt",val_/;With[{num=ToExpression[StringDrop[val,-2]],unit=StringTake[val,-2]},Which[unit=="cm",150<=num<=193,unit=="in",59<=num<=76]]},
{"hcl",val_/;StringMatchQ[val,"#"~~Alternatives@@Prepend[CharacterRange["a","f"],DigitCharacter]..]},
{"ecl","amb"|"blu"|"brn"|"gry"|"grn"|"hzl"|"oth"},
{"pid",val_/;StringLength@val==9&&StringMatchQ[val,DigitCharacter..]},
{"cid",_}
];


Clear@validQ
validQ=AllTrue@*MatchQ@conds;


Clear@valnum
valnum=Total@*Boole@*Map[validQ];


(*test*)
parser@badpasses;
(*Should be 0*)valnum@%


parser@goodpasses;
(*Should be 4*) valnum@%


Select[parsed,Length@#==8||Length@#==7&&FreeQ[#,"cid"]&];
valnum@%
