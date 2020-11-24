/* ------------------------------------------------------------------------- *
 * Problem Set 4, Question 1 - Data Preparation
 * Stats 506, Fall 2020
 *
 * This script prepares data for Q1 by creating the following .sas7bdat's:
 *    - recs2009 - needed variables from 2009 RECS data
 *    - recs2015 - needed variables from 2015 RECS data
 *    - wt09_long - BRR weights for 2009 data in a long format
 *    - wt15_long - BRR weights for 2015 data in a long format
 *
 * The weights are sorted by id and replicate. 
 *
 * Author: James Henderson
 * Updated: November 23, 2020
 * ------------------------------------------------------------------------- *
*/

/* 79: --------------------------------------------------------------------- */

/* sas library: ------------------------------------------------------------ */    
libname mylib './'; 

/* formats: ---------------------------------------------------------------- */
proc format lib=mylib.recs_formats;  
value region 
 1="Northeast" 
 2="Midwest"
 3="South"
 4="West";

value type09_tv
 1="Standard Tube"
 2="LCD"
 3="Plasma"
 4="Projection"
 5="LED"
 -2="Not Applicable";

value type15_tv
 1="LCD"
 2="Plasma"
 3="LED"
 4="Projection"
 5="Standard Tube"
 -2="Not Applicable";
run;

options fmtsearch = (mylib.recs_formats work); 
run;

/* data preparation: ------------------------------------------------------- */
%let recs_vars = DOEID NWEIGHT REGIONC TVCOLOR TVTYPE1; 
%let recs_names = DOEID=id NWEIGHT=w REGIONC=region TVCOLOR=tv_n 
                  TVTYPE1=tv_type;

/* recs 2009 */
data mylib.recs2009; 
  set mylib.recs2009_public_v4;
  keep &recs_vars.;
  rename &recs_names.;
  format REGIONC region.; 
  format TVTYPE1 type09_tv.;
run; 

/* map 2009 types to 2015 types */
data mylib.recs2009; 
 set mylib.recs2009;
 tv_type15=-2;
 if tv_type=1 then tv_type15=5;
 if tv_type=2 then tv_type15=1;
 if tv_type=3 then tv_type15=2;
 if tv_type=4 then tv_type15=4;
 if tv_type=5 then tv_type15=3;
 drop tv_type;
 rename tv_type15=tv_type;
 format tv_type15 type15_tv.; 
run;

/* recs 2015 */
data mylib.recs2015; 
 set mylib.recs2015_public_v4;
 keep &recs_vars.;
 rename &recs_names.;
 format REGIONC region.; 
 format TVTYPE1 type15_tv.; 
run;


/* transform replicate weights to a long format: --------------------------- */

/* 2009 */
proc transpose 
  data=mylib.recs2009_public_repweights
  out=mylib.w09_long
  prefix=brr_weight_;
 by DOEID;
 var brr_weight_1-brr_weight_244; 
run;  

data mylib.w09_long;
 set mylib.w09_long;
 rename DOEID=id _NAME_=repl brr_weight_1=w;

proc sort data=mylib.w09_long out=mylib.w09_long;    
 by id repl; 

/* 2015 */
proc transpose
  data=mylib.recs2015_public_v4
  out=mylib.w15_long
  prefix=brrwt;
 by DOEID;
 var brrwt1-brrwt96;
run;

data mylib.w15_long;
 set mylib.w15_long;
 rename DOEID=id _NAME_=repl brrwt1=w; 

proc sort data=mylib.w15_long out=mylib.w15_long;
 by id repl; 

/* 79: --------------------------------------------------------------------- */
