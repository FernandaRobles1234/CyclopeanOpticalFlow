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
(* Input\[Rule] {{initial values for v1, v2 and status}, pixel of interest, {functions f1, df1, f2, df2}, threshold for magnitude error}*)
(* Output\[Rule] {new values for v1, v2 and status} *)
PyrUpgrade1D[{v1_,v2_,status_,e_,dv1sign_,dv2sign_},p0_, {{fline1_,dfline1_} ,{fline2_,dfline2_}}, threshold_,"ConstrainedInitialSign"]:=Block[{fric1,fric2,p1, p2, c,d1,d2,dv1,dv2,newdv1sign, newdv2sign},(

p1=(p0-dv1sign)-v1;
p2=(p0+dv2sign)+v2;

c = (fline1[p0]+fline2[p0])/2;
d1=dfline1[p1];
d2=dfline2[p2];

fric1=0.5*dfline1'[p1]; 
fric2=0.5*dfline2'[p2];

(* Change of sign during iteration *)
If[(Abs[d1]<threshold||Abs[d2]<threshold ),
If[e<2,Return[{v1,v2,"mag",e+1,dv1sign,dv2sign}],Return[{0.,0.,"mag",e,0.,0.}]]];

(* Change of sign during iteration *)
(*If[(dfline1[p0-dv1sign]*d1<0||dfline2[p0+dv2sign]*d2<0),If[e<2,Return[{v1,v2,"flip",e+1,dv1sign,dv2sign}],Return[{0.,0.,"flip",e,0.,0.}]]];*)

(*We cannot compare to previous lvls because we don't know where we are at *)

(* d1 and d2 have to be the same sign in every iteration *)
If[d1*d2 <0, 

If[e<2,

(* if p at initial position and failed... *)
If[(p0==p1 && p0==p2),
(*we could use the root to find the new dv1 too*)
(* we feed new dv1sign... *)
If[Abs[d1]>Abs[d2],
{newdv1sign,newdv2sign}={0.,(c-fline2[p2])/-(d2+Sign[d2]*0.01)},{newdv1sign,newdv2sign}={(fline1[p1]-c)/-(d1+Sign[d1]*0.01),0.}];

Return[PyrUpgrade1D[{v1,v2,"oksign",e,newdv1sign, newdv2sign},p0, {{fline1,dfline1} ,{fline2,dfline2}}, threshold,"ConstrainedInitialSign"]],

Return[PyrUpgrade1D[{v1,v2,"oksign",e,dv1sign,dv2sign},p0, {{fline1,dfline1} ,{fline2,dfline2}}, threshold,"ConstrainedInitialSign"]]
]
,
Return[{0.,0.,"sign",e,0.,0.}]
]
];

(* dv1,dv2 : step from last {v1,v2} to new {v1,v2} *)
{dv1,dv2}= {(fline1[p1]-c)/(d1+Sign[d1]*Abs[fric1]),(c-fline2[p2])/(d2+Sign[d2]*Abs[fric2])};

{v1+dv1,v2+dv2,If[Norm[{dv1,dv2}]<0.001,"converged","ok"],e,dv1sign,dv2sign}
)];

(* status: "OK" -> solution respects constraints,  errors: "sign", "mag", "flip" *)
(* status: "converged" -> we converged!! *)

PyrUpgrade1D[{v1_,v2_,"oksign",e_,dv1sign_,dv2sign_},p0_, {{fline1_,dfline1_} ,{fline2_,dfline2_}}, threshold_,"ConstrainedInitialSign"]:=Block[{fric1,fric2,p1,p2,c,d1,d2,dv1,dv2,r0},(

p1=(p0-dv1sign)-v1;
p2=(p0+dv2sign)+v2;

c = (fline1[p0]+fline2[p0])/2;
d1=dfline1[p1];
d2=dfline2[p2];

fric1=0.5*dfline1'[p1];
fric2=0.5*dfline2'[p2];

(*{Null,Null}*)
(* magnitude *)
If[(Abs[d1]<threshold||Abs[d2]<threshold ),If[e<2,Return[{v1,v2,"mag",e+1,dv1sign,dv2sign}],Return[{0.,0.,"mag",e,0.,0.}]]];

(*{v1,v2}*)
(* Change of sign during iteration *)
(*If[(dfline1[p0-dv1sign]*d1<0||dfline2[p0+dv2sign]*d2<0),If[e<2,Return[{v1,v2,"flip",e+1,dv1sign,dv2sign}],Return[{0.,0.,"flip",e,0.,0.}]]];*)

(*{Null,Null}*)
(* d1 and d2 have to be the same sign *)
 If[d1*d2 <0, If[e<2,Return[{v1,v2,"sign",e+1,dv1sign,dv2sign}],Return[{0.,0.,"sign",e,0.,0.}]]]; 

(* dv1,dv2 : step from last {v1,v2} to new {v1,v2} *)
{dv1,dv2}= {(fline1[p1]-c)/(d1+Sign[d1]*Abs[fric1]),(c-fline2[p2])/(d2+Sign[d2]*Abs[fric2])};

{v1+dv1,v2+dv2,If[Norm[{dv1,dv2}]<0.001,"converged","oksign"],e,dv1sign,dv2sign}
)];

PyrUpgrade1D[{v1_,v2_,status_,2,dv1sign_,dv2sign_},p0_, {{fline1_,dfline1_} ,{fline2_,dfline2_}}, threshold_,"ConstrainedInitialSign"]:=Return[{0.,0.,status,2,0.,0.}];

PyrUpgrade1D[{v1_,v2_,"sign",e_,dv1sign_,dv2sign_},p0_, {{fline1_,dfline1_} ,{fline2_,dfline2_}}, threshold_,"ConstrainedInitialSign"]:=Return[{v1,v2,"sign",e,dv1sign,dv2sign}];

PyrUpgrade1D[{v1_,v2_,"mag",e_,dv1sign_,dv2sign_},p0_, {{fline1_,dfline1_} ,{fline2_,dfline2_}}, threshold_,"ConstrainedInitialSign"]:=Return[{v1,v2,"mag",e,dv1sign,dv2sign}];

PyrUpgrade1D[{v1_,v2_,"flip",e_,dv1sign_,dv2sign_},p0_, {{fline1_,dfline1_} ,{fline2_,dfline2_}}, threshold_,"ConstrainedInitialSign"]:=Return[{v1,v2,"flip",e,dv1sign,dv2sign}];

PyrUpgrade1D::usage="
Function to update values of v1 and v2 with Constrained standards
Input\[Rule] [{v1,v2,status,e},p0,{{f1,df1},{f2,df2},threshold}
Output-> {v1,v2,status}
v1= Solution of f1
v2= Solution of f2
status= Status of the solution (ok, sign, mag, flip, converged)
e= counts the amount of constraints not met
p0= point of interest
{f1,df1}={function 1, derivative of function 1}
{f2,df2}={function 2, derivative of function 2}
threshold= threshold to respect magnitude constraint
";


(* ::Input::Initialization:: *)
PyrFlow1D[i_, p0_, pyrfunctions_,threshold_,"ConstrainedInitialSign"]:=Block[{v1, v2,c,d,dd,cc,status,e,dv1sign,iterTable,updateValues},(
c=Length[pyrfunctions]; (* number of levels *)

(*{v1, v2, status, e, dv1sign, dv2sign}*)
updateValues={0.,0.,"ok",0.,0.,0.};

Do[
(* compute at this scale, using current motion estimate *)
If[updateValues[[4]]<2,updateValues[[3]]="ok",updateValues={0.,0.,updateValues[[3]],2.,0.,0.}];

iterTable=Table[
updateValues=PyrUpgrade1D[updateValues,p0, pyrfunctions[[-f]],threshold*2^(-c+1),"ConstrainedInitialSign"];

,{j,1,i}];

c=c-1;
,{f,1,Length[pyrfunctions]}];

{updateValues[[1]]+updateValues[[-2]], updateValues[[2]]+updateValues[[-1]],updateValues[[3]]}
)];

PyrFlow1D::usage="
Function to update values of v1 and v2 over all levels of a pyramidal function representation
with OverConstrained standards.
Input\[Rule] [i, p0, pyrfunctions, threshold]
Output-> {v1, v2, status,e}
i= number of iterations
p0= point of interest
pyrfunctions= list with the dimensions of {pyrlvl, number of image(1 or 2), kind of function(f or df)}
where pyrlvl is the pyramidal level
threshold= threshold to respect magnitude constraint
v1= Solution of f1
v2= Solution of f2
status= Status of the solution (ok, sign, mag, flip, converged)
e= Counts the amount of times the constraints were not met
";


(* ::Input::Initialization:: *)
(* Function to find solutions for all levels of pyramid {l1,l2,l3,l4,...} or {l1} *)
(* Input\[Rule] {number of iterations, pixel of interests, pyrfunctions,threshold *)
(* Output\[Rule] {v1, v2,status}*)
PyrFlow1DIter[i_, p0_,v0_, pyrfunctions_,threshold_,"ConstrainedInitialSign"]:=Block[{v1, v2,c,status,iterTable,updateValues},(

c=Length[pyrfunctions]; (* number of levels *)

(*{v1, v2, status, e, dv1sign, dv2sign}*)
updateValues={v0[[1]],v0[[2]],"ok",0.,0.,0.};

Table[
(* compute at this scale, using current motion estimate *)
If[updateValues[[4]]<2,updateValues[[3]]="ok",updateValues={0.,0.,updateValues[[3]],2.,0.,0.}];

iterTable=Table[
updateValues=PyrUpgrade1D[updateValues,p0, pyrfunctions[[-f]],threshold*2^(-c+1),"ConstrainedInitialSign"];

{updateValues[[1]]+updateValues[[-2]], updateValues[[2]]+updateValues[[-1]],updateValues[[3]]}
,{j,1,i*2}];

c=c-1;

iterTable
,{f,1,Length[pyrfunctions]}]
)];



