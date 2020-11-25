capture log close
log using "C:\Users\WB459082\OneDrive - WBG\Middle East\buffers\\BufferZoneAnalysis.txt", replace text
/*==================================================
project:       Transition in/out of cropland along buffer zone
Author:        Javier Parada 
E-email:       fparadagomezurqu@worldbank.org
url:           
Dependencies:  The World Bank
----------------------------------------------------
Creation Date:    14 Oct 2020 - 10:06:59
Modification Date:   
Do-file version:   01
References:
Input:             wide.dta, ged201.dta       
Output:            m1_Buffer_RegResults.csv, m2_Buffer_RegResults.csv
==================================================*

Model 1 : Transition out of cropland along buffer zone
Model 2 : Transition into cropland along buffer zone

*==================================================
              0: Program set up
==================================================*/
drop _all
clear all

cd "C:\Users\WB459082\OneDrive - WBG\Middle East\buffers\"

*----------0.1: Define years

local figures 0
local geonear 0

local models "m1 m2"
local base "2009"
local year "2017"

save results, emptyok replace

foreach model of local models{

/*----------0.2: Prepare UCDP data
 
use "ged201.dta", clear

keep if country =="Syria" | country =="Turkey" | country =="Iraq" 
keep if year >= 2015 & year <= `year'

* y = latitude 29-42
* x = longitude 25-50
rename latitude ctlat
rename longitude ctlon

* Drop incomplete events
drop if adm_2==""
drop if adm_1==""
drop if ctlat==35 & ctlon==38

save "ucdp.dta", replace 
*/

/*==================================================
              1: Descriptive Land Use Analysis
==================================================*/

use "wide.dta", clear /*16,860 pixels */

*----------1.1: Keep variables
rename __id______ index
rename __worldpop2017___2017_ worldpop2017
keep index __value___`base'_ *`year'_ worldpop2017
encode __NAME_0___`year'_, gen(Country)

*----------1.2: Buffer size (2,000 pixels each approx.)
tab __bins___`year'_ __NAME_0___`year'_

*----------1.3: Keep croplands from base or end year and recode cropland transitions
* Model 1: Losses
if "`model'"=="m1"{
	
	keep if __value___`base'_==4
	gen cropland_`year'=1 
	replace cropland_`year'=0 if __value___`year'_==4
	label define croplabel 0 "Maintained" 1 "Lost"
	label values cropland_`year' croplabel
	
}

* Model 2: Gains
if "`model'"=="m2"{
	
	keep if __value___`year'_==4
	gen cropland_`year'=1
	replace cropland_`year'=0 if __value___`base'_==4
	label define croplabel 0 "Maintained" 1 "New"
	label values cropland_`year' croplabel
	
}

tab  __bins___`year'_ cropland_`year', row

*----------1.4: Cropland size is larger in Turkey, but almost equal in two middle buffers
tab __bins___`year'_ __NAME_0___`year'_

*----------1.6: Encode longitude variable
encode __x_cat___`year'_, gen(Longitude)
tab Longitude
label dir
*numlabel `r(names)', add
tab Longitude
label define longitude_names 1 "37-38" 2 "38-39" 3 "39-40" 4 "40-41" 
label values Longitude longitude_names
tab Longitude 

*----------1.7: Summarize M1 7,524 pixels M2 6,930 pixels 
summarize 

*----------1.8: Table 1 same as figures
tab  __bins___`year'_ cropland_`year', row
*bysort Longitude: tab  __bins___`year'_ cropland_`year', row


/* 
Model 1
    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
       index |      7,524    6929.516    4439.081          0      16859
__row_~2017_ |      7,524    1139.493    130.0313        890       1530
__col_~2017_ |      7,524    2960.598     270.522       2525       3410
__valu~2009_ |      7,524           4           0          4          4
__valu~2017_ |      7,524    3.748405    .6653869          2          7
-------------+---------------------------------------------------------
 __x___2017_ |      7,524    38.96262     1.21507    37.0061   40.98114
 __y___2017_ |      7,524    36.99041    .5840457   35.23642   38.11103
__Uniq~2017_ |      7,524    570.2226    366.1711        201       1057
__NAME_0__~_ |          0
__NAME_1__~_ |          0
-------------+---------------------------------------------------------
__NAME_2__~_ |          0
__Dist~2017_ |      7,524    .1746697    .5086959  -.9933749   .9999355
worldpop2017 |      7,524    100.2331     256.716     2.4236    6166.19
__bins~2017_ |      7,524     4.17916    2.030883          0          7
__x_ca~2017_ |          0
-------------+---------------------------------------------------------
__y_ca~2017_ |          0
__Land~2017_ |          0
     Country |      7,524    1.589979    .4918699          1          2
croplan~2017 |      7,524    .1265284    .3324661          0          1
   Longitude |      7,524    2.484716    1.170171          1          4

   
Model 2
    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
       index |      6,930    6403.853    4267.622          0      16859
__row_~2017_ |      6,930    1124.198    124.8754        890       1530
__col_~2017_ |      6,930    2986.569    270.5054       2525       3410
__valu~2009_ |      6,930    3.896825    .4422535          2          4
__valu~2017_ |      6,930           4           0          4          4
-------------+---------------------------------------------------------
 __x___2017_ |      6,930    39.07927    1.214996    37.0061   40.98114
 __y___2017_ |      6,930    37.05911    .5608873   35.23642   38.11103
__Uniq~2017_ |      6,930    619.5339     366.938        201       1057
__NAME_0__~_ |          0
__NAME_1__~_ |          0
-------------+---------------------------------------------------------
__NAME_2__~_ |          0
__Dist~2017_ |      6,930    .2351705    .4901035  -.9933749   .9999355
worldpop2017 |      6,930    101.3051    278.7216    1.82693    6166.19
__bins~2017_ |      6,930    4.422078    1.959631          0          7
__x_ca~2017_ |          0
-------------+---------------------------------------------------------
__y_ca~2017_ |          0
__Land~2017_ |          0
     Country |      6,930    1.662193    .4729964          1          2
croplan~2017 |      6,930    .0516595    .2213545          0          1
   Longitude |      6,930    2.602453    1.159135          1          4

*/

/*==================================================
              2: Figures
==================================================*/
* http://repec.sowi.unibe.ch/stata/palettes/getting-started.html
* colorpalette lin fruits
if `figures'{
* Model 1: Losses
if "`model'"=="m1"{
	
	local colors "bar(1, color(64 105  166)) bar(2, color(255 86 29))"
	*local title "title("Transition out of cropland along buffer zone")"
	local title "title("Sampled Pixels")"
	local title2 "title("Sampled Pixels (%)")"
	
	*----------2.1: Figure 1 
	* if  __value___`base'_==4
	graph bar (count), 	over(cropland_`year') asyvars ///
						over(__bins___`year'_, label(angle(45) labsize(small))) ///
						over(Country, gap(90)) nofill stack blabel(total) /// 		
						`title' ///
						/// subtitle("Have `base' croplands changed in `year'?")  /// legend(label(1 "Grass") label(2 "Cropland") ) 
						`colors'
	graph display, ysize(5)
	graph export "figures\\count\\`model'_finding_gdp_bar_`base'_`year'.png", width(1200) replace
	
	*----------2.2: Figure 2
	* if  __value___`base'_==4
	graph bar (count) , over(cropland_`year')  ///
						over(__bins___`year'_, label(angle(45) labsize(small))) ///
						over(Country, gap(90)) nofill stack asyvars blabel(total, size(vsmall)) ///
						by(Longitude, `title') ///
						ylabel(, labsize(tiny)) ///
						`colors'
	graph display, ysize(5)
	graph export "figures\\count\\`model'_finding_gdp_bar_`base'_`year'_v2.png", width(1200) replace
	
	*----------2.3: Figure 3
	* if  __value___`base'_==4
	graph bar (count), 	over(cropland_`year')  ///
						over(__bins___`year'_, label(angle(45) labsize(small))) ///
						over(Country, gap(90)) nofill stack asyvars blabel(total, format(%9.0f) size(vsmall)) percentages /// 		
						`title2' ///
						/// subtitle("Have `base' croplands changed in `year'?") /// legend(label(1 "Grass") label(2 "Cropland") ) 
						`colors'
	graph display, ysize(5)
	graph export "figures\\perc\\`model'_finding_gdp_bar_`base'_`year'.png", width(1200) replace
	
	*----------2.4: Figure 4
	* if  __value___`base'_==4
	graph bar (count) , over(cropland_`year')  ///
						over(__bins___`year'_, label(angle(45) labsize(small))) ///
						over(Country, gap(90)) nofill stack asyvars blabel(total, format(%9.0f) size(vsmall)) percentages ///
						by(Longitude, `title2') /// legend(off)
						ylabel(, labsize(tiny)) ///
						`colors'
	graph display, ysize(5)
	graph export "figures\\perc\\`model'_finding_gdp_bar_`base'_`year'_v2.png", width(1200) replace
	
}

* Model 1: Losses
if "`model'"=="m2"{
	
	local colors "bar(1, color(64 105  166)) bar(2, color(146 195 51))"
	*local title "title("Transition into cropland along buffer zone")"
	local title "title("Sampled Pixels")"
	local title2 "title("Sampled Pixels (%)")"
	
	*----------2.1: Figure 1 
	* if  __value___`year'_==4
	graph bar (count), 	over(cropland_`year')  ///
						over(__bins___`year'_, label(angle(45 ))) ///
						over(Country, gap(90)) nofill stack asyvars blabel(total) /// 		
						`title' ///
						/// subtitle("Are `year' croplands newly developed since `base'?")  /// legend(label(1 "Grass") label(2 "Cropland") )  
						`colors'
	graph display, ysize(5)
	graph export "figures\\count\\`model'_finding_gdp_bar_`base'_`year'.png", width(1200) replace

	*----------2.2: Figure 2
	* if  __value___`year'_==4
	graph bar (count) , over(cropland_`year')  ///
						over(__bins___`year'_, label(angle(45) labsize(small) )) ///
						over(Country, gap(90)) nofill stack asyvars blabel(total, size(vsmall)) ///
						by(Longitude, `title') /// legend(off)
						ylabel(, labsize(tiny)) ///
						`colors'
	graph display, ysize(5)				
	graph export "figures\\count\\`model'_finding_gdp_bar_`base'_`year'_v2.png", width(1200) replace
	
		*----------2.3: Figure 3
	* if  __value___`year'_==4
	graph bar (count), 	over(cropland_`year')  ///
						over(__bins___`year'_, label(angle(45 ))) ///
						over(Country, gap(90)) nofill  stack asyvars blabel(total, format(%9.0f) size(vsmall)) percentages /// 		
						`title2' ///
						/// subtitle("Are `year' croplands newly developed since `base'?")  /// legend(label(1 "Grass") label(2 "Cropland") )  
						`colors'
	graph display, ysize(5)
	graph export "figures\\perc\\`model'_finding_gdp_bar_`base'_`year'.png", width(1200) replace

	*----------2.4: Figure 4
	* if  __value___`year'_==4
	graph bar (count) , over(cropland_`year')  ///
						over(__bins___`year'_, label(angle(45) labsize(small) )) ///
						over(Country, gap(90)) nofill stack asyvars blabel(total, format(%9.0f) size(vsmall)) percentages ///
						by(Longitude, `title2') /// legend(off) 
						ylabel(, labsize(tiny)) ///
						`colors'
	graph display, ysize(5)				
	graph export "figures\\perc\\`model'_finding_gdp_bar_`base'_`year'_v2.png", width(1200) replace
}
}

/*==================================================
              3: Match violence data
==================================================*/

*----------3.1: Save as pixels tempfile 
rename __y___`year'_ bglat
rename __x___`year'_ bglon
*scatter bglat bglon
tempfile pixels
save "`pixels'"

*----------3.2: Apply geonear
if `geonear'{
	geonear index bglat bglon using "ucdp", n(id ctlat ctlon) within(5) long near(0)
	merge m:1 id using "ucdp.dta"
	keep if _merge==3
	collapse (count) ucdp_events=id (rawsum) ucdp_deaths=best (mean) meankm_ucdp=km_to_id, by(index)
	save "`model'_ucdp_matches.dta", replace
}

*----------3.3: Merge UCDP data to pixels
use "`pixels'", clear
merge 1:1 index using "`model'_ucdp_matches.dta"
rename _merge ucdp_violence
recode ucdp_violence (1=0) (3=1)
replace ucdp_deaths=0 if ucdp_deaths==.
replace ucdp_events=0 if ucdp_events==.
label define violentornot 0 "Non-Violent" 1 "Violent"
label values ucdp_violence violentornot 

* More violence in Syrian side
tab Country ucdp_violence, row /*62.56 vs 3*/
tab Country, sum(ucdp_deaths) /* 63 vs 1 */
tab Country, sum(ucdp_events) /* 9 vs .27*/

* Violence in Syria is not the highest next to border
tab __bins___`year'_ ucdp_violence, row /* Second buffer is highest */
tab __bins___`year'_, sum(ucdp_deaths) /* Third buffer is highest */
tab __bins___`year'_, sum(ucdp_events) /* Third buffer is highest */

sum ucdp*
/*
    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
 ucdp_events |      7,524    8.396332    55.49301          0       3843
 ucdp_deaths |      7,524    46.93315     331.748          0      20430
 ucdp_meankm |      2,515    3.345847     .906248   .2132345   4.992366
ucdp_viole~e |      7,524    .3342637    .4717638          0          1
*/

bysort ucdp_violence: tab  __NAME_0___`year'_ cropland_`year', row

/*==================================================
              4: Regressions
==================================================*/
*http://repec.sowi.unibe.ch/stata/coefplot/getting-started.html
levelsof Longitude, local(longitude_levels) 
/*
numlabel , add

   1. 37-38 |      2,092       27.80       27.80
   2. 38-39 |      1,812       24.08       51.89
   3. 39-40 |      1,501       19.95       71.84
   4. 40-41 |      2,119       28.16      100.00

tab Longitude
*/


estimates clear

** Regressions

local baselevel "ib0"

	eststo: reg cropland_`year'   `baselevel'.__bins___`year'_
	regsave using results, addlabel(model, `model', subsample, 0, regression, reg cropland bins) append

coefplot , baselevels drop(_cons) vertical yline(0) xlabel(, labsize(small) angle(vertical)) ///
			xtitle("Buffers") ytitle("Coefficients") title("OLS regression")
graph display, ysize(5)
graph export "figures\\coefficients\\`model'_reg_`base'_`year'_v1.png", width(1200) replace

****
	reg cropland_`year'   `baselevel'.__bins___`year'_ if Longitude==1
	estimates store long_37_38
	regsave using results, addlabel(model, `model', subsample,1, regression, reg cropland bins) append
	
	reg cropland_`year'   `baselevel'.__bins___`year'_ if Longitude==2
	estimates store long_38_39
	regsave using results, addlabel(model, `model', subsample,2, regression, reg cropland bins) append
	
	reg cropland_`year'   `baselevel'.__bins___`year'_ if Longitude==3
	estimates store long_39_40
	regsave using results, addlabel(model, `model', subsample,3, regression, reg cropland bins) append
	
	reg cropland_`year'   `baselevel'.__bins___`year'_ if Longitude==4
	estimates store long_40_41
	regsave using results, addlabel(model, `model', subsample,4, regression, reg cropland bins) append
	

coefplot (long_37_38 \ long_38_39 \ long_39_40 \ long_40_41), drop(_cons) vertical yline(0) aseq  baselevels /// swapnames ///
			xlabel(, labsize(small) angle(vertical)) xtitle("Buffers") ytitle("Coefficients") title("OLS regression by Longitude") ///
			coeflabels(est2 = "37-38"  est3 = "38-39" est4 = "39-40"  est5 = "40-41")
graph display, ysize(5)
graph export "figures\\coefficients\\`model'_reg_`base'_`year'_v2.png", width(1200) replace


** Logit
	eststo: logit cropland_`year'   `baselevel'.__bins___`year'_
	regsave using results, addlabel(model, `model', subsample, 0, regression, logit cropland bins) append

coefplot, baselevels drop(_cons) vertical yline(0) xlabel(, labsize(small) angle(vertical)) ///
			xtitle("Buffers") ytitle("Coefficients") title("Logit regression")
graph display, ysize(5)
graph export "figures\\coefficients\\`model'_logit_`base'_`year'_v1.png", width(1200) replace

	logit cropland_`year'   `baselevel'.__bins___`year'_ if Longitude==1
	estimates store long_37_38
	regsave using results, addlabel(model, `model', subsample,1, regression, logit cropland bins) append
	
	logit cropland_`year'   `baselevel'.__bins___`year'_ if Longitude==2
	estimates store long_38_39
	regsave using results, addlabel(model, `model', subsample,2, regression, logit cropland bins) append
	
	logit cropland_`year'   `baselevel'.__bins___`year'_ if Longitude==3
	estimates store long_39_40
	regsave using results, addlabel(model, `model', subsample,3, regression, logit cropland bins) append
	
	logit cropland_`year'   `baselevel'.__bins___`year'_ if Longitude==4
	estimates store long_40_41
	regsave using results, addlabel(model, `model', subsample,4, regression, logit cropland bins) append
	
coefplot (long_37_38 \ long_38_39 \ long_39_40 \ long_40_41), drop(_cons) vertical yline(0) aseq  baselevels ///
			xlabel(, labsize(small) angle(vertical)) xtitle("Buffers") ytitle("Coefficients") title("Logit regression by Longitude") ///
			coeflabels(est7 = "37-38"  ///
					   est8 = "38-39" ///
					   est9 = "39-40"  ///
					   est10 = "40-41")
graph display, ysize(5)
graph export "figures\\coefficients\\`model'_logit_`base'_`year'_v2.png", width(1200) replace

*http://repec.org/bocode/e/estout/esttab.html
esttab* using "`model'_Buffer_RegResults.csv", se compress replace
estimates clear
export delimited using "`model'_qgis.csv", replace

}

use results, clear

gen LongitudeLabel = ""
replace LongitudeLabel = "All" if subsample==0
replace LongitudeLabel = "37-38" if subsample==1
replace LongitudeLabel = "38-39" if subsample==2
replace LongitudeLabel = "39-40" if subsample==3
replace LongitudeLabel = "40-41" if subsample==4

*keep if LongitudeLabel == "All"
split var, parse(".")
split var1, parse(":")
replace var12= var11 if var12==""
drop var1 var2 var11
rename var12 bin
order bin
sort model regression subsample bin
br if model=="m1" & subsample==1
gen gains_losses="Losses"
replace gains_losses="Gains" if model=="m2"

export excel using "results.xls",  firstrow(variables) replace



log close
exit
/* End of do-file */

><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><

Notes:
1.
2.
3.


Version Control:


/* backup

__bins___2017 |               __value___2017_
            _ |         2          4          5          7 |     Total
--------------+--------------------------------------------+----------
(-1.0, -0.75] |        68        183          1          1 |       253 
              |     26.88      72.33       0.40       0.40 |    100.00 
--------------+--------------------------------------------+----------
(-0.75, -0.5] |       151        399          0          0 |       550 
              |     27.45      72.55       0.00       0.00 |    100.00 
--------------+--------------------------------------------+----------
(-0.5, -0.25] |       276        533          0          0 |       809 
              |     34.12      65.88       0.00       0.00 |    100.00 
--------------+--------------------------------------------+----------
 (-0.25, 0.0] |       296      1,177          0          0 |     1,473 
              |     20.10      79.90       0.00       0.00 |    100.00 
--------------+--------------------------------------------+----------
  (0.0, 0.25] |        69      1,176          0          0 |     1,245 
              |      5.54      94.46       0.00       0.00 |    100.00 
--------------+--------------------------------------------+----------
  (0.25, 0.5] |        15        596          0          0 |       611 
              |      2.45      97.55       0.00       0.00 |    100.00 
--------------+--------------------------------------------+----------
  (0.5, 0.75] |        52      1,206          1          0 |     1,259 
              |      4.13      95.79       0.08       0.00 |    100.00 
--------------+--------------------------------------------+----------
  (0.75, 1.0] |        22      1,302          0          0 |     1,324 
              |      1.66      98.34       0.00       0.00 |    100.00 
--------------+--------------------------------------------+----------
        Total |       949      6,572          2          1 |     7,524 
              |     12.61      87.35       0.03       0.01 |    100.00 
