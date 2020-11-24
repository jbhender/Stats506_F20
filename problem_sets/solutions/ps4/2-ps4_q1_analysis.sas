/* ------------------------------------------------------------------------- *
 * Problem Set 4, Question 1
 * Stats 506, Fall 2020
 *
 * This is the solution to Q1. Data manipulations are collected into a 
 * macro to limit repetition. 
 *
 * See the link below for the source of testing the case when `catvar` is
 * an empty string (`%str()`):
 * > https://support.sas.com/resources/papers/proceedings09/022-2009.pdf
 * 
 * Author: James Henderson
 * Updated: November 23, 2020
 * ------------------------------------------------------------------------- *
*/

/* 79: --------------------------------------------------------------------- */

/* sas library: ------------------------------------------------------------ */    
libname mylib './'; 
options fmtsearch=(mylib.recs_formats work); 

/* macros: ----------------------------------------------------------------- */
/* normal quantile for 95% confidence level */
%let z = quantile('NORMAL', .975);      

/* estimate the mean of a continuous variable in recs, 
 *  see recs_sum macro below for argument documentation 
 */
%macro est_mean(est_dat, est_var, est_grp, est_w, est_out=pe, out_var=pe); 
 
 proc summary data=&est_dat.;
  by &est_grp.;
  var &est_var.;
  output out = &est_out.
    mean(&est_var.) = &out_var.;
  weight &est_w.;
 run;

%mend est_mean; 

/* estimate the proportion of a categorigcal variable in RECS,
 * see res_sum macro below for argument documentation
 */
%macro est_prop(dat, var, catvar, grp, w, est_out=pe, out_var=pe);

 /* totals for each level of catvar */
 proc summary data=&dat.;
  by &grp. &catvar.;
  var &var.;
  output out = n_catvar
    sum(&var.) = n;
  weight &w.;
 run;

 /* totals for each group */
 proc summary data=&dat.;
  by &grp.;
  var &var.;
  output out = n_total
    sum(&var.) = total;
  weight &w.;
 run;

 /* merge and output proportion estimates */
 data &est_out.; 
  merge n_catvar n_total; 
  by &grp.;
  &out_var. = n / total; 
  drop n total; 
 run;

 /* clean up temporary datasets */
 proc datasets gennum=all;
  delete n_total;
  delete n_catvar; 
 run;
  
%mend est_prop;

/* aggregate RECS data by group and use BRR weights to compute CIs */
%macro recs_sum(out, dat, wt_long, lib, id, var, grp, catvar = %str(),
                post = %str(), dat_w = w, wt_w = w, wt_repl = repl, 
                fay = 0.05, level = 0.95);

 /* out - a name for the summary data set being created
  * dat - the primary dataset
  * wt_long - data set of weights
  * lib - library where dat and wt_long (below) can be found
  * id - variable(s) to merge data and wt_long on
  * var - variable (singular only) in dat to summarize
  * catvar - use with var identically 1 for propotions in a long format
  * grp - any grouping variables to use (required) 
  * post - optional postscript to use when naming variables in out
  * dat_w - the name of the weighting variable in dat
  * wt_w - the name of the variable with eh (replicate) weights in wt_long
  * wt_repl - the name of the variable in wt_long identifying the replicates.
  * fay - the Fay coefficient for use in calculating standard errors
  * level - confidence level used for computing confidence intervals.
  */

 %let z = quantile('NORMAL', 1 - (1 - &level.) / 2); 

 /* point estimates */
 proc sort data=&lib..&dat. out=work.dat; 
  by &grp. &catvar.;
 run;

 data work.dat;
  set work.dat;
  all=1; 

 %if %sysevalf(%superq(catvar)=, boolean)
   %then %est_mean(work.dat, &var., &grp., &dat_w.);
   %else %est_prop(work.dat, all, &catvar., &grp., &dat_w.);

 /* replicate estimates */
 proc sort data=work.dat out=work.dat;
  by &id.;
 run;

 data work.dat_long; 
  merge work.dat(in=in_dat) &lib..&wt_long.;
   by &id.;
   if in_dat; 
  all=1; 
 run;

 proc sort data=work.dat_long out=work.dat_long;
  by &grp. &wt_repl. &catvar.; 
 run;

 %if %sysevalf(%superq(catvar)=, boolean)
   %then %est_mean(work.dat_long, &var., &grp. &wt_repl., &wt_w., 
   	 	   est_out=re, out_var=re);
   %else %est_prop(work.dat_long, all, &catvar., &grp. &wt_repl., 
   	           &wt_w., est_out=re, out_var=re);


 /* standard errors and confidence bounds */ 
 proc sort data=work.re out=work.re;
  by &grp. &catvar.;

 data re; 
  merge pe(keep=&grp. &catvar. pe) re(keep=&grp. &catvar. re);
  by &grp. &catvar.;
  d_sq = (re - pe)**2;
 run;

 proc summary data=re;
  by &grp. &catvar.;
  output out=mse
    mean(d_sq)=mse;
  run;

 data &out.;
  merge pe mse;
   by &grp.;
  se&post. = sqrt(mse) / (1 - &fay.);
  lwr&post. = pe - &z. * se&post.;
  upr&post. = pe + &z. * se&post.;
  rename pe=est&post.; 
  drop mse _TYPE_ _FREQ_;
 run; 

 /* clean up */
 proc datasets gennum=all; 
  delete pe;
  delete re;
  delete dat;
  delete dat_long; 
 run; 

%mend recs_sum;

%macro csvexport(dataset, lib=work);
 proc export
   data = &lib..&dataset
   outfile = "./&dataset..csv"
   dbms = dlm
   replace;
  delimiter=",";
%mend csvexport;

/* (a) number of tvs: ------------------------------------------------------ */

/* 2009 */
%recs_sum(
 out=n_tv09, 
 dat=recs2009, 
 wt_long=w09_long,
 lib=mylib,
 id=id,
 var=tv_n,
 grp=region,
 post=09
)

/* 2015 */
%recs_sum(
 out=n_tv15,
 dat=recs2015,
 wt_long=w15_long,
 lib=mylib,
 id=id,
 var=tv_n,
 grp=region,
 post=15
)

/* differences */
data n_tv;
 merge n_tv09 n_tv15; 
 by region;
 diff = est15 - est09; 
 se_diff = sqrt(se15**2 + se09**2);
 lwr_diff = diff - &z. * se_diff;
 upr_diff = diff + &z. * se_diff;

%csvexport(n_tv);
run;

/* (b) tv type: ------------------------------------------------------------ */

%recs_sum(
 out=type_tv09,
 dat=recs2009,
 wt_long=w09_long,
 lib=mylib,
 id=id,
 grp=region,
 catvar=tv_type,
 post=09
); 

%recs_sum(
 out=type_tv15,
 dat=recs2015,
 wt_long=w15_long,
 lib=mylib,
 id=id,
 grp=region,
 catvar=tv_type,
 post=15
);

/* differences */
data type_tv;
 merge type_tv09 type_tv15;
 by region tv_type;
 diff = est15 - est09;
 se_diff = sqrt(se15**2 + se09**2);
 lwr_diff = diff - &z. * se_diff;
 upr_diff = diff + &z. * se_diff;

%csvexport(type_tv);
run;

/* 79: --------------------------------------------------------------------- */
