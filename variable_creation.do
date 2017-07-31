clear all
set more off
set memory 500m
cd "F:\Agraj Gupta Documents\UW_bothell\RD\NissimPennman"

*Load data
use "raw_data.dta", clear
duplicates drop gvkey fyear, force
g coid = gvkey
destring gvkey, replace force
tsset gvkey fyear

keep if tic=="AAPL"

global rf = 0.02
global eqprem = 0.06
global horizon = 5                                   // this is big T of equation 9
global rho_w = $eqprem


*************************************************************************
***************Appendix: Notation and Variables Measurement**************
*************************************************************************
gen fa = che + ivao
*Financial Assets (FA) = cash and short term investments (Compustat #1)plus 
*investments and advances-other (Compustat #32)

gen oa =at  - fa
*Operating Assets (OA) = Total Assets (TA, Compustat #6) minus Financial Assets (FA)

by gvkey:gen fo = dlc + dltt + pstk - tstkp + dvpa
 
*Financial Obligations (FO) = debt in current liabilities (#34) plus 
*long term debt (#9) plus preferred stock (#130) minus preferred treasury stock (#227) 
*and plus preferred dividends in arrears (#242)

gen nfo = fo - fa
*Net Financial Obligations (NFO) = Financial Obligations (FO) minus 
*Financial Assets(FA)

gen cse = ceq + tstkp - dvpa

*Common Equity (CSE) = common equity (#60) plus preferred treasury stock (#227)
* minus preferred dividends in arrears (#242)

by gvkey:gen noa = nfo + cse + mib

*Net Operating Assets (NOA) = Net Financial Obligations (NFO) plus Common Equity
* (CSE) and plus Minority Interest (MI, #38)


gen ol = oa - noa
*Operating Liabilities (OL) = Operating Assets (OA) minus Net Operating Assets (NOA)

global mtr = 0.48 
*Marginal Tax Rate=the top statutory federal tax rate plus 2% average state tax rate.

by gvkey:g core_nfe = (xint*(1-$mtr))+dvp - (idit*(1-$mtr))

*Core Net Financial Expense (Core NFE) = after tax interest expense (#15 × (1 - marginal
*tax rate)) plus preferred dividends (#19) and minus after tax interest income (#62 ×
*(1 - marginal tax rate))




g ufe = l.msa - msa
*Unusual Financial Expense (UFE)=lag marketable securities adjustment (lag #238) minus
*marketable securities adjustment (#238)

g nfe = core_nfe + ufe
*Net Financial Expense (NFE) = Core Net Financial Expense (Core NFE) plus Unusual
*Financial Expense (UFE)


g csa = msa- l.msa + recta - l.recta
*Clean Surplus Adjustments to net income (CSA)=marketable securities adjustment (#238)
*minus lag marketable securities adjustment (lag #238) plus cumulative translation adjustment
*(#230) and minus lag cumulative translation adjustment (lag #230).


by gvkey:g cni = ni- dvp + csa
*Comprehensive Net Income (CNI) = net income (#172) minus preferred dividends (#19)
*and plus Clean Surplus Adjustment to net Income (CSA).



g oi = nfe + cni + mii
*Comprehensive Operating Income (OI) = Comprehensive Net Financial Expense (NFE)
*plus Comprehensive Net Income (CNI) and plus Minority Interest in Income (MII, #49).



g uoi = ((nopio- esub)*(1-$mtr)) + (spi*(1-$mtr)) + xido +recta - l.recta
*Unusual Operating Income (UOI) = after tax nonoperating income (expense) excluding
*interest and equity in earnings ((#190 - #55) × (1 - marginal tax rate)) plus after
*tax special items (#17 × (1 - marginal tax rate)) plus extraordinary items & discontinued
*operations (#48) plus cumulative translation adjustment (#230) and minus lag
*cumulative translation adjustment (lag #230)


g other_items = esub
*Other Operating Income Items (Other Items) = Equity in earnings (#55)


g oi_from_sales = oi- other_items
*Operating Income from Sales (OI from Sales) = Operating Income (OI) minus Other
*Operating Income Items (Other Items)


g core_oi_from_sales = oi_from_sales - uoi
*Core Operating Income from Sales (Core OI from Sales) = Operating Income from Sales
*(OI from Sales) minus Unusual Operating Income (UOI)


global rfr = 0.02
*one year risk-free rate = 0.02



g io = $rfr*(ol - txditc)
*Interest on Operating Obligations (io) = the one year risk-free rate at the beginning of
*the year multiplied by the difference between operating liabilities (OL) and “Deferred
*Taxes and Investment Tax Credit” (#35)
**************************************************************************************
**************************************************************************************
**************************************************************************************
**************************************************************************************



**************************************************************************************
***********************2. Ratio Identification****************************************
**************************************************************************************


g roce = cni/l.cse													
* ROCEt = CNIt/CSEt-1  



global rho_e = 0.5
** $rho_e



replace re = roce - (($rho_e - 1)*l.cse) 						// page 114
*REt = [ROCEt - (rho_E - 1)]CSEt-1


replace cni  = oi - nfe											// page 114
*CNI = Comprehensive Operating Income (OI) - Comprehensive Net Financial Expense (NFE)

replace cse = noa - nfo											// page 114					
* CSE = Net Operating Assets (NOA) - Net Financial Obligations (NFO)

*g ta_new = oa +fa


g rnoa = oi/l.noa												// page 115
*Return on Net Operating Assets (RNOA)t= OIt/NOAt-1



g nbc = nfe/l.nfo												// page 115
*Net Borrowing Cost (NBC)t= NFEt/NFOt-1
 

replace roce = (noa*rnoa / cse) - (nfo*nbc/cse)					// page 116
  
g flev = nfo/ cse

g spread = rnoa - nbc

***********************************equation 4*****************************************
**************************************************************************************


g rooa = (oi+io)/oa
*********************************equation 7*******************************************
replace rnoa = (rooa * oa / noa) - ( io*ol/(ol*noa))			// page 118
**************************************************************************************



************************************2.3. Reducing the Analysis************************

g reoi = oi -($rho_w * l.noa)									// page 119

 
********************************************** Equattion 9****************************



g reoi_growth = (reoi/l.reoi - 1)                           	// section 2.4 page 119
g pvfactor = ((((1+ reoi_growth)/(1+ $rho_w))^( $horizon + 1) - 1)/(((1+ reoi_growth)/(1+ $rho_w)) - 1))
g cse_np = noa - nfo
g reoi_bar = reoi*pvfactor
g term_val1 = 0													// page 119
g term_val2 = (reoi*(1+reoi_growth)^($horizon+1))/$rho_w		
g term_val3 = (reoi*(1+reoi_growth)^($horizon+1))/($rho_w - reoi_growth )
g v_0_e1 = cse_np + reoi_bar + term_val1
g v_0_e2 = cse_np + reoi_bar + term_val2
g v_0_e3 = cse_np + reoi_bar + term_val3


**************************************************************************************
**************************************************************************************
**************************End of the variable creation do file************************
**************************************************************************************
**************************************************************************************
