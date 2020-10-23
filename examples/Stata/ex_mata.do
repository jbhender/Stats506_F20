/* ---------------------------------------------------------------------------*
 * Stata "mata" example
 *
 * Using the citytemp2 data, we will compute the proportion of each 
 * age category by census region and then format data for export using
 * mata.
 *
 * Author: James Henderson
 * Updated: October 22, 2020
 * ---------------------------------------------------------------------------*
 */
/* 79: --------------------------------------------------------------------- */
 
/* data: ------------------------------------------------------------------- */
webuse citytemp2, clear

/* compute proprotions: ---------------------------------------------------- */
proportion agecat, over(region) citype(normal)
ereturn list

// note matrices available with results
matrix list e(b)
matrix list e(freq)
matrix list e(_N)
matrix list e(V)

/* format for export using mata: -------------------------------------------- */
mata:
 /* construct an output matrix from the ereturn matrices */

 /* import matrices from stata to mata */
 n = st_matrix("e(freq)")
 N = st_matrix("e(_N)")
 p = st_matrix("e(b)")
 V = st_matrix("e(V)")

 /* manipulate in mata */
 s = sqrt(diagonal(V))
 R = (n', N', p', s) 

 /* export matrix R back to stata as "R" */
 st_matrix("R", R)
 
 /* work with the "stripe" e.g. row / colum names */
 nms = st_matrixcolstripe("e(b)", 1)
 Rcols = J(4, 2, "")
 Rcols[,2] = ("n", "N", "p", "se")'
 st_matrixcolstripe("R", Rcols)
 st_matrixrowstripe("R", nms)
 
 r = st_matrix("r(table)")
 r = r'
 st_matrix("r", r)
 st_matrixcolstripe("r", st_matrixrowstripe("r(table)"))
 st_matrixrowstripe("r", st_matrixcolstripe("r(table)"))
end

/* see R in Stata */
matrix list R
