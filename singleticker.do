 version 13
 set more off
 clear all
 capture log close
 log using "singleticker", text replace
 
* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
* NOTES
*  This file tries to solve the following problem:
/*
As discussed, I'm trying to simplify the plot code so that a single ticker can be entered as a target of interest, 
with all industry classifications being auto-calculated.  I'm sure there is a cleaner way to do this, but my best 
solution (so far) is to temporarily remove all data that is not for the target company, then remove all lines that 
are not in the most current fyear, then store the sic/kdj/ffind values in globals.

global tic_of_interest "MT"    /// the only value the user must enter
preserve
keep if tic == "`$tic_of_interest'"   /// this isn't working - seems to remove all lines with any ticker value (only blanks remain)
local max_year = max(fyear)     /// doesn't work either
keep if fyear = $max_year      /// should remove all lines except the most recent for the target ticker.  Should...
global sic4_of_interest = max(sic)    /// probably a better way to do this
restore

As you may have guessed, the above doesn't work.  Do you have any thoughts on an efficient way to capture the sic2 (or kdj) of interest into a global?

Thanks,
Kyle

More rudimentary:  I allowed the user to enter the 4-digit SIC, then calculated the SIC2 and SIC3, but have the same issue making a global for KDF and the ffind's.

 global sic4_of_interest "3312"
 global sic2_of_interest = int($sic4_of_interest / 100)
 global sic3_of_interest = int($sic4_of_interest / 10)

*/
*  author: Rajib Doogar
* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
*  The following references about some "advanced" aspects of Stata programming are worth reading:
*  1. Stata User Guide Chapter 18 Programming, especially Section 18.1 thru 18.3
*  2. Overview at http://www.econometricsbysimulation.com/2012/06/stata-programming-basics-macros.html
*  3. Overview at http://data.princeton.edu/stata/programming.html
*  4. Using the Stata - include - command to help manage macros: http://tinyurl.com/globalmacrobinding
* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
* Final observation:   --- IMPORTANT --- 
*  1. Cut and paste everything below line by line in your Stata session
*      to ensure macros work as intended in batch mode.
*  2. Many lines include comments starting with "//", delete these comments
*      before running the code interactively.  Interactive mode is *not* 
*      comment friendly! 
* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

 use basedata_2005_2014, clear
 
 * Solving the first problem, that of keeping only one ticker
     * for the purposes of this demo changing tic_of_interest to IBM as MT is not in basedata 
 global tic_of_interest "IBM"      // the only value the user must enter  ( note the use of the double slash for commenting, triple slash is the escape code in Stata for "ignore line break")

 preserve
 keep if tic=="$tic_of_interest"   // global macros don't need the left-quote-right-quote-wrapper
 br
 li fyear gvkey tic                // how many obs do we expect to be listed?
 
 * Second problem, creating a local macro that stores the max value of fyear
 restore
 preserve
 keep if tic=="$tic_of_interest"   // global macros don't need the left-quote-right-quote-wrapper
 summ fyear                        // first summarize fyear ... this causes Stata to compute the max (among other stats)
                                   //  and store it in memory as a "result" ... an r-class datum in Stata jargon
 return list                       // now ask Stata to list the contents of the r-class registers which are all locals 
                                   //  with the wrapper r() ... note also that this step of listing the contents is optional
 local max_year = `r(max)'         // now assign the contents of the macro `r(max)' (note the left-quote-right-quote call)
 di `max_year'                     // one way to show contents of `max_year'
 macro list                        // another way: list all macros and see if _max_year contains desired value
 keep if fyear == `max_year'       // since max_year was created as a local, not a global macro, it must be called with the 
                                   //  left-quote-right-quote wrapper used for locals (rather than the "$" prefix used for globals)
 br								   
 li fyear gvkey tic                // how many obs do we expect to be listed now?
 
 restore
 
 * Third problem, storing sic4 of interest as a global 
 * my basedata does not have sic4 or sic3 defined (btw sic4 is the same as sic) so
 * we create those first
     g sic4=sic
     g sic3=int(sic/10)
 * now to the main task of interest 
 summ sic4 if tic=="$tic_of_interest"
 global sic4=`r(mean)'
 di $sic4
 summ sic3 if tic=="$tic_of_interest"
 global sic3=`r(mean)'
 di $sic3
 summ sic2 if tic=="$tic_of_interest"
 global sic2=`r(mean)'
 di $sic2
 macro list
 
 * Fourth problem, generalization of the third problem, storing any industry of the ticker of interest as a local
 * By now we have learned it is safer and more efficient to do this by looping over a defined list of industries
   * clearing the decks ... !! for demo purposes only!! do not cut and paste into a working program  
 macro drop _*                      // clear all existing local macros 
 macro drop s*                      // clear the global sic macros
 macro list                         // check
 * Now the loop of interest ...
 global indlist  "sic sic2 sic3 sic4 kdj ffind05 ffind10 ffind12 ffind17 ffind30 ffind38 ffind48 ffind49" 
 foreach x in $indlist {
 di "industry is now defined as " `x'
 summ `x' if tic=="$tic_of_interest"
 di "mean of `x' for $tic_of_interst is " `r(mean)' ", and its sd (expected value 0) is " `r(sd)' 
 local `x'=`r(mean)'                          // using locals, not globals as per caution above     
 di "`x' == " ``x'' ", mean == " `r(mean)'     // note the use of ``x'' to call the local macro just defined
                       }
macro list                        // look at contents of local macros ...

* Some further discussion of Stata programming language and the use of quotes.
* The idea behind ``x'' is useful to think through ... roughly the inner `x' is the string (e.g., sic or sic2 
* that is being looped over, so Stata unpacks the instruction "di ``x''" to "di `sic2'" and then looks for a 
* local macro called "sic".  If you "di `x'" (i.e., omit the second set of quotes) inside a loop, Stata does 
* not know clearly which `x' you mean: do you mean for stat to display the value it is looping over (sic) or
* do you mean the local macro `sic' which is, for Stata, a different animal altogether. 
* Again, I recommend you start with Section 18.1 thru 18.3 of the Stata User Guide.  

 * What if we had a list of tickers instead for which we wanted to store the industries ...
 macro drop _all                   // as before, for demo purposes only, don't copy into working program
 global indlist "sic sic2 sic3 sic4 kdj ffind05 ffind10 ffind12 ffind17 ffind30 ffind38 ffind48 ffind49" 
 global ticlist "IBM XRX ORCL MSFT"
 foreach a in $ticlist {
 foreach x in $indlist {
 summ `x' if tic=="`a'"
 local `x'_`a' = `r(mean)'
 di "The local macro `x'_`a' stores the value " ``x'_`a''
                      }
					  }
 * check if macros have the correct information  
 macro list
 * Important practice tip: calling local macros made and stored elsewhere or read in from
 * a global library using the - include - command from inside a loop (see  
 * the double-single-quote syntax ``x'_`a'' should be familiar
 * from the preceeding discussion
   *         *
   * Warning *
   *         *
 * The following code generates long lists of output ...
 foreach a in $ticlist {
 foreach x in $indlist {
 * check if recall works as expected ... usse ``x'_`a'' to select observations to list
 li gvkey fyear tic `x' if `x'==``x'_`a'' 
 * use `x'_`a' in a di command ... 
 di "The local macro `x'_`a' stores the value " ``x'_`a''
                      }
					  }
 * **********
 * Last exercise ... work through this BUT see http://tinyurl.com/globalmacrobinding
 * What if we MUST make globals? 
 macro drop _all 
 global indlist "sic sic2 sic3 sic4 kdj ffind05 ffind10 ffind12 ffind17 ffind30 ffind38 ffind48 ffind49" 
 global ticlist "IBM XRX ORCL MSFT"
 foreach a in $ticlist {
 foreach x in $indlist {
 qui summ `x' if tic=="`a'"
 global `x'_`a' = `r(mean)'                   
 di ${`x'_`a'}                      // note the use of { and } to "bind" `x'_`a' as Stata does the expansion [U 18.3.10 Programming]
                      }
					  }
 macro list


 * ****************
 * Exit nicely
 * ****************
 log close
 exit
