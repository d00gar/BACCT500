version 13.1
set more off
capture log close
log using Stat2.log, t replace

* Lesson 2
* Understanding randomness

* Please review Stat1.do for instructions on completing the exercises

*  Student name:          Master Accountant
*  UW netid:              acct007@uw.edu 

* Introductory comments
*  Graphs are a powerful way to understand the concept of a random variable
*  In this exercise we will examine a bit more closely this concept.

* <> || << |o| >> || <> || << |o| >> || <> || << |o| >> || <> || << |o| >> || <>
/*  Definitions

o Random variable (rv): a variable whose values are determined by forces unknown and
   of no particular interest to the analyst.  Such forces are beyond the scope
   of the analysis and the analyst feels no obligation to further analyze the
   data to shed light on the causes of these fluctuations.
   
o Data generating process (dgp): a process that generates random variables with
   some known determinants. Also called a random process (rp). 
   
o Values of an rv: specific realizations of the rv, outcomes from a dgp.

o Distribution of an rv: listing of all possible values of an rv together with
   the proportion of times (probability) each value will be realized, the most
   complete possible mathematical characterization of a dgp. 
   
   + the values of the known determinants of an rv are called its domain
   + the values the rv can take is called its range
   + the relative proportion of times each value in the range is realized is 
     called its frequency and the collection of frequencies of all possible
	 values of the rv is called the frequency distribution of the rv.
   + the set of all possible distributions cannot be described except in the
     most abstract way. As a practical matter, analysts therefore generally 
	 assume that the data are obtained from a particular class of well studied
	 random processes.  
	 - every analyst should remember that the data being analyzed could well be
	   the realization of an infinite number of dgps.  
	 - If follows, threfore, that conclusions from even the most sophisticated 
	   data analyses are only valid to the degree to which the analyst has 
	   correctly identified the class of dgps.  "Every test of a hypothesis is
	   a joint test of the hypothesis and the class of dgp."
   
o The sun is a dgp. The number of photons arriving at a specific location in 
   space within a certain time frame is a random variable with a distribution
   that is determined by the location (the surface of the earth, a totally 
   enclosed room, a square foot of lunar surface on the "dark" side of the moon,
   a point in deep space).
   
o A factory is a dgp.  A product line is a dgp.  Accounts receivable is a dgp.
   In each case, can you tell why?   

 Finally, some points to keep in mind when analyzing data and presenting the
 findings of any data analysis
 
   + in general, the true dgp and distribution are never known to the analyst
   + the purpose of statistical analysis is to discover the "true" dgp from a
     sample (possibly large) of realizations of an rv.
	 - in practice, one can never know the true dgp, but given enough data, for
	   a decently well-behaved dgp, one can bound the amount of error in one's
	   estimate of the parameters of the dgp.
	 - for practical purposes, analysts work with well understood distributions
	 - improvements in computational power allow analysts to work with other
	   distributions by simulating them, but this is computation-intenstive and
	   has its own challenges
   > In sum: With some luck, statistics can help us know closely enough if some 
       "standard" dgp can be assumed to describe - at least to an acceptable
	   degree of closelness, the actual dgp from which the data are drawn. The 
	   process of identifyng the dgp is called "estimation (of dgp parameters)."
 
   + for a posited dgp one can use the sample of realizations to form and test 
     hypotheses (conjectures) about the dgp. 
	  
   + 
   
* <> || << |o| >> || <> || << |o| >> || <> || << |o| >> || <> || << |o| >> || <>
*/

* Let us start by generating some random variables
clear                    // clear data in memory
set obs 250000             // set sample size
set seed 34786543        // initialize random number generator (using the same seed for comparability)

* generate realizations from some widely used classes of random functions:
*  + binomial
*  + negative binomial
*  + possion
*  + uniform
*  + normal
*  + beta
*  + gamma
*  + t

 // see "help random_number_functions" for more information

* "discrete" distributions 
 // binomial
g  bin705       =rbinomial(7,.05)
la var bin705   "rv, binomial(7,.05)"
g  bin7005      =rbinomial(70,.05)
la var bin7005  "rv, binomial(70,.05)"

 // negative binomial
g  nbin705      =rnbinomial(7,.05)
la var nbin705  "rv, nbinomial(7,.05)"
g  nbin7005     =rnbinomial(70,.05)
la var nbin7005 "rv, nbinomial(70,.05)"

 // possion
g  pois5        =rpoisson(5)
la var pois5    "rv, possion(5)"
g  pois15       =rpoisson(15)
la var pois15   "rv, possion(15)"

* "continuous" distributions
 // uniform
g  unif         = runiform()
la var unif     "rv, uniform(0,1)"
g  unif28       = 2 +(8-2)*runiform()
la var unif28   "rv, uniform(2,8)"

 // normal
g  norm         = rnormal()
la var norm     "rv, n(0,1)"
g  norm2        = rnormal(2)
la var norm2    "rv, n(2,1)"
g  norm78       = rnormal(7, 8)
la var norm78   "rv, n(7,8)"

 // chi2
g  chi210       = rchi2(10)
la var chi210   "rv, chi2(10)"
g  chi2100      = rchi2(100)
la var chi2100  "rv, chi2(100)"

 // F
g  f22          = invF(2,2,unif)
la var f22      "rv, F(2,2)"
g  f2100        = invF(2,100,unif)
la var f2100    "rv, F(2,100)"

 // t
g  t10          =rt(10)
la var t10      "rv, t(10)"
g  t30          =rt(30)
la var t30      "rv, t(30)"
g  t100         =rt(100)
la var t10      "rv, t(100)"

 // beta
g  beta11       = rbeta(1,1)
la var beta11   "rv, beta(1,1)"
g  beta15       = rbeta(1,5)
la var beta15   "rv, beta(1,5)"

 // gamma
g  gamma11      = rgamma(1,1)
la var gamma11  "rv, gamma(1,1)"
g  gamma15      = rgamma(1,5)
la var gamma15  "rv, gamma(1,5)"

* [] {} () | - o 0 o - | () {} []       oo       [] {} () | - o 0 o - | () {} []
* ][ }{ )( | - 0 o 0 - | )( }{ ][       00       ][ }{ )( | - 0 o 0 - | )( }{ ][ 
* [] {} () | - o 0 o - | () {} []       oo       [] {} () | - o 0 o - | () {} []

*              ----------------------------------------------------              
*              |><|><|><}><|><|><|><|><}><|><|><|><|><}><|><|><|><|
*              ----------------------------------------------------
local varlist "unif norm chi22 f2100 t100"
local varlist "unif norm"
di `"`varlist'"'

* add code to plot f(x)
foreach x of varlist " "
kdensity `x', saving(kdensity_`x', replace)
}

* add code to visually compare distirbutions 

* now plot F(x)
 // univariate plot
 
 // two at a time etc ...
foreach x of var `varlist' {
foreach y of var `varlist' {
if "`x'"!="`y'" {
sort `x'
g Fx = _n/_N
g px = 1/_N
sort `y'
g Fy = _n/_N
g py = 1/_N
sc Fx `x', mcolor(blue green) msymbol(d dh) msize(small) || ///
sc Fy `y', mcolor(red purple) msymbol(o oh) msize(small)
drop Fx px Fy py
}
}
}
set trace off


/*
sc  v7  v0, mcolor(blue) msymbol(+) msize(small)   ||                  ///
sc  v10 v0, mcolor(red)  msymbol(d) msize(small)                       ///
     legend(off)                                                        ///

/* Exercise 1.Final  A final reflection exercise for today.
    As you look back at what you've done, did you ever tell yourself "This is
     not accounting!"?  It sure isn't anything like what we normally learn or
     use in accounting classes or use in doing day-to-day accounting.  So why
     drag us through all this review of stuff we will never use in our 
     professional lives?
    If you did, you are not alone.  This is a very normal question to ask. 
     The answer is obvious, but discovering it for yourself and stating it in 
     your own words is likely to be more productive in the long run. One way 
     to do this is to set out in 50-75 words your views on the proposition:
       Any accountant who fails to see that accounting is a branch of 
	   applied statistics does not truly understand what accounting does,
	   how accounting data is produced or the nature and properties of 
	   accounting data.  Such a person does not understand accounting!    */
*               - Provide your answer below, adding lines as needed -
*
*	   
*
*
*

* Last step
* Save this do file, run it start to finish and upload it and the log file
*  to Canvas.  Do not work on the code below till you have uploaded.

*   -------------            Begin stretch exercise             -------------
*********                                                              *********
******                           FOR AFTERHOURS                           ******
***            Warning:  Not for the faint of heart or the pain-averse.      ***
******                                                                    ******
*  Note 1:  If you want to hack this, you have found your true home.  Welcome!
*  Note 2:  If you don't want to hack it, ignore it for now.  We'll do it less
*            far less painfully later.  But you'll have to wait and we may not
*            get there for a while and in as much detail.
******                                                                    ******
*  Parse and understand the following code, then uncomment and run it.
/*
foreach t of var v1-v9 {
qui su `t', det
local mit  = int(round(r(min),1))
local mat  = int(round(r(max),1))
local mut  = int(round(r(mean),1))
local fqt  = int(round(r(p25),1))
local met  = int(round(r(p50),1))
local tqt  = int(round(r(p75),1))
qui su v10, det
local mi10 = int(round(r(min),1))
local ma10 = int(round(r(max),1))
local mu10 = int(round(r(mean),1))
local fq10 = int(round(r(p25),1))
local me10 = int(round(r(p50),1))
local tq10 = int(round(r(p75),1))							
line `t' v0, lcolor(red) lpattern(l) lwidth(medium) ||                  ///
line v10 v0, lcolor(blue) lpattern(l) lwidth(thin)  ||                  ///
 sc  `t' v0, mcolor(blue) msymbol(+) msize(small)   ||                  ///
 sc  v10 v0, mcolor(red)  msymbol(d) msize(small)                       ///
     legend(off)                                                        ///
	 yli(`mut', lp(l) lc(blue)) yli(`met', lp(dash) lc(blue))           ///
	 yli(`mit'  `fqt'  `tqt'  `mat', lp(dot) lcolor(blue))              ///
	 yli(`mu10', lp(l) lc(green)) yli(`me10', lp(dash) lc(green))       ///
	 yli(`mi10' `fq10' `tq10' `ma10', lp(dot) lc(green))                ///
     title("Line plot of `t' and v10 against v0" "A generic dataset")   ///
     saving(linescatter_`t'v10_v0, replace)
	                   }
*/

* When you get it, go out and celebrate.  The ability to effortlessly (!) unlock
*  the secrets of accounting data is now at your fingertips.

*   -------------             End stretch exercise             -------------

* exit nicely
log close
exit

* ==========================================================
*                           Code locker
* ----------------------------------------------------------
* Topics left for future lessons:
 -- deeper dive into random variables
 -- generating rvs
 -- model identification
 -- hypothesis testing
 -- prediction

/*

* ------------------------------------------------------------------------------
* set trace on
foreach v of varlist v1-v10 {
su `v', det
sc `v' v0, saving(`v'_sc, replace)
line `v' v0, saving(`v'_li, replace)
hist `v', saving(`v'_hist, replace)
                            }
* ------------------------------------------------------------------------------
* loop for line plot of all combinations of n variables
* set trace off
foreach v of varlist v1-v10 {
foreach w of varlist v1-v10 {
line `v' `w', saving(`v'_`w'_li, replace)
}
}
* ------------------------------------------------------------------------------


* ------------------------------------------------------------------------------
* code to illustrate level sets 							
qui su v7, det
local mi7  = int(round(r(min),1))
local ma7  = int(round(r(max),1))
local mu7  = int(round(r(mean),1))
local fq7  = int(round(r(p25),1))
local me7  = int(round(r(p50),1))
local tq7  = int(round(r(p75),1))
qui su v10, det
local mi10 = int(round(r(min),1))
local ma10 = int(round(r(max),1))
local mu10 = int(round(r(mean),1))
local fq10 = int(round(r(p25),1))
local me10 = int(round(r(p50),1))
local tq10 = int(round(r(p75),1))

 // we print out the values of the locals ... if the code crashes, reviewing 
 // this line will tell us if the error lies in how we coded the locals ...
di `"`mi7' `mu7' `fq7' `me7' `tq7' `ma7' || `mi7' `mu10' `fq10' `me10' `tq10' `ma7'"'

 // now to use the values stored in the locals as level sets, we simply add
 // a yline (look up added_line_options) at the value of the relevant local.
 //  Again, we get a bit fancy with changing linepatterns and linecolors, but
 //  all in the cause of a good graduate tutorial.

* set more off
* set trace on
line v7  v0, lcolor(red) lpattern(l) lwidth(medium) ||                  ///
line v10 v0, lcolor(blue) lpattern(l) lwidth(thin)  ||                  ///
 sc  v7  v0, mcolor(blue) msymbol(+) msize(small)   ||                  ///
 sc  v10 v0, mcolor(red)  msymbol(d) msize(small)                       ///
     legend(off)                                                        ///
	 yli(`mu7', lp(l) lc(blue)) yli(`me7', lp(dash) lc(blue))           ///
	 yli(`mi7'  `fq7'  `tq7'  `ma7', lp(dot) lcolor(blue))              ///
	 yli(`mu10', lp(l) lc(green)) yli(`me10', lp(dash) lc(green))       ///
	 yli(`mi10' `fq10' `tq10' `ma10', lp(dot) lc(green))                ///
     title("Line plot of v7 and v10 against v0" "A generic dataset")    ///
     saving(linescatter_v7v10_v0, replace)
set trace off 
set more on
* end block
* ------------------------------------------------------------------------------

* ------------------------------------------------------------------------------
* now loop for creating pairwise level sets for several variables						
foreach v of var v1-v9 {
qui su `v', det
local mit  = int(round(r(min),1))
local mat  = int(round(r(max),1))
local mut  = int(round(r(mean),1))
local fqt  = int(round(r(p25),1))
local met  = int(round(r(p50),1))
local tqt  = int(round(r(p75),1))
qui su v10, det
local mi10 = int(round(r(min),1))
local ma10 = int(round(r(max),1))
local mu10 = int(round(r(mean),1))
local fq10 = int(round(r(p25),1))
local me10 = int(round(r(p50),1))
local tq10 = int(round(r(p75),1))							
line `v' v0, lcolor(red) lpattern(l) lwidth(medium) ||                  ///
line v10 v0, lcolor(blue) lpattern(l) lwidth(thin)  ||                  ///
 sc  `v' v0, mcolor(blue) msymbol(+) msize(small)   ||                  ///
 sc  v10 v0, mcolor(red)  msymbol(d) msize(small)                       ///
     legend(off)                                                        ///
	 yli(`mut', lp(l) lc(blue)) yli(`met', lp(dash) lc(blue))   ///
	 yli(`mit'  `fqt'  `tqt'  `mat', lp(dot) lcolor(blue))              ///
	 yli(`mu10', lp(l) lc(green)) yli(`me10', lp(dash) lc(green))       ///
	 yli(`mi10' `fq10' `tq10' `ma10', lp(dot) lc(green))                ///
     title("Line plot of `v1' and v10 against v0" "A generic dataset")    ///
     saving(linescatter_`v1'v10_v0, replace)
	 }
* ------------------------------------------------------------------------------

* ----------------------------------------------------
* |><|><|><}><|><|><|><|><}><|><|><|><|><}><|><|><|><|
* ----------------------------------------------------

* ----------------------------------------------------
* |<.>|<.>|<.>| * |<.>|<*>|00|<*>|<.>| * |<.>|<.>|<.>|
* ----------------------------------------------------

* || )[{(0 *.* 0)}]( || )[{(0 *.* 0)}]( || )[{(0 *.* 0)}]( || )[{(0 *.* 0)}]( ||
* || )[{(0 *.* 0)}]( || )[{(0 *.* 0)}]( || )[{(0 *.* 0)}]( || )[{(0 *.* 0)}]( ||
* || )[{(0 *.* 0)}]( || )[{(0 *.* 0)}]( || )[{(0 *.* 0)}]( || )[{(0 *.* 0)}]( ||
