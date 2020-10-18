/* ------------------------------------------------------------------------- *
 * SAS Example for Stats 506, Fall 2020
 *  
 * Compute the percent of wood shingled roofs by state 
 *  using PROC SQL and the 2009 RECS data.
 *
 * Author: James Henderson 
 * Updated: Oct 18, 2020
 * ------------------------------------------------------------------------- *
 */ 
/* 79: --------------------------------------------------------------------- */

/* data library: ----------------------------------------------------------- */ 
libname mylib '~/github/Stats506_F20/examples/sas/data/';

/* tell sas where to find formats: ----------------------------------------- */ 
/* see example 7 for creaton of this library */
options fmtsearch=( mylib.recs_formats work ); 
run;

/* use proc sql to find % of wood shingle roofs by "State": ---------------- */
proc sql;

  /* Count total homes by state */
  create table total as
    select sum(nweight) as n_total, reportable_domain
      from mylib.recs2009_public_v4
      where rooftype > 0
      group by reportable_domain;

  /* Count wood shingle roofs by state */
  create table wood_roof as
    select sum(nweight) as n_wood, reportable_domain
      from mylib.recs2009_public_v4
      where rooftype=2
      group by reportable_domain;

  /* Join these two tables */
  create table wood_roof_pct as
    select t.reportable_domain as state, n_wood, n_total, 
    	   100*n_wood/n_total as percent_wood
      from total t
      inner join wood_roof w
      on t.reportable_domain=w.reportable_domain
    order by -percent_wood;

  quit;
run;

/* print the result: ------------------------------------------------------- */
proc print data=wood_roof_pct noobs;
  var state percent_wood;
  format percent_wood 4.1
         state state.;
run;

/* export to csv: ---------------------------------------------------------- */
proc export data=wood_roof_pct
  outfile = 'wood_roof_pct.csv'
  dbms=dlm replace; 
  delimiter  = ",";
run; 

/* 79: --------------------------------------------------------------------- */
