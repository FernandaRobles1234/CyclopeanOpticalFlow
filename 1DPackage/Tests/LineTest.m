(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



(* ::Input::Initialization:: *)
lineTest[rangex_,{lvlmin_,lvlmax_},pyrfunctions_,threshold_,mode_]:=Block[{},(
(* Import mode of interest *)
Get["pyramidalCyclope1DLK"<>mode<>"`"];

(* Get all values of 10 iterations *)
(*Any time we call the methods we have to give threshold accordint to the min level *)
seeAllLine[rangex,pyrfunctions[[lvlmin;;lvlmax]],threshold*2^(-lvlmin+1)]
)]

lineTest::usage="
Input=[rangex, {lvlmin, lvlmax}, pyrfunctions, threshold, mode]
Output= Plot in range of rangex for solution ran over a pyramid in range of lvlmin and lvlman using lvl min as a reference
";



