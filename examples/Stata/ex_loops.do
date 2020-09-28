*-----------------------------------------------------------------------------*
* Loop examples in Stata
* Stats 506, F20
*
* 1. Loop store the iterator as a macro
* 2. Looping over a numlist using "of"
* 3. Looping over a varlist using "of varlist"
* 4. Looping over a general list with "in"
* 5. Looping over a local using "of local"
* 6. One difference between a varlist and a genera list
* 
* Updated: September 28, 2020
*-----------------------------------------------------------------------------*
// 79: ---------------------------------------------------------------------- *

// numlist: ----------------------------------------------------------------- *
foreach i of numlist 1/5 {
  display `i'
}

// varlist: ----------------------------------------------------------------- *
sysuse auto, clear
foreach var of varlist weight displacement gear_ratio {
  quietly regress mpg `var'
  local r2 = e(r2)
  display "The R^2 for `var' is ",, %4.2f `r2'
}

// varlist using local: ----------------------------------------------------- *
local myvars "weight displacement gear_ratio"
foreach var of varlist `myvars' {
  quietly regress mpg `var'
  local r2 = e(r2)
  display "The R^2 for `var' is ",, %4.2f `r2'
}

// use in for a general list: ----------------------------------------------- *
foreach var in weight displacement gear_ratio {
  quietly regress mpg `var'
  local r2 = e(r2)
  display "The R^2 for `var' is ",, %4.2f `r2'
}

// can specify that myvars is a local: -------------------------------------- *
local myvars "weight displacement gear_ratio"
foreach var of local myvars {
  quietly regress mpg `var'
  local r2 = e(r2)
  display "The R^2 for `var' is ",, %4.2f `r2'
}

// varlist versus in: ------------------------------------------------------- *
foreach x in mpg weight-turn {
 display "`x'"
}

foreach x of varlist mpg weight-turn {
 display "`x'"
}

// 79: ---------------------------------------------------------------------- *