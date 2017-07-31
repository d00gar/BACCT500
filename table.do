 version 13
 set more off
 clear all
 capture log close
 log using "table", text replace
 
 /* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
 NOTES
  This file uses the dataset basedata_w_summ_stat to make plots
  
  this version: 2 May 2016
  author: Rajib Doogar
    $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ */ 

 use basedata_w_summ_stat, clear
 
 ******************************************     Some        ******************************************
 ******************************************   Introductory  ******************************************
 ******************************************    Remarks      ******************************************
 
 * A first point: rows are elements/units, columns are units/years
 * The traditional accounting format reads across rows (left to right) and down columns (top to bottom)
 *  so it makes sense to think of rows as labels as F/S elements or reporting units and column labels 
 *  the reporting units or as time elements
 
 * A second point: learn to think in panels (and to use the Stata tsset command)
 * Due to the nature of accrual accounting, accounting data really come into their own i.e., are the 
 *  most useful when we have several years of data on a reporting unit.  This enables us to study
 *  unit behavior over time, which is where accounting discipline really starts to have some bite.
 *    In our data sets, each row represents a (unique) gvkey-fyear combination.
 *    All the rows for a gvkey taken together represent the entire panel of data for that gvkey
 *    The tsset command in Stata will rememeber this structure if you type
 sort  gvkey fyear
 tsset gvkey fyear

 *    This is *incredibly* useful to the analyst.  Why the adulation?  Suppose you want to create a 
 *    variable "change in total assets."  How would you do that?
 *      One way might be to create a new variable that contains the value of last year's at for IBM in 
 *      the current row, then create a new variable that equals the difference between current and past at.
 *    If you have tsset your data, you can just type 
 *      generate ch_at = at-L.at
 *    and Stata will do all the heavy lifting for you.
 
 ******************************************                 ******************************************
 ***************************************** Begin Macro Block ******************************************
 ******************************************                 ******************************************

 * Lets's start by creating some macros: key lists of text we will use to control the program flow
 * The idea here is to think analytically about the elements of the exhibit we will create:
 * How will the rows be labeled?  The columns?  What will be reported in the table body itself?

 * I start with the elements of the table.  These will usually be F/S elements or combinations thereof (e.g.,
 * all of the F/S ratios which are the staple of financial analysis), or important descriptive statistics 
 * such as the mean, median, percentiles, standard deviation (sd) etc.of these elements or ratios.  
 * Experience teaches us the wisdom of coding in blocks i.e., keeping together related sequences of commands 
 * and that is how the code in this file will flow.  It may seem a bit awkward and confusing to read code 
 * written in  this way, but after a while you will learn why it is so valuable.  So bear with me for now.  
 *  Your story is only be as good as your data analysis, your data analysis only as good as your program and
 *  your program only as good as your ability to visualize the computations you want and to check that your 
 *  code does what you want it to.  So before you can walk down the red-carpet-glam of a multi-color powerpoint,
 *  you have learn to enjoy spending some time with the equipment in gym of programming. No sweat, no glam! :)

 * With this objective, let us define UPFRONT lists of F/S elements and ratios that we may want to work with.
 *  Henceforth, whenever we wish to add a new element to our analysis, we agree to come back to this part of 
 *  the code and add the new element definition to the appropriate block of code
 
 * Practice Note:
 * We may or may not use all of these lists in this program, but given modern computing power, we might as well 
 * keep this part constant across all our files.  Later you will learn to call in "libraries" as part of a current 
 * program, ensuring consistency of definitions across generations of programs.  Here we won't worry about that 
 * level of control.  At work you should be fanatical about keeping your program libraries synchronized.  But for
 * we'll use the good old "carry all neccesary code in your program" approach because I want you to be able to go
 * back and forth within the program to better understand what is being coded.
 
 ************************************************************************
 * Define varlists for creating Good Form F/S
 ************************************************************************
 global B1 ="at lse"
 global B2 ="act ppent ivaeq ivao intan ao lt mib teq"                                           // complete on your own
 global B3 ="che  rect  invt  aco  ppegt dpact gdwl intano  dc  aox lct  dltt  txditc lo"        // complete on your own
 global B4 ="ch ivst rectr txr recco invrm invwip invfg invo xpp acox aldo"                      // complete on your own

 * define income statement varlists
 global I1 ="sale cogs xsga dp xint nopi spi txt mii dvp cstke xido niadj"                       // complete on your own
 * global I2 =""             // complete on your own
 * global I3 =""             // complete on your own
 * global I4 =""             // complete on your own
 
 * define cash flow statement varlists
 global C1 ="oancf ivncf fincf exre chech"                                                       // complete on your own
 global C2 ="ibc  dpc  xidoc  txdc  esubc  sppiv  fopo  recch  invch  apalch  txach  aoloch ivch  siv  ivstch  capx  sppe  aqc  ivaco sstk  txbcof  prstkc  dv  dltis  dltr  dlcch  fiao"             // complete on your own
 global C3 =""             // complete on your own
 global C4 =""             // complete on your own

 global all ="$B1 $B2 $B3 $B4 $I1 $I2 $I3 $I4 $C1 $C2 $C3 $C4"
 
 ************************************************************************
 * Define Traditional Ratios and Scores
 ************************************************************************
 
 glo liquidity "quick_ratio current_ratio cash_ratio"
 glo solvency "debt_equity debt_ratio lt_debt_ratio"
 glo profitability "roa roe pm"
 glo activity "cgs_inv rec_inv sale_ta"
 * one ring
 glo trad_ratios "$liquidity $solvency $profitability $activity"
 
 * Define KDJ Ratios and Scores
 
 * one ring
 global kdj_rat = "kdj1 kdj2 kdj3"

 * Define NP Ratios and Scores
 global np_rat  = ""

 * Next let's define reporting units: these are our"target" and "peer" firms, our "industries"
 * and our "reporting groups."  
 *  The concept of a reporting group will become clear by the end of the program.
 
 *************************************************************************
 * Define Targets, Industries and Reporting Groups
 *************************************************************************
 
 * define list of targets
 global tlist = "IBM MSFT FDC ORCL XRX EA"

 * create reporting groups
 generate  rgroup=0 if inlist(gvkey,"mean","min","p10","p25","p50","p75","p90","max")    // we want to exclude these from being treated as observations
 replace   rgroup=0 if inlist(gvkey,"count","sum","sd")                                  // likewise these as well ...
 replace   rgroup=1 if inlist(tic,"IBM","MSFT","FDC","ORCL","XRX","EA")                  // list of target firms (sic==73)

 * creating headers for output columns of csfs
 glo rgroupname    "$tlist Industry"                                              // specify order of column headers within each year
 glo colnames      "$rgroupname $rgroupname $rgroupname $rgroupname $rgroupname"  // number of repetitions = # of years (of csfs produced, here 5: 2009-2013)

 * ###
 * define industry list
 * ###
 global indlist "kdj ffind05 ffind10 ffind12 ffind17 ffind30 ffind38 ffind48 ffind49" 
 
 * Finallly, we will want to tabulate some descriptive statistics for each element
 * for one or more firms.  So here we specify the statistics of interest that we
 * want the program to compute.
 
 *************************************************************************
 * define summary statistics
 *************************************************************************

 global stats ="count sum mean sd min p10 p25 p50 p75 p90 max"
 
 ******************************************                 ******************************************
 ****************************************** End Macro Block ******************************************
 ******************************************                 ******************************************
 
 
 * Now and only now do we start coding our variables ... finally (!!!) 
 *  goal is to transform the raw data into new measures that will be informative for our purpose
 
 
 ******************************************                 ******************************************
 **************************************** Begin Vardef Block *****************************************
 ******************************************                 ******************************************

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
 
 * NP
 
 
 * Other
 
 ******************************************                  ******************************************
 ****************************************** End Vardef Block ******************************************
 ******************************************                  ******************************************

 ******************************************                  ******************************************
 *************************************** Begin Tabulation Block ***************************************
 ******************************************                  ******************************************

  * %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 *  tables
 * %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 * housekeeping
   preserve               // protect data
   keep if sic2==73       // reduce size of data set
   keep if inlist(rgroup,0,1)
   drop if gvkey == "sum"
 * +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 * tables for Traditional ratios
 * +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 * code morphed from csfscoding v6.do

 sort fyear rgroup gvkey                                               // never hurts to sort :)
 egen csgroup=group(fyear rgroup) if (fyear>=$baseyear & fyear<=2013)
 summ csgroup                                                          // max should be ___ (fill in the blanks) !! Ha !! 
 table csgroup fyear if (fyear>=$baseyear & fyear<=2013)               // and here they are marching up and down in good battle order


 tabstat $trad_ratios  if (fyear>=2009 & fyear<=2013), by(csgroup) save nototal    // omitting the total column, which we do not need
 tabstatmat temp                                                            // line items in columns, csgroups in rows
 matrix temp=temp'                                                          // line items now in rows, csgroups in columns
 matrix rownames temp = $trad_ratios                                         // set rownames 
 matrix colnames temp = _:                                                  // blank out eq. number in column header: http://www.stata.com/manuals13/pmatrixrownames.pdf, page 4, Technical Note 
 matrix colnames temp = $colnames                                           // insert rgroupnames into column headers
 mat li temp, noheader
 putexcel B1=($baseyear) F1=($baseyear+1) J1=($baseyear+2) N1=($baseyear+3) R1=($baseyear+4) using trad_ratios, sh("trad_ratios") replace
 putexcel A2=mat(temp, names) using trad_ratios, sh("trad_ratios") mod

 sort rgroup gvkey fyear
 list rgroup gvkey tic fyear che rect lct quick_ratio if fyear==2009 & (rgroup==1| rgroup==2)

 
 restore
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 * close and exit
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 log close
 exit
 
 
 
 /*  
 

 * %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 *  plots
 * %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 * housekeeping
   preserve               // protect data
   keep if sic2==73       // reduce size of data set
   generate depvar=.      // generate shell variable for graphing
   
 * +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 * plots for total assets
 * +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   replace depvar=at      // stuff value of desired variable into shell
   global  depvar="Total Assets"    // likewise into a macro to use for labels etc.
 
 * scatter for observations and lines for mean and target firms
   twoway (scatter depvar fyear if rgroup!=0, sort msize(small)) (line depvar fyear if gvkey =="mean", sort) ///
          (line depvar fyear if gvkey =="p50", sort) (connected depvar fyear if tic=="IBM", sort) ///
	      (connected depvar fyear if tic=="MSFT", sort) (connected depvar fyear if tic=="ORCL", sort), ///
		  ylabel(#10, angle(horizontal) grid) xlabel(#12, grid) title($depvar) ///
		  subtitle(SIC code 73) legend(order(1 "$depvar " 2 "SIC mean" 3 "SIC median" 4 "IBM" 5 "MSFT" 6 "ORCL")) ///
		  scheme(sj) scale(0.8) saving("line-scatter_1_73.gph", replace)
 * scatter for observations and lines for mean and target firms + histogram for firm counts
   twoway (bar depvar fyear if gvkey=="count", sort yaxis(2) fcolor(ebg) fintensity(10)) ///
          (scatter depvar fyear if rgroup!=0, sort msize(small)) (line depvar fyear if gvkey =="mean", sort) ///
		  (line depvar fyear if gvkey =="p50", sort) (connected depvar fyear if tic=="IBM", sort) ///
		  (connected depvar fyear if tic=="MSFT", sort) (connected depvar fyear if tic=="ORCL", sort), ///
		  ylabel(#10, angle(horizontal) grid) ytitle(Firm count, axis(2)) xlabel(#12, grid) ///
		  title($depvar) subtitle(SIC code 73) ///
		  legend(order(1 "SIC Count" 2 "$depvar " 3 "SIC mean" 4 "SIC median" 5 "IBM" 6 "MSFT" 7 "ORCL")) ///
		  scheme(sj) scale(0.8) saving("line-scatter-hist_1_73.gph", replace)
 * scatter for observations and lines for mean and target firms + histogram for (insutry) sum of AT
   twoway (bar depvar fyear if gvkey=="sum", sort yaxis(2) fcolor(ebg) fintensity(10)) ///
          (scatter depvar fyear if rgroup!=0, sort msize(small)) (line depvar fyear if gvkey =="mean", sort) ///
	  	  (line depvar fyear if gvkey =="p50", sort) (connected depvar fyear if tic=="IBM", sort) ///
		  (connected depvar fyear if tic=="MSFT", sort) (connected depvar fyear if tic=="ORCL", sort), ///
		  ylabel(#10, angle(horizontal) grid) ytitle(SIC Sum AT, axis(2)) xlabel(#12, grid) ///
		  title($depvar) subtitle(SIC code 73) ///
		  legend(order(1 "SIC Sum" 2 "$depvar " 3 "SIC mean" 4 "SIC median" 5 "IBM" 6 "MSFT" 7 "ORCL")) ///
		  scheme(sj) scale(0.8) saving("line-scatter-hist_2_73.gph", replace)
 
 * +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 * plots for KDJ ratio 1
 * +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   replace depvar=kdj1                // stuff value of desired variable into shell
   global depvar="che/at"        // likewise into a macro to use for labels etc.
 
 * scatter for observations and lines for mean and target firms
   twoway (scatter depvar fyear if rgroup!=0, sort msize(small)) (line depvar fyear if gvkey =="mean", sort) ///
          (line depvar fyear if gvkey =="p50", sort) (connected depvar fyear if tic=="IBM", sort) ///
		  (connected depvar fyear if tic=="MSFT", sort) (connected depvar fyear if tic=="ORCL", sort), ///
		  ylabel(#10, angle(horizontal) grid) xlabel(#12, grid) title($depvar) ///
		  subtitle(SIC code 73) legend(order(1 "$depvar " 2 "SIC mean" 3 "SIC median" 4 "IBM" 5 "MSFT" 6 "ORCL")) ///
		  scheme(sj) scale(0.8) saving("line-scatter_2_73.gph", replace)
 * scatter for observations and lines for mean and target firms + histogram for firm counts
   twoway (bar depvar fyear if gvkey=="count", sort yaxis(2) fcolor(ebg) fintensity(10)) ///
          (scatter depvar fyear if rgroup!=0, sort msize(small)) (line depvar fyear if gvkey =="mean", sort) ///
		  (line depvar fyear if gvkey =="p50", sort) (connected depvar fyear if tic=="IBM", sort) ///
		  (connected depvar fyear if tic=="MSFT", sort) (connected depvar fyear if tic=="ORCL", sort), ///
		  ylabel(#10, angle(horizontal) grid) ytitle(Firm count, axis(2)) xlabel(#12, grid) ///
		  title($depvar) subtitle(SIC code 73) ///
		  legend(order(1 "SIC Count" 2 "$depvar " 3 "SIC mean" 4 "SIC median" 5 "IBM" 6 "MSFT" 7 "ORCL")) ///
		  scheme(sj) scale(0.8) saving("line-scatter-hist_3_73.gph", replace)
 * scatter for observations and lines for mean and target firms + histogram for (insutry) sum of AT
 * note the chnage in depvar for the histogram ("bar che", in this case, why??)
 twoway (bar che fyear if gvkey=="sum", sort yaxis(2) fcolor(ebg) fintensity(10)) ///
        (scatter depvar fyear if rgroup!=0, sort msize(small)) (line depvar fyear if gvkey =="mean", sort) ///
		(line depvar fyear if gvkey =="p50", sort) (connected depvar fyear if tic=="IBM", sort) ///
		(connected depvar fyear if tic=="MSFT", sort) (connected depvar fyear if tic=="ORCL", sort), ///
		ylabel(#10, angle(horizontal) grid) ytitle(SIC Sum che, axis(2)) xlabel(#12, grid) ///
		title($depvar) subtitle(SIC code 73) ///
		legend(order(1 "SIC Sum" 2 "$depvar " 3 "SIC mean" 4 "SIC median" 5 "IBM" 6 "MSFT" 7 "ORCL")) ///
		scheme(sj) scale(0.8) saving("line-scatter-hist_4_73.gph", replace)
   
 restore
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 * close and exit
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 

 log close
 exit
 
 
 
 /*  
 
 Old commands

 
