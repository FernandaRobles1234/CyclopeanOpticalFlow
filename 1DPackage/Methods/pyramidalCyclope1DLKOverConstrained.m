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
(* Function to update values of v1 and v2 with Over Constrained standards *)
(* Any value that does not meets the constraints becomes 0 *)

(* Input\[Rule] {{initial values for v1, v2 and status}, pixel of interest, {functions f1, df1, f2, df2}, threshold for magnitude error}*)
(* Output\[Rule] {new values for v1, v2 and status} *)
PyrUpgrade1D[{v1_,v2_,status_},p0_, {{fline1_,dfline1_} ,{fline2_,dfline2_}}, threshold_]:=Block[{p1, p2, c,d1,d2,dv1,dv2},(

p1=p0-v1;
p2=p0+v2;

c = (fline1[p0]+fline2[p0])/2;
d1=dfline1[p1];
d2=dfline2[p2];

(* d1 and d2 have to be the same sign in every iteration *)
If[d1*d2 <0, Return[{0,0,"sign"}]];

(* magnitude needs to be bigger than threshold every iteration *)
If[(Abs[d1]<threshold||Abs[d2]<threshold ),Return[{0,0,"mag"}]];

(* Change of sign during iteration *)
If[(dfline1[p0]*d1<0||dfline2[p0]*d2<0),Return[{0,0,"flip"}]];


(* dv1,dv2 : step from last {v1,v2} to new {v1,v2} *)
{dv1,dv2}= {(fline1[p1]-c)/d1,(c-fline2[p2])/d2};

(* status: "OK" -> solution respects constraints,  errors: "sign", "mag", "flip" *)
(* status: "converged" -> we converged!! *)
{v1+dv1,v2+dv2,If[Norm[{dv1,dv2}]<0.001,"converged","ok"]}
)];

(* No other solution will be calculated when status records an error message in this pyramidal level*)
PyrUpgrade1D[{v1_,v2_,"sign"},p0_, {{fline1_,dfline1_} ,{fline2_,dfline2_}}, threshold_]:={0,0,"sign"};
PyrUpgrade1D[{v1_,v2_,"mag"},p0_, {{fline1_,dfline1_} ,{fline2_,dfline2_}}, threshold_]:={0,0,"mag"};
PyrUpgrade1D[{v1_,v2_,"flip"},p0_, {{fline1_,dfline1_} ,{fline2_,dfline2_}}, threshold_]:={0,0,"flip"};

PyrUpgrade1D::usage="
Function to update values of v1 and v2 with OverConstrained standards
Input\[Rule] [{v1,v2,status},p0,{{f1,df1},{f2,df2},threshold}
Output-> {v1,v2,status}
v1= Solution of f1
v2= Solution of f2
status= Status of the solution (ok, sign, mag, flip, converged)
p0= point of interest
{f1,df1}={function 1, derivative of function 1}
{f2,df2}={function 2, derivative of function 2}
threshold= threshold to respect magnitude constraint
";


(* ::Input::Initialization:: *)
(* Function to find solutions for all levels of pyramid {l1,l2,l3,l4,...} or {l1} *)
(* Input\[Rule] {number of iterations, pixel of interests, pyrfunctions,threshold *)
(* Output\[Rule] {v1, v2,status}*)
PyrFlow1D[i_, p0_, pyrfunctions_,threshold_]:=Block[{v1, v2,c,status},(
c=Length[pyrfunctions]-1; (* number of levels *)

status="ok";
{v1, v2}={0.,0.};

Do[
(* compute at this scale, using current motion estimate *)
{v1,v2,status}=Nest[PyrUpgrade1D[#,p0, pyrfunctions[[-f]],threshold*2^(-c)]&,{v1,v2,status},i];

c=c-1

,{f,1,Length[pyrfunctions]}];

{v1, v2,status}
)];

PyrFlow1D::usage="
Function to update values of v1 and v2 over all levels of a pyramidal function representation
with OverConstrained standards.
Input\[Rule] [i, p0, pyrfunctions, threshold]
Output-> {v1, v2, status}
i= number of iterations
p0= point of interest
pyrfunctions= list with the dimensions of {pyrlvl, number of image(1 or 2), kind of function(f or df)}
where pyrlvl is the pyramidal level
threshold= threshold to respect magnitude constraint
v1= Solution of f1
v2= Solution of f2
status= Status of the solution (ok, sign, mag, flip, converged)
";


(* ::Input::Initialization:: *)
(* Makes iterations and saves all the values *)
pixelIter[i_, p0_, pyrfunctions_,threshold_]:=Block[{v1, v2,c,status,iterTable},(

c=Length[pyrfunctions]-1; (* number of levels *)
status="ok";
{v1, v2}={0.,0.};

Table[
(* compute at this scale, using current motion estimate *)

iterTable=Table[
(*index of pyrfunction works only if fed the right range of pyrfunctions*)
{v1,v2,status}=PyrUpgrade1D[{v1,v2,status},p0, pyrfunctions[[-f]],threshold*2^(-c)]
,{j,1,i}];

c=c-1;
iterTable
,{f,1,Length[pyrfunctions]}]

)];

pixelIter::usage="
Makes iterations with OverConstrained standards and saves all the values
Input\[Rule] [i, p0, pyrfunctions, threshold]
Output-> list with the dimensions of: {lvls, i, {v1, v2, status}}
i= number of iterations
p0= point of interest
pyrfunctions= list with the dimensions of {pyrlvl, number of image(1 or 2), kind of function(f or df)}
where pyrlvl is the pyramidal level
threshold= threshold to respect magnitude constraint
v1= Solution of f1
v2= Solution of f2
status= Status of the solution (ok, sign, mag, flip, converged)
";


(* ::Input::Initialization:: *)
(* Makes plots only for one level *)
(* input:{currentlvl, each iteration v, pixel of interest, pixel range for plots, functions of current lvl}*)
oneLevelPixelIterGraphics[lvl_,iter_, p0_,prange_, {{flineia_,dflineia_},{flineib_,dflineib_}}]:=Block[{c,iterTable},(

(* c values *)
c=(flineia[p0]+flineib[p0])/2;

iterTable=Table[
Labeled[
Show[
(* Plot Graphic *)
Plot[{flineia[x],flineib[x]},{x,p0-prange,p0+prange},PlotLegends->{"ia","ib"}],

Graphics[{
PointSize[0.01],
(* c line *)
Line[{{p0,flineia[p0]},{p0,flineib[p0]}}],
If[iter[[i,3]]=="sign",Red,
If[iter[[i,3]]=="mag",Purple,
If[iter[[i,3]]=="flip",Orange,Black]]
],
(* c point *)
Point[{p0,c}],
{Arrowheads->Small,Arrow[{{p0-iter[[i,1]],c},{p0+iter[[i,2]],c}}]}
}],
ImageSize->Scaled[0.5]
],
(* Label *)
Style[Framed[GraphicsColumn[{
Row[{"Current dv= ", Total[{iter[[i,1;;2]]}]}],
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
pixelIterGraphics[i_, p0_,prange_, maxlvl_,pyrfunctions_,threshold_]:=Block[{iter},(
(* Makes iterations by saving all the values *)
iter=pixelIter[i,p0, pyrfunctions,threshold];

Flatten[Table[
(* Makes plots only for one level *)
oneLevelPixelIterGraphics[maxlvl-j+1,iter[[j]], p0,prange,  pyrfunctions[[-j ;;-j]][[1]]]
,{j,1,Length[iter]}]]
)]

pixelIterGraphics::usage="
Makes plots for the intermediate solutions of a pyramidal level
Input\[Rule] [i, p0, prange, maxlvl, pyrfunctions threshold]
Output-> list with the dimensions of: {lvls*i, Plot of flineia and flineib with solution v1 and v2}
";


(* ::Input::Initialization:: *)
lineTest[rangex_,pyrab_,threshold_]:=Block[{v1,v2,status},(
Table[
{v1,v2,status}=PyrFlow1D[10,x,pyrab,threshold]

,{x,rangex}]
)]

pixelIterGraphics::usage="
Input\[Rule] [rangex, pyrab, threshold]
Output-> {rangex, {v1,v2,status}}
";


(* ::Input::Initialization:: *)
seeAllLine[rangex_, {lvlmin_,lvlmax_},pyrab_,threshold_]:=Block[{tRun,lineia,dlineia,lineib,dlineib,cTable,c,g0},(

tRun=lineTest[rangex,pyrab[[lvlmin;;lvlmax]],threshold];

{lineia,dlineia}=pyrab[[lvlmin,1]];
{lineib,dlineib}=pyrab[[lvlmin,2]];

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
Plot[{lineia[x],lineib[x]},{x,rangex[[1]],rangex[[-1]]},PlotLegends->{"ia","ib"}],
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



