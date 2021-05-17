clear
use "[filepath]/pma_#####.dta"
cd "[filepath]"
set more off

*Keep only female records
keep if consentfq == 1

*********************************
********SPLIT STRING VARS********
*********************************

*Kenya calendar variable starts in Jan 2017, 36 entries
*splitting the calendar data up into individual variables where commas were in the original variable
split calendarke, p(,) gen(cal_ke)

*****************************************
********RESHAPE FROM WIDE TO LONG********
*****************************************

*changing from wide form to long form, indicating that cal_ke is a time variant variable
reshape long cal_ke, i(personid) j(month)

*********************************
********RECODE VARIABLES*********
*********************************

*The calendars read from right to left from the earliest month to the most recent month
*this line reorders the months so that month 1 is the earliest month.  The earliest month is now 36
replace month = 37 - month
sort personid month

*cmc is the century-month format, because month 1 is January 2017, or CMC 1405
gen cmc = month + 1404



*some clean up - create new version, convert birth, termination, and pregnant into codes and destring
gen numcal_ke = cal_ke
replace numcal_ke = "90" if numcal_ke == "P"
replace numcal_ke = "91" if numcal_ke == "T"
replace numcal_ke = "92" if numcal_ke == "B"
destring numcal_ke, replace

*create labels
label define calendar 92 "Birth" 90 "Pregnant" 91 "Pregnancy ended" 0 "No family planning method used" 1 "Female Sterilization" 2 "Male Sterilization" 3 "Implant" 4 "IUD" 5 "Injectables" 7 "Pill" 8 "Emergency Contraception" 9 "Male Condom" 10 "Female Condom" 11 "Diaphragm" 12 "Foam / Jelly" 13 "Standard Days / Cycle beads" 14 "LAM" 30 "Rhythm method" 31 "Withdrawal" 39 "Other traditional methods"
*apply labels
label values numcal_ke calendar

*******************************
********SURVIVAL CURVES********
*******************************

****Create a variable that indicates that she was using any FP in the first observed month

*First create a binary variable that indicates whether she was using FP in that month for each observation
recode numcal_ke (0=0) (90/92=0) (else=1), gen(fp_use)

*Create a variable that is equal to 1 in month 1 when the she is using FP
gen discontinue_sample_temp = 0 
replace discontinue_sample_temp = 1 if fp_use == 1 & month == 1

*Create a variable that is equal to 1 for all observations of the woman if she was using FP in the first month
egen discontinue_sample = max(discontinue_sample_temp), by(personid)

*This command establishes month as the time variable, personid as the unique personal identifier
stset month, id(personid) failure(fp_use==0)
*Creates a survival curve of women using FP and leaving that group because they stop using FP
sts graph if discontinue_sample == 1


*****************************************
********SURVIVAL CURVES BY METHOD********
*****************************************

*Variable that indicates that she was using the pill
recode numcal_ke (7=1) (else=0), gen(pill)
gen pill_temp = 0 
replace pill_temp = 1 if pill == 1 & month == 1
egen pill_sample = max(pill_temp), by(personid)

stset month, id(personid) failure(pill==0)
sts graph if pill_sample == 1

*Variable that indicates that she was using Implant
recode numcal_ke (3=1) (else=0), gen(implant)
gen implant_temp = 0 
replace implant_temp = 1 if implant == 1 & month == 1
egen implant_sample = max(implant_temp), by(personid)

stset month, id(personid) failure(implant==0)
sts graph if implant_sample == 1





