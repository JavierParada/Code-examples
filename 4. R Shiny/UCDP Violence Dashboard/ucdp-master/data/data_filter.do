cd "C:\Users\WB459082\OneDrive - WBG\Documents\Code-examples\4. R Shiny\UCDP Violence Dashboard\ucdp-master\data\"
use "ged201.dta", clear

keep if country=="Syria" | country=="Iraq" | country=="Turkey"

keep if year>2010
keep if year<2016

keep if year==2014

label define type_of_violence_label 1 "state-based armed conflict" 2 "non-state conflict" 3 "one-sided violence"
label values type_of_violence type_of_violence_label

keep id relid type_of_violence latitude longitude country year best source_article
export delimited using "ged201.csv", replace