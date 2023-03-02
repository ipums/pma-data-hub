clear

cd "Z:\pma\admin\staff\Devon\research\blog\abortionvars\January_2023"

use pma_00363.dta

keep if resultfq_1 == 1 & resultlfq_2 == 1
svyset [pw=aborweight], strata(strata_1) psu(eaid_1)

************************
***BASELINE SUM STATS***
************************

*period regulation more popular in Nigeria, maybe
tab abororreg_2 country, col
svy: tab abororreg_2 country, col

*women who regulated slightly less educated
tab educattgen_1 abororreg_2, col
svy: tab educattgen_1 abororreg_2, col

*not much difference in age
svy: mean age_1, over(abororreg_2)

*more likely to be never married
svy: tab marstat_1 abororreg_2, col

*more likely to consider the event an abortion if they got surgery versus pills or other methods

***Abortion methods

*use the first method she used if there were multiple methods
replace aboronlymeth_1 = aborfirstmeth_1 if abormult_1 == 1
tab aboronlymeth_1 if abororreg_2 == 1 & aboronlymeth_1 <= 90
svy: tab aboronlymeth_1 if abororreg_2 == 1 & aboronlymeth_1 <= 90

***Regulation methods
**more likely to use pills and traditional methods
*use the first method she used if there were multiple methods
replace regmeth_1 = reg1st_1 if regmult_1 == 1
tab regmeth_1 if abororreg_2 == 2 & regmeth_1 <= 90
svy: tab regmeth_1 if abororreg_2 == 2 & regmeth_1 <= 90

****how to deal with flag/fix variables
**question is phrased as, is this answer correct?  So if she said no, we correct
replace aboronlymeth_1 = aboronlymethfix_2 if aboronlymethflag_2 == 0

****bring in newly collected data
*Period regulation if less certain of pregnancy
svy: tab aborcertainty_2 country if abororreg_2 == 1, col
svy: tab regcertainty_2 country if abororreg_2 == 2, col

**What about Burkina Faso 2021?
***Maybe drop women who said they never ended a pregnancy or regulated a period
keep if abororreg_2 == 1 | abororreg_2 == 2
***Period regulation questions asked in Phase 2, so the suffix is different
**Nigeria and Cote d'Ivoire
tab regmeth_1 country
**Burkina Faso
tab regmeth_2 country

**Except abororreg_2 will still use _2 for all 3 countries
***Can use variables from _2 for abortion in Nigeria and Cote d'Ivoire for matching with Burkina, but not regulation because _2 method variables are combined for regulation and abortion - maybe we just use the _2 variables for method?

replace aboronlymeth_2 = aborfirstmeth_2 if abormult_1 == 1
tab aboronlymeth_2 abororreg_2 if aboronlymeth_2 <= 90, col
svy: tab aboronlymeth_2 abororreg_2 if aboronlymeth_2 <= 90, col

**What about Ethiopia 2020
****No period regulation questions







