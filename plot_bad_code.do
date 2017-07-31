 version 13
 set more off
 clear all
 capture log close
 log using "plot", text replace
 
 /* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
 NOTES
  This file uses the dataset basedata_w_summ_stat to make plots
  
  this version: 2 May 2016
  author: Rajib Doogar
    $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ */ 

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
 global other_r = "cash_to_sales_ratio cash_to_total_asset cash_to_total_debt current_asset_to_sales_ratio curr_asset_to_total_asset_ratio curr_debt_to_total_debt_ratio op_inc_to_sales_ratio op_inc_to_total_assets_ratio op_inc_to_total_debts_ratio op_inc_plus_depr_to_sales_ratio op_inc_plus_depr_to_AT_ratio op_inc_plus_depr_to_LT_ratio cash_flow_to_sales_ratio cash_flow_to_assets_ratio cash_flow_to_debts_ratio cash_flow_to_assets_ratio cogs_to_inventory_ratio cogs_to_sales_ratio inventory_to_current_assets_ratio inventory_to_sales_ratio inventory_to_working_capital_ratio long-term_debt_to_total_asset_ratio receivables_to_inventory_ratio receivables_to_sales_ratio sales_to_receivables_ratio sales_to_total_asset_ratio working_cap_to_sales_ratio working_cap_to_total_asset_ratio working_cap_to_total_debt_ratio total_debt_to_equity_ratio equity_to_net_profits_before_tax"
 * One ring of rings
 global all_r = "$trad_r $kdj_r $np_r $other_r"
 
 *************************************************************************
 * Define Targets, Industries and Reporting Groups
 *************************************************************************
 * define list of targets
 global tlist = "MT X STLD NUE"
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
 capture mkdir industry_graphs
 capture mkdir industry_graphs1
 cd industry_graphs1
 * make a basic box graph
 foreach ind in $indlist1 {      
 foreach x in $B1 $all_r {
 levelsof `ind', l(ind_level) 
 foreach level of local ind_level {
 graph box `x' if `ind'==`level', order(fyear)  ///
	   ytitle("`:variable label `x''") ylabel(, labsize(small) angle(horizontal)) ymtick(, angle(horizontal)) ///
	   xtitle(Fiscal year) xlabel(#10, labsize(medsmall) angle(forty_five) grid) ///
	   title("Graph of `:variable label `x''") subtitle("`ind'==`level' (2005-2014)") ///
	   saving(box_`ind'_`level'_`x', replace)
                                }
                  				    }
				           }
 * now a more complicated story ... "designing a picture to tell a story"
 cd ..
 cd industry_graphs
 foreach ind in $indlist1 {      
 foreach x in $B1 $all_r {
 tempvar lhinge uhinge upper lower mean median  
 bys `ind' fyear: egen lhinge = pctile(`x'), p(25) 
 bys `ind' fyear: egen uhinge = pctile(`x'), p(75) 
 bys `ind' fyear: egen median = pctile(`x'), p(50) 
 bys `ind' fyear: egen lower = pctile(`x'), p(05) 
 bys `ind' fyear: egen upper = pctile(`x'), p(95) 
 bys `ind' fyear: egen mean = mean(`x') 
 levelsof `ind', l(ind_level) 
 * set trace on
 foreach level of local ind_level {
 twoway (rbar lhinge uhinge fyear if `ind'==`level' & fyear!=. & tic!="", fcolor(gs12) barwidth(0.6)) ///
       (rcap upper lower fyear if `ind'==`level' & fyear!=. & tic!="", sort lwidth(thin) msize(medium)) ///
	   (connected mean fyear if `ind'==`level' & fyear!=. & tic!="", sort mcolor(red) msize(vsmall) msymbol(diamond)) ///
	   (connected median fyear if `ind'==`level' & tic!="" & fyear!=., sort mcolor(yellow) msize(vsmall) msymbol(diamond)) ///
	   (scatter at fyear if `ind'==`level' & tic!="" & fyear!=. & at>uhinge & at<upper, sort mcolor(dkgreen) msize(tiny) msymbol(square)) ///
	   (scatter at fyear if `ind'==`level' & tic!="" & fyear!=. & at>upper, sort mcolor(blue) msize(tiny) msymbol(lgx)), ///
	   ytitle("`:variable label `x''") ylabel(, labsize(small) angle(horizontal)) ymtick(, angle(horizontal)) ///
	   xtitle(Fiscal year) xlabel(#10, labsize(medsmall) angle(forty_five) grid) ///
	   title("Graph of `:variable label `x''") subtitle("`ind'==`level' (2005-2014)") ///
	   saving(`ind'_`level'_`x', replace)
                                }
 drop lhinge uhinge median lower upper mean
				  }
				           }
* and now a monster loop
/*
 cd ..
 capture mkdir monster_loop
 cd monster_loop
 foreach ind in $indlist {      
 foreach x in $all {
 tempvar lhinge uhinge upper lower mean median  
 bys `ind' fyear: egen lhinge = pctile(`x'), p(25) 
 bys `ind' fyear: egen uhinge = pctile(`x'), p(75) 
 bys `ind' fyear: egen median = pctile(`x'), p(50) 
 bys `ind' fyear: egen lower = pctile(`x'), p(05) 
 bys `ind' fyear: egen upper = pctile(`x'), p(95) 
 bys `ind' fyear: egen mean = mean(`x') 
 levelsof `ind', l(ind_level) 
 foreach level of local ind_level {
 twoway (rbar lhinge uhinge fyear if `ind'==`level' & fyear!=. & tic!="", fcolor(gs12) barwidth(0.6)) ///
       (rcap upper lower fyear if `ind'==`level' & fyear!=. & tic!="", sort lwidth(thin) msize(medium)) ///
	   (connected mean fyear if `ind'==`level' & fyear!=. & tic!="", sort mcolor(red) msize(vsmall) msymbol(diamond)) ///
	   (connected median fyear if `ind'==`level' & tic!="" & fyear!=., sort mcolor(yellow) msize(vsmall) msymbol(diamond)) ///
	   (scatter at fyear if `ind'==`level' & tic!="" & fyear!=. & at>uhinge & at<upper, sort mcolor(dkgreen) msize(tiny) msymbol(square)) ///
	   (scatter at fyear if `ind'==`level' & tic!="" & fyear!=. & at>upper, sort mcolor(blue) msize(tiny) msymbol(lgx)), ///
	   ytitle("`:variable label `x''") ylabel(, labsize(small) angle(horizontal)) ymtick(, angle(horizontal)) ///
	   xtitle(Fiscal year) xlabel(#10, labsize(medsmall) angle(forty_five) grid) ///
	   title("Graph of `:variable label `x''") subtitle("`ind'==`level' (2005-2014)") ///
	   saving(`ind'_`level'_`x', replace)
                                }
 drop lhinge uhinge median lower upper mean
				  }
				           }
 cd ..
*/
 * %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 * Exit nicely
 * $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
 log close
 exit

/*

 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Miscellaneous old code
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 // from csfs.do ...
 * create reporting groups
 generate  rgroup=0 if inlist(gvkey,"mean","min","p10","p25","p50","p75","p90","max")    // we want to exclude these from being treated as observations
 replace   rgroup=0 if inlist(gvkey,"count","sum","sd")                                  // likewise these as well ...
 replace   rgroup=1 if inlist(tic,"IBM","MSFT","FDC","ORCL","XRX","EA")                  // list of target firms (sic==73)

 * creating headers for output columns of csfs
 glo rgroupname    "$tlist Industry"                                                     // specify order of column headers within each year
 glo colnames      "$rgroupname $rgroupname $rgroupname $rgroupname $rgroupname"         // number of repetitions = # of years (of csfs produced, here 5: 2009-2013)

 * housekeeping

   * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   *  Another monster loop .... this time plotting target and peer firms against industry
   *   we have selected IBM, MSFT, ORCL and XRX as our target & peer firms and sic2==73
   *   as our industry of choice.  We start by dropping all 
   * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   * first run "make_basedata_w_summary_stat" to create the data set "basedata_w_summary_stat.dta"
   * then uncomment the folloiwng line:
   
   * use basedata_w_summary_stat
   
   preserve               // protect data
   keep if sic2==73       // reduce size of data set
   foreach x in $all {
   twoway (connected `x' fyear if tic=="`tic1'", sort msize(small)) ///
	   (connected `x' fyear if tic=="`tic2'", sort msize(vsmall)) ///
	   (connected `x' fyear if tic=="`tic3'", sort msize(vsmall)) ///
	   (connected `x' fyear if tic=="`tic4'", sort msize(vsmall)) , ///
	   ylabel(#10, angle(horizontal) grid) xlabel(#25, angle(forty_five) grid) ///
	   title(`: variable label `x'') subtitle((1980 - 2014)) ///
	   legend(order(1 "`tic1'" 2 "`tic2'" 3 "`tic3'" 4 "`tic4'")) scheme(sj) saving(`x'_type1_group1, replace)
   twoway (scatter   `x' fyear if rgroup!=0, sort msize(small)) ///
       (connected `x' fyear if tic=="`tic1'", sort msize(small)) ///
	   (connected `x' fyear if tic=="`tic2'", sort msize(vsmall)) ///
	   (connected `x' fyear if tic=="`tic3'", sort msize(vsmall)) ///
	   (connected `x' fyear if tic=="`tic4'", sort msize(vsmall)) , ///
	   ylabel(#10, angle(horizontal) grid) xlabel(#25, angle(forty_five) grid) ///
	   title(`: variable label `x'') subtitle((1980 - 2014)) ///
	   legend(order(1 "`tic1'" 2 "`tic2'" 3 "`tic3'" 4 "`tic4'")) scheme(sj) saving(`x'_type2_group1, replace)
   twoway (bar     `x' fyear if gvkey=="sum", sort yaxis(2) fcolor(ebg) fintensity(10)) ///
       (scatter `x' fyear if rgroup!=0, sort msize(small)) ///
	   (line    `x' fyear if gvkey =="mean", sort) ///                       // notice the value of the industry mean of `x' is from the obs with gvkey=="mean" & sic2==73
       (line    `x' fyear if gvkey =="p50", sort) ///                        // likewise the value of the industry mean of `x' is from the obs with gvkey=="p50" & sic2==73
	   (connected `x' fyear if tic=="`tic1'", sort) ///
	   (connected `x' fyear if tic=="`tic2'", sort) ///
	   (connected `x' fyear if tic=="`tic3'", sort) ///
	   (connected `x' fyear if tic=="`tic4'", sort), ///
	   ylabel(#10, angle(horizontal) grid) ytitle(SIC Sum `: variable label `x'', axis(2)) xlabel(#12, grid) ///             // note the label syntax, also the legend order below
       title(`: variable label `x'') subtitle("SIC code 73 (1980 - 2014)") ///
       legend(order(1 "SIC Sum" 2 `"`: variable label `x''"' 3 "SIC mean" 4 "SIC median" 5 "`tic1'" 6 "`tic2'" 7 "`tic3'" 8 "`tic4'")) ///
	   scheme(sj) scale(0.8) saving(`x'_type3_group1, replace)
   twoway (bar     `x' fyear if gvkey=="sum", sort yaxis(2) fcolor(ebg) fintensity(10)) ///
       (scatter `x' fyear if rgroup!=0, sort msize(small)) ///
	   (line    `x' fyear if gvkey =="mean", sort) ///                       // notice the value of the industry mean of `x' is from the obs with gvkey=="mean" & sic2==73
       (line    `x' fyear if gvkey =="p25", sort) ///                        // likewise the value of the industry mean of `x' is from the obs with gvkey=="p25" & sic2==73
       (line    `x' fyear if gvkey =="p50", sort) ///                        // likewise the value of the industry mean of `x' is from the obs with gvkey=="p50" & sic2==73
	   (line    `x' fyear if gvkey =="p75", sort) ///                        // likewise the value of the industry mean of `x' is from the obs with gvkey=="p50" & sic2==73
	   (connected `x' fyear if tic=="`tic1'", sort) ///
	   (connected `x' fyear if tic=="`tic2'", sort) ///
	   (connected `x' fyear if tic=="`tic3'", sort) ///
	   (connected `x' fyear if tic=="`tic4'", sort), ///
	   ylabel(#10, angle(horizontal) grid) ytitle(SIC Sum `: variable label `x'', axis(2)) xlabel(#12, grid) ///             // note the label syntax, also the legend order below
       title(`: variable label `x'') subtitle("SIC code 73 (1980 - 2014)") ///
       legend(order(1 "SIC Sum" 2 `"`: variable label `x''"' 3 "SIC mean" 4 "SIC Q1" 5 "SIC median" 6 "SIC Q3" ///
	   7 "`tic1'" 8 "`tic2'" 9 "`tic3'" 10 "`tic4'")) ///
	   scheme(sj) scale(0.8) saving(`x'_type4_group1, replace)
	   }
 restore

 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 * close and exit
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 

 log close
 exit
 
 
 
 /*  tet more old code

bys sic2 fyear: egen lhinge = pctile(at), p(25) 
bys sic2 fyear: egen uhinge = pctile(at), p(75) 
bys sic2 fyear: egen median = pctile(at), p(50) 
bys sic2 fyear: egen lower = pctile(at), p(05) 
bys sic2 fyear: egen upper = pctile(at), p(99) 
bys sic2 fyear: egen mean = mean(at) 
twoway (rbar lhinge uhinge fyear if sic2==73 & fyear!=. & tic!="", fcolor(gs12) barwidth(0.6)) ///
       (rcap upper lower fyear if sic2==73 & fyear!=. & tic!="", sort lwidth(thin) msize(medium)) ///
	   (scatter mean fyear if sic2==73 & fyear!=. & tic!="", sort mcolor(red) msize(vsmall) msymbol(diamond)) ///
	   (scatter median fyear if sic2==73 & tic!="" & fyear!=., sort mcolor(black) msize(vsmall) msymbol(diamond)) ///
	   (scatter at fyear if sic2==73 & tic!="" & fyear!=. & at>uhinge & at<upper, sort mcolor(dkgreen) msize(tiny) msymbol(square)) ///
	   (scatter at fyear if sic2==73 & tic!="" & fyear!=. & at>upper, sort mcolor(blue) msize(tiny) msymbol(lgx)), ///
	   ytitle("`:variable label at', $ Billions") ylabel(, labsize(small) angle(horizontal)) ymtick(, angle(horizontal)) ///
	   xtitle(Fiscal year) xlabel(#10, labsize(medsmall) angle(forty_five) grid) ///
	   title(Graph of `:variable label at') subtitle("sic2==73 (2005-2014)") legend(off)
 
 
/* still older code ...

generate depvar=.      // generate shell variable for graphing
 * scatter for observations and lines for mean and target firms
   twoway (line depvar fyear if gvkey =="mean", sort) ///
          (line depvar fyear if gvkey =="p50", sort) (connected depvar fyear if tic=="IBM", sort) ///
	      (connected depvar fyear if tic=="MSFT", sort) (connected depvar fyear if tic=="ORCL", sort), ///
		  ylabel(#10, angle(horizontal) grid) xlabel(#12, grid) title($depvar) ///
		  subtitle(SIC code 73) legend(order(1 "$depvar " 2 "SIC mean" 3 "SIC median" 4 "IBM" 5 "MSFT" 6 "ORCL")) ///
		  scheme(sj) scale(0.8) saving("line-scatter_1_73.gph", replace)
		  
		  /*
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

		  ** exploring tokenization ...
from Cox:  SJ 3(2):185--202  Speaking Stata:  Problems with lists [http://www.stata-journal.com/sjpdf.html?articlenum=pr0009]
tokenize ‘mylist’
forvalues i = 1/‘: list sizeof mylist’ {
local ‘i’ : display _dup(3) "‘‘i’’ "
local newlist "‘newlist’‘‘i’’ "
}

tokenize ‘$tlist’
forvalues i = 1/‘: list sizeof tlist’ {
local ‘i’ : display _dup(3) "‘‘i’’ "
local newlist "‘newlist’‘‘i’’ "
}


