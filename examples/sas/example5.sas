/* ------------------------------------------------------------------------- *
 * An example SAS program for Stats 506.
 *
 * This file uses RECS data from:
 *   recs2009_public_v4.sas7bdat
 * 
 *   http://www.eia.gov/consumption/residential/data/2009/index.cfm
 *     ?view=microdata
 *
 * Then demonstrates proc tabulate for descriptive statistics.
 * 
 * Author: James Henderson
 * Updated: Oct 19, 2020
 * ------------------------------------------------------------------------- *
*/
/* 79: --------------------------------------------------------------------- */

/* data library for reading/writing data: ---------------------------------- */
libname mylib '~/github/Stats506_F20/examples/sas/data/';

/* create a short name and working copy for recs data: --------------------- */
data recs;
 set mylib.recs2009_public_v4;

/* data step to create urban indicator: ------------------------------------ */
data recs;
 set recs;
 urban=1;
 if ur='R' then urban=0;

/* Tabulate: --------------------------------------------------------------- */

/* get max, min, and Nobs for regionC */
proc tabulate data=recs;
 var regionc;
 table regionc*N regionc*max regionc*min;

/* var vs class */
proc tabulate data=recs;
 var urban;
 class ur;
 table urban*sum ur*N urban*N;

/* grouped tables */
proc tabulate data=recs;
 var cdd65; 
 class regionc;
 table regionc, cdd65*N cdd65*mean; 

proc tabulate data=recs;
 var cdd65;
 class regionc;
 table cdd65*N*regionc cdd65*mean*regionc;

/* twice stratified tables */
proc tabulate data=recs;
 var cdd65;
 class regionc ur;
 table regionc, cdd65*mean*ur;
run;

