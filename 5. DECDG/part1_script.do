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

*----------3.1: Download data in wide format
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
drop if region == "NA"
drop if difference == .

*----------3.2: Figure 1: Scatterplot
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

*----------3.3: Export to Word document
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
putdocx text ("One of the indicators used to measure progress towards Sustainable Development Goal 6 is the share of population with access to safely managed sanitation services (facilities that are uniquely used by the household where excreta are treated and disposed of separated from human contact). Even though access to safely managed sanitation services has increased over time in most countries, it is not doing so uniformly. Countries with the least access are not increasing access as rapidly, which leads to the inverted-U shape in the quadratic relationship between initial access and the increase in access achieved over time measured as change between 2017 and 2012. Low-income countries with low access to safely managed sanitation services, i.e., Niger (8%), Sierra Leone (12%), Mali (15%), are among the countries that have achieved the least progress during this five-year period. High income countries, such as Monaco, Kuwait, and Singapore, have achieved universal access to safely managed sanitation services. Therefore, their progress over time is also limited. It is the lower and upper middle-income countries that have achieved the most progress, with China being the leader by increasing access from 53.93% in 2012 to 72.08% in 2017.")
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