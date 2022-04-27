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
PyrUpgrade1D[{v1_,v2_,status_,e_},p0_, {{fline1_,dfline1_} ,{fline2_,dfline2_}}, threshold_,n_,"ConstrainedNewMethod"]:=Block[{fric1,fric2,p1, p2, c,d1,d2,dv1,dv2},(

p1=p0-v1;
p2=p0+v2;

c = (fline1[p0]+fline2[p0])/2;
d1=dfline1[p1];
d2=dfline2[p2];

fric1=1*dfline1'[p1];
fric2=1*dfline2'[p2];

(* d1 and d2 have to be the same sign in every iteration *)
If[d1*d2 <0, If[e<n,Return[{v1,v2,"oksign",e+1}],Return[{0.,0.,"sign",e}]]];

(* magnitud *)
If[(Abs[d1]<threshold||Abs[d2]<threshold ),If[e<n,Return[{v1,v2,"okmag",e+1}],Return[{0.,0.,"mag",e}]]];

(* Change of sign during iteration *)
(*If[(dfline1[p0]*d1<0||dfline2[p0]*d2<0),If[e<2,Return[{v1,v2,"flip",e+1}],Return[{0.,0.,"flip",e}]]];*)

(* dv1,dv2 : step from last {v1,v2} to new {v1,v2} *)
{dv1,dv2}= {(fline1[p1]-c)/(d1+Sign[d1]*Abs[fric1]),(c-fline2[p2])/(d2+Sign[d2]*Abs[fric2])};

If[e<=n,{v1+dv1,v2+dv2,If[Norm[{dv1,dv2}]<0.01,"converged","ok"],e},Return[{0.,0.,status,e}]]

)];

(* No other solution will be calculated when status records an error message in this pyramidal level*)
(* status: "OK" -> solution respects constraints,  errors: "sign", "mag", "flip" *)
(* status: "converged" -> we converged!! *)
PyrUpgrade1D[{v1_,v2_,"sign",e_},p0_, {{fline1_,dfline1_} ,{fline2_,dfline2_}}, threshold_,n_,"ConstrainedNewMethod"]:=Return[{v1,v2,"sign",e}];

PyrUpgrade1D[{v1_,v2_,"mag",e_},p0_, {{fline1_,dfline1_} ,{fline2_,dfline2_}}, threshold_,n_,"ConstrainedNewMethod"]:=Return[{v1,v2,"mag",e}];

PyrUpgrade1D[{v1_,v2_,"flip",e_},p0_, {{fline1_,dfline1_} ,{fline2_,dfline2_}}, threshold_,n_,"ConstrainedNewMethod"]:=Return[{v1,v2,"flip",e}];



(* ::Input::Initialization:: *)
(* This will only give values that sum up to the magnitude of v 
Or if v0 = 0, random values between 10 and -10 *)
(*n=allowed failed levels, u= shift on v solution through levels*)

newValues[i_,n_,u_,{v1_,v2_,status_,e_},newv0_,"ConstrainedNewMethod"]:=Block[{v,r,rs,newVals},(
v=v1+v2;

If[e>n,
Return[{{0.,0.}}];
];

If[v!=0. && status=="ok",
newVals=Table[
r=RandomReal[];
{r,1-r}*v
,{j,i}];
If[u!=0.,Join[newVals,newVals-u, newVals+u],newVals]

,
newv0
]

)]


(* ::Input::Initialization:: *)
(* This will give back a value that converged or is on "ok" status. If not, error is returned and {v1,v2} goes back to 0. *)

pickNewValue[tableNewVals_,condition_,"ConstrainedNewMethod"]:=Block[{newValOk,newValCon,newValAny,noFakeConverge},(

(* Criterias to select a solution *)
newValCon=Select[tableNewVals,(#[[3]]=="converged")&&condition[#]&,1];
newValAny=Select[tableNewVals,(#[[3]]!= "ok"&&#[[3]]!= "oksign"&&#[[3]]!= "okmag"&&#[[3]]!= "converged")&&condition[#]&,1];
newValOk=Select[tableNewVals,(#[[3]]=="ok"||#[[3]]=="oksign"||#[[3]]=="okmag")&& condition[#]&,1];

noFakeConverge=Select[tableNewVals,(#[[3]]!= "ok"&&#[[3]]!= "oksign"&&#[[3]]!= "okmag"&&#[[3]]!= "converged")&,1];

(* No solution meets criteria *)
If[newValCon=={}&&newValAny=={}&&newValOk=={},

If[noFakeConverge=={},
Flatten[{0.,0.,"fakeconverged",tableNewVals[[1,4]]+1}]
,
Flatten[{0.,0.,noFakeConverge[[1,3]],noFakeConverge[[1,4]]}]
]

,
(* solution meets criteria but it did not converge *)
If[newValCon=={},
(* solution meets criteria but isn't ok or converged *)
If[newValOk=={},
newValAny[[1]]
,

Flatten[{newValOk[[1,1;;2]],"ok",newValOk[[1,4]]}]
],

newValCon[[1]]
]

]
)]


(* ::Input::Initialization:: *)
(* Function to find solutions for all levels of pyramid {l1,l2,l3,l4,...} or {l1} *)
(* Input\[Rule] {number of iterations, allowed failed levels, shift on v solution through levels, pixel of interests, pyrfunctions,threshold *)
(* Output\[Rule] {v1, v2,status}*)
PyrFlow1D[i_,n_,u_, p0_,listv0_,condition_, pyrfunctions_,threshold_,"ConstrainedNewMethod"]:=Block[{c, updateValues,nV,tableNewValues,tValues},(

c=Length[pyrfunctions]; (* number of levels *)

(*{v1, v2, status, e}*)
updateValues={0.,0.,"ok",0.};

Do[

(* Flag to stop when e\[GreaterEqual]n *)
If[updateValues[[4]]<=n,updateValues[[3]]="ok", updateValues={0.,0.,updateValues[[3]],updateValues[[4]]}];

(* This will only give values that sum up to the magnitude of v 
Or if v0 = 0, list newv0 is created and fed to the function to try all it's contained values *)
nV=newValues[10,n,u,updateValues[[1;;4]],listv0,"ConstrainedNewMethod"];
(* compute at this scale, using current motion estimate *)

tableNewValues=Table[

(* We initialize whith values calculated at nV and last calculated updateValues[[3;;4]]*)
tValues=Flatten[{v,updateValues[[3;;4]]}];

Do[
tValues=PyrUpgrade1D[tValues,p0, pyrfunctions[[-f]],threshold*2^(-c+1),n,"ConstrainedNewMethod"];
If[tValues[[3]]!="ok",Break[]];

,{j,1,i}];

tValues
,{v,nV}];

(* We only update updateValues with the tValue that converged *)
updateValues=pickNewValue[tableNewValues,condition,"ConstrainedNewMethod"];


c=c-1;
,{f,1,Length[pyrfunctions]}];
updateValues[[1;;3]]
)];


(* ::Input::Initialization:: *)
pickNewValueIter[tableIterNewVals_,"ConstrainedNewMethod"]:=Block[{newIterValCon,newIterValAny,newIterValOk,noIterFakeConverge},(
newIterValCon=Select[tableIterNewVals,(Last[#][[3]]=="converged"&&Last[#][[1]]*Last[#][[2]]>0 && 0<Last[#][[2]]+Last[#][[1]]<1)&,1];
newIterValAny=Select[tableIterNewVals,((Last[#][[3]]!= "ok" ||Last[#][[3]]!= "oksign"||Last[#][[3]]!= "okmag"||Last[#][[3]]!= "converged")&&Last[#][[1]]*Last[#][[2]]>0 && 0<Last[#][[2]]+Last[#][[1]]<1)&,1];
newIterValOk=Select[tableIterNewVals,((Last[#][[3]]=="ok" ||Last[#][[3]]=="oksign"||Last[#][[3]]=="okmag")&&Last[#][[1]]*Last[#][[2]]>0 && 0<Last[#][[2]]+Last[#][[1]]<1)&,1];
noIterFakeConverge=Select[tableIterNewVals,(Last[#][[3]]!= "ok" ||Last[#][[3]]!= "oksign"||Last[#][[3]]!= "okmag"||Last[#][[3]]!= "converged")&,1];

(* No solution meets criteria *)
If[newIterValCon=={}&&newIterValAny=={}&&newIterValOk=={},

If[noIterFakeConverge=={},
(* If any kind of ok does not meet the criteria, there is no solution in this lvl*)
Join[tableIterNewVals[[1]],{Flatten[{0.,0.,"fakeconverge",Last[tableIterNewVals[[1]]][[4]]+1}]}]
,
Join[noIterFakeConverge[[1]],{Flatten[{0.,0.,Last[noIterFakeConverge[[1]]][[3]],Last[noIterFakeConverge[[1]]][[4]]}]}]
]

,
(* solution meets criteria but it did not converge *)
If[newIterValCon=={},
(* solution meets criteria but isn't ok or converged *)
If[newIterValOk=={},
newIterValAny[[1]]
,
Join[newIterValOk[[1]],{Flatten[{Last[newIterValOk[[1]]][[1;;2]],"ok",Last[newIterValOk[[1]]][[4]]}]}]
],
newIterValCon[[1]]
]
]

)]


(* ::Input::Initialization:: *)
(* Function to find solutions for all levels of pyramid {l1,l2,l3,l4,...} or {l1} *)
(* Input\[Rule] {number of iterations, allowed failed levels, shift on v solution through levels, pixel of interests, pyrfunctions,threshold *)
(* Output\[Rule] {v1, v2,status}*)
PyrFlow1DIter[i_,n_,u_, p0_,newv0_, pyrfunctions_,threshold_,"ConstrainedNewMethod"]:=Block[{c,updateValues,newVals,tableNewValues,tValues,iterTable,goodValIter,nV},(


c=Length[pyrfunctions]; (* number of levels *)

(*{v1, v2, status, e}*)
updateValues={0.,0.,"ok",0.};

Table[

(* Flag to stop when e\[GreaterEqual]n *)
If[updateValues[[4]]<=n,updateValues[[3]]="ok", updateValues={0.,0.,updateValues[[3]],updateValues[[4]]}];

(* This will only give values that sum up to the magnitude of v 
Or if v0 = 0, list newv0 is created and fed to the function to try all it's contained values *)
nV=newValues[10,n,u,updateValues[[1;;4]],newv0,"ConstrainedNewMethod"];


tableNewValues=Table[

(* We initialize whith values calculated at nV and last calculated updateValues[[3;;4]]*)
tValues=Flatten[{v,updateValues[[3;;4]]}];


iterTable=Table[

tValues=PyrUpgrade1D[tValues,p0, pyrfunctions[[-f]],threshold*2^(-c+1),n,"ConstrainedNewMethod"]
,{j,1,i}]

,{v,nV}];

c=c-1;

goodValIter=pickNewValueIter[tableNewValues,"ConstrainedNewMethod"];
updateValues=Last[goodValIter];

goodValIter[[All,1;;3]]
,{f,1,Length[pyrfunctions]}]

)];



