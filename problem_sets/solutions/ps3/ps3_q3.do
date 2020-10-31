*-----------------------------------------------------------------------------*
* Stats 506, Fall 2020 
* Problem Set 3, Question 3
* 
* This script uses the four-wave NHANES data and the dentition exams to
* descriptively compare how the tooth status changes with age for each
* tooth. Age is discretized into ~6 year windows. 
* 
* Author: James Henderson
* Updated: October 29, 2020
*-----------------------------------------------------------------------------*
// 79: ---------------------------------------------------------------------- *

// set up: ------------------------------------------------------------------ *
*cd ~/path/to/your/files // comment out before submission 
version 16.1
log using ps3_q3.log, text replace

// data prep: --------------------------------------------------------------- *
use ps3_ohxden, clear
gsort id
merge 1:1 id using demo_ps3, keepusing(age)
keep if _merge == 3
drop _merge
keep if ohx_status == 1
drop ohx_status

// create age groups: ------------------------------------------------------- *
generate age_grp = .

foreach upr of numlist 1/14 {
	local start = 6 * (`upr' - 1)
	local stop = 6 * `upr'
	display `start'
	display `stop'
	label define lbl_age_grp `upr' "[`start'-`stop')", add
	replace age_grp = `upr' if age >= `start' & age < `stop'	
}
label values age_grp lbl_age_grp

// count frquencies for each tooth and age group: --------------------------- *
reshape long ohx, i(id age_grp) j(tooth) string
rename ohx ohx_tc
collapse (count) n=id, by(tooth age_grp ohx_tc)

// count totals for each tooth/age group combo: ----------------------------- *
frame copy default total
frame total: collapse (sum) total=n, by(tooth age_grp)

frlink m:1 tooth age_grp, frame(total tooth age_grp) generate(total_link)
frget total, from(total_link)

// "complete" the data with implicit zeros
reshape wide n, i(age_grp tooth) j(ohx_tc)
foreach i of numlist 1/5 {
	replace n`i' = 0 if n`i' == .
}
reshape long n, i(age_grp tooth) j(ohx_tc)

// compute percentages: ----------------------------------------------------- *
generate p = n / total * 100

// truncated confidence intervals
generate stderr = sqrt(p * (100 - p) / total)
generate lwr = p - 1.96 * stderr
generate upr = p + 1.96 * stderr
replace lwr = 0 if lwr < 0
replace upr = 100 if upr > 100

// a little more clean up
drop total_link total

// export results
export delimited using ps3_q3_results.csv

// close log: --------------------------------------------------------------- *
log close

// 79: ---------------------------------------------------------------------- *
