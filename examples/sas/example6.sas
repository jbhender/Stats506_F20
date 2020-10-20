/* ------------------------------------------------------------------------- *
 * An example SAS program for Stats 506.
 *
 * This file uses RECS data from:
 *   recs2009_public_v4.sas7bdat
 * 
 *   http://www.eia.gov/consumption/residential/data/2009/index.cfm
 *    ?view=microdata
 *
 * Then demonstrates sevaral procs for descriptive statistics:
 *  proc means, proc summary, proc freq
 *
 * Not shown here but similar: proc univariate
 *
 * Author: James Henderson
 * Updated: Oct 20, 2020
 * ------------------------------------------------------------------------- *
*/
/* 79: --------------------------------------------------------------------- */

/* library: ---------------------------------------------------------------- */
libname mylib '~/github/Stats506_F20/examples/sas/data';

/* data prep: -------------------------------------------------------------- */
data recs;
 set mylib.recs2009_public_v4;

/* proc means: ------------------------------------------------------------- */
proc means data=recs;
 var cdd65; 
 class regionc;

/* proc sort for use with 'by' in proc means */
proc sort data=recs;
 by regionc;

proc means data=recs;
 var cdd65;
 by regionc;

/* twice stratified using "by" */
proc sort data=recs;
 by regionc ur;

proc means;
 var cdd65;
 by regionc ur;

proc means;
 var cdd65 hdd65;
 by regionc ur; 

proc means;
 var cdd65 hdd65;
 class ur;
 by regionc; 
run;

/* proc freq: -------------------------------------------------------------- */

proc freq data=recs;
  tables occupyyrange / out=occupyrange_freq;  

proc print data=occupyrange_freq; 
run;

/* proc summary: ----------------------------------------------------------- */
proc summary data=recs;
 class regionc;
 output out=meanstats
   mean(kwh) = mean_kwh
   std(kwh) = std_kwh;
run;

proc print data=meanstats;
run;

/* 79: --------------------------------------------------------------------- */