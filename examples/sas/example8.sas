/* ------------------------------------------------------------------------- *
 * Professor Shedden's Example of using PROC SQL.
 * Stats 506, F20
 * 
 * This script finds all single family homes with 
 * "heating degree days" above 2000.
 *
 * Author: James Henderson
 * Updated: Oct 18, 2020
 * ------------------------------------------------------------------------- *
 */
/* 79: --------------------------------------------------------------------- */

/* sas library: ------------------------------------------------------------ */
libname mydata './data';

/* create the desired table with proc sql: --------------------------------- */
proc sql;

    create table recs as
        select doeid, reportable_domain, hdd65, 
               mean(hdd65) as mean_hdd65, cufeetng
        from mydata.recs2009_public_v4
        where typehuq = 2
        group by reportable_domain
        having hdd65 ge 2000
        order by reportable_domain, hdd65;

quit;

/* tables created in proc sql are regular sas tables/datasets: ------------- */
proc print data=recs;

run;

/* (SQL) Question: How would you modify this script to 
 * return only a single row per reportable_domain ?
 */

/* 79: --------------------------------------------------------------------- */
