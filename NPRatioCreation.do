*V14.2 SE
*Created by Xian ZHOU
*Date: July 24 2017
*Revised by: Aug16 9,2017

*Comments by XZ 20170816
*Winsorize the dataset by upper & lower 1% of npratios line 288
*Run 1: run the Pearson and Spearman correlation matrix(CORSP)of npratios, but it will run for quite a long time. 
*Tried histogram , and two way scatted grahp of ROCE

*Comments by XZ 20170809
*NPRatioV4run8.log winsor and trim the npratios based on run 3. Uset the test code to see the change of dataset size  //Increase the interpretation meaning of the dataset while keep the dataset as the same size as it used to be
*Tried some hypothesis test on ROCE.---->need review the statistic seriously, leave it for future study

**Comments by XZ 20170804
*Change the macro mtr from 0.48 to 0.37 as per my understanding of the paper
*Add 2 raw varibles in npbvar
*Updates some typo in equation
*Update Panel B with different periods
*run1.log keep all the missing values as they are
*run2.log treat all the missing values of `npbvar' `npivar' as 0
*run3.log further treat all the missing values of `npinterim' as 0 // I chose this as the proper dataset, see line159 for my reasoning. 
*According to NP paper, Summrize the key features of each ratio in panel A & panel B that  see line 267& line 293


* comments by RD, 20170802 after discussion in 104F UWBB
*   added new macros npiterim and npratios to reduce typing
*   addded new tabulations of bmiss and imiss
*   added commands to safely recode missing values to 0 before computing new
*    variables
*  This version saved as NPRatioCreationV3_RD.do



*capture log close 
log using NPRatioCreationV5_run3, t replace
use "\\netid.washington.edu\csde\homes\udrive\BACCT600\clean_INDL.dta", clear
set more off

*Macros
global mtr = 0.37      //(Method 1)
*Marginal Tax Rate=the top statutory federal tax rate plus 2% average state tax rate. The top federal statutory corporate tax rate was 52% in 1963, 50% in 1964, 48% in 1965–1967,52.8% in 1968–1969, 49.2% in 1970, 48% in 1971–1978, 46% in 1979–1986, 40% in
*1987, 34% in 1988–1992 and 35% in 1993–1999.(NP 2001 Appendix)
*It would be better if we can generate mtr as variable which changes by year. but since there's only 2 similar values in our sample set, 0.37 could be accepted for the whole dataset
//egen mtr=0.36 if ryear>=1989 & ryear<=1992 |egen mtr=0.37 if ryear>=1993 & ryear<=2016 (returns to break)


*glo rfr = 0.02       //(Method 1)
*one year risk-free rate at the beginning of the year  (NP 2001 Appendix)
// the following lines check data available in the Compustat variable optrfr:
     // summ optrfr, det
     // codebook optrfr
     //  table ryear, c(n optrfr mean optrfr sd optrfr  median optrfr ) format(%9.2f) row 
  // Note: The risk free rate in Compustat is available starting only from 2001 while the NP paper use the data from 1963-1999
g rfr = 0.02         //(Method 2)
replace rfr = optrfr if optrfr !=.
la var rfr "Risk free rate, optrfr if nonmissing, else 0.02 (per NP 2001)"
 // if you go this route, you will have to replace "$rfr" with simply "rfr"
 //  in all subsequent lines
local npbvar `"at ceq che dlc dltt dvp dvpa esub ivao lct lo mib msa pstk recta tstkp"' //add two items "lo & lct "for Debt total variable
local npivar `"idit mii ni nopio revt spi txditc xido xint"'
local npinterim `"fa oa fo cse mi nfo noa ol core_nfe ufe csa nfe cni oi other_it oi_sales sales uoi coreoi_sales io core_oi r IE td"'
local rocevar `"roce msr rotce rnoa rota ollev olspread flev tflev nbc spread pm ato"'   
local CIvar `"sales_pm csales_pm ps u_rnoa core_rnoa core_nbc u_nbc core_spread"'
*Drivers of equation 16 on page 124        
local Gvar `"reg greoi gcse gnoa gfcf"'                                                   
local npratios `"`rocevar' `CIvar' `Gvar'"'

* Data inspection & cleaning
** identify and delete duplicates
summ ryear, det
duplicates drop gvkey ryear, force
destring gvkey, replace force
la var gvkey "gvkey stored as number"
** Some basic info about the dataset
*** Number of observations by reporting year
table ryear, c(n gvkey n sic4)  format(%9.2f) row
*** Preparation for variable definition
tsset gvkey fyear

*** Check availability of the variables used in NP(2001)
**count number of missing variables within each observation  
egen bmiss=rowmiss(`npbvar')
egen imiss=rowmiss(`npivar')
la var bmiss "# of missing bvars" 
la var imiss "# of missing ivars" 
*tabulate missing counts, range 0-16 for bmiss, 0-9 for imiss
tab bmiss, missing
tab imiss, m
* tabulate key values of the underlying compustat variables
tabstat `npbvar', statistics(n mean sd max p99 p95 p90 p75 p50 p25 p5 p1 min) f(%9.2f)  
tabstat `npivar', statistics(n mean sd max p99 p95 p90 p75 p50 p25 p5 p1 min) f(%9.2f)

*foreach x of var `npbvar' `npivar' {
* summ `x', det                                              // uncomment as needed
* table ryear, c(n `x' m `x' sd `x' p50 `x') row f(%9.2f)    // uncomment as needed
*                              }

// codebook `npbvar' `npivar' 

* =============================================================================							   
							   ***Define NP variables***
* =============================================================================							   
*  Many of the compustat variables used to compute the NP interim variables have
*  missing values: if used as-is derived variables may have missing values only
*  because some component was not reported.  To avoid needless data loss in this
*  way, we may want to treat missing values of raw compustat variables as zero.
*   !!! This is normal with accounting data: not all variables are relevant for
*        or reported by a given firm, so recoding "." = 0 is NOT crazy !!!
*  To be careful, we first gen a backup copy of all the relevant variables.
*  We can then safely recode (.=0) since `x'_bak stores the original values.
foreach x of var `npbvar' `npivar' {
g `x'_bak = `x'
recode `x' (.=0)
}

//codebook `npbvar'  all the missing variables has been changed to 0

* Generate NP "interim" variables
g fa = che + ivao	
la var fa "Financial Assets, NP 2001"
g oa =at  - fa	
la var oa "Operating Assets, NP 2001"
g fo = dlc + dltt + pstk - tstkp + dvpa 	
la var fo "Financial Obligations , NP 2001"
g cse = ceq + tstkp - dvpa	
la var cse "Common Equity, NP 2001"
g mi = mib	
la var mi "Minority Interest , NP 2001"
g nfo = fo - fa	
la var nfo "Net Financial Obligations , NP 2001"
g noa = nfo + cse + mib	
la var noa "Net Operating Assets, NP 2001"
g ol = oa - noa	
la var ol "Operating Liablities, NP 2001"
g core_nfe = (xint*(1-$mtr))+dvp - (idit*(1-$mtr))	
la var core_nfe "Core Net Financial Expense , NP 2001"
g ufe = l.msa - msa	
la var ufe "Unusual Financial Expense , NP 2001"
br gvkey fyear msa ufe
g csa = msa- l.msa + recta - l.recta	
la var csa "Clean Surplus Adjustment to net Income , NP 2001"
g nfe = core_nfe + ufe	
la var nfe "Comprehensive Net Financial Expense , NP 2001"
g cni = ni- dvp + csa	
la var cni "Comprehensive Net Income , NP 2001"
g oi=nfe+cni+mii	
la var oi "Comprehensive Operating Income , NP 2001"
g other_it = esub	
la var other_it "Other Operaring income Items, NP 2001"
g oi_sales = oi- esub	
la var oi_sales "Operating Income from Sales, NP 2001"
g sales=revt	
la var sales "Sales revenue, NP 2001"
g uoi = ((nopio- esub)*(1-$mtr)) + (spi*(1-$mtr)) + xido +recta - l.recta	
la var uoi "Unusual Operating Income, NP 2001"
g coreoi_sales = oi_sales-uoi	
la var coreoi_sales "Core Operating Income from Sales, NP 2001"
g io = rfr*(ol - txditc)	
la var io "Interest on Operating Obligation, NP 2001" 
g core_oi = oi-uoi	
la var core_oi "Core operating income, NP 2001"
g r = rfr+0.06	                                      
la var r "Required return for common equity, NP 2001"
g IE = r +1
la var IE "IE, NP 2001" 
g td = lct+dltt+txditc+lo
la var td "Debt Total, NP 2001"

*For all the variable generated with lag , there's 31958 missing value for each of them. It's reasonable to convert those missing value into zero as well 
local npinterim `"fa oa fo cse mi nfo noa ol core_nfe ufe csa nfe cni oi other_it oi_sales sales uoi coreoi_sales io core_oi r IE td"'
egen intermiss=rowmiss(`npinterim')
la var intermiss "# of missing npinterim"
tab intermiss, m

*uncommented from run 3
foreach x of var `npinterim'{
g `x'_bak = `x'
recode `x' (.=0)
}
 
 * Generate the NP ratios (all denominators should be >0, except nbc & core_nbc)							   
g nbc = nfe/l.nfo 	
la var nbc "Net Borrowing Cost(Financing profitability), NP 2001"
g rnoa = oi/l.noa if l.noa > 0		
la var rnoa "Return on Net Operating Assets, NP 2001"
li gvkey fyear conm rnoa if (rnoa!=. & l.noa<0) //check
g spread = rnoa-nbc		
la var spread "Spread, NP 2001"
g flev = nfo/cse if cse>0		
la var flev "Financial Leverage, NP 2001"
li gvkey fyear flev nfo cse if (flev!=. & cse < 0) //check
g ato = sales/noa if noa>0	
la var ato "Asset Turn Over, NP 2001"
g pm = oi/sales	 if sales>0
la var pm "Profit margin, NP 2001"
g sales_pm = oi_sales/sales	 if sales>0	
la var sales_pm "Sales Profit margin, NP 2001"
g rotce = (cni+mii)/(cse+mi) if cse+mi>0		
la var rotce "Return on Total common equity, NP 2001"
g msr = (cni/(cni+mii))/(cse/(cse+mib))	 if (cni>0& cni+mii>0& cse>0& cse+mib>0)	
la var msr "Minority Sharing Ratio, NP 2001"
g ps = other_it/noa	 if noa>0
la var ps "Profitability of Sales, NP 2001"
g roce = rotce*msr		
la var roce "Return on Common Equity, NP 2001"
*g roce = sales_pm * ato+ps+(flex * spread)
*la var roce "Return on Common Equity, NP 2001"
g rooa = (oi+io)/oa	 if oa>0	
la var rooa "Return on Operating Assets (without leverage from operating liability), NP 2001"
g ollev = ol/noa  if noa>0		
la var ollev "Operating liability leverage, NP 2001"
g olspread = rooa-io/ol  if ol>0	
la var olspread "Operating liability leverage, NP 2001"
g rota = (ni+(xint*(1-$mtr))+ mii)/at  if at>0	
la var rota "Return on Total Assets, NP 2001"
g csales_pm = coreoi_sales/sales  if sales>0		
la var csales_pm "Core Sales Profit margin, NP 2001"
g scsales_pm = (coreoi_sales+io)/sales  if sales >0	
la var scsales_pm "*Core Sales Profit margin, NP 2001"
g sato = sales/oa  if oa>0		
la var sato "*Asset turn over, NP 2001"
g sflev = nfo/(cse+mib) if cse+mib>0	
la var sflev "*FLEV, NP 2001"
g sroce = msr*((scsales_pm*sato)+(other_it/oa)+(uoi/oa)+(ollev*olspread)+(sflev*spread))		
la var sroce "Return on Common Equity (operating liability included), NP 2001"
g tflev = (lt+pstk)/ceq  if ceq>0
la var tflev "Traditional Debt/Equity, NP 2001"

g u_rnoa = uoi/noa  if noa >0	
la var u_rnoa "Unusual RNOA, NP 2001"
g core_rnoa = core_oi/noa  if noa >0	
la var core_rnoa "Core RNOA, NP 2001"
g core_nbc = core_nfe/nfo		
la var core_nbc "Core NBC, NP 2001"
g core_spread = core_rnoa-core_nbc	
la var core_spread "Core Spread, NP 2001"

g u_nbc = ufe/nfo  if nfo >0
la var u_nbc "Unusual NBC, NP 2001"

g re1 = (roce-(IE -1))*l.cse
la var re1 "Residual Earning, NP 2001"
g reg = (re1/l.re1)-1	 if l.re1 > 0
la var reg "Growth in RE, NP 2001"
g reoi = sales*(pm-(IE -1)/ato)
la var reoi "Residual Operating Income, NP 2001"
by gvkey: g greoi = reoi/l.reoi-1  if l.reoi >0	
la var greoi "Growth in ReOI, NP 2001"
by gvkey: g gcse = cse/l.cse-1  if l.cse >0	
la var gcse "Growth in CSE, NP 2001"
by gvkey: g gnoa = noa/l.noa-1 if l.noa >0	
la var gnoa "Growth in NOA , NP 2001"
by gvkey: g fcf = l.noa*(rnoa-gnoa)	
la var fcf "Free Cash Flow, NP 2001"
g gfcf = fcf/noa  if noa >0
la var gfcf "Growth in Free Cash Flow, NP 2001"

* Describe and summarize ratios 1990-2016 (long output, uncomment as needed)
desc `npratios'
** summarise ratios for the full sample period
* summ `npratios', det
** summarise ratios by period
* summ `npratios' if ryear>=1990 & ryear<=2001, det
* summ `npratios' if ryear>=2002 & ryear<=2016, det

egen rmiss=rowmiss(`npratios')
la var rmiss "# of missing npratios"
tab rmiss, m
*foreach x of var `npratios'{
*g `x'_bak = `x'
*recode `x' (.=0)
*}
*br gvkey fyear conm rnoa oi noa
******2 reasons of missing value of the NP Ratios. 
** 1. The denominator is missing (no lag denominator)
** 2. The denominator is negative as we defined 
****  The second reason made it not reasonalbe to treat the missing ratios as 0***

*****Winsorize the dataset*******
local npbvar `"at ceq che dlc dltt dvp dvpa esub ivao lct lo mib msa pstk recta tstkp"' //add two items "lo & lct "for Debt total variable
local npivar `"idit mii ni nopio revt spi txditc xido xint"'
local npinterim `"fa oa fo cse mi nfo noa ol core_nfe ufe csa nfe cni oi other_it oi_sales sales uoi coreoi_sales io core_oi r IE td"'
local rocevar `"roce msr rotce rnoa rota ollev olspread flev tflev nbc spread pm ato"'   
local CIvar `"sales_pm csales_pm ps u_rnoa core_rnoa core_nbc u_nbc core_spread"'
*Drivers of equation 16 on page 124        
local Gvar `"reg greoi gcse gnoa gfcf"'                                                   
local npratios `"`rocevar' `CIvar' `Gvar'"'
winsor2 `npratios', replace cuts(1 99) 
*winsor2 `npratios', cuts(1 99) t // trim will treat all the upper or down extream value as missing value, thus decrease the sample size (decrease the power of dataset)





****Replicate Table 1 of NP 2001***** 
****Panel A Drivers of ROCE*****
****Expectation of the ratios as per NP 2011****
*****1.Majority of MSR should close to 1 -> ROCE is a good approximation for ROTCE; ROCE=ROTCE*MSR 
*****2.Median ROCE is close to the historcial average equity cost of capital (12.5%),which reflects an ex post successful stock market (High expectation)
*****3.SD,Mean & median of ROCE is higher than those of ROTCE. Demonstrats the "clean" distinction between operatng and financing items and the adjustment for operating liability has a significant effect
*****4.Median OLLEV>0 & Median OLSPREAD >0 -> Operating liablity typically is used favorably, contributing to the difference between RNOA & ROTA (RNOA=ROOA+OLLEV*OLSPREAD)
*****5.Median FLEV< Median tFLEV <- FLEV recognize only indebtedness from financing activities, and also recoginzes the debt held as assets defeases debt owned
*****6.Variations (SD) of NBC <- A) different borrowing rate B)Recoginition of transitory realized and untrealized gains and losses on financial items. NBC=NFE/l.NFO
*****7.Spread was positive at median , but negative for the 30% tail.->Financial leverage has favorable & unfavorable effect on ROCE (ROCE=RNOA+SPREAD*FLEV)
*****8.Median ROCE was higher than that of RNOA -> typically on-average leverage combines with positive spred to lever ROCE favarobly
*****9.listed PM & ATO as the traditional DuPont driver of RNOA or "Return on investment" for comparison.(Return on investment=PM*ATO)


* Panel A.1 Full period
tabstat `rocevar', statistics(n mean sd max p99 p95 p90 p75 p50 p25 p5 p1 min) f(%9.2f)
table ryear, c(n msr mean msr sd msr p95 msr p90 msr) row 
  // the mean of msr is obviously unreasonable. by table we can see that there 
  //  is an abnormally high mean in 1998 and very low (negative in 1991)
    * >> this problem solved when all the missing value of npinterims is treated as 0 
	
	//// *Does not comply to the conclusion with #3:  SD of roce is not higher than rotce, which is caused by post-NP period 	

* Panel A.2 for NP period only
tabstat `rocevar' if ryear>=1990 & ryear<=1999, statistics(n mean sd max p99 p95 p90 p75 p50 p25 p5 p1 min) f(%9.2f)

* Panel A.3 for post-NP period
tabstat `rocevar' if ryear>=2000 & ryear<=2016, statistics(n mean sd max p99 p95 p90 p75 p50 p25 p5 p1 min) f(%9.2f)
 

 
 ****Panel B Additional ratios of ROCE Drivers in extensive analysis *****
****Expectation of the ratios as per NP 2011****
************* `CIVar'the drivers of ROCE in Equation (16)****************
*****1. Sales PM< PM
*****2. Other Items/NOA is typically small
*****3. UOI/NOA (the unusual operating item) has bigger effect than that of other items
*****4. cf Core RNOA vs RNOA , and cf Core Sales PM vs Sales PM reflects of these items (in point 2& 3). RNOA= Core RNOA+UOI/NOA
*****5. The decompositon of Spread (Core RNOA, Core NBC, UFE/NFO, Core Spread)-> Demonstrate the change when FSAB NO.115 became effective? (Recognize the unrealized gain and loss on short-term financial assets)


* Panel B.1 Full period
tabstat `CIvar', statistics(n mean sd max p99 p95 p90 p75 p50 p25 p5 p1 min) f(%9.2f)
tabstat `Gvar' , statistics(n mean sd max p99 p95 p90 p75 p50 p25 p5 p1 min) f(%9.2f)

* Panel B.2 for NP period only
tabstat `CIvar' if ryear>=1990 & ryear<=1999, statistics(n mean sd max p99 p95 p90 p75 p50 p25 p5 p1 min) f(%9.2f)
tabstat `Gvar' if ryear>=1990 & ryear<=1999, statistics(n mean sd max p99 p95 p90 p75 p50 p25 p5 p1 min) f(%9.2f)

* Panel B.3 for post-NP period
tabstat `CIvar' if ryear>=2000 & ryear<=2016, statistics(n mean sd max p99 p95 p90 p75 p50 p25 p5 p1 min) f(%9.2f)
tabstat `Gvar' if ryear>=2000 & ryear<=2016, statistics(n mean sd max p99 p95 p90 p75 p50 p25 p5 p1 min) f(%9.2f)

*Understand correlations among NP iterim vars and among NP ratios
local npinterim `"fa oa fo cse mi nfo noa ol core_nfe ufe csa nfe cni oi other_it oi_sales sales uoi coreoi_sales io core_oi r IE td"'
*Full period
cor `npinterim'
*corsp `npinterim'
*NP Period only
cor `npinterim' if ryear>=1990 & ryear<=1999
*corsp `npinterim' if ryear>=1990 & ryear<=1999
*Post-NP period
cor `npinterim' if ryear>=2000 & ryear<=2016
*corsp `npinterim' if ryear>=2000 & ryear<=2016

local rocevar `"roce msr rotce rnoa rota ollev olspread flev tflev nbc spread pm ato"'  
local CIvar `"sales_pm csales_pm ps u_rnoa core_rnoa core_nbc u_nbc core_spread"'   
local Gvar `"reg greoi gcse gnoa gfcf"'
local npratios `"`rocevar' `CIvar' `Gvar'"'
*Full period
cor `npratios'
corsp `npratios'
*NP Period only
cor `npratios' if ryear>=1990 & ryear<=1999 
*corsp `npratios' if ryear>=1990 & ryear<=1999 
*Post-NP period
cor `npratios' if ryear>=2000 & ryear<=2016 
*corsp `npratios' if ryear>=2000 & ryear<=2016 


********Test for differences in means and distributions over time *******
*** t tests (mean-comparison tests)
histogram roce
twoway (scatter roce ryear)
*histogram roce,by(ryear)
ttest roce == 0.17
ttest roce == rotce, unpaired unequal  //review of the statistics is required

***z tests (mean-comparison tests, known variance)******
ztest roce == 0.1

*** sdtest performs tests on the equality of standard deviations (variances).
sdtest roce == 0.162

***equality of distributions*****
*** A one-sample test compares the distribution of the tested variable with the specified distribution.*****
****A two-sample test tests the equality of the distributions of two samples.****
*ksmirnov roce, by(rotce) // too many observations


***Other testing*****
*sdtest -- Variance-comparison tests
*anova -- Analysis of variance and covariance****

****test code*****
/*
local rocevar2 `"roce_tr msr_tr rotce_tr rnoa_tr rota_tr ollev_tr olspread_tr flev_tr tflev_tr nbc_tr spread_tr pm_tr ato_tr"'   
local CIvar2 `"sales_pm_tr csales_pm_tr ps_tr u_rnoa_tr core_rnoa_tr core_nbc_tr u_nbc_tr core_spread_tr"'   
local Gvar2 `"reg_tr greoi_tr gcse_tr gnoa_tr gfcf_tr"'
local npratios2 `"`rocevar2' `CIvar2' `Gvar2'"'
local npvar2 

local rocevar3 `"roce_w msr_w rotce_w rnoa_w rota_w ollev_w olspread_w flev_w tflev_w nbc_w spread_w pm_w ato_w"'   
local CIvar3 `"sales_pm_w csales_pm_w ps_w u_rnoa_w core_rnoa_w core_nbc_tr u_nbc_w core_spread_w"'   
local Gvar3 `"reg_w greoi_w gcse_w gnoa_w gfcf_w"'
local npratios3 `"`rocevar3' `CIvar3' `Gvar3'"'
local npvar3 

foreach x of varlist `npratios npratios2 npratios3' { 
summ `x'
} 

tabstat `npratios' `npratios2' `npratios3', stat(n) // the result prove that winsorize will keep the sample size , and trim will decrease the sample size




