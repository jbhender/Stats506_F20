/* ------------------------------------------------------------------------- *
 * An example of "data step programming".
 * Stats 506, Fall 2020
 *
 * This analysis finds the % of single-family homes 
 *  more than 1 sd above average in terms of electrical
 *  usage by cesnsus region.
 *
 * This script illusrates the following data step programming concepts:
 *   - merging tables using a data step
 *   - the 're-merging' technique in which we compute summary statistics,
 *      then 're-merge' these into the original table, much like a 
 *      (dplyr) group_by / mutate in R.   
 *   
 *
 * Author: James Henderson
 * Upated: Oct 19, 2020
 * ------------------------------------------------------------------------- *
 */
/* 79: --------------------------------------------------------------------- */

/* data library: ----------------------------------------------------------- */
libname mydata './data/';
run;

/* read full data and subset to single family homes: ----------------------- */
data recs;
 set mydata.recs2009_public_v4;
 if typehuq = 2;
 keep doeid nweight regionc kwh;
run;

/* Sort and then compute summary statistics: ------------------------------ */
proc sort data=recs;
 by regionc;
run;

proc summary;
 by regionc;
 output out=meanstats
  mean(kwh) = mean_kwh
   std(kwh) = std_kwh
   sum(nweight) = tot_weight;

proc sort data=meanstats;
    by regionc;
run;

/* "Remerge" summary stats into sorted recs data: -------------------------- */
data recs;
    merge recs meanstats(keep=regionc mean_kwh std_kwh tot_weight);
    by regionc;

/* Reweight and Filter to those homes at least 1 sd above mean kwh: --------- */
data recs;
    set recs;
    high_kwh = mean_kwh + std_kwh;
    if kwh ge high_kwh;
    w = nweight / tot_weight;
run;

/* Propotion of homes above the threshold: ---------------------------------- */
proc summary;  
    by regionc;
    output out=high_kwh
      sum(w) = p_high_kwh;

proc sort data=high_kwh;
  by regionc;
run;

/* Merge information from meanstats: ---------------------------------------- */
data tab1; 
  merge meanstats(keep=regionc mean_kwh std_kwh) 
        high_kwh(keep=regionc p_high_kwh);
  by regionc; 
  p_high_kwh = 100 * p_high_kwh;
  label REGIONC="Census Region";
  label mean_kwh="Avg Electricity Usage (kwh), 2009";
  label std_kwh="Std Deviation Electricity Usage (kwh), 2009";
  label p_high_kwh="% of homes >1 sd above mean";
run; 

proc sort data=tab1; 
 by p_high_kwh;

proc format;
 value regionc
  1="Northeast"
  2="Midwest"
  3="South"
  4="West"; 

/* Print to see result: ----------------------------------------------------- */
title "Percent of homes in each Census Region with electricity usage more than 
1 standard deviation above the mean."; 

proc print data=tab1 noobs label; 
 format regionc regionc. 
        mean_kwh 6.0
        std_kwh 5.0
        p_high_kwh 4.1;

run;

/* 79: --------------------------------------------------------------------- */