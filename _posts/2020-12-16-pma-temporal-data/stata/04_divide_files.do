clear
cd "Z:\pma\admin\staff\Devon\research\papers\seasonality\2020\July\easerved"
set more off
use 03_longform_all.dta

***Divide files
levelsof(sample), local(samp)
foreach s in `samp' {
preserve
keep if sample == `s'
keep if cmc <= minintmonth & cmc >= startmonth
cap save fpcalendar_`s'.dta, replace
restore
}

