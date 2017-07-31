version 13.1
set more off
capture log close
log using Lesson_1.log, t replace

* created 20170719 by RD
* illustrate certain commands ... to be assimilated into teaching files

* use data
use "CompustatAll20102016.dta", clear

* how many firms?
*  gvkey is the unique firm identifier, so count number of distinct gvkeys
egen gvk=group(gvkey)      // each gvkey gets a distinct number
la var gvk "firm id"
summ gvkey, det
order gvkey gvk            // move gvk to the "front" of the data set
br gvkey gvk datadate      // browse gvkey gvk 

* how many observations are duplicates?
*  As accountants, we expect that a firm will issue a single set of f/s on any reporting date, i.e.,
*   a firm cannot have more than one set of f/s per reporting period.
*  In Compustat, a gvkey and datadate (fiscal period end or, equivalently, "reporting date") combination
*   will normally identify a firm-year combination ... but there are exceptions.  We want to understand this
*   a bit more closely before doing anything with the data.

*  First, a small, but useful digression.  It stands to reason that both gvkey and datadate should 
*   never be missing for any observation ... let's check this by creating a "flag" for those cases 
*   where both are missing: generate a variable that takes the value 1 iff. both are missing and is
*   itself missing when both are present ...
describe gvkey datadate                        // let's find out the datatype of the variables of interest
generate temp = 1 if gvkey=="" & datadate==.   // note difference in syntax for missing values of gvkey (text) and datadate (number)
tabulate temp, missing                         // tabulate values of temp, making sure missing values are included in the tabulation
* we can create a flag slightly differently as well
g    temp2 = (gvkey=="" & datadate==.)     // generate contracted to g, if condition is implicitly specified  ... time to read the manual :)
tab  temp2, miss                         // tabulate again, note the contraction of the option specification
* let's cross tabulate the two variables we created ... 
tab  temp temp2, miss
* and now x-tabulate without the mssing optiop
tab  temp temp2                          // w/o the missing option, we do not get a tabulation any more 
drop temp temp2                         // don't need these any more

* ===============================  Reflection  =================================
*  Make some notes on what you learned so far about understanding your data set
*   Why is it useful to create gvk?  To get count of gvkeys?
*   Why is it important to understand the role of gvkey and datadate, each by itself 
*    and acting in tandem with the other?  
*   Is it useful to tabulate temp, temp2, and to xtab temp vs temp2?  Yes or No?  Why?
*   Is it useful to tabulate with the missing option?  Y or N?  Why?
*   What is the difference between the contents of temp and temp2?  
*    Is one better than the other?  Why or why not?
*    Is it useful to know two different ways to code temp and temp2?  Why?  
* ==============================================================================

* Next let us better understand the structure of any duplicate observations.
*  Reading the manual tells us that gvkey + datadate may not uniquely identify
*   observations because of differences in indfmt, datamft, consol, etc ... so
*   we now want to understand how pervasive this problem is in the dataset
* We will got through this in sequence:
duplicates tag gvkey datadate, generate(temp)     // first tag duplicates
tab temp                                          // if no dups, should be all 0s                               
tab temp indfmt                                   // xtab temp against indfmt, most common cause of dups
*
* If duplicates=1 has more than one format, what does that mean?
*

* Now let's clean up the duplicates by dropping obs with unwanted indfmt ...
desc         indfmt                                       // we know indfmt is string, but why not check
drop         if indfmt=="FS"                              // get rid of all obs with unwanted indfmt
drop         temp                                         // drop temp, we are about to regenerate it
duplicates t gvkey datadate, g(temp)                      // note syntax contraction 
* 
* Did this get rid of all duplicates? 
*  If it did, output should be null.
*  If not, can you deal with duplicates in datafmt, consol, etc.?
*
drop temp
* Copy code for fyearlen and associated tutorial code.
*by gvkey: g fyearlen = datadate[_n] - datadate[_n-1]

* having gotten rid of duplicates, let us count the number of observations per gvkey
* First sort the data by gvkey and datadate(Why not by datadate and gvkey in that order?)
sort gvkey datadate
by gvkey: g    nobs1=_N                      // number of years the gvkey appears in the data set
by gvkey: egen nobs2=count(gvk)              // number of years the gvkey appears in the data set
by gvkey: egen nobs3=count(datadate)         // number of years the gvkey appears in the data set
* reoder the variables for ease of inspection
order gvkey gvk datadate nobs*
* summarize
su    nobs*, det
* and browse ...
br
*
*  What differences do you expect to see between the three different nobs variables?  Why?
*

* Different tabulations of the three variables ...
ta nobs1                                      // note syntax contaction
ta nobs2
ta nobs3
ta nobs1 nobs2                                // now two-way tabulations ..
ta nobs1 nobs3                                //  another two-way tabulation
ta nobs2 nobs3                                //  and the third possibility
bys nobs3: ta nobs1 nobs2                     // note the use of bys to get a 3-way tabulation
br                                            // browse the data ... what do you see?
* 
* Is this what you expected to see?  Why or why not?
*  Do you see what bys does to the data organization?
*  What are the implications of using bys for your subsequent programming?
*

* let's bet back to where we were before running the last bys
sort gvkey datadate
br
*
*  Do you now better understand what bys and sort do?
*

* Making a decision ...
* to identify number of company years for which reports are available, which of the
*  three nobs values is best? Let's keep that and drop the other two and rename and
*  label the retained variable
drop nobs1 nobs2
ren  nobs3 nyears                                                   // rename
la var nyears "number of datadates available for a given gvkey"     // label the renamed variable

* now let's study again the different information provided by desc, inspect codebook, sum and ta
desc     nyears
inspect  nyears
codebook nyears
su       nyears, det
ta       nyears
*                        
* Reflection: in 250 words or less, interpret this table.  How useful is it?
* What improvement would you like to see?
* tab nyears if fyearlen ==. // answer
* 

* *************************** Note *****************************
* The process of creating, describing, inspecting, codebooking
* summarizing and tabulating the variables we create is part of 
* the KYD ("know your data") security system that is central to
* good analytical hygenie and obtaining reliable/interpretable
* conclusions.
* **************************************************************

* 2222222222222222222222222 - Question - 222222222222222222222222
*  Record some new reflections on the work you have done so far. 
*  Your reflection should address the following questions:
*   Is there anything you have seen so far that you cannot do in Excel?
*   How would you update the analysis sor far given one more year of data?
*    In Excel?  In Stata?
*   What if you had new data coming in every day/week/month/quarter?
*   Would you trust the results coming from Excel?  Stata?
*    explain why the two answers above differ ...
* 2222222222222222222222222 - Question - 222222222222222222222222

* exit nicely
log close
exit

* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
*   ------ C O D E  L O C K E R ------
* Cut and paste scrap/test/obsolete code
*  below this line, not to be run ...
* ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/* 
