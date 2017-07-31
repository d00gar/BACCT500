 set more off
 clear all
 capture log close
* cd "H:\RD\"
 log using "select_sample", text
 use "1980_2015_all.dta" 
 drop if fyear <=2004
 drop if fyear ==2015
 destring sic, replace force
 gen sic2 = int(sic/100)
 gen ind = sic2
 tab sic2 fyear
 
 * define balance sheet varlists
 global B1 =="at lse"
 global B2 =="act ppent "             // complete on your own
 global B3 =="che "                   // complete on your own
 global B4 =="ch "                    // complete on your own

 * define income statement varlists
 global I1 =="sale cogs xgsa dp xint nopi spi txt mii dvp cstke xidp niadj"
 * global I2 ==""             // complete on your own
 * global I3 ==""             // complete on your own
 * global I4 ==""             // complete on your own
 
 * define cash flow statement varlists
 global C1 ==""             // complete on your own
 global C2 ==""             // complete on your own
 global C3 ==""             // complete on your own
 global C4 ==""             // complete on your own

 global all =="$B1 $B2 $B3 $B4 $I2 $I2 $I3 $I4 $C1 $C2 $C3 $C4"
 
 * count number of instances of all variables
 preserve
 collapse (count) $all
 xpose, clear varname
 order _varname
 sort  _varname
 export delimited using "varcount_all", novarnames replace
 restore

 preserve
 collapse (count) $all, by(fyear)
 xpose, clear varname
 order _varname
 sort  _varname
 export delimited using "varcount_by_fyear", novarnames replace
 restore

 preserve
 collapse (count) $all, by(ind)
 xpose, clear varname
 order _varname
 sort  _varname
 export delimited using "varcount_by_ind", novarnames replace
 restore

 preserve
 collapse (count) $all, by(ind fyear)
 xpose, clear varname
 order _varname
 sort  _varname
 export delimited using "varcount_by_ind_fyear", novarnames replace
 restore
