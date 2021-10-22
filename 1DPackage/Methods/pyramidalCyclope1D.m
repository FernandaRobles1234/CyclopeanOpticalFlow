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
(* Function to plot flow solution *)
(* Input\[Rule] {pixel of interest, range of plot from p, {initial value for v1, initial value for v2}, {functions a, da, b, db}}*)
(* Output\[Rule] Plot with graphics solutions *)
seePlot[p_,q_,{v1_,v2_},{{a_,da_},{b_,db_}}]:=Block[{c},(
c=(a[p]+b[p])/2;
Show[
Plot[{a[x],b[x]},{x,p-q,p+q}],
Graphics[{
Point[{{p,c},{p,a[p]},{p,b[p]}}],
Point[{{p-v1,c},{p+v2,c}}],
Line[{{p,a[p]},{p,b[p]}}],
Line[{{p-v1,c},{p+v2,c}}]
}]
]
)];

seePlot::usage="
Function to plot flow solution
Input\[Rule] {p, q, {v1, v2}, {{a,da},{b,db}}}
Output-> a and b plot with v1 and v2 solutions
p= Pixel of interest
q= Range to plot from pixel of interest
v1= Solution for a
v2= Solution for b
{a, da}= {function of a, derivative of function of a}
{b, db}= {function of b, derivative of function of b}
";


(* ::Input::Initialization:: *)
(* status: "OK" -> solution respects constraints,  errors: "sign", "mag", "flip" *)
(* status: "converged" -> we converged!! *)

PyrUpgrade1D::usage="
Function to update values of v1 and v2.
Input\[Rule] [{v1,v2,status,___},p0,{{f1,df1},{f2,df2},threshold,mode}
Output-> {v1,v2,status,___}
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

PyrFlow1D::usage="
Function to update values of v1 and v2 over all levels of a function's pyramidal representation.
Input\[Rule] [i, p0, pyrfunctions, threshold]
Output-> {v1, v2, status, ___}
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
lineTest[rangex_,pyrab_,threshold_,mode_]:=Block[{v1,v2,status},(
Table[
{v1,v2,status}=PyrFlow1D[10,x,pyrab,threshold,mode]
,{x,rangex}]
)]



(* ::Input::Initialization:: *)
seeAllLine[rangex_,pyrab_,threshold_,mode_]:=Block[{tRun,lineia,dlineia,lineib,dlineib,cTable,c,g0,i},(

tRun=lineTest[rangex,pyrab,threshold,mode];

{lineia,dlineia}=pyrab[[1,1]];
{lineib,dlineib}=pyrab[[1,2]];

i=1;
cTable=Table[
c=(lineia[p]+lineib[p])/2;
g0=Graphics[{
PointSize[0.01],
Line[{{p,lineia[p]},{p,lineib[p]}}],
If[tRun[[i,3]]=="sign",Red,
If[tRun[[i,3]]=="mag",Purple,
If[tRun[[i,3]]=="flip",Orange,Black]]
],
Point[{p,c}],
{Arrowheads->Small,Arrow[{{p-tRun[[i,1]],c},{p+tRun[[i,2]],c}}]}
}];
i=i+1;
g0
,{p,rangex}];

Show[
Plot[{lineia[x],lineib[x]},{x,rangex[[1]],rangex[[-1]]},PlotLegends->{"ia","ib"},PlotLabel->mode],
cTable,
(*,
PlotLabel\[Rule]info,*)
ImageSize->Scaled[0.5]
]
)]

seeAllLine::usage="
Input\[Rule] [rangex, {lvlmin,lvlmax}, pyrab, threshold]
Output-> Plot with solutions in rangex
";


(* ::Input::Initialization:: *)
(* Makes iterations by saving all the values *)

(* If you call without v0 (the initial motion), then it will be {0,0} *)
PyrFlow1DIter[i_, p0_, pyrfunctions_,threshold_,mode_]:=PyrFlow1DIter[i, p0,{0.,0.}, pyrfunctions,threshold,mode];

PyrFlow1DIter::usage="
Makes iterations with OverConstrained standards and saves all the values
Input\[Rule] [i, p0, pyrfunctions, threshold]
Output-> list with the dimensions of: {lvls, i, {v1, v2, status,e}}
i= number of iterations
p0= point of interest
pyrfunctions= list with the dimensions of {pyrlvl, number of image(1 or 2), kind of function(f or df)}
where pyrlvl is the pyramidal level
threshold= threshold to respect magnitude constraint
v1= Solution of f1
v2= Solution of f2
status= Status of the solution (ok, sign, mag, flip, converged)
e= Counts the amount of times constraints were not met
";


(* ::Input::Initialization:: *)
(* Makes plots only for one level *)
(* input:{currentlvl, each iteration v, pixel of interest, pixel range for plots, functions of current lvl}*)
oneLevelPixelIterGraphics[lvl_,iter_, p0_,prange_, {{flineia_,dflineia_},{flineib_,dflineib_}},info_]:=Block[{c,iterTable},(

(* c values *)
c=(flineia[p0]+flineib[p0])/2;

iterTable=Table[
Labeled[
Show[
(* Plot Graphic *)
Plot[{flineia[x],flineib[x]},{x,p0-prange,p0+prange},PlotLegends->{"ia","ib"},PlotLabel->info],

Graphics[{
PointSize[0.01],
(* c line *)
Line[{{p0,flineia[p0]},{p0,flineib[p0]}}],
(*If[iter[[i,4]]\[Equal]2,Blue,*)
If[iter[[i,3]]=="sign",Red,
If[iter[[i,3]]=="mag",Purple,
If[iter[[i,3]]=="flip",Orange,Black](*]*)
]],
(* c point *)
Point[{p0,c}],
{Arrowheads->Small,Arrow[{{p0-iter[[i,1]],c},{p0+iter[[i,2]],c}}]}
}],
ImageSize->Scaled[0.5]
],
(* Label *)
Style[Framed[GraphicsColumn[{
Row[{"Initial df= ", {NumberForm[dflineia[p0],3],NumberForm[dflineib[p0],3]}}],
Row[{"Current dv= ", {iter[[i,1]],iter[[i,2]]}}],
Row[{"Current iteration= ",i}],Row[{"Current level= ",lvl}]}]]]]
,{i,1,Length[iter]}]

)]

oneLevelPixelIterGraphics::usage="
Makes plots for the intermediate solutions of a pyramidal level
Input\[Rule] [lvl, iter, p0, prange, {{flineia, dflineia},{flineib, dflineib}}]
Output-> list with the dimensions of: {i, Plot of flineia and flineib with solution v1 and v2}
lvl= current pyramidal level
iter= solutions with the form {lvls, i, {v1, v2, status}
p0= pixel of interest
prange= range for plot from p0
{{flineia, dflineia},{flineib, dflineib}}= Current level functions 
";


(* ::Input::Initialization:: *)
(* Makes graphics for all levels*)
(* iterations, pixel of interest, plot range from pixel, max lvl,lvl's functions, threshold}*)
pixelIterGraphics[i_, p0_,v0_,prange_, lvlmax_,pyrfunctions_,threshold_,mode_]:=Block[{},(
(* Makes iterations by saving all the values *)
iter=PyrFlow1DIter[i,p0,v0, pyrfunctions,threshold,mode];

Flatten[Table[
(* Makes plots only for one level *)
oneLevelPixelIterGraphics[lvlmax-j+1,iter[[j]], p0,prange,  pyrfunctions[[-j ;;-j]][[1]],mode]

,{j,1,Length[iter]}]]
)];

pixelIterGraphics[i_, p0_,prange_, lvlmax_,pyrfunctions_,threshold_,mode_]:=pixelIterGraphics[i, p0,{0.,0.},prange, lvlmax,pyrfunctions,threshold,mode];

pixelIterGraphics::usage="
Makes plots for the intermediate solutions of a pyramidal level
Input\[Rule] [i, p0, prange, maxlvl, pyrfunctions threshold,mode]
Output-> list with the dimensions of: {lvls*i, Plot of flineia and flineib with solution v1 and v2}
";



