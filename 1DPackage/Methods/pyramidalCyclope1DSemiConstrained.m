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
(* Function to update values of v1 and v2 with Over Constrained standards *)
(* Any value that does not meets the constraints becomes 0 *)

(* Input\[Rule] {{initial values for v1, v2 and status, and counter e}, pixel of interest, {functions f1, df1, f2, df2}, threshold for magnitude error}*)
(* Output\[Rule] {new values for v1, v2 and status and e} *)
PyrUpgrade1D[{v1_,v2_,status_},p0_, {{fline1_,dfline1_} ,{fline2_,dfline2_}}, threshold_,"SemiConstrained"]:=Block[{p1, p2, c,d1,d2,dv1,dv2,fric1,fric2},(
p1=p0-v1;
p2=p0+v2;

c = (fline1[p0]+fline2[p0])/2;
d1=dfline1[p1];
d2=dfline2[p2];

fric1=0.5*dfline1'[p1];
fric2=0.5*dfline2'[p2];

(* d1 and d2 have to be the same sign in every iteration *)
If[d1*d2 <0, Return[{v1,v2,"sign"}]];

(* magnitude needs to be bigger than threshold every iteration *)
If[(Abs[d1]<threshold||Abs[d2]<threshold ),Return[{v1,v2,"mag"}]];

(* Change of sign during iteration *)
(*If[(dfline1[p0]*d1<0||dfline2[p0]*d2<0),Return[{v1,v2,"flip"}]];*)

(* dv1,dv2 : step from last {v1,v2} to new {v1,v2} *)
{dv1,dv2}= {(fline1[p1]-c)/(d1+Sign[d1]*Abs[fric1]),(c-fline2[p2])/(d2+Sign[d2]*Abs[fric2])};

{v1+dv1,v2+dv2,If[Norm[{dv1,dv2}]<0.001,"converged","ok"]}
)];

(* No other solution will be calculated when status records an error message in this pyramidal level*)
PyrUpgrade1D[{v1_,v2_,"sign"},p0_, {{fline1_,dfline1_} ,{fline2_,dfline2_}}, threshold_,"SemiConstrained"]:={v1,v2,"sign"};

PyrUpgrade1D[{v1_,v2_,"mag"},p0_, {{fline1_,dfline1_} ,{fline2_,dfline2_}}, threshold_,"SemiConstrained"]:={v1,v2,"mag"};

PyrUpgrade1D[{v1_,v2_,"flip"},p0_, {{fline1_,dfline1_} ,{fline2_,dfline2_}}, threshold_,"SemiConstrained"]:={v1,v2,"flip"};



(* ::Input::Initialization:: *)
(* Function to find solutions for all levels of pyramid {l1,l2,l3,l4,...} or {l1} *)
(* Input\[Rule] {number of iterations, pixel of interests, pyrfunctions,threshold *)
(* Output\[Rule] {v1, v2,status}*)


PyrFlow1D[i_, p0_, pyrfunctions_,threshold_,"SemiConstrained"]:=Block[{v1, v2,c,status},(

c=Length[pyrfunctions]; (* number of levels *)

{v1, v2,status}={0.,0.,"ok"};

Do[
(* compute at this scale, using current motion estimate *)
{v1,v2,status}=Nest[PyrUpgrade1D[#,p0, pyrfunctions[[-f]],threshold*2^(-c+1),"SemiConstrained"]&,{v1,v2,"ok"},i];

c=c-1

,{f,1,Length[pyrfunctions]}];

{v1, v2,status}

)];


(* ::Input::Initialization:: *)
(* Function to find solutions for all levels of pyramid {l1,l2,l3,l4,...} or {l1} *)
(* Input\[Rule] {number of iterations, pixel of interests, pyrfunctions,threshold *)
(* Output\[Rule] {v1, v2,status}*)
PyrFlow1DIter[i_, p0_,v0_, pyrfunctions_,threshold_,"SemiConstrained"]:=Block[{v1, v2,c,status,iterTable},(

c=Length[pyrfunctions]; (* number of levels *)

{v1, v2}=v0;
status="ok";

Table[
(* compute at this scale, using current motion estimate *)

iterTable=Table[
(*index of pyrfunction works only if fed the right range of pyrfunctions*)
{v1,v2,status}=PyrUpgrade1D[{v1,v2,"ok"},p0, pyrfunctions[[-f]],threshold*2^(-c+1),"SemiConstrained"];

{v1,v2,status}
,{j,1,i}];

c=c-1;
iterTable
,{f,1,Length[pyrfunctions]}]

)];


