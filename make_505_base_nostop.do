version 13.1
capture log close

set more off
log using make_505_base_nostop.log, replace

* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
* Notes
* Created   March 31, 2015 c. 14:30 by RD
* Revised   March 31, 2015 c. 11:30 by RD
* Revised   April 02-03, 2015       by RD 
*             ... this version comments out breaks in the training version
* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

* &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
* Explanatory notes
* This file walks you through a series of simple tasks like importing & summarizing 
* and tabulating and plotting variables.
*
* There are a number of steps. After each step I have inserted two commands that cause 
* Stata to write out the log file and exit.  Each time this happens, you should review the log file
* created up to that stage then come back to this file and comment out the last two commands before
* Stata stopped.  That will allow the program to run up to the next stopping point.
*
* You will have to do this several times and the process may take a while, so feel free to
* work on this as far as you and then come back to it after Day 2.
*
* &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

* import WRDS data file
use query0_USA_2013, clear

* review import
desc
summ 

***************
* Housekeeping
***************

* Step 1 Reorder vars
* We want the variables to be contiguous groups so that when we use the data viewer, to scan the data, it makes sense ...
* The following command is commented out, study it, then uncomment it, save the file and run it.
* What changes do we see on the screen?

* order gvkey conm cik cusip tic costat fic exchg  datadate fyear fyr fyrc  sic sich naics indfmt consol popsrc datafmt curcd at lt ceq rev cogs

* log close
* exit

*******************
* Elementary tasks
*******************

* Step 2: A scatter plot
* One-way
* sc at

* oops, plots need two variables, "plot of y against x"
* Step 3: how about a histogram?  Let's comment out the previous command by placing a star before it and 
* typing the following command, save the .do file and rerun
hist at

* log close
* exit

* Step 4: That picture is not very informative, because at (Total Assets) can take some pretty large values (outliers).
* Such values cause scale compression and can obscure patterns in the data at large.

* Step 5.  Cure 1: transform the data to rescale and reduce the impact of outliers
* Implementation: let's log-transform the at variable, save the .do file and rerun ...
g lat=ln(at)

hist lat

* log close
* exit

* Step 6.  Cure 2: drop the outliers and plot the data.  The simplest way to identify outliers is to use an ad-hoc approach. 
* Simply compute the percentiles of the variable in question, then plot a histogram of the data for values smaller
* than the cutoffs 
* Note that one can find cutoffs by summarizing the data using the det option:
qui summ at, det
* stata helpfully saves quantiles in memory
return list

* log close
* exit

* step 7.  naming these quantiles for later use
g cutoff1=r(p95)
g cutoff2=r(p90)

* log close
* exit

* Step 8.  Using the cutoffs to draw histograms.
* First using the 95th percentile cutoff
hist at if at<cutoff1

* log close
* exit

* Step 9.  Next using the 90th percentile cutoff
hist at if at<cutoff2

* log close
* exit

* Step 10.  Lets try a two-way plot
sc at lt

* again, we see the impact of scale compression at work
* how will you fix this?
* open for you to resolve ....

* log close
* exit

* Step 11.  Tabulate the data

* First let's tabulate fiscal year ends
tab fyr

* log close
* exit

* and then industries
tab sic

* log close
* exit

* Step 13.  Let's make 2-digit SIC codes by destringing sic and converting it into a digit number 
destring sic, force replace  // see help destring
summ sic                     // note it is not str4 any more

* Step 14.  Now we can make 2-digit sic codes
g sic2=int(sic/100)          // int() retains the integer part of the result, see help gen

* Step 15.  lets tabulate the data again
tab sic2

* log close
* exit

* Step 16.  now a two-way tab
tab sic2 fyr

* log close
* exit

* Step 17.  how about a more interesting plot?
sc sic2 at

**********
* Closing
**********

* Step 18.  save the data and exit
save day2_temp, replace

log close
exit

/*

Add comments and notes below.

1.  As we get more practice, we'll run the entire .do file in one go.  

2.  Learn the `table' and `tabstat' commands.

3.  Learn to `collapse' the data.

4.  Learn to create new variables using the `gen' and `egen' commands. 
