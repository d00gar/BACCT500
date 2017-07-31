***Getting you started with your project using Stata***
***Launch stata on your PC
***Clear your working space 
*clear all
* cd "H:\RD\Day6\"
***set screen to scroll automatically (better handle long blocks of output)
set more off 
***Close any open log files 
capture log close
***Open a new log file for this session
log using "day06_log",text replace 
***Open your data set
* use "all_industry_raw_data.dta", clear 
use "1980_2015_all.dta", clear 
drop if fyear > 2014
duplicates drop gvkey fyear, force

***Plot at for your company (IBM) [use menu buttons]
twoway (connected at fyear, sort) if tic=="IBM", ylabel(#10, angle(horizontal) grid) ///
		xlabel(#25, angle(forty_five) grid) title(Total assets ) subtitle((1980 - 2014)) ///
		legend(order(1 "IBM")) scheme(sj)
***Add MSFT to this plot [using menu buttons]
twoway (connected at fyear if tic=="IBM", sort) (connected at fyear if tic=="MSFT", sort), ///
		ylabel(#10, angle(horizontal) grid) xlabel(#25, angle(forty_five) grid) ///
		title(Total assets ) subtitle((1980 - 2014)) legend(order(1 "IBM" 2 "MSFT")) scheme(sj)
***Now add ORCL and XRX [cut, paste, modify]
twoway (connected at fyear if tic=="IBM", sort) (connected at fyear if tic=="MSFT", sort) ///
		(connected at fyear if tic=="ORCL", sort) (connected at fyear if tic=="XRX", sort) , ///
		ylabel(#10, angle(horizontal) grid) xlabel(#25, angle(forty_five) grid) ///
		title(Total assets ) subtitle((1980 - 2014)) legend(order(1 "IBM" 2 "MSFT" 3 "ORCL" 4 "XRX")) scheme(sj)
***We don't like the default marker sizes
twoway (connected at fyear if tic=="IBM", sort msize(small)) ///
		(connected at fyear if tic=="MSFT", sort msize(small)) ///
		(connected at fyear if tic=="ORCL", sort msize(small)) ///
		(connected at fyear if tic=="XRX", sort msize(small)) , ///
		ylabel(#10, angle(horizontal) grid) xlabel(#25, angle(forty_five) grid) ///
		title(Total assets ) subtitle((1980 - 2014)) legend(order(1 "IBM" 2 "MSFT" 3 "ORCL" 4 "XRX")) ///
		scheme(sj)
*** Still don't like this, so tune furthur
twoway (connected at fyear if tic=="IBM", sort msize(small)) ///
		(connected at fyear if tic=="MSFT", sort msize(vsmall)) ///
		(connected at fyear if tic=="ORCL", sort msize(vsmall)) ///
		(connected at fyear if tic=="XRX", sort msize(vsmall)) , ///
		ylabel(#10, angle(horizontal) grid) xlabel(#25, angle(forty_five) grid) ///
		title(Total assets ) subtitle((1980 - 2014)) legend(order(1 "IBM" 2 "MSFT" 3 "ORCL" 4 "XRX")) ///
		scheme(sj)
***Good time to save this graph 
twoway (connected at fyear if tic=="IBM", sort msize(small)) ///
		(connected at fyear if tic=="MSFT", sort msize(vsmall)) ///
		(connected at fyear if tic=="ORCL", sort msize(vsmall)) ///
		(connected at fyear if tic=="XRX", sort msize(vsmall)) , ///
		ylabel(#10, angle(horizontal) grid) xlabel(#25, angle(forty_five) grid) ///
		title(Total assets ) subtitle((1980 - 2014)) ///
		legend(order(1 "IBM" 2 "MSFT" 3 "ORCL" 4 "XRX")) scheme(sj) saving(at_group1, replace)
***Now repeat the process for act[Search and replace "at" with "act"]
twoway (connected act fyear if tic=="IBM", sort msize(small)) ///
		(connected act fyear if tic=="MSFT", sort msize(vsmall)) ///
		(connected act fyear if tic=="ORCL", sort msize(vsmall)) ///
		(connected act fyear if tic=="XRX", sort msize(vsmall)) , ///
		ylabel(#10, angle(horizontal) grid) xlabel(#25, angle(forty_five) grid) ///
		title(Total assets ) subtitle((1980 - 2014)) ///
		legend(order(1 "IBM" 2 "MSFT" 3 "ORCL" 4 "XRX")) scheme(sj) saving(act_group1, replace)
***oops !! Title is incorrect !! rectify 		
twoway (connected act fyear if tic=="IBM", sort msize(small)) ///
		(connected act fyear if tic=="MSFT", sort msize(vsmall)) ///
		(connected act fyear if tic=="ORCL", sort msize(vsmall)) ///
		(connected act fyear if tic=="XRX", sort msize(vsmall)) , ///
		ylabel(#10, angle(horizontal) grid) xlabel(#25, angle(forty_five) grid) ///
		title(Current Assets ) subtitle((1980 - 2014)) ///
		legend(order(1 "IBM" 2 "MSFT" 3 "ORCL" 4 "XRX")) scheme(sj) saving(act_group1, replace)
***Better solution : Automate title syntax
*** I search google for the words "stata report variable name graph title" which leads me to
*** http://www.stata.com/statalist/archive/2006-10/msg00909.html (second item when I ran the search)
*** and found Nick Conx's suggestion to use "title(Scatter plot for `: variable label `v'')"
*** which led me to try the following code (see line 81):
twoway (connected act fyear if tic=="IBM", sort msize(small)) ///
		(connected act fyear if tic=="MSFT", sort msize(vsmall)) ///
		(connected act fyear if tic=="ORCL", sort msize(vsmall)) ///
		(connected act fyear if tic=="XRX", sort msize(vsmall)) , ///
		ylabel(#10, angle(horizontal) grid) xlabel(#25, angle(forty_five) grid) ///
		title(`: variable label act' ) subtitle((1980 - 2014)) ///
		legend(order(1 "IBM" 2 "MSFT" 3 "ORCL" 4 "XRX")) scheme(sj) saving(act_group1, replace)

*** Yet better : Allow tickers to be customized
*** This can be thought of as the next step in making the program more general.
*** Key is to learn to use lists of names (of variables, tickers, statistics) that we will type once
***  and then ask Stata to use to perform various tasks for each value in the list.  In Stata, these 
*** lists can be specified in two ways: "local" and "global"
*** to specify a "local" list we type
*** local list1 = "item1 item2 item3"
*** to specify a "global" list we type 
*** global list1 = "item1 item2 item3 ..."
*** Now let us apply this logic to our setting.
*** First, let's specify each ticker as a local of its own. 		
local 1 = "IBM"
local 2 = "MSFT"
local 3 = "ORCL"
local 4 = "XRX"
* Now let's see how to call locals in our command
twoway (connected act fyear if tic=="`1'", sort msize(small)) ///      // note that the local "1" is being called as `1' and wrapped in ""
        ///                                                            // telling Stata to treat the content of `1' as a string
	   (connected act fyear if tic=="`2'", sort msize(vsmall)) ///
	   (connected act fyear if tic=="`3'", sort msize(vsmall)) ///
	   (connected act fyear if tic=="`4'", sort msize(vsmall)) , ///
	   ylabel(#10, angle(horizontal) grid) xlabel(#25, angle(forty_five) grid) ///
	   title(`: variable label act' ) subtitle((1980 - 2014)) ///
	   legend(order(1 "`1'" 2 "`2'" 3 "`3'" 4 "`4'")) scheme(sj) saving(act_group1, replace)
***Safer: use macro + tokenize to make tickers customizable
*** I want to type all firm names as one list then have stata automatically 
*** parse it into a list of items which I will then be able to call as locals.
*** For reasons that will be clearer later, it is useful to specify such a "master" list
*** as a global string.  I also need to find a Stata command that will parse the master
*** list into a sequence of named elements.     
***  As before, I search google for the words "parse macro stata" ... the first page 
***  it returns is the page for the Stata command "tokenize" which will do the job but
***  it turns out that it is better to use instead the more-general user-written command "tknz"
***  which we will want to download and install if it is not already installed.  The following 
***  block of code addresses these tasks
global tlist = "IBM MSFT ORCL XRX"
capture ssc install tknz                                        // find and install from the wbe the user-written program "tknz" if it is not already installed
tknz $tlist, s(tic)                                             // each "word" of $tlist will now be stored in a local named _tic1 _tic2 etc ...
macro list                                                      // demonstrate how tknz has created _tic1 _tic2 _tic3 etc ..and stored the respective tickers in them
* now use the local macros "`tic1'" etc. in the loop
twoway  (connected act fyear if tic=="`tic1'", sort msize(small)) ///
		(connected act fyear if tic=="`tic2'", sort msize(vsmall)) ///
		(connected act fyear if tic=="`tic3'", sort msize(vsmall)) ///
		(connected act fyear if tic=="`tic4'", sort msize(vsmall)) , ///
		ylabel(#10, angle(horizontal) grid) xlabel(#25, angle(forty_five) grid) ///
		title(`: variable label act' ) subtitle((1980 - 2014)) ///
		legend(order(1 "`tic1'" 2 "`tic2'" 3 "`tic3'" 4 "`tic4'")) scheme(sj) saving(act_group1, replace)

***Do this for all balance sheet items
* define balance sheet varlists as a series of globals
 global B1 ="at lse"
 global B2 ="act ppent ivaeq ivao intan ao lt mib teq"                                           // complete on your own
 global B3 ="che  rect  invt  aco  ppegt dpact gdwl intano  dc  aox lct  dltt  txditc lo"        // complete on your own
 global B4 ="ch ivst rectr txr recco invrm invwip invfg invo xpp acox aldo"                      // complete on your own

*** Now we can set up a loop in which, for each word of the list $B1 
*** Stata will make the graph we have developed so far and save it. 
***  One of us initially coded this as follows:
/*
 foreach x of global B1 { 
 twoway (connected `x' fyear if tic=="IBM", sort msize(small)) ///
		(connected `x' fyear if tic=="MSFT", sort msize(vsmall)) ///
		(connected `x' fyear if tic=="ORCL", sort msize(vsmall)) ///
		(connected `x' fyear if tic=="XRX", sort msize(vsmall)) , ///
		ylabel(#10, angle(horizontal) grid) xlabel(#25, angle(forty_five) grid) ///
		title(`: variable label `x'' ) subtitle((1980 - 2014)) ///
		legend(order(1 "IBM" 2 "MSFT" 3 "ORCL" 4 "XRX")) scheme(sj) saving(`x'_group1, replace)
		}
*/
*** but then we decided to use the stata "foreach ... in ... " syntax which is
*** more forgiving for beginners ...
 foreach x in $B1 {
twoway  (connected act fyear if tic=="`tic1'", sort msize(small)) ///
		(connected act fyear if tic=="`tic2'", sort msize(vsmall)) ///
		(connected act fyear if tic=="`tic3'", sort msize(vsmall)) ///
		(connected act fyear if tic=="`tic4'", sort msize(vsmall)) , ///
		ylabel(#10, angle(horizontal) grid) xlabel(#25, angle(forty_five) grid) ///
		title(`: variable label act' ) subtitle((1980 - 2014)) ///
		legend(order(1 "`tic1'" 2 "`tic2'" 3 "`tic3'" 4 "`tic4'")) scheme(sj) saving(act_group1, replace)
                  }
*** Which predictably did not do what we had in mind. (Why "predictably"?)
*** So let's try to correct.  Also while we're at it, just for fun, let's add another list to the loop.
 foreach x in $B1 $B2 {
 twoway (connected `x' fyear if tic=="IBM", sort msize(small)) ///
		(connected `x' fyear if tic=="MSFT", sort msize(vsmall)) ///
		(connected `x' fyear if tic=="ORCL", sort msize(vsmall)) ///
		(connected `x' fyear if tic=="XRX", sort msize(vsmall)) , ///
		ylabel(#10, angle(horizontal) grid) xlabel(#25, angle(forty_five) grid) ///
		title(`"`: variable label `x''"' ) subtitle((1980 - 2014)) ///
		legend(order(1 "IBM" 2 "MSFT" 3 "ORCL" 4 "XRX")) scheme(sj) saving(`x'_group1, replace)
		}
*** which gets us closer to the goal.  		
*** Which is to run the loop over all B/S elements.
 foreach x in $B1 $B2 $B3 $B4 {
 twoway (connected `x' fyear if tic=="IBM", sort msize(small)) ///
		(connected `x' fyear if tic=="MSFT", sort msize(vsmall)) ///
		(connected `x' fyear if tic=="ORCL", sort msize(vsmall)) ///
		(connected `x' fyear if tic=="XRX", sort msize(vsmall)) , ///
		ylabel(#10, angle(horizontal) grid) xlabel(#25, angle(forty_five) grid) ///
		title(`"`: variable label `x''"' ) subtitle((1980 - 2014)) ///
		legend(order(1 "IBM" 2 "MSFT" 3 "ORCL" 4 "XRX")) scheme(sj) saving(`x'_group1, replace)
		}
*** And the final step would be throw in the Income statement and Cash flow variables as well. 
*** Which leads us to:
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

 * and indulging in our eeror-phobia one more step.
 global all ="$B1 $B2 $B3 $B4 $I1 $I2 $I3 $I4 $C1 $C2 $C3 $C4"
 
 foreach x in $all {
 twoway (connected `x' fyear if tic=="IBM", sort msize(small)) ///
		(connected `x' fyear if tic=="MSFT", sort msize(vsmall)) ///
		(connected `x' fyear if tic=="ORCL", sort msize(vsmall)) ///
		(connected `x' fyear if tic=="XRX", sort msize(vsmall)) , ///
		ylabel(#10, angle(horizontal) grid) xlabel(#25, angle(forty_five) grid) ///
		title(`"`: variable label `x''"' ) subtitle((1980 - 2014)) ///
		legend(order(1 "IBM" 2 "MSFT" 3 "ORCL" 4 "XRX")) scheme(sj) saving(`x'_group1, replace)
		}



log close
exit  


