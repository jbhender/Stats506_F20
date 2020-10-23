/* ---------------------------------------------------------------------------*
 * Stata frames example 
 *
 * Using the citytemp2 data, we will compute the proportion of each 
 * age category by census region.
 *
 * In the process, we will make use of `frames` to work with multiple in
 * memory data sets. This script also reviews `collapse` and the concept
 * of "re-merging" discussed in the SAS module. 
 *
 * Author: James Henderson
 * Updated: October 22, 2020
 * ---------------------------------------------------------------------------*
 */
/* 79: --------------------------------------------------------------------- */
 
/* data: ------------------------------------------------------------------- */
webuse citytemp2, clear

/* count the number of oberservations within each region: ------------------ */
generate all=1
frame copy default region, replace
frame region: collapse (sum) rtot=all, by(region)

/* create counts for individual cells: ------------------------------------- */
frame copy default tab1
frame change tab1
collapse (sum) N=all, by(region agecat)

// "merge" frames using link
frlink m:1 region, frame(region) generate(region_link)
frget rtot=rtot, from(region_link)
generate p = N / rtot

// verify 
frame copy tab1 check
frame change check
collapse (sum) p, by(region)
list

frame change default
frame drop check


