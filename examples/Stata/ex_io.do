*-----------------------------------------------------------------------------*
* I/O examples in Stata
* Stats 506, F20
*
* 1. `sysuse` for built in data, see also webuse
* 2. `clear` to okay overwrite of current data
* 3. `import delimited` for e.g. csv 
* 4. `save` to write native .dta, `use` to load local .dta
* 5. `export delimited` to write e.g. csv
*
* Updated: September 28, 2020
*-----------------------------------------------------------------------------*
// 79: ---------------------------------------------------------------------- *

// sysuse: ------------------------------------------------------------------ *
sysuse auto

drop foreign

// need the option `clear` if there is already data in memory. 
sysuse auto, clear

// delimited data: ---------------------------------------------------------- *
local base_url https://www.eia.gov/consumption/residential/data/2015/csv/

// read from web and then save
import delimited `base_url'/recs2015_public_v3.csv, clear
save recs2015
save recs2015, replace

// exporting delimited data
export delimited recs2015_public_v3.csv, replace 

// local Stata data set (dta): ---------------------------------------------- *
use recs2015.dta, clear

exit, clear

// 79: ---------------------------------------------------------------------- *
