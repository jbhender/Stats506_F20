*-----------------------------------------------------------------------------*
* Stats 506, Fall 2020 
* Problem Set 3, Question 1
* 
* Construct a balance table examining associations with missing or incomplete
* dentition examanitations in the NHANES data. 
* 
*
* Author: James Henderson
* Updated: October 25, 2020
*-----------------------------------------------------------------------------*
// 79: ---------------------------------------------------------------------- *

// set up: ------------------------------------------------------------------ *
*cd ~/github/ps506_F20/PS3
version 16.1
log using ps3_q1.log, text replace

// data prep: --------------------------------------------------------------- *
use demo_ps3.dta, clear
generate all = 1
label define all 1 "Total"
label values all all

// balance table for categorical variables: --------------------------------- *

// categorical variables
local balance_vars0 "all gender race college"
local balance_vars1 "all gender race"

// separate results for each level of under_20
foreach x in 0 1 {

	frame copy default ref 
	frame ref: drop if under_20 != `x'

	// loop over subtables
	foreach var of local balance_vars`x' {
		
		// create frame for summary data
		frame copy ref "`var'"
		
		frame `var' {
			// summarize
			generate all2=1
			collapse (sum) n=all2, by(`var' ohx) 
			reshape wide n, i("`var'") j(ohx)
			generate pct_miss = n0 / (n0 + n1) * 100
			generate pct_obs = n1 / (n0 + n1) * 100

			// chi-squared test 
			frame ref: quietly tabulate ohx `var', chi2
			generate p = r(p)
			generate chi2 = r(chi2)
			replace p = . if _n > 1
			replace chi2 = . if _n > 1
	
			// clean up names and facilitate appending
			*rename `var' level
			decode `var', generate(lev)
			generate level = lev, before(`var')
			drop `var' lev
			generate variable = "`var'", before(level)
			rename (n0 n1) (n_miss n_obs)
		
			// save temporary dta file for appending
			save ".`var'", replace
		}
		frame drop `var'		
	}
	
	// append variable tables into a single table
	frame create balance_table`x'
	frame change balance_table`x'
	use ".all", clear
	
	local append_vars0 "gender race college"
	local append_vars1 "gender race"
	
	foreach var of local append_vars`x' {
		append using ".`var'"
		erase ".`var'"	
	}
	erase ".all"
	
	export delimited "balance_table_`x'.csv", replace
	
	frame change default
	frame drop ref
	frame drop balance_table`x'
}

// balance table for continuous variables: ---------------------------------- *

// continuous age
frame copy default age
frame age {
  collapse (mean) mean=age (p25) lwr=age (p75) upr=age, by(under_20 ohx)
}

// ttest for age under 20
quietly ttest age if under_20 == 1, by(ohx)
frame age {
	generate t = `r(t)'
	generate p = `r(p)'
	list
}

// ttest for age 20+
quietly ttest age if under_20 == 0, by(ohx)
frame age {
	replace t = `r(t)' if under_20 == 0
	replace p = `r(p)' if under_20 == 0
	list
}

// one p or t per age group
frame age {
  replace p = . if mod(_n, 2) != 1
  replace t = . if mod(_n, 2) != 1	
  
  export delimited "balance_table_age.csv", replace
}
frame drop age

// close log: --------------------------------------------------------------- *
log close

// 79: ---------------------------------------------------------------------- *
