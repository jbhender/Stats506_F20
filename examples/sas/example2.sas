/* ------------------------------------------------------------------------- *
 * An example SAS program for Stats 506
 *
 * This file imports RECS data from:
 *  ./data/recs2009_public.csv
 * http://www.eia.gov/consumption/residential/data/2009/index.cfm?view=microdata
 *  Then writes a sas7bat  native format to a data library.
 *
 * Author: James Henderson
 * Updated: Oct 17, 2020
 * ------------------------------------------------------------------------- *
*/
/* 79: --------------------------------------------------------------------- */

/* data library for reading/writing data: ---------------------------------- */
libname mylib '~/github/Stats506_F20/examples/sas/data';

/* import delimited data: -------------------------------------------------- */
proc import 
  datafile='./data/recs2009_public.csv'
  out=work.recs;

/* use a data step and a set statement to save: ---------------------------- */
data mylib.recs2009;
 set recs;

/* Question: How could we have saved directly to mylib? */

/* view the contents of this file: ----------------------------------------- */
proc contents data=mylib.recs2009;
run;

/* 79: --------------------------------------------------------------------- */