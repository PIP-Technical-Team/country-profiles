*===============================================================================
//PIP (GMI data to PIP) - 2011ppp and 2017ppp combine
*===============================================================================
set more off
clear all
*===============================================================================
//Macros
*===============================================================================
** main path **
*global main2017 "\\wbgfscifs01\GTSD\03.projects_corp\06.GMI\06.GMI_SM23\06.GMI_SM23_QA\03.output\01.data\PIP"
*global main2011 "\\wbgfscifs01\GTSD\03.projects_corp\06.GMI\06.GMI_SM22\06.GMI_SM22_QA\03.output\01.data\PIP"

*===============================================================================
//Main
*===============================================================================
//1. chart1_chart2_KI2
import delimited "${dataout}\indicator_values_country_chart1_chart2_KI2_${icpyr}.csv", clear
gen xyzdcxyzpppyear = 2017
tempfile a
save `a', replace
import delimited "${dataout}\indicator_values_country_chart1_chart2_KI2_${icpyr2}.csv", clear
gen xyzdcxyzpppyear = 2011
append using `a'
egen id = group(xyzdmxyzcountry xyzdmxyzrequestyear xyzdcxyzdatayear xyzdcxyzwelfaretype xyzdcxyzcoverage xyzdmxyzinterpolation xyzdcxyzsurvname xyzdmxyzcomparability xyzdmxyzcomparable_spell )
save `a', replace

use `a', clear
keep xyzdmxyzpovertyline xyzdpxyzsi_pov_all xyzdpxyzsi_pov_all_poor xyzdcxyzpppyear id
save "${git_aux}\indicator_values_country_chart1_chart2_KI2_data.dta", replace
export delimited _all using "${git_aux}\indicator_values_country_chart1_chart2_KI2_data.csv",  delim(",") datafmt replace

use `a', clear
drop xyzdmxyzpovertyline xyzdpxyzsi_pov_all xyzdpxyzsi_pov_all_poor xyzdcxyzpppyear
duplicates drop id, force
save "${git_aux}\indicator_values_country_chart1_chart2_KI2_ID.dta", replace
export delimited _all using "${git_aux}\indicator_values_country_chart1_chart2_KI2_ID.csv",  delim(",") datafmt replace

use `a', clear
*export delimited _all using "${dataout}\indicator_values_country_chart1_chart2_KI2_combine.csv",  delim(",") datafmt replace
export delimited _all using "${git_aux}\indicator_values_country_chart1_chart2_KI2.csv",  delim(",") datafmt replace

//2. chart3
import delimited "${dataout}\indicator_values_country_chart3_${icpyr}.csv", clear
cap drop ppp
gen xyzdcxyzpppyear = 2017
tempfile a
save `a', replace
import delimited "${dataout}\indicator_values_country_chart3_${icpyr2}.csv", clear
cap drop ppp
gen xyzdcxyzpppyear = 2011
append using `a'
export delimited _all using "${git_aux}\indicator_values_country_chart3.csv",  delim(",") datafmt replace

//3. chart4
import delimited "${dataout}\indicator_values_country_chart4_${icpyr}.csv", clear
cap drop ppp
gen xyzdcxyzpppyear = 2017
tempfile a
save `a', replace
import delimited "${dataout}\indicator_values_country_chart4_${icpyr2}.csv", clear
cap drop ppp
gen xyzdcxyzpppyear = 2011
append using `a'
drop if xyzdpxyzsi_pov_share_all == .
export delimited _all using "${git_aux}\indicator_values_country_chart4.csv",  delim(",") datafmt replace

//4. chart5
import delimited "${dataout}\indicator_values_country_chart5_${icpyr}.csv", clear
gen xyzdcxyzpppyear = 2017
tempfile a
save `a'

import delimited "${dataout}\indicator_values_country_chart5_${icpyr2}.csv", clear
gen xyzdcxyzpppyear = 2011

append using `a'
gen countrycode = xyzdmxyzcountry
gen rep_year = xyzdmxyzrequestyear
cap drop survey_coverage
merge m:1 countrycode rep_year survname using "${dataout}\pfw.dta", keepusing(survey_coverage) keep(3) nogen
drop countrycode rep_year
ren survey_coverage xyzdcxyzcoverage
export delimited _all using "${git_aux}\indicator_values_country_chart5.csv",  delim(",") datafmt replace

//5.chart6_KI4
import delimited "${dataout}\indicator_values_country_chart6_KI4_${icpyr}.csv", clear
tempfile a
save `a'

import delimited "${dataout}\indicator_values_country_chart6_KI4_${icpyr2}.csv", clear
append using `a'

gen year = substr(xyzdmxyzyearrange, 1,4)
destring year, replace
gen countrycode = xyzdmxyzcountry
merge m:1 countrycode year using "${dataout}\pfw2.dta", keepusing(survey_coverage) keep(1 3) nogen
replace survey_coverage = "N" if survey_coverage == ""
drop countrycode year
export delimited _all using "${git_aux}\indicator_values_country_chart6_KI4.csv",  delim(",") datafmt replace

