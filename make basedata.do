 version 13
 set more off
 clear all
 capture log close
 log using "make_basedata", text replace
 
* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
* NOTES
* this version: 12 May 2016
* This version defines ratios and functions of compustat variables
* as well as industries (kdj, ffind etc.)
* 
*  original version: 2 May 2016
*  author: Rajib Doogar
* This version has the F/S levels filled out, students are given a version
* which has the relevant globals left incomplete for them to fill out.
* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
 use "1980_2015_all.dta" 

 * Some Pedagogical steps ... (does not affect final output)  
 * lets browse the data ...
 br gvkey fyear tic conm at lse
 * sorting rows (Stata is a row-wise engine ... it cares about row order!) 
 sort gvkey fyear
 sort fyear gvkey
 * sorting columns (Stata does not care as much about column order)
 order gvkey fyear tic sic conm 
 * conditional browsing 
 br gvkey fyear tic conm at lse if fyear==2015
 br gvkey fyear tic conm at lse if fyear==2014

 * data cleaning ... 
 * garbage cleaning (get rid of bad/unusable data)
 drop if fyear ==2015
 duplicates drop gvkey fyear, force
 * drop irrelevant data 
 drop if fyear <=2004

 * @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 * define some useful macros
 * @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 * define balance sheet varlists
 global B1 ="at lse"
 global B2 ="act ppent ivaeq ivao intan ao lt mib teq"                                           // complete on your own
 global B3 ="che  rect  invt  aco  ppegt dpact gdwl intano  dc  aox lct  dltt  txditc lo"        // complete on your own
 global B4 ="ch ivst rectr txr recco invrm invwip invfg invo xpp acox aldo"                      // complete on your own

 * define income statement varlists
   global I1 ="sale cogs xsga dp xint nopi spi txt mii dvp cstke xido niadj"                       // complete on your own
 * global I2 = ""             // complete on your own
 * global I3 = ""             // complete on your own
 * global I4 = ""             // complete on your own
 
 * define cash flow statement varlists
 global C1 = "oancf ivncf fincf exre chech"                                                       // complete on your own
 global C2 = "ibc  dpc  xidoc  txdc  esubc  sppiv  fopo  recch  invch  apalch  txach  aoloch ivch  siv  ivstch  capx  sppe  aqc  ivaco sstk  txbcof  prstkc  dv  dltis  dltr  dlcch  fiao"             // complete on your own
 global C3 = ""             // complete on your own
 global C4 = ""             // complete on your own

 global all ="$B1 $B2 $B3 $B4 $I1 $I2 $I3 $I4 $C1 $C2 $C3 $C4"
 
 ******************************************                 ******************************************
 **************************************** Begin Vardef Block *****************************************
 ******************************************                 ****************************************** 
 * count number of firms and number of data items available
 sort gvkey
 egen gvid=group(gvkey)                         // assign each gvkey a unique numerical id
 summ gvid                                      // max of gvid is number of unique gvkeys in data set
 global N_unique=r(max)                         
 * let's look at data completeness
 egen n_items=rownonmiss($all)                  // measure data completeness at observation level
 egen n_items12 = rownonmiss($B1 $B2 $I1 $I2 $C1 $C2)
 hist n_items if at!=.
 hist n_items if at!=. & at>1000
 * googling "overlay histograms" takes me to http://www.ats.ucla.edu/stat/stata/faq/histogram_overlay.htm where I find
 /*
 twoway (histogram write if female==1, start(30) width(5) color(green)) ///
       (histogram write if female==0, start(30) width(5) ///
	   fcolor(none) lcolor(black)), legend(order(1 "Female" 2 "Male" ))
 */
 * which I can morph into:
  twoway (histogram n_items if at!=., color(green)) ///
         (histogram n_items if at!=. & at>1000, fcolor(none) lcolor(black)), ///
		 legend(order(1 "All" 2 "Billion+" ))

 * %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 * Compute ratios and scores
 * %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 * "Traditional"
  * Liquidity
 g quick_ratio = (che+rect)/(lct)
 g current_ratio = (act) / (lct)
 g cash_ratio = (che) / (lct)
  * Solvency
 g debt_equity = (lt)/(teq)
 g debt_ratio = (lt) / (at)
 g lt_debt_ratio = (dltt) / (at)
  * Profitability
 g roa = (ni)/(at)
 g roe = (ni) / (teq)
 g pm = (ni) / (sale)
  * Activity
 g cgs_inv = (cogs)/(invt)
 g rec_inv = (rect) / (invt)
 g sale_ta = (sale) / (at)
  * Other

 * KDJ
 generate kdj1 = che/at
 generate kdj2 = act/at
 generate kdj3 = sale/at
 
 * NP
 
 
 * Other

 * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
 * define industries
 * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
 * destring sic & create 2-digit SIC code
 destring sic, replace force
 gen sic2 = int(sic/100)
 
 * Define KDJ industries
 generate kdj = 8
 replace  kdj = 1 if (sic>= 3711 & sic<=3792)
 replace  kdj = 2 if(sic>=2800 & sic<=3079)
 replace  kdj = 3 if (sic>=3570 & sic<=3699)
 replace  kdj = 4 if(sic>=2000 & sic<=2121)
 replace  kdj = 5 if(sic>=5200 & sic<=5995)
 replace  kdj = 6 if(sic>=3310 & sic<=3568)
 replace  kdj = 7 if(sic>=2200 & sic<=2650)
 label var kdj "KDJ Industries"

 * define fama french industries using ffind.ado found at https://sites.google.com/site/judsoncaskey/data
 * ffind options are: 5, 10, 12, 17, 30, 38, 48 or 49 industries, we code them all
 ffind sic, newvar(ffind05) type(5)
 ffind sic, newvar(ffind10) type(10)
 ffind sic, newvar(ffind12) type(12)
 ffind sic, newvar(ffind17) type(17)
 ffind sic, newvar(ffind30) type(30)
 ffind sic, newvar(ffind38) type(38)
 ffind sic, newvar(ffind48) type(48)
 ffind sic, newvar(ffind49) type(49)
 
 * %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 * label and save data
 * %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 label data "Compustat F/S data, all firms, 2004-2015"
 save basedata_2005_2014, replace                                                // save the base data set


 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 * close and exit
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 log close
 exit
 
 
 /*
 * The folllowing code was moved to make_basedata_w_summ_stat.do
 * It is designed to compute descriptive stats by industry-fyear combination
 * using a variety of industry definitions.
 * These statistics are then appended as "observations," where the name of the 
 * statistic is stored in the gvkey variable and the definition of industry is stored 
 * in the ind_class variable.  So 
 * list at if gvkey=="mean" & sic2==73
 * will list the value of mean total assets for sic2==73 for all years, while
 * list at if gvkey=="mean" & ind_class=="sic2"
 * will list the value of mean total assets for all values of sic2 for all years, and
 * list at if gvkey=="mean" & ind_class=="sic2" & fyear==2007
 * will list the value of mean total assets for all values of sic2 for 2007, etc.
 
 * @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 * define some more useful macros
 * @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 
 ************************************************************************
 * Define Traditional Ratios and Scores
 ************************************************************************
 glo liquidity "quick_ratio current_ratio cash_ratio"
 glo solvency "debt_equity debt_ratio lt_debt_ratio"
 glo profitability "roa roe pm"
 glo activity "cgs_inv rec_inv sale_ta"
 * one ring
 glo trad_r "$liquidity $solvency $profitability $activity"
 
 * Define KDJ Ratios and Scores
 * one ring
 global kdj_r = "kdj1 kdj2 kdj3"

 * Define NP Ratios and Scores
 * one ring
 global np_r  = ""
  
 * Define Other ratios and scores
 * one ring
 global other_r  = ""
  
 * One ring of rings for ratios
 global all_r = "$trad_r $kdj_r $np_r $other_r"

 *************************************************************************
 * Define Targets, Industries and Reporting Groups
 *************************************************************************
 global indlist  "sic2 kdj ffind05 ffind10 ffind12 ffind17 ffind30 ffind38 ffind48 ffind49" 
 global indlist1 "sic2 kdj"

 *************************************************************************
 * define master list of all vars for which summary stats are to be computed 
 *************************************************************************
 global master="$all $all_r" 

 *************************************************************************
 * define summary statistics
 *************************************************************************
 global stats ="count sum mean sd min p10 p25 p50 p75 p90 max"
 
 ******************************************                 ******************************************
 ****************************************** End Macro Block ******************************************
 
 ******************************************                 ******************************************

 * ################################################################
 * collapse data to create summary variables
 * ################################################################
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 capture mkdir industry_stats
 cd industry_stats
 timer clear
 timer on 1
 foreach ind in $indlist1 {
 di "classification = `ind'"
 foreach stat in $stats {
   preserve
   collapse (`stat') $master if tic!="" & fyear!=., by(fyear `ind')
   gen gvkey=`"s_`stat'"'
   gen ind_class="`ind'"
   save `ind'_`stat'.dta, replace
   restore
   append using `ind'_`stat'
   * erase `stat'.dta
                        }
                         }
 label data "Compustat F/S data, all firms, 2004-2015 with summary stats"
 save basedata_w_summ_stat, replace
 timer off 1
 timer list 1

 * end of code block for creating observations containing descriptive stats
 
* Other miscellaneous old code 
 
 * %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 * tsset the data
 * %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 tsset gvid fyear
 
 * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 * Further analysis
 * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
 * tabulations

 * table ind fyear, c(min n_items p25 n_items p50 n_items p75 n_items)

 
 * Older commands

 qui tabstat $all, c(s) s($stats) save
 matrix A=r(StatTotal)
 preserve
 drop *
 svmat2 A, names(col) r(gvkey) 
 order gvkey
 save keystat, replace
 restore
 
  preserve
 collapse (count) $all if tic=="AAPL", by(fyear)                    // obtain varcount for target co, by fyear 
 xpose, clear varname
 order _varname
 sort  _varname
 export delimited using "varcounts_AAPL", novarnames replace        // change the saving filename to target company ticker
 restore

 preserve
 collapse (count) $all if ind=="36", by(fyear)                              // obtain varcount for target industry, by fyear 
 export delimited using "varcounts_36", novarnames replace     // change the saving filename to target industry name
 restore

 preserve
 collapse (count) $all, by(ind fyear)                            // obtain varcount for economy by industry
 export delimited using "varcounts_e", novarnames replace 
 restore

 preserve
 collapse (count) $all, by(gvkey fyear)                            // obtain varcount for economy by gvkey
 export delimited using "varcounts_bygvkey", novarnames replace 
 restore
 
 * generate number of observations per industry year
 foreach ind in list $indlist {
 egen nobs_`ind'=nvals(insert varname here), by(fyear `ind')                      // !! nvals requires package egenmore to be installed (net egenmore) !!
 table fyear `ind', c(n nobs_`ind' m nobs_`ind' sd nobs_`ind')        // egen nobs=
                              }
 table ind fyear if n_items>0, c(min n_items)                         // also try max, count, median and sum and interpret ... 
 table ind fyear if n_items>0, c(count n_items)                       // eliminate firms with no data for the year
 table ind fyear if n_items>50, c(count n_items)                      // eliminate firms with fewer than 50 data items for the year

 
