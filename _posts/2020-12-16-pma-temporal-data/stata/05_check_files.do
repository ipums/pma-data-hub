clear
cd "Z:\pma\admin\staff\Devon\research\papers\seasonality\2020\July\easerved"
set more off
log using "05_check_files.smcl", replace

***Divide files

foreach s in 85405 85408 {
clear
use fpcalendar_`s'
gen flag = 0
replace flag = 1 if fp == 1 & preg == 1
tabstat notpreg_notfp fp preg birth flag, by(cmc) stat(sum)
tab cheb
tab month year
export delimited fpcalendar_`s'.csv, replace
}

log close

