set more off
********************************************************************************
/*
clear all
capture log close
cd "H:\RD"
import delimited "7dd255774070ccaa.csv"
save "demo.dta", replace
********************************************************************************
clear all
log using "demo_log.scml", replace
use "demo.dta", clear
*/
*br
*Safer than browsing in excel
*Note -  data is organized by gvkey(unique company identifier ) and then within gvkey by fyear
sort fyear gvkey
*br

order gvkey fyear conm at tl sale 
*br

*preserve 
keep if tic == "IBM"
*br
xpose, clear varname
*br
gen tic = "IBM"
order tic _varname
sort _varname
export delimited using "IBM", replace
*br
*restore
********************************************************************************




