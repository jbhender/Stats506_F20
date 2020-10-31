*-----------------------------------------------------------------------------*
* Stats 506, Fall 2020 
* Problem Set 3, data prep
* 
* This script prepares data for various parts of question 3 by:
*   - creating memorable variables names
*   - creating a missingness indicator for an incomplete dentition exam
*   - collapsing levels of education
*
* Author: James Henderson
* Updated: October 24, 2020
*-----------------------------------------------------------------------------*
// 79: ---------------------------------------------------------------------- *

// set up: ------------------------------------------------------------------ *
*cd ~/github/ps506_F20/PS3
version 16.1
log using ps3_prep_data.log, text replace

// demo data prep: ---------------------------------------------------------- *

// demographics
import delimited nhanes_demo.csv, clear

// easier to remember names
local demo_vars seqn riagendr ridageyr ridreth3 dmdeduc2 ridstatr 
local new_vars id gender age race edu exam_status
rename (`demo_vars') (`new_vars')
keep `new_vars'

// labels for race and gender
label define gender 1 "Male" 2 "Female"
label values gender gender

label define race 1 "Mexican American" 2 "Other Hispanic" ///
 3 "Non-Hispanic White" 4 "Non-Hispanic Black" 6 "Non-Hispanic Asian" ///
 7 "Other" 
label values race race

// separate age groups
generate under_20 = 0
replace under_20 = 1 if age < 20

// define college
generate college = 0 // no college unknown
replace college = 1 if edu == 4 | edu == 5
replace college = . if under_20 == 1
drop edu
label define lbl_college 0 "no college or unknown" ///
    1 "some college or college graduate"
label values college lbl_college

// remove those who did not participate in medical exams
keep if exam_status == 2

// dentition exam status: --------------------------------------------------- *

// use a frame to avoid saving a new subset to disk
frame create ohx
frame change ohx
import delimited nhanes_ohxden.csv, clear
rename (seqn ohddests) (id ohx_status)
drop *ctc

// create labels and save for use in Q3
label define tooth_count ///
  1 "Primary tooth present" 2 "Permanent tooth present" 3 "Dental Implant" ///
  4 "Tooth not present" 5 "Root fragment" 9 "could not assess"
label values ohx*tc tooth_count

gsort id
save ohxden_ps3.dta, replace

keep id ohx_status

// frlink / frget are used to link (e.g. merge) frames
frame change default
frlink 1:1 id, frame(ohx id) generate(ohx_link)
frget ohx_status, from(ohx_link)

generate ohx = 1 if ohx_status == 1 // (implicitly) & exam_status == 1
replace ohx = 0 if ohx_status != 1 | ohx_status == .

// save demographic data for ps3: ------------------------------------------- *
gsort id
save demo_ps3.dta, replace

// close log: --------------------------------------------------------------- *
log close

// 79: ---------------------------------------------------------------------- *
