clear
cd "Z:\pma\admin\staff\Devon\research\papers\seasonality\2020\July\easerved"
set more off
use 02_wideform.dta
rename cheb0 childreneverborn

***Reshape file
reshape long birth fp age preg cheb, i(personid) j(month)
keep hhid personid birth month fp age preg cheb urban subnational sample eaid fqweight strata lastbirth* fpevuse fpcurruse childreneverborn pregnant durcurpreg wealth* score edu* mar* fpbegin* fpstop* fpcurreffmeth intfq* startmonth minintmonth maxintmonth
rename month cmc
gen month = mod(cmc,12)
recode month (0=12)
gen year = int((cmc/12) +1900)
replace year = year - 1 if month == 12
replace cheb = . if childreneverborn == 98
replace cheb = . if childreneverborn == 99


***Sample-specific cleanup

sort eaid sample personid cmc
merge m:1 eaid sample using 01b_sdp_long.dta
**The unmatched cases are women who live in EAs that did not have a facility on record for that round
**To be safe, I'll recode the num_methods variables to zero, but keep _merge so we can exclude these cases
foreach var of varlist num_meth* outpercent number_facilitie* num_interviewed {
recode `var' (.=0) if _merge == 1
}
gen notpreg_notfp = 0
replace notpreg_notfp = 1 if preg == 0 & fp == 0
replace num_interviewed  = 0 if num_interviewed == .
cap save 03_longform_all.dta, replace
/*
***Refine inclusion in sample
*****Identify first month of observation
*******12 months prior to interview month
*****Determine who should be in sample in first month
egen maxintmonth = max(intfqcmc), by(sample)
egen minintmonth = min(intfqcmc), by(sample)
gen startmonth = maxintmonth - 12
gen firstmonth = 0
replace firstmonth = 1 if cmc == startmonth

gen notpreg_notfp = 0
replace notpreg_notfp = 1 if preg == 0 & fp == 0
gen outofsample = 0
replace outofsample = 1 if notpreg_notfp == 0 & firstmonth == 1
egen drop_em = max(outofsample), by(personid) 
drop if drop_em == 1
*/

*******June


 

