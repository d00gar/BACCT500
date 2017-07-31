 set more off
 clear all
 capture log close
* cd "H:\RD\"
 log using "select_sample_v2", text replace
 * modified version with F/S levels filled out
 use "1980_2015_all.dta" 
 drop if fyear <=2004
 drop if fyear ==2015
 destring sic, replace force
 gen sic2 = int(sic/100)
 gen ind = sic2
 tab sic2 fyear
 
 * define balance sheet varlists
 global B1 ="at lse"
 global B2 ="act ppent ivaeq ivao intan ao lt mib teq"                                           // complete on your own
 global B3 ="che  rect  invt  aco  ppegt dpact gdwl intano  dc  aox lct  dltt  txditc lo"        // complete on your own
 global B4 ="ch ivst rectr txr recco invrm invwip invfg invo xpp acox aldo"                  // complete on your own

 * define income statement varlists
 global I1 ="sale cogs xgsa dp xint nopi spi txt mii dvp cstke xidp niadj"                       // complete on your own
 * global I2 =""             // complete on your own
 * global I3 =""             // complete on your own
 * global I4 =""             // complete on your own
 
 * define cash flow statement varlists
 global C1 ="oancf ivncf fincf exre chech"                                                       // complete on your own
 global C2 ="ibc  dpc  xidoc  txdc  esubc  sppiv  fopo  recch  invch  apalch  txach  aoloch ivch  siv  ivstch  capx  sppe  aqc  ivaco sstk  txbcof  prstkc  dv  dltis  dltr  dlcch  fiao"             // complete on your own
 global C3 =""             // complete on your own
 global C4 =""             // complete on your own

 global all ="$B1 $B2 $B3 $B4 $I2 $I2 $I3 $I4 $C1 $C2 $C3 $C4"
 
 preserve
 collapse (count) $all, by(ind fyear)
 xpose, clear varname
 order _varname
 sort  _varname
 export delimited using "test", novarnames replace
 restore
