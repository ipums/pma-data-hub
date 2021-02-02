clear
cd "Z:\pma\admin\staff\Devon\research\papers\seasonality\2020\July\easerved"
set more off
use pma_00180.dta
***Cleanup
drop if eligible == 0
drop if eligible == 96
replace intfqmon = . if intfqmon > 90
replace intfqyear = . if intfqyear > 9000
replace lastbirthmo = . if lastbirthmo > 90
replace lastbirthyr = . if lastbirthyr > 9000
gen lastbirthcmc = (lastbirthyr-1900)*12 + lastbirthmo
replace dobcmc = . if dobcmc > 9000
rename age age_reported
replace cheb = birthevent if cheb == .
rename cheb cheb0
drop birthevent

***Create calendar of FP use, pregnancy, birth, and age
forvalues cmc = 1369(1)1429 {
	gen fp`cmc' = 0
	gen birth`cmc' = 0
	gen preg`cmc' = 0
	gen cheb`cmc' = cheb0
	gen age`cmc' = int((`cmc'-dobcmc)/12)
	**Women who are currently using FP
	replace fp`cmc' = 1 if intfqcmc >= `cmc' & cp == 1 & fpbeginusecmc <= `cmc'
	**Replace with missing for months after the interview
	replace fp`cmc' = . if intfqcmc < `cmc'
	replace birth`cmc' = . if intfqcmc < `cmc'
	replace age`cmc' = . if intfqcmc < `cmc'
	replace preg`cmc' = . if intfqcmc < `cmc'
	**Women who are not currently using FP but have used in the past 12 months
	replace fp`cmc' = 1 if intfqcmc >= `cmc' & fpuseyr == 1 & fpbeginusecmc <= `cmc' & fpstopusecmc >= `cmc'
	**We can only consider the past 12 months since the interview
	replace fp`cmc' = . if intfqcmc - 12 > `cmc'
	**Unless they've never used FP
	*replace fp`cmc' = 0 if fpevuse == 0 & intfqcmc > `cmc'
	**Create indicator for when she gave birth
	replace birth`cmc' = 1 if lastbirthcmc == `cmc'
	replace preg`cmc' = 1 if pregnant == 1 & intfqcmc == `cmc'
	**Reducing CHEB before recent birth
	replace cheb`cmc' = cheb`cmc' - 1 if lastbirthcmc > `cmc' & cheb0 != 0
}

**Create indicator when she was pregnant with her most recent child
forvalues x = 1369(1)1420 {
	forvalues i = 1(1)9 {
	local cmc = `x' + `i'
	replace preg`x' = 1 if birth`cmc' == 1
	}
}
forvalues cmc = 1420(1)1429 {
	forvalues i = 1(1)9 {
	local x = `cmc' - `i'
	replace preg`x' = 1 if birth`cmc' == 1
	}
}
**Also mark women as pregnant even if they haven't given birth yet at the time of the interview
levelsof(intfqcmc), local(intmonths)
foreach cmc in `intmonths' { //this is the list of all intfqcmc
	forvalues i = 1(1)9 {
	local x = `cmc' - `i'
	replace preg`x' = 1 if durcurpreg >= `i' & durcurpreg <=10 & intfqcmc == `cmc'
	}
}
drop if intfqmon == 2 & sample == 85404
egen maxintmonth = max(intfqcmc), by(sample)
egen minintmonth = min(intfqcmc), by(sample)
replace maxintmonth = 1416 if sample == 85405
gen startmonth = maxintmonth - 12
gen firstmonth = 0
forvalues cmc = 1369(1)1429 {
	replace firstmonth = 1 if preg`cmc' == 0 & fp`cmc' == 0 & startmonth == `cmc'
}
keep if firstmonth == 1


**As soon as the woman leaves the not pregnant, "not using FP" group, we need to keep that new group as 1 until the end of her calendar
gen leftgroup1369 = 0
forvalues cmc = 1370(1)1429 {
	gen leftgroup`cmc' = 0
	replace leftgroup`cmc' = 1 if preg`cmc' == 1 | fp`cmc' == 1
	local x = `cmc' - 1
	replace preg`cmc' = 1 if preg`x' == 1 & startmonth < `cmc' & minintmonth >= `cmc'
	replace fp`cmc' = 1 if fp`x' == 1 & startmonth < `cmc' & minintmonth >= `cmc'
	replace leftgroup`cmc' = 1 if leftgroup`x' == 1
}

***Sample-specific cleanup
*This woman has never used fp, so we can feel certain that she is a 0 in Dec 2016
replace fp1404 = 0 if fp1404 == . & fpevuse == 0 & sample == 85405
*This woman says she's been using FP without stopping since 2014, so we can safely change this to a 1
replace fp1404 = 1 if fp1404 == . & fpbeginusecmc < 1404 & sample == 85405
*This woman was pregnant at the time, and gave birth in July 2017, so we can safely say that she was not using FP in Dec 2016
replace fp1404 = 0 if fp1404 == . & preg1404 == 1 & sample == 85405
*We can't determine if this woman was using FP in Dec 2016, so we should drop her from all time periods
drop if personid == "          0733200000017602017516"
cap save 02_wideform.dta, replace


