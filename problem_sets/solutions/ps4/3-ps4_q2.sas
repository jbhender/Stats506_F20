/* ------------------------------------------------------------------------- *
 * Problem Set 4, Question 2 
 * Stats 506, Fall 2020
 *
 * In this script, we Examine the relationship between age and presence of 
 * a permanent upper right first molar using 4 NHANES cohorts from 
 * 2011-2018. 
 *  
 * Author: James Henderson
 * Updated: November 23, 2020
 * ------------------------------------------------------------------------- *
*/

/* 79: --------------------------------------------------------------------- */

/* sas library: ------------------------------------------------------------ */    
libname mylib './'; 

/* data preparation: ------------------------------------------------------- */

/* cleaned demographics from PS3 */
proc import out=mylib.demo datafile = "./demo_ps3.dta" replace;

proc sort data=mylib.demo out=mylib.demo;
 by id;
run;

/* survey design and weights */
proc import
 datafile="./nhanes_demo.csv"
 out=mylib.weights
 replace;
run;

data mylib.weights; 
 set mylib.weights;
 keep SEQN SDMVPSU SDMVSTRA WTMEC2YR;
 rename SEQN=id SDMVPSU=psu SDMVSTRA=strata WTMEC2YR=w;
run;

proc sort data=mylib.weights out=mylib.weights;
 by id;

/* merge weights to demo */
data mylib.demo; 
 merge mylib.demo mylib.weights;
 by id;
 w = w / 4; 
run;

proc contents data=mylib.demo;
run;

/* cleaned dentition data from ps3 */
proc import out=mylib.ohxden datafile = "./ohxden_ps3.dta" replace;

proc sort data=mylib.ohxden out=mylib.ohxden;
 by id;
run;

data mylib.ps4_q2;
 merge mylib.demo mylib.ohxden;
 by id;
run;

/* drop missing cases, flag tooth */
data mylib.ps4_q2a;
 set mylib.ps4_q2;
 where ohx=1; 
 y=0;
 if ohx03tc=2 then y=1;
 if college=. then college=0;
run;

/* center and scale age: -------------------------------------------------- */

/* compute mean */ 
proc means data=mylib.ps4_q2a;
 var age;
 output out = mean_age 
   mean = avg_age;
run;

/* create a macro with mean */ 
data mean_age; 
 set mean_age;
 call symput('avg_age', avg_age); /* For exact centering. */
run;

/* center, scale to decades */ 
data mylib.ps4_q2a;
  set mylib.ps4_q2a;
  /*age_c = (age - &avg_age.) / 10;*/ /* If you want exact centering. */
  age_c = (age - 33) / 10; 
run;

/* logistic regression models: -------------------------------------------- */

/* macro for concision:
 *  arguments: 
 *    age_eff - specification of an age transform in the "effect" statement
 *      ivars - independent variables in the model statement
 *      class - the class statement
 *        out - name of sas dataset to create with OR and CI's
 *        dat - the name of the data to compute with
 */
%macro logit(age_eff, ivars, class, out, dat = mylib.ps4_q2a);
 proc logistic data=&dat.;
  class &class. / param=reference; 
  effect sm_age = &age_eff.; 
  model y(event='1') = sm_age &ivars. / clodds=WALD;
  store &out.; 
  ods output 
   CLOddsWald=&out._or 
   ParameterEstimates=&out._par
   FitStatistics=&out._ic;
 run;
%mend logit;

/* quadratic age and gender to establish a baseline */
%logit(poly(age_c / degree=2), gender, gender, mod1); 

proc print data = mod1_or;
run; 

/* splines */ 
%let sm_age = spline(age_c / basis=bspline knotmethod=equal(13) degree=3);
%logit(&sm_age., gender, gender, mod2); 

/* other demographics */
%logit(&sm_age., gender race college, gender race(ref="3"), mod3);

proc print data = mod3_or;
run;

/* survey models: ---------------------------------------------------------- */

proc surveylogistic data=mylib.ps4_q2a;
  strata strata;
  cluster psu;
  weight w; 
  class gender race(ref="3") / param=reference;
  effect sm_age = &sm_age.;
  model y(event='1') = sm_age gender race college;
  store mod4; 
  ods output 
    OddsRatios=mod4_or 
    ParameterEstimates=mod4_par
    FitStatistics=mod4_ic;
run;

proc print data=mod4_or; 
run;

/* select and merge key results: ------------------------------------------- */
data pars;
 set mod3_par; 
 keep Variable ClassVal0 Estimate StdErr;
 rename Estimate=mod3_est StdErr=mod3_se;
run;

proc sort data=pars out=pars;
 by Variable ClassVal0;

proc sort data=mod4_par out=mod4_par;
 by Variable ClassVal0;

data pars;
 merge pars mod4_par(keep = Variable ClassVal0 Estimate StdErr); 
 by Variable ClassVal0; 
 rename Estimate=mod4_est StdErr=mod4_se;
run; 

/* predictions at specified ages: ------------------------------------------ */
data key_age; 
 input age_c gender race college;
 datalines;
-3 2 1 0
-2.9 2 1 0
-2.8 2 1 0
-2.7 2 1 0
-2.6 2 1 0
-2.5 2 1 0
-2 2 1 0
-1 2 1 0
 0 2 1 0
 1 2 1 0
 2 2 1 0
 3 2 1 0
 4 2 1 0
; 

proc plm restore=mod3; 
 score data=key_age 
       out=yhat_mod3
       predicted lclm uclm / ilink;
run; 

proc plm restore=mod4;
 score data=key_age
       out=yhat_mod4
       predicted lclm uclm / ilink;
run;

data yhat_mod3; 
 set yhat_mod3;
run;

data yhat_mod4;
 set yhat_mod4;
run;

data pars;
 set pars;
run;

/* export results: --------------------------------------------------------- */
%macro csvexport(dataset, lib=work);
 proc export
   data = &lib..&dataset
   outfile = "./&dataset..csv"
   dbms = dlm
   replace;
  delimiter=",";
 run;
%mend csvexport;

%csvexport(mod1_ic); 
%csvexport(mod2_ic);
%csvexport(mod3_par);
%csvexport(mod3_ic);
%csvexport(mod4_par);
%csvexport(mod4_ic); 
%csvexport(pars); 
%csvexport(yhat_mod3);  
%csvexport(yhat_mod4);

/* 79: --------------------------------------------------------------------- */
