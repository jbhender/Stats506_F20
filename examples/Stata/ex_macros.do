*-----------------------------------------------------------------------------*
* Macro examples in Stata
* Stats 506, F20
*
* 1. Create macros with the local command
* 2. Access macros with `'
* 3. Use = to evaluate expression and store value in macros
* 4. Expressons are unevaluated without =
*
* Updated: September 28, 2020
*-----------------------------------------------------------------------------*
// 79: ---------------------------------------------------------------------- *

// evaluated vs unevaluated: ------------------------------------------------ *

// unevaluated
local x 3
display `x'

local x 3
local y2 `x' + 2
display `y2'
display "`y2'"

// evaluated
local x 3
local y = `x' + 2
display `y'

local x 3
local y = `x' + 2
display `y'
display "`y'"

// 79: ---------------------------------------------------------------------- *
