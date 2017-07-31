 version 13
 set more off
 clear all
 capture log close
 log using "demo", text replace
 
* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
* NOTES
*  This file uses the dataset basedata_w_summ_stat to show students 
*  how to assemble complex plots from simple ones.
*  This version: 18 May 2016
*   
*  this version: 2 May 2016
*  author: Rajib Doogar
* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

 use basedata_2005_2014, clear
 
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
 glo trad_r "$liquidity $solvency $profitability $activity"
 
 * Define KDJ Ratios and Scores
 * one ring
 global kdj_r = "kdj1 kdj2 kdj3"

 * Define NP Ratios and Scores
 * one ring
 global np_r  = ""

 * Define other ratios and scores
 * one ring
 global other_r = ""
 * One ring of rings
 global all_r = "$trad_r $kdj_r $np_r $other_r"
 global all_r1 = "$kdj_r"
 desc $all_r
 
 * The following code is necessary because some variables in basedata are not
 * yet labeled resulting in blank varnames in graph titles.  Labeling them gives
 * Stata some text to feed into the graph title.  If variables are already properly 
 * labeled, this loop should be deleted ...
 foreach x in $all_r {
 la var `x' "`x'"
                     }
 *************************************************************************
 * Define Targets, Industries and Reporting Groups
 *************************************************************************
 * define list of targets
 global tlist = "IBM MSFT FDC ORCL XRX EA"
 capture ssc install tknz
 tknz $tlist, s(tic)
 
 * ###
 * define industry list
 * ###
 global indlist  "sic2 kdj ffind05 ffind10 ffind12 ffind17 ffind30 ffind38 ffind48 ffind49" 
 global indlist1 "kdj"   
 *************************************************************************
 * define master list of all vars for which summary stats are to be computed 
 *************************************************************************
 global master="$all $all_r" 

 *************************************************************************
 * define summary statistics
 *************************************************************************
 global stats ="count sum mean sd min p10 p25 p50 p75 p90 max"
 tknz $stats, s(stat)
  
 ******************************************                 ******************************************
 ****************************************** End Macro Block ******************************************
 ******************************************                 ******************************************

 ******************************************                  ******************************************
 **************************************** Begin Plotting Block ****************************************
 ******************************************                   ******************************************
 * demonstrate steps
 
 * Generating industry level statistics
 * To understand what we are hoping to accomplish, it is useful to go slowly and to use the data browser 
 * at every step.  In what follows, you should run each line of code one step at a time.
 
 * Let's browse the data (come back to this window after you are done browsing the data by scrolling down,
 * up, right and left)
 br
 * Lets sort the data by industry, then by fiscal year within industry and finally by gvkey within fiscal year
 sort kdj fyear gvkey
 * Browse again to see what changed
 br
 * Now lets move some column to the leftmost positions in the data set
 order kdj fyear gvkey tic at 
 * Browse again, but this time only the variables of interest
 br kdj fyear gvkey tic at
 * Limit the browse to the observations of interest
 br kdj fyear gvkey tic at che sale if kdj==1 & fyear>2006

 * close the browser window
 window manage close viewer
 
 * We see that the values of variables (at, che, sale etc.) vary from row to row within year (and from year to year as well)
 * What we want Stata to do is to compute the mean, median, 25th percentile etc. of at by year for each industry.  The egen 
 * command will do this quite readily and the next few steps will allow you to understand how this changes the dataset.

 * As a preliminary we observe that at can take very large values, making for awkward tick labels, so rescale at to be in $millions
 replace at=at/10^3
 save temp, replace                      // variable changed, don't save data under old name
 
 * The key is to understand the strcuture of the Stata "bys <x> <y> : <z>" syntax.  Here "bys" is a specific Stata command 
 * which stands for "by sort," <x> and <y> are existing variables in your data set and <z> is some Stata (command other than
 * bys itself).  The beauty of "bys" is that it first sorts the data by <x>, then within the <x> sort, by <y>, then for each 
 * <x> X <y> combination, it performs the command <z>.  You can see how powerful this is by running the next line:
 bys kdj fyear: egen lhinge = pctile(at), p(25) 
 * and browsing the data again:
 br kdj fyear gvkey tic at lhinge
 * This may be a good point to stop and repeat the exercise above using sic2 as your industry definition instead of kdj.
 * If you do so, remember to save the modified do file with a different name than demo.do (use simething like demo2.do). 
 
 * At this point you know enough to program and run the following commands.  Do so and for each command predict how you expect 
 * the data set to change.  After executing the block of code, resview the results by writing your own browse command.
 * Feel free to add more statistics to the block of code below ...
 bys kdj fyear: egen uhinge = pctile(at), p(75) 
 bys kdj fyear: egen median = pctile(at), p(50) 
 bys kdj fyear: egen lower = pctile(at), p(05) 
 bys kdj fyear: egen upper = pctile(at), p(95) 
 bys kdj fyear: egen mean = mean(at) 
 bys kdj fyear: egen indsize = total(at)        // this gives us the total scale of investment in the industry 
 bys kdj fyear: egen indcount = count(at)       // this gives us the number of active firms in the industry
 
 * Now write your own browse command below
 br
 
 ***
 *** Moving to graphs
 ***
 
 * Now we are ready to make some interesting graphs using both raw variables and the associated industry-year statistics we
 * have computed.  We'll start with two key industry year statistics that we have programmed, lhinge and uhinge and then
 * draw successiely more-complex pictures ...

 * Lets make a subdirectory to store the demo graphs
 capture mkdir demo_graphs
 
 * Start with a simple bar chart spanning lhinge to uhinge:
 twoway (rbar lhinge uhinge fyear if kdj==1 & fyear!=. & tic!="", fcolor(gs12) barwidth(0.6)), saving(gph0, replace)
 * Or how about a spike and cap chart spanning lower to upper?
 twoway (rcap upper lower fyear if kdj==1 & fyear!=. & tic!="", sort lwidth(thin) msize(medium)), ///
         saving(demo_graphs\gph1, replace)
 * Let's be ambitious and combine the two
 twoway (rbar lhinge uhinge fyear if kdj==1 & fyear!=. & tic!="", fcolor(gs12) barwidth(0.6)) ///
        (rcap upper lower fyear if kdj==1 & fyear!=. & tic!="", sort lwidth(thin) msize(medium)), ///
		saving(gph2, replace)
 * Next, add a connected plot for the median
 twoway (rbar lhinge uhinge fyear if kdj==1 & fyear!=. & tic!="", fcolor(gs12) barwidth(0.6)) ///
        (rcap upper lower fyear if kdj==1 & fyear!=. & tic!="", sort lwidth(thin) msize(medium))  ///
        (connected median fyear if kdj==1 & tic!="" & fyear!=., sort mcolor(yellow) msize(vsmall) msymbol(diamond)), ///
		saving(gph3, replace)
 * and another for the mean		
 twoway (rbar lhinge uhinge fyear if kdj==1 & fyear!=. & tic!="", fcolor(gs12) barwidth(0.6)) ///
        (rcap upper lower fyear if kdj==1 & fyear!=. & tic!="", sort lwidth(thin) msize(medium))  ///
        (connected median fyear if kdj==1 & tic!="" & fyear!=., sort mcolor(yellow) msize(vsmall) msymbol(diamond))	///
		(connected mean fyear if kdj==1 & fyear!=. & tic!="", sort mcolor(red) msize(vsmall) msymbol(diamond)), ///
		saving(gph4, replace)
* Switch arguments of the rbar and rcap elements 
 twoway (rbar upper lower fyear if kdj==1 & fyear!=. & tic!="", fcolor(gs12) barwidth(0.6)) ///
        (rcap uhinge lhinge fyear if kdj==1 & fyear!=. & tic!="", sort lwidth(thin) msize(medium))  ///
        (connected median fyear if kdj==1 & tic!="" & fyear!=., sort mcolor(yellow) msize(vsmall) msymbol(diamond))	///
		(connected mean fyear if kdj==1 & fyear!=. & tic!="", sort mcolor(red) msize(vsmall) msymbol(diamond)), ///
		saving(gph5, replace)
* Back to the original, add scatter between uhinge and upper to show points in the right tail of the distribution
twoway  (rbar lhinge uhinge fyear if kdj==1 & fyear!=. & tic!="", fcolor(gs12) barwidth(0.6)) ///
        (rcap lower upper fyear if kdj==1 & fyear!=. & tic!="", sort lwidth(thin) msize(medium))  ///
        (connected median fyear if kdj==1 & tic!="" & fyear!=., sort mcolor(yellow) msize(vsmall) msymbol(diamond))	///
		(connected mean fyear if kdj==1 & fyear!=. & tic!="", sort mcolor(red) msize(vsmall) msymbol(diamond)) ///
		(scatter at fyear if kdj==1 & tic!="" & fyear!=. & at>uhinge & at<upper, sort mcolor(dkgreen) msize(tiny) msymbol(square)), ///
		saving(gph6, replace)
* Add another scatter, this time for points "above" upper
twoway  (rbar lhinge uhinge fyear if kdj==1 & fyear!=. & tic!="", fcolor(gs12) barwidth(0.6)) ///
        (rcap lower upper fyear if kdj==1 & fyear!=. & tic!="", sort lwidth(thin) msize(medium))  ///
        (connected median fyear if kdj==1 & tic!="" & fyear!=., sort mcolor(yellow) msize(vsmall) msymbol(diamond))	///
		(connected mean fyear if kdj==1 & fyear!=. & tic!="", sort mcolor(red) msize(vsmall) msymbol(diamond)) ///
		(scatter at fyear if kdj==1 & tic!="" & fyear!=. & at>uhinge & at<upper, sort mcolor(dkgreen) msize(tiny) msymbol(square)) ///	
		(scatter at fyear if kdj==1 & tic!="" & fyear!=. & at>upper, sort mcolor(blue) msize(tiny) msymbol(lgx)), ///
		saving(gph7, replace)
* Eliminate last scatter (x > upper) to reduce compression, add bar for indsize
twoway  (rbar lhinge uhinge fyear if kdj==1 & fyear!=. & tic!="", fcolor(gs12) barwidth(0.6)) ///
        (rcap lower upper fyear if kdj==1 & fyear!=. & tic!="", sort lwidth(thin) msize(medium))  ///
        (connected median fyear if kdj==1 & tic!="" & fyear!=., sort mcolor(yellow) msize(vsmall) msymbol(diamond))	///
		(connected mean fyear if kdj==1 & fyear!=. & tic!="", sort mcolor(red) msize(vsmall) msymbol(diamond)) ///
		(scatter at fyear if kdj==1 & tic!="" & fyear!=. & at>uhinge & at<upper, sort mcolor(dkgreen) msize(tiny) msymbol(square)) ///
		(bar indsize fyear if kdj==1, sort yaxis(2) fcolor(none) fintensity(10)), ///
		saving(gph8, replace)
* Push bar to the back
twoway  (bar indsize fyear if kdj==1, sort yaxis(2) fcolor(ebg) fintensity(10)) ///
        (rbar lhinge uhinge fyear if kdj==1 & fyear!=. & tic!="", fcolor(gs12) barwidth(0.6)) ///
        (rcap lower upper fyear if kdj==1 & fyear!=. & tic!="", sort lwidth(thin) msize(medium))  ///
        (connected median fyear if kdj==1 & tic!="" & fyear!=., sort mcolor(yellow) msize(vsmall) msymbol(diamond))	///
		(connected mean fyear if kdj==1 & fyear!=. & tic!="", sort mcolor(red) msize(vsmall) msymbol(diamond)) ///
		(scatter at fyear if kdj==1 & tic!="" & fyear!=. & at>uhinge & at<upper, sort mcolor(dkgreen) msize(tiny) msymbol(square)), ///
		saving(gph9, replace)
* Alternatively, keep bar as the last item, but leave the interior empty         
twoway  (rbar lhinge uhinge fyear if kdj==1 & fyear!=. & tic!="", fcolor(gs12) barwidth(0.6)) ///
        (rcap lower upper fyear if kdj==1 & fyear!=. & tic!="", sort lwidth(thin) msize(medium))  ///
        (connected median fyear if kdj==1 & tic!="" & fyear!=., sort mcolor(yellow) msize(vsmall) msymbol(diamond))	///
		(connected mean fyear if kdj==1 & fyear!=. & tic!="", sort mcolor(red) msize(vsmall) msymbol(diamond)) ///
		(scatter at fyear if kdj==1 & tic!="" & fyear!=. & at>uhinge & at<upper, sort mcolor(dkgreen) msize(tiny) msymbol(square)) ///
		(bar indsize fyear if kdj==1, sort yaxis(2) fcolor(none) fintensity(10)), ///
		saving(gph10, replace)
* Now change arg of the bar plot to show indcount
twoway  (rbar lhinge uhinge fyear if kdj==1 & fyear!=. & tic!="", fcolor(gs12) barwidth(0.6)) ///
        (rcap lower upper fyear if kdj==1 & fyear!=. & tic!="", sort lwidth(thin) msize(medium))  ///
        (connected median fyear if kdj==1 & tic!="" & fyear!=., sort mcolor(yellow) msize(vsmall) msymbol(diamond))	///
		(connected mean fyear if kdj==1 & fyear!=. & tic!="", sort mcolor(red) msize(vsmall) msymbol(diamond)) ///
		(scatter at fyear if kdj==1 & tic!="" & fyear!=. & at>uhinge & at<upper, sort mcolor(dkgreen) msize(tiny) msymbol(square)) ///
		(bar indcount fyear if kdj==1, sort yaxis(2) fcolor(none) fintensity(10)), ///
		saving(gph11, replace)
* How about 2 bars?
twoway  (rbar lhinge uhinge fyear if kdj==1 & fyear!=. & tic!="", fcolor(gs12) barwidth(0.6)) ///
        (rcap lower upper fyear if kdj==1 & fyear!=. & tic!="", sort lwidth(thin) msize(medium))  ///
        (connected median fyear if kdj==1 & tic!="" & fyear!=., sort mcolor(yellow) msize(vsmall) msymbol(diamond))	///
		(connected mean fyear if kdj==1 & fyear!=. & tic!="", sort mcolor(red) msize(vsmall) msymbol(diamond)) ///
		(scatter at fyear if kdj==1 & tic!="" & fyear!=. & at>uhinge & at<upper, sort mcolor(dkgreen) msize(tiny) msymbol(square)) ///
		(bar indsize fyear if kdj==1, sort yaxis(2) fcolor(none) fintensity(10)) ///
		(bar indcount fyear if kdj==1, sort yaxis(2) fcolor(none) fintensity(10)), ///
		saving(gph12, replace)
* Let's add some title and legend details
twoway  (rbar lhinge uhinge fyear if kdj==1 & fyear!=. & tic!="", fcolor(gs12) barwidth(0.6)) ///
        (rcap lower upper fyear if kdj==1 & fyear!=. & tic!="", sort lwidth(thin) msize(medium))  ///
        (connected median fyear if kdj==1 & tic!="" & fyear!=., sort mcolor(yellow) msize(vsmall) msymbol(diamond))	///
		(connected mean fyear if kdj==1 & fyear!=. & tic!="", sort mcolor(red) msize(vsmall) msymbol(diamond)) ///
		(scatter at fyear if kdj==1 & tic!="" & fyear!=. & at>uhinge & at<upper, sort mcolor(dkgreen) msize(tiny) msymbol(square)) ///
        (bar indsize fyear if kdj==1, sort yaxis(2) fcolor(none) fintensity(10) barwidth(0.2)) ///
        (bar indcount fyear if kdj==1, sort yaxis(3) fcolor(none) fintensity(10) barwidth(0.4)), ///
		ytitle("`:variable label at'") ylabel(, labsize(small) angle(horizontal)) ymtick(, angle(horizontal)) ///
		ysc(ax(2) alt) ysc(ax(3) alt) ///
	    xtitle("Fiscal year") xlabel(#10, labsize(medsmall) angle(forty_five) grid) ///
	    title("Graph of `:variable label at'") subtitle("kdj==1 (2005-2014)") legend(c(4)) ///
		legend(label(1 "IQR") label(2 "p05-p90") label(3 "p50")  label(5 "AT") label(6 "Sum AT") label(7 "# Firms") c(4))  ///
		saving(gph13, replace)
* replace bars with lines
twoway  (rbar lhinge uhinge fyear if kdj==1 & fyear!=. & tic!="", fcolor(gs12) barwidth(0.6)) ///
        (rcap lower upper fyear if kdj==1 & fyear!=. & tic!="", sort lwidth(thin) msize(medium))  ///
        (connected median fyear if kdj==1 & tic!="" & fyear!=., sort mcolor(yellow) msize(vsmall) msymbol(diamond))	///
		(connected mean fyear if kdj==1 & fyear!=. & tic!="", sort mcolor(red) msize(vsmall) msymbol(diamond)) ///
		(scatter at fyear if kdj==1 & tic!="" & fyear!=. & at>uhinge & at<upper, sort mcolor(dkgreen) msize(tiny) msymbol(square)) ///
		(li indsize fyear if kdj==1, sort yaxis(2) lcolor(gs1) lw(medthick)) ///
		(li indcount fyear if kdj==1, sort yaxis(3) lcolor(gs12) lw(medthick)), ///
		ytitle("`:variable label at'") ylabel(, labsize(small) angle(horizontal)) ymtick(, angle(horizontal)) ///
		ysc(ax(2) alt) ysc(ax(3) alt) ///
	    xtitle("Fiscal year") xlabel(#10, labsize(medsmall) angle(forty_five) grid) ///
	    title("Graph of `:variable label at'") subtitle("kdj==1 (2005-2014)") ///
		legend(label(1 "IQR") label(2 "p05-p90") label(3 "p50")  label(5 "AT") label(6 "Sum AT") label(7 "# Firms") c(4))  ///
		saving(gph14, replace)

* By now you should have a good idea of how I complied the guts of the loops in plot.do.  The next step is to learn how to program loops in
* Stata and to modify the toway command to take dynamic arguments so that it can work inside the loop.  We will cover this step elsewhere.
		
 * %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 * Exit nicely
 * $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
 erase temp.dta
 log close
 exit

/*

Graveyard of old/scrap code, references etc...

  ** exploring tokenization ...
from Cox:  SJ 3(2):185--202  Speaking Stata:  Problems with lists [http://www.stata-journal.com/sjpdf.html?articlenum=pr0009]
tokenize ‘mylist’
forvalues i = 1/‘: list sizeof mylist’ {
local ‘i’ : display _dup(3) "‘‘i’’ "
local newlist "‘newlist’‘‘i’’ "
}

* version 1
tokenize ‘$tlist’
forvalues i = 1/‘: list sizeof tlist’ {
local ‘i’ : display _dup(3) "‘‘i’’ "
local newlist "‘newlist’‘‘i’’ "
}


