*-----------------------------------------------------------------------------*
* Stats 506, Fall 2020 
* Problem Set 3, Question 2
* 
* Model the probability of an incomplete or missing dentition exam in the
* NHANES data. 
*
* Author: James Henderson
* Updated: October 25, 2020
*-----------------------------------------------------------------------------*
// 79: ---------------------------------------------------------------------- *

// set up: ------------------------------------------------------------------ *
cd ~/github/ps506_F20/PS3
version 16.1
log using ps3_q2.log, text replace

// data prep: --------------------------------------------------------------- *
use demo_ps3.dta, clear

// center and re-scale age
quietly: summarize age
generate age_c = (age - `r(mean)') / 10

quietly: summarize age if under_20 == 0
generate age_c0 = (age - `r(mean)') / 10 * (1 - under_20)

quietly: summarize age if under_20 == 1
generate age_c1 = (age - `r(mean)') / 10 * under_20

replace college = 0 if under_20 == 1

// note, all missing for age == 0, drop these: ------------------------------ *
drop if age == 0

// models for missing: ------------------------------------------------------ *

// write results to xlsx file
putexcel set ps3_q2.xlsx, replace sheet("AIC")
putexcel A1 = "model"
putexcel B1 = "description"
putexcel C1 = "AIC"

// mod1: 
logistic ohx i.under_20 i.gender c.age_c##c.age_c i.college
putexcel A2 = "`e(cmdline)'"
putexcel B2 = "base model (m1)"
putexcel C2 = (-2 * `e(ll)' + 2 * `e(rank)')
estat ic // for the log, not really needed when run in batch mode

// store these results until a better model comes along
estimates store best_model
local best_aic = (-2 * `e(ll)' + 2 * `e(rank)')
local top_model = "mod1"

// mod2: 
logistic ohx i.under_20 i.gender c.age_c##c.age_c c.age_c##i.college
putexcel A3 = "`e(cmdline)'"
putexcel B3 = "m1 + age/college interaction"
putexcel C3 = (-2 * `e(ll)' + 2 * `e(rank)')
estat ic 

// is this model better by AIC? 
if `best_aic' > (-2 * `e(ll)' + 2 * `e(rank)') {
	estimate store best_model
	local best_aic = (-2 * `e(ll)' + 2 * `e(rank)')
	local top_model = "mod2"
}

// mod3: 
logistic ohx i.under_20 i.gender c.age_c##c.age_c c.age_c#i.gender i.college
putexcel A4 = "`e(cmdline)'"
putexcel B4 = "m1 + age/gender interaction"
putexcel C4 = (-2 * `e(ll)' + 2 * `e(rank)')
estat ic

// is this model better by AIC? 
if `best_aic' > (-2 * `e(ll)' + 2 * `e(rank)') {
	estimate store best_model
	local best_aic = (-2 * `e(ll)' + 2 * `e(rank)')
	local top_model = "mod3"
}

// mod4: 
logistic ohx i.under_20 i.gender c.age_c##c.age_c i.college##i.gender
putexcel A5 = "`e(cmdline)'"
putexcel B5 = "m1 + gender/college interaction"
putexcel C5 = (-2 * `e(ll)' + 2 * `e(rank)')
estat ic

// is this model better by AIC? 
if `best_aic' > (-2 * `e(ll)' + 2 * `e(rank)') {
	estimate store best_model
	local best_aic = (-2 * `e(ll)' + 2 * `e(rank)')
	local top_model = "mod4"
}

// mod5: 
logistic ohx i.under_20 i.gender i.college c.age_c##c.age_c#i.under_20
putexcel A6 = "`e(cmdline)'"
putexcel B6 = "m1 + 'under 20'/age(both linear and quadratic) interaction"
putexcel C6 = (-2 * `e(ll)' + 2 * `e(rank)')
estat ic

// is this model better by AIC? 
if `best_aic' > (-2 * `e(ll)' + 2 * `e(rank)') {
	estimate store best_model
	local best_aic = (-2 * `e(ll)' + 2 * `e(rank)')
	local top_model = "mod5"
}


// mod6:
logistic ohx i.under_20#i.gender i.college c.age_c##c.age_c ///
	c.age_c#c.age_c#c.age_c
putexcel A7 = "`e(cmdline)'"
putexcel B7 = "m1 + cubic age"
putexcel C7 = (-2 * `e(ll)' + 2 * `e(rank)')
estat ic

// is this model better by AIC? 
if `best_aic' > (-2 * `e(ll)' + 2 * `e(rank)') {
	estimate store best_model
	local best_aic = (-2 * `e(ll)' + 2 * `e(rank)')
	local top_model = "mod6"
}

// format and save best model: ---------------------------------------------- *
estimates restore best_model
display "`top_model'"
 
// collect results
mata:
 b = st_matrix("e(b)")
 v = diagonal(st_matrix("e(V)"))
 se = sqrt(v)
 lwr = b' - 1.96 * se
 upr = b' + 1.96 * se
 coef = (b', se, lwr, upr) 
 st_matrix("coef_tab", coef)
 st_matrixrowstripe("coef_tab", st_matrixcolstripe("e(b)"))
end

// write to Excel
putexcel set ps3_q2.xlsx, modify sheet("Top Model")
putexcel A1 = "Top Model"
putexcel A2 = "`top_model'"
putexcel B1 = "response"
putexcel C1 = "Term"
putexcel D1 = "est"
putexcel E1 = "se"
putexcel F1 = "lwr"
putexcel G1 = "upr"
putexcel B2 = matrix(coef_tab), rownames

// An alternative built in way to output results. 
putexcel set ps3_q2.xlsx, modify sheet("Top Model etable")
estimates replay best_model
putexcel A1 = etable

// marginal effects for age at specific ages under 20
margins, dydx(age_c) at(age_c=(-3 -2) under_20=1 college=0) 

//marginal effects for age at specific ages over 20
margins, dydx(age_c) at(age_c=(-1 0 1 2 3 4) under_20=0)

// close log: --------------------------------------------------------------- *
log close

// 79: ---------------------------------------------------------------------- *
