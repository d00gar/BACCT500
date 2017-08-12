version 13.1
set more off
capture log close
log using Stat2.log, replace

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
set obs 250             // set sample size
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
local varlist unif norm chi22 f2100 t100
local varlist unif norm
di "`varlist'"


* binomial(n,k,p)   nbinomial(n,k,p)   poisson(m,k)   t(,t)  chi2(df,x)   ibeta(a,b,x)  F(df1,df2,f) 

* add code to plot f(x)
* add code to visually compare distirbutions 
* Plots of actual f(x) added on a graph with histogram and kernel density by Agraj
* now plot F(x)
 // univariate plot
twoway (histogram bin705) (kdensity bin705, lpattern(solid)) (function binomialp(7,x,0.05), range(bin705)), ytitle(Density) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (bin705)) xlabel(#10, grid)  legend(order(1 "Histogram" 2 "Kernel" 3 "Actual")) scheme(tufte)  scale(0.8)
graph export "f_bin705.png", as(png) replace
sort bin705
gen F_bin705 = _n/_N
twoway (line F_bin705 bin705, sort) (function binomial(7,x,0.05), range(bin705)), ytitle(Cumulative Probability) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (bin705)) xlabel(#10, grid)  legend(order(1 "Empirical Distribution" 2 "Actual Distribution")) scheme(tufte)  scale(0.8) 
graph export "F_bin705.png", as(png) replace
********************************************************************************
twoway (histogram bin7005) (kdensity bin7005, lpattern(solid)) (function binomialp(70,x,0.05), range(bin7005)), ytitle(Density) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (bin7005)) xlabel(#10, grid)  legend(order(1 "Histogram" 2 "Kernel" 3 "Actual")) scheme(tufte)  scale(0.8)
graph export "f_bin7005.png", as(png) replace
sort bin7005
gen F_bin7005 = _n/_N
twoway (line F_bin7005 bin7005, sort) (function binomial(70,x,0.05), range(bin7005)), ytitle(Cumulative Probability) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (bin7005)) xlabel(#10, grid)  legend(order(1 "Empirical Distribution" 2 "Actual Distribution")) scheme(tufte)  scale(0.8) 
graph export "F_bin7005.png", as(png) replace
********************************************************************************
twoway (histogram nbin705) (kdensity nbin705, lpattern(solid)) (function nbinomialp(7,x,0.05), range(nbin705)), ytitle(Density) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (nbin705)) xlabel(#10, grid)  legend(order(1 "Histogram" 2 "Kernel" 3 "Actual")) scheme(tufte)  scale(0.8)
graph export "f_nbin705.png", as(png) replace
sort nbin705
gen F_nbin705 = _n/_N
twoway (line F_nbin705 nbin705, sort) (function nbinomial(7,x,0.05), range(nbin705)), ytitle(Cumulative Probability) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (nbin705)) xlabel(#10, grid)  legend(order(1 "Empirical Distribution" 2 "Actual Distribution")) scheme(tufte)  scale(0.8) 
graph export "F_nbin705.png", as(png) replace
********************************************************************************
twoway (histogram nbin7005) (kdensity nbin7005, lpattern(solid)) (function nbinomialp(70,x,0.05), range(nbin7005)), ytitle(Density) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (nbin7005)) xlabel(#10, grid)  legend(order(1 "Histogram" 2 "Kernel" 3 "Actual")) scheme(tufte)  scale(0.8)
graph export "f_nbin7005.png", as(png) replace
sort nbin7005
gen F_nbin7005 = _n/_N
twoway (line F_nbin7005 nbin7005, sort) (function nbinomial(70,x,0.05), range(nbin7005)), ytitle(Cumulative Probability) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (nbin7005)) xlabel(#10, grid)  legend(order(1 "Empirical Distribution" 2 "Actual Distribution")) scheme(tufte) scale(0.8) 
graph export "F_nbin7005.png", as(png) replace
********************************************************************************
twoway (histogram pois5) (kdensity pois5, lpattern(solid)) (function poissonp(5,x), range(pois5)), ytitle(Density) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (pois5)) xlabel(#10, grid)  legend(order(1 "Histogram" 2 "Kernel" 3 "Actual")) scheme(tufte)  scale(0.8)
graph export "f_pois5.png", as(png) replace
sort pois5
gen F_pois5 = _n/_N
twoway (line F_pois5 pois5, sort) (function poisson(5,x), range(pois5)), ytitle(Cumulative Probability) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (pois5)) xlabel(#10, grid)  legend(order(1 "Empirical Distribution" 2 "Actual Distribution")) scheme(tufte)  scale(0.8) 
graph export "F_pois5.png", as(png) replace
********************************************************************************
twoway (histogram pois15) (kdensity pois15, lpattern(solid)) (function poissonp(15,x), range(pois15)), ytitle(Density) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (pois15)) xlabel(#10, grid)  legend(order(1 "Histogram" 2 "Kernel" 3 "Actual")) scheme(tufte) scale(0.8)
graph export "f_pois15.png", as(png) replace
sort pois15
gen F_pois15 = _n/_N
twoway (line F_pois15 pois15, sort) (function poisson(15,x), range(pois15)), ytitle(Cumulative Probability) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (pois15)) xlabel(#10, grid)  legend(order(1 "Empirical Distribution" 2 "Actual Distribution")) scheme(tufte)  scale(0.8) 
graph export "F_pois15.png", as(png) replace
********************************************************************************
twoway (histogram unif) (kdensity unif, lpattern(solid)) (function 1/(1-0), range(unif)), ytitle(Density) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (unif)) xlabel(#10, grid)  legend(order(1 "Histogram" 2 "Kernel" 3 "Actual")) scheme(tufte) scale(0.8)
graph export "f_unif.png", as(png) replace
sort unif
gen F_unif = _n/_N
twoway (line F_unif unif, sort) (function (x)/(1-0), range(unif)), ytitle(Cumulative Probability) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (unif)) xlabel(#10, grid)  legend(order(1 "Empirical Distribution" 2 "Actual Distribution")) scheme(tufte)  scale(0.8) 
graph export "F_unif.png", as(png) replace
********************************************************************************
twoway (histogram unif28) (kdensity unif28, lpattern(solid)) (function 1/(8-2), range(unif28)), ytitle(Density) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (unif28)) xlabel(#10, grid)  legend(order(1 "Histogram" 2 "Kernel" 3 "Actual")) scheme(tufte)  scale(0.8)
graph export "f_unif28.png", as(png) replace
sort unif28
gen F_unif28 = _n/_N
twoway (line F_unif28 unif28, sort) (function (x-2)/(8-2), range(unif28)), ytitle(Cumulative Probability) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (unif28)) xlabel(#10, grid)  legend(order(1 "Empirical Distribution" 2 "Actual Distribution")) scheme(tufte)  scale(0.8) 
graph export "F_unif28.png", as(png) replace
********************************************************************************
twoway (histogram norm) (kdensity norm, lpattern(solid)) (function normalden(x,0,1), range(norm)), ytitle(Density) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (norm)) xlabel(#10, grid)  legend(order(1 "Histogram" 2 "Kernel" 3 "Actual")) scheme(tufte) scale(0.8)
graph export "f_norm.png", as(png) replace
sort norm
gen F_norm = _n/_N
twoway (line F_norm norm, sort) (function  normal(x), range(norm)) , ytitle(Cumulative Probability) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (norm)) xlabel(#10, grid)  legend(order(1 "Empirical Distribution" 2 "Actual Distribution")) scheme(tufte)  scale(0.8) 
graph export "F_norm.png", as(png) replace
********************************************************************************
twoway (histogram norm2) (kdensity norm2, lpattern(solid)) (function normalden(x,2,1), range(norm2)), ytitle(Density) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (norm2)) xlabel(#10, grid)  legend(order(1 "Histogram" 2 "Kernel" 3 "Actual")) scheme(tufte)  scale(0.8)
graph export "f_norm2.png", as(png) replace
sort norm2
gen F_norm2 = _n/_N
twoway (line F_norm2 norm2, sort) (function normal((x-2)/1), range(norm2)), ytitle(Cumulative Probability) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (norm2)) xlabel(#10, grid)  legend(order(1 "Empirical Distribution" 2 "Actual Distribution")) scheme(tufte)  scale(0.8) 
graph export "F_norm2.png", as(png) replace
********************************************************************************
twoway (histogram norm78) (kdensity norm78, lpattern(solid)) (function normalden(x,7,8), range(norm78)), ytitle(Density) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (norm78)) xlabel(#10, grid)  legend(order(1 "Histogram" 2 "Kernel" 3 "Actual")) scheme(tufte)  scale(0.8)
graph export "f_norm78.png", as(png) replace
sort norm78
gen F_norm78 = _n/_N
twoway (line F_norm78 norm78, sort) (function normal((x-7)/8), range(norm78)), ytitle(Cumulative Probability) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (norm78)) xlabel(#10, grid)  legend(order(1 "Empirical Distribution" 2 "Actual Distribution")) scheme(tufte)  scale(0.8) 
graph export "F_norm78.png", as(png) replace
********************************************************************************
twoway (histogram chi210) (kdensity chi210, lpattern(solid)) (function chi2den(10,x), range(chi210)), ytitle(Density) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (chi210)) xlabel(#10, grid)  legend(order(1 "Histogram" 2 "Kernel" 3 "Actual")) scheme(tufte)  scale(0.8)
graph export "f_chi210.png", as(png) replace
sort chi210
gen F_chi210 = _n/_N
twoway (line F_chi210 chi210, sort) (function chi2(10,x), range(chi210)), ytitle(Cumulative Probability) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (chi210)) xlabel(#10, grid)  legend(order(1 "Empirical Distribution" 2 "Actual Distribution")) scheme(tufte)  scale(0.8) 
graph export "F_chi210.png", as(png) replace
********************************************************************************
twoway (histogram chi2100) (kdensity chi2100, lpattern(solid)) (function chi2den(100,x), range(chi2100)), ytitle(Density) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (chi2100)) xlabel(#10, grid)  legend(order(1 "Histogram" 2 "Kernel" 3 "Actual")) scheme(tufte)  scale(0.8)
graph export "f_chi2100.png", as(png) replace
sort chi2100
gen F_chi2100 = _n/_N
twoway (line F_chi2100 chi2100, sort) (function chi2(100,x), range(chi2100)), ytitle(Cumulative Probability) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (chi2100)) xlabel(#10, grid)  legend(order(1 "Empirical Distribution" 2 "Actual Distribution")) scheme(tufte) scale(0.8) 
graph export "F_chi2100.png", as(png) replace
********************************************************************************
twoway (histogram f22) (kdensity f22, lpattern(solid)) (function Fden(2,2,x), range(f22)), ytitle(Density) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (f22)) xlabel(#10, grid)  legend(order(1 "Histogram" 2 "Kernel" 3 "Actual")) scheme(tufte)  scale(0.8)
graph export "f_f22.png", as(png) replace
sort f22
gen F_f22 = _n/_N
twoway (line F_f22 f22, sort) (function F(2,2,x), range(f22)), ytitle(Cumulative Probability) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (f22)) xlabel(#10, grid)  legend(order(1 "Empirical Distribution" 2 "Actual Distribution")) scheme(tufte)  scale(0.8) 
graph export "F_f22.png", as(png) replace
********************************************************************************
twoway (histogram f2100) (kdensity f2100, lpattern(solid)) (function Fden(2,100,x), range(f2100)), ytitle(Density) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (f2100)) xlabel(#10, grid)  legend(order(1 "Histogram" 2 "Kernel" 3 "Actual")) scheme(tufte) scale(0.8)
graph export "f_f2100.png", as(png) replace
sort f2100
gen F_f2100 = _n/_N
twoway (line F_f2100 f2100, sort) (function F(2,100,x), range(f2100)), ytitle(Cumulative Probability) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (f2100)) xlabel(#10, grid)  legend(order(1 "Empirical Distribution" 2 "Actual Distribution")) scheme(tufte) scale(0.8) 
graph export "F_f2100.png", as(png) replace
********************************************************************************
twoway (histogram t10) (kdensity t10, lpattern(solid)) (function tden(10,x), range(t10)), ytitle(Density) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (t10)) xlabel(#10, grid)  legend(order(1 "Histogram" 2 "Kernel" 3 "Actual")) scheme(tufte) scale(0.8)
graph export "f_t10.png", as(png) replace
sort t10
gen F_t10 = _n/_N
twoway (line F_t10 t10, sort) (function t(10,x), range(t10)), ytitle(Cumulative Probability) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (t10)) xlabel(#10, grid)  legend(order(1 "Empirical Distribution" 2 "Actual Distribution")) scheme(tufte) scale(0.8) 
graph export "F_t10.png", as(png) replace
********************************************************************************
twoway (histogram t30) (kdensity t30, lpattern(solid)) (function tden(30,x) , range(t30)), ytitle(Density) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (t30)) xlabel(#10, grid)  legend(order(1 "Histogram" 2 "Kernel" 3 "Actual")) scheme(tufte) scale(0.8)
graph export "f_t30.png", as(png) replace
sort t30
gen F_t30 = _n/_N
twoway (line F_t30 t30, sort) (function t(30,x), range(t30)), ytitle(Cumulative Probability) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (t30)) xlabel(#10, grid)  legend(order(1 "Empirical Distribution" 2 "Actual Distribution")) scheme(tufte) scale(0.8) 
graph export "F_t30.png", as(png) replace
********************************************************************************
twoway (histogram t100) (kdensity t100, lpattern(solid)) (function tden(100,x) , range(t100)), ytitle(Density) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (t100)) xlabel(#10, grid)  legend(order(1 "Histogram" 2 "Kernel" 3 "Actual")) scheme(tufte) scale(0.8)
graph export "f_t100.png", as(png) replace
sort t100
gen F_t100 = _n/_N
twoway (line F_t100 t100, sort) (function t(100,x), range(t100)), ytitle(Cumulative Probability) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (t100)) xlabel(#10, grid)  legend(order(1 "Empirical Distribution" 2 "Actual Distribution")) scheme(tufte) scale(0.8) 
graph export "F_t100.png", as(png) replace
********************************************************************************
twoway (histogram beta11) (kdensity beta11, lpattern(solid)) (function betaden(1,1,x) , range(beta11)), ytitle(Density) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (beta11)) xlabel(#10, grid)  legend(order(1 "Histogram" 2 "Kernel" 3 "Actual")) scheme(tufte) scale(0.8)
graph export "f_beta11.png", as(png) replace
sort beta11
gen F_beta11 = _n/_N
twoway (line F_beta11 beta11, sort) (function  ibeta(1,1,x)), ytitle(Cumulative Probability) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (beta11)) xlabel(#10, grid)  legend(order(1 "Empirical Distribution" 2 "Actual Distribution")) scheme(tufte) scale(0.8) 
graph export "F_beta11.png", as(png) replace
********************************************************************************
twoway (histogram beta15) (kdensity beta15, lpattern(solid)) (function betaden(1,5,x) , range(beta15)), ytitle(Density) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (beta15)) xlabel(#10, grid)  legend(order(1 "Histogram" 2 "Kernel" 3 "Actual")) scheme(tufte) scale(0.8)
graph export "f_beta15.png", as(png) replace
sort beta15
gen F_beta15 = _n/_N
twoway (line F_beta15 beta15, sort) (function ibeta(1,5,x), range(beta15)), ytitle(Cumulative Probability) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (beta15)) xlabel(#10, grid)  legend(order(1 "Empirical Distribution" 2 "Actual Distribution")) scheme(tufte) scale(0.8) 
graph export "F_beta15.png", as(png) replace
********************************************************************************
twoway (histogram gamma11) (kdensity gamma11, lpattern(solid)) (function gammaden(1,1,0,x) , range(gamma11)), ytitle(Density) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (gamma11)) xlabel(#10, grid)  legend(order(1 "Histogram" 2 "Kernel" 3 "Actual")) scheme(tufte) scale(0.8)
graph export "f_gamma11.png", as(png) replace
sort gamma11
gen F_gamma11 = _n/_N
twoway (line F_gamma11 gamma11, sort) (function  gammap(1,(x-0)/(1)), range(gamma11)), ytitle(Cumulative Probability) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (gamma11)) xlabel(#10, grid)  legend(order(1 "Empirical Distribution" 2 "Actual Distribution")) scheme(tufte) scale(0.8) 
graph export "F_gamma11.png", as(png) replace
********************************************************************************
twoway (histogram gamma15) (kdensity gamma15, lpattern(solid)) (function gammaden(1,5,0,x) , range(gamma15)), ytitle(Density) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (gamma15)) xlabel(#10, grid)  legend(order(1 "Histogram" 2 "Kernel" 3 "Actual")) scheme(tufte) scale(0.8)
graph export "f_gamma15.png", as(png) replace
sort gamma15
gen F_gamma15 = _n/_N
twoway (line F_gamma15 gamma15, sort) (function  gammap(1,(x-0)/(5)), range(gamma15)), ytitle(Cumulative Probability) ylabel(#10, angle(horizontal) grid) xtitle(Random Variable (gamma15)) xlabel(#10, grid)  legend(order(1 "Empirical Distribution" 2 "Actual Distribution")) scheme(tufte) scale(0.8) 
graph export "F_gamma15.png", as(png) replace
********************************************************************************



/*

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
