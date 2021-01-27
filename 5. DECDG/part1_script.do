capture log close
log using "C:\Users\WB459082\OneDrive - WBG\Documents\Code-examples\5. DECDG\part1_script1.txt", replace text
/*==================================================
Project:       Part 1: People using safely managed sanitation services (% of population)
Author:        Francisco Javier Parada Gomez Urquiza
E-email:       fparadagomezurqu@worldbank.org
url:           https://paradajavier.com/
Dependencies:  The World Bank
----------------------------------------------------
Creation Date:    26 Jan 2021 - 12:50:55
Modification Date:   
Do-file version:    01
References:          
Output:             Part1.docx
==================================================*/

/*==================================================
              0: Program set up
==================================================*/
version 16.1
drop _all
clear all
cd "C:\Users\WB459082\OneDrive - WBG\Documents\Code-examples\5. DECDG\"
capture which wbopendata
if _rc==111 ssc install wbopendata

/*==================================================
              1: Download data from API
==================================================*/
/*
tempfile append

*----------1.1: All
*wbopendata, language(en - English) country() topics() indicator(SH.STA.SMSS.ZS - People using safely managed sanitation services (% of population)) clear
wbopendata, language(en - English) country() topics() indicator(SH.STA.SMSS.ZS - People using safely managed sanitation services (% of population)) clear long
rename sh_sta_smss_zs  percent
gen ruralUrban="Total"
save `append', replace

*----------1.2: Rural
*wbopendata, language(en - English) country() topics() indicator(SH.STA.SMSS.RU.ZS - People using safely managed sanitation services, rural (% of rural population)) clear
wbopendata, language(en - English) country() topics() indicator(SH.STA.SMSS.RU.ZS - People using safely managed sanitation services, rural (% of rural population)) clear long
rename sh_sta_smss_ru_zs percent
gen ruralUrban="Rural"
append using `append'
save `append', replace

*----------1.3: Urban
*wbopendata, language(en - English) country() topics() indicator(SH.STA.SMSS.RU.ZS - People using safely managed sanitation services, rural (% of rural population)) clear
wbopendata, language(en - English) country() topics() indicator(SH.STA.SMSS.UR.ZS - People using safely managed sanitation services, urban (% of urban population)) clear long
rename sh_sta_smss_ur_zs percent
gen ruralUrban="Urban"
append using `append'
save `append', replace

/*==================================================
              2: Explore data
==================================================*/

drop if percent==.
sort countryname year
tab year ruralUrban 
reshape wide percent, i(countryname year) j(ruralUrban) string

*----------2.1: 
gen order = .
replace order= 1 if incomelevelname=="Low income"
replace order= 2 if incomelevelname=="Lower middle income"
replace order= 3 if incomelevelname=="Upper middle income"
replace order= 4 if incomelevelname=="High income"

label define lblincomelevelname 1 "Low" 2 "Lower middle" 3 "Upper middle" 4 "High"
label values order lblincomelevelname

*----------2.2:
bys countryname: egen mean = mean(percentTotal)
gen average = string(mean, "%8.2f") + "%"
gen countryname2 = countryname + " " + incomelevel

*----------2.3:
levelsof region, local(regionList)
sort countryname year
tempfile database
save `database', replace
foreach r of local regionList{
	use `database', clear
	keep if region=="`r'"
	graph twoway /// 
	(line percentTotal year) ///
	(line percentRural year) ///
	(line percentUrban year) ///
	, by(average countryname2, title(People using safely managed sanitation services) subtitle((% of population)) note(Source: World Development Indicators (`r' region))) // caption(nn) 
	graph export "graphs\\`r'.pdf", replace
}
*/
/*==================================================
              3: Figure 
==================================================*/

*----------3.1: Download data wide
wbopendata, language(en - English) country() topics() indicator(SH.STA.SMSS.ZS - People using safely managed sanitation services (% of population)) clear
foreach var of varlist _all {
	capture assert mi(`var')
	if !_rc {
		drop `var'
	}
}
local baseyear "yr2012"
local endyear "yr2017"
gen difference = `endyear' - `baseyear' 
drop if region=="NA"
drop if difference==.

*----------3.2: Figure Scatterplot
local options "mlabel(countrycode) mlabsize(half_tiny) mlabposition(0) mlabcolor(black)"
graph twoway ///
	(scatter difference `baseyear' if incomelevelname=="Low income", `options' mcolor(red)) ///
	(scatter difference `baseyear' if incomelevelname=="Lower middle income", `options' mcolor(midblue)) ///
	(scatter difference `baseyear' if incomelevelname=="Upper middle income", `options' mcolor(blue)) ///
	(scatter difference `baseyear' if incomelevelname=="High income", `options' mcolor(green)) ///
	(qfit difference `baseyear') ///
	, legend(label(1 "Low income") label(2 "Lower middle income") label(3 "Upper middle income") label(4 "High income")) ///
	 ytitle(Change = `endyear' - `baseyear') xtitle(Baseyear = `baseyear') title(People using safely managed sanitation services) subtitle((% of population)) note(Source: World Development Indicators) scheme(plotplain)  

graph export "graphs\\Graph`baseyear'_`endyear'.png", replace

*----------3.3: Create document
putdocx begin

putdocx paragraph, halign(center)
putdocx text ("Part 1")
putdocx paragraph, halign(center)
putdocx text ("Javier Parada")
putdocx paragraph, halign(center)
putdocx image "graphs\\Graph`baseyear'_`endyear'.png"

// Create a paragraph
putdocx paragraph
putdocx text ("Figure 1: "), bold
putdocx text ("This figure shows people using safely managed sanitation services as a percentage of the total population in the x-axis for the year 2012 Access to sanitation facilities  is increasing over time in most countries, it is not doing so in an even way that will allow to reach max coverage. Low income: Niger (8%), Sierra Leone (12%), Mali (15%) have barely increased. Upper Middle Income; Belarus, Venezuela, Libya China +18% . High income countries have reached the maximum such as Monaco, Kuwait, and Singapore")
putdocx save Part1.docx, replace


log close
exit
/* End of do-file */

><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><

Notes:
1.
2.
3.


Version Control: