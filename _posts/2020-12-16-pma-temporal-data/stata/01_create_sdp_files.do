clear
cd "Z:\pma\admin\staff\Devon\research\papers\seasonality\2020\July\easerved"
set more off
use pma_00199.dta
local geolevel eaid
keep eaid sample year *obs *out3mo *prov facilityid consentsq facilitytyp* authority *outday easerved1-easerved18
*for calculating the number of facilities in an EA
gen fac_number = 1
drop fpadolprov
sort sample eaid 
/*Recoding in stock variables to instock y/n or out of stock y/n*/
foreach var of varlist *obs {
recode `var' (1/2=1)(nonmiss=0), gen(`var'_instock)
label variable `var'_instock "`var' is in stock"
}
foreach var of varlist *obs {
recode `var' (3=1)(nonmiss=0), gen(`var'_out)
}
foreach var of varlist *obs_out *_instock{
gen `var'_count = `var'
}
foreach var of varlist *prov {
recode `var' (99=0)
}
foreach var of varlist *out3mo {
recode `var' (94/99=.)
}

tab facilitytypegen, gen(ftype)
tab authority, gen(auth)
rename (ftype1 ftype2 ftype3 ftype4) (hospital hcenter pharm other)
rename (auth1 auth2 auth3) (gov faith private)


*Calculates the number of facilities in the EAID
bys eaid sample: egen number_facilities_inEAtemp = sum(fac_number)
*Get rid of missing facilities before we calculate anything else, plus count of facilities that were interviewed
drop if consentsq == 0
bys eaid sample: egen num_interviewed = sum(fac_number)

foreach method in con cycb depo dia emrg fc fj imp iud pill say {
egen `method'outev = rowmax(`method'obs_out `method'out3mo) //facility level
}

drop injprov injobs injout3mo injoutday injobs_instock injobs_out injobs_out_count injobs_instock_count
cap save 01a_all_sdp.dta, replace
*export delimited 01b_all_sdp, replace

clear
set more off
use 01a_all_sdp.dta

**Creating observations for facilities that serve EAIDs
***Create copies of the stock variables to keep in-EA values separate from in-EA + out-EA var
foreach var of varlist conobs_out-sayobs_out conobs_instock-sayobs_instock conprov-sayprov *out3mo *outev {
gen `var'_inEA = `var'
}
***loop through each faciility abd then loop through each EAserved# 
*Create new count variable for facilities outside of the EA
gen outside_flag = 0
keep if year == 2017 | year == 2018

forvalues i = 1(1)18 {
*if the easerved is the same as the EA it's located in, replace with missing code in order to ignore later
replace easerved`i' = 99998 if easerved`i' == eaid
}
sort year facilityid
foreach yr in 2017 2018 {
levelsof facilityid if year == `yr', local(fac)
foreach x in `fac' {
di "`x' for `yr'"
forvalues i = 1(1)18 {
di "easerved`i'"
*Create a new observation with that value of EAID with stockout and method mix info (new vars that retains in-EA info)
set obs `=_N+1'
levelsof easerved`i' if facilityid == `x' & year == `yr', local(temp_ea)
cap replace eaid = `temp_ea' if eaid == .
replace outside_flag = 1 if outside_flag == .
replace facilityid = `x' if facilityid == .
replace year = `yr' if year == .
foreach var of varlist sample conobs_out-sayobs_out conobs_instock-sayobs_instock conprov-sayprov *out3mo *outev {
*di "`var'"
levelsof `var' if facilityid == `x' & year == `yr', local(tempv)
cap replace `var' = `tempv' if `var' == . & facilityid == `x' & year == `yr'
}
}
}
}
drop if outside_flag == 1 & eaid > 90000
**Create a new variable to keep info about method mix with only serving facilities 
foreach var of varlist conobs_out-sayobs_out conobs_instock-sayobs_instock conprov-sayprov *out3mo *outev {
gen `var'_outEA = .
replace `var'_outEA = `var' if outside_flag == 1
}
**Create count var for all facilities serving and within EA
replace fac_number = 1
bys eaid sample: egen number_facilities_outEAtemp = sum(outside_flag)
gen number_facilities = number_facilities_inEA + number_facilities_outEAtemp
cap save 01.5_easervedSDP.dta, replace

clear 
use 01.5_easervedSDP.dta
set more off
**Bringing data to EAID level
collapse (mean) number_facilitie* num_interviewed (max) conobs_out-sayobs_out conobs_instock-sayobs_instock conprov-sayprov *out3mo *outev *inEA *outEA (sum) outside_flag hospital hcenter pharm other gov faith private, by(eaid sample)
rename number_facilities_inEAtemp number_facilities_inEA
rename number_facilities_outEAtemp number_facilities_outEA
**changing zeros to missing so that we count only provides, out of stock, or in stock at the EA level
foreach var of varlist conprov-sayprov *prov_outEA *prov_inEA {
recode `var' (0=.), gen(`var'_temp)
}
foreach var of varlist conobs_out-sayobs_out *out_inEA *out_outEA {
recode `var' (0=.), gen(`var'_temp)
}
foreach var of varlist conobs_instock-sayobs_instock {
recode `var' (0=.), gen(`var'_temp)
}
foreach var of varlist conout3mo-sayout3mo *out3mo_inEA *out3mo_outEA {
recode `var' (0=.), gen(`var'_temp)
}
foreach var of varlist conoutev-sayoutev *outev_inEA *outev_outEA{
recode `var' (0=.), gen(`var'_temp)
}
*all facilities in and outside of EA
egen num_methods_prov = rownonmiss(conprov_temp-sayprov_temp)
egen num_methods_out = rownonmiss(conobs_out_temp-sayobs_out_temp)
egen num_methods_instock = rownonmiss(conobs_instock_temp-sayobs_instock_temp)
egen num_methods_out3mo = rownonmiss(conout3mo_temp-sayout3mo_temp)
egen num_methods_outev = rownonmiss(conoutev_temp-sayoutev_temp)
*facilities inside EA
egen num_methods_prov_inEA = rownonmiss(conprov_inEA_temp-sayprov_inEA_temp)
egen num_methods_out_inEA = rownonmiss(conobs_out_inEA_temp-sayobs_out_inEA_temp)
*egen num_methods_instock_inEA = rownonmiss(conobs_instock_inEA_temp-sayobs_instock_inEA_temp)
*egen num_methods_out3mo_inEA = rownonmiss(conout3mo_inEA_temp-sayout3mo_inEA_temp)
egen num_methods_outev_inEA = rownonmiss(conoutev_inEA_temp-sayoutev_inEA_temp)
*facilities outside EA
egen num_methods_prov_outEA = rownonmiss(conprov_outEA_temp-sayprov_outEA_temp)
egen num_methods_out_outEA = rownonmiss(conobs_out_outEA_temp-sayobs_out_outEA_temp)
*egen num_methods_instock_outEA = rownonmiss(conobs_instock_outEA_temp-sayobs_instock_outEA_temp)
*egen num_methods_out3mo_outEA = rownonmiss(conout3mo_outEA_temp-sayout3mo_outEA_temp)
egen num_methods_outev_outEA = rownonmiss(conoutev_outEA_temp-sayoutev_outEA_temp)

drop *_temp
**Note: num_methods_prov does not always = num_methods_out + num_methods_instock because of female or male sterilization

gen outpercent = num_methods_outev/num_methods_prov
gen outpercent_inEA = num_methods_outev_inEA/num_methods_prov_inEA
replace outpercent_inEA = 0 if outpercent_inEA == .
gen outpercent_outEA = num_methods_outev_outEA/num_methods_prov_outEA
replace outpercent_outEA = 0 if outpercent_outEA == .


keep sample eaid num_methods* outpercent hospital hcenter pharm other gov faith private number_facilitie* num_interviewed num_methods_prov_inEA num_methods_prov_outEA num_methods_prov_inEA num_methods_prov_outEA
replace number_facilities_inEA = 0 if number_facilities_inEA == .
replace number_facilities = number_facilities_inEA + number_facilities_outEA
cap save 01b_sdp_long.dta, replace
export delimited "Z:\pma\admin\staff\Devon\research\papers\seasonality\2020\July\easerved\01b_sdp_long.csv", replace 

gen year = 2017
replace year = 2018 if sample == 85408
reshape wide sample num_methods* outpercent hospital hcenter pharm other gov faith private number_facilitie* num_interviewed, i(eaid) j(year)
replace number_facilities_inEA2018 = 0 if number_facilities_inEA2018 == .
replace number_facilities_outEA2018 = 0 if number_facilities_outEA2018 == .
replace number_facilities2018 = 0 if number_facilities2018 == .
replace sample2018 = 85408 if sample2018 == .
foreach var of varlist *2018 *2017 {
replace `var' = 0 if `var' == .
}

cap save 01d_sdp_wide.dta, replace
export delimited 01d_sdp_wide, replace
