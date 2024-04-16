//National poverty
import delimit using "${git_aux}\indicator_values_country_KI1.csv" , clear
ren xyzdmxyzcountry countrycode
ren xyzdmxyzrequestyear year
tempfile data1
save `data1', replace

import delimit using "${git_aux}\indicator_values_country_KI5_KI6_KI7.csv" , clear
isid xyzdmxyzcountry xyzdmxyzrequestyear

ren xyzdmxyzcountry countrycode
ren xyzdmxyzrequestyear year
tempfile data2
save `data2', replace

import delimit using "${git_aux}\indicator_values_country_chart3.csv" , clear

isid xyzdmxyzcountry xyzdmxyzrequestyear xyzdcxyzpppyear
ren xyzdmxyzcountry countrycode
ren xyzdmxyzrequestyear year
ren xyzdcxyzpppyear pppyear
ren xyzdcxyzwelfaretype welfaretype
tempfile chart3
save `chart3', replace

//MPM
import delimit using "${git_aux}\indicator_values_country_chart5.csv"  , clear

isid xyzdmxyzcountry xyzdmxyzrequestyear xyzdcxyzpppyear
ren xyzdmxyzcountry countrycode
ren xyzdmxyzrequestyear year
ren xyzdcxyzpppyear pppyear
ren xyzdcxyzwelfaretype welfaretype
tempfile chart5
save `chart5', replace

//group breakdown
import delimit using "${git_aux}\indicator_values_country_chart4.csv" , clear

reshape wide xyzdpxyzsi_pov_share_all , i( xyzdmxyzcountry xyzdmxyzrequestyear xyzdmxyzinterpolation xyzdcxyzwelfaretype xyzdcxyzcoverage xyzdcxyzgender xyzdcxyzagegroup xyzdcxyzeducation xyzdcxyzpppyear ) j( xyzdcxyzdistribution ) string

gen gr = xyzdcxyzcoverage + xyzdcxyzgender + xyzdcxyzagegroup + xyzdcxyzeducation

gen x = "edu_noedu" if gr=="No education"
replace x = "edu_pri" if gr=="Primary education"
replace x = "edu_sec" if gr=="Secondary education"
replace x = "edu_ter" if gr=="Tertiary education"
replace x = "agecat_0_14" if gr=="0-14"
replace x = "agecat_15_64" if gr=="15-64"
replace x = "agecat_65p" if gr==">65"
replace x = "_female" if gr== "Female"
replace x = "_male" if gr=="Male"
replace x = "_rural" if gr=="R"
replace x = "_urban" if gr=="U"

drop xyzdcxyzcoverage xyzdcxyzgender xyzdcxyzagegroup xyzdcxyzeducation gr
ren xyzdpxyzsi_pov_share_allT60 share_allT60
ren xyzdpxyzsi_pov_share_allB40 share_allB40
reshape wide share_allB40 share_allT60, i( xyzdmxyzcountry xyzdmxyzrequestyear xyzdmxyzinterpolation xyzdcxyzwelfaretype xyzdcxyzpppyear  ) j(x) string

isid xyzdmxyzcountry xyzdmxyzrequestyear xyzdcxyzpppyear
ren xyzdmxyzcountry countrycode
ren xyzdmxyzrequestyear year
ren xyzdcxyzpppyear pppyear
ren xyzdcxyzwelfaretype welfaretype

tempfile chart4
save `chart4', replace

//Chart6_KI4 data shared prosperity
import delimit using "${git_aux}\indicator_values_country_chart6_KI4.csv", clear
ren xyzdpxyzsi_spr_pcap_zg ind_
reshape wide ind_ , i( xyzdmxyzcountry xyzdmxyzyearrange xyzdmxyzinterpolation xyzdcxyzwelfaretype xyzdcxyzpppyear ) j( xyzdcxyzdistribution ) string

replace xyzdmxyzyearrange = subinstr( xyzdmxyzyearrange,"-","_",.)
reshape wide ind_b40 ind_m50 ind_premium ind_tot, i( xyzdmxyzcountry xyzdmxyzinterpolation xyzdcxyzwelfaretype xyzdcxyzpppyear ) j( xyzdmxyzyearrange ) string

isid xyzdmxyzcountry xyzdcxyzwelfaretype xyzdcxyzpppyear
ren xyzdmxyzcountry countrycode
ren xyzdcxyzpppyear pppyear
ren xyzdcxyzwelfaretype welfaretype
tempfile chart6
save `chart6', replace

//indicator_values_country_chart1_chart2_KI2_ID.dta
//indicator_values_country_chart1_chart2_KI2_data.dta
use "${git_aux}\indicator_values_country_chart1_chart2_KI2_data.dta", clear
keep if xyzdcxyzpppyear==2017
drop if id==.
gen str line=string( xyzdmxyzpovertyline)
keep if line=="2.15" | line=="3.65" | line=="6.85"
replace line = subinstr(line,".","_",.)
drop xyzdmxyzpovertyline
ren xyzdpxyzsi_pov_all  si_pov_all
ren xyzdpxyzsi_pov_all_poor si_pov_all_poor
tempfile data11
save `data11', replace

use "${git_aux}\indicator_values_country_chart1_chart2_KI2_data.dta", clear
keep if xyzdcxyzpppyear==2011
drop if id==.
gen str line=string( xyzdmxyzpovertyline)
keep if line=="1.9" | line=="3.2" | line=="5.5"
replace line = subinstr(line,".","_",.)
drop xyzdmxyzpovertyline
ren xyzdpxyzsi_pov_all  si_pov_all
ren xyzdpxyzsi_pov_all_poor si_pov_all_poor
append using `data11'

reshape wide si_pov_all si_pov_all_poor, i(id xyzdcxyzpppyear) j(line) string

gen headcount_ipl = si_pov_all2_15 if xyzdcxyzpppyear==2017
replace headcount_ipl = si_pov_all1_9 if xyzdcxyzpppyear==2011

gen headcount_lmicpl  = si_pov_all3_65 if xyzdcxyzpppyear==2017
replace headcount_lmicpl  = si_pov_all3_2 if xyzdcxyzpppyear==2011

gen headcount_umicpl = si_pov_all6_85 if xyzdcxyzpppyear==2017
replace headcount_umicpl = si_pov_all5_5 if xyzdcxyzpppyear==2011
drop si_*

merge m:1 id using "${git_aux}\indicator_values_country_chart1_chart2_KI2_ID.dta"
drop _merge	
isid id xyzdcxyzpppyear

clonevar countrycode = xyzdmxyzcountry 
clonevar year = xyzdmxyzrequestyear 
clonevar pppyear= xyzdcxyzpppyear 
clonevar welfaretype = xyzdcxyzwelfaretype 
//merge back with other data
merge m:1 countrycode year using `data1'
ta _merge
drop _merge

merge 1:1 countrycode year pppyear welfaretype using `chart3'
ta _merge
drop _merge

merge 1:1 countrycode year pppyear welfaretype using `chart4'
ta _merge
drop _merge

merge 1:1 countrycode year pppyear welfaretype using `chart5'
ta _merge
drop _merge
drop if countrycode==""

drop survname comparable_spell xyzdcxyzpppyear xyzdmxyzcountry xyzdmxyzrequestyear xyzdcxyzwelfaretype id ymax 
*si_pov_all_poor2_15 si_pov_all_poor3_65 si_pov_all_poor6_85

ren xyzdcxyzdatayear datayear 
*ren xyzdcxyzwelfaretype welfaretype 
ren xyzdcxyzcoverage coverage 
ren xyzdmxyzinterpolation interpolation 
ren xyzdcxyzsurvname survname 
ren xyzdmxyzcomparability comparability
ren xyzdmxyzcomparable_spell comparable_spell 
ren xyzdpxyzsi_pov_nahc si_pov_nahc 
ren xyzdmxyzfootnote si_pov_nahc_footnote 
ren xyzdpxyzsi_pov_gini si_pov_gini 
ren xyzdpxyzsi_pov_theil si_pov_theil 
ren xyzdpxyzsi_mpm_educ si_mpm_educ 
ren xyzdpxyzsi_mpm_edue si_mpm_edue 
ren xyzdpxyzsi_mpm_elec si_mpm_elec 
ren xyzdpxyzsi_mpm_imps si_mpm_imps 
ren xyzdpxyzsi_mpm_impw si_mpm_impw 
ren xyzdpxyzsi_mpm_poor si_mpm_poor 
ren xyzdpxyzsi_mpm_mdhc si_mpm_mdhc

ren countrycode country_code
ren year year
ren datayear welfare_time
ren coverage survey_coverage
ren interpolation is_interpolated
ren survname survey_acronym
ren comparability survey_comparability
ren comparable_spell comparable_spell
ren welfaretype welfare_type
ren pppyear ppp_year
*ren si_pov_all2_15 headcount_ipl
*ren si_pov_all3_65 headcount_lmicpl  
*ren si_pov_all6_85 headcount_umicpl
ren si_pov_nahc headcount_national
ren si_pov_nahc_footnote headcount_national_footnote
ren si_pov_gini gini
ren si_pov_theil theil
ren share_allB40_female share_b40_female
ren share_allT60_female share_t60_female
ren share_allB40_male share_b40_male
ren share_allT60_male share_t60_male
ren share_allB40_rural share_b40_rural
ren share_allT60_rural share_t60_rural
ren share_allB40_urban share_b40_urban
ren share_allT60_urban share_t60_urban
ren share_allB40agecat_0_14 share_b40agecat_0_14
ren share_allT60agecat_0_14 share_t60agecat_0_14
ren share_allB40agecat_15_64 share_b40agecat_15_64
ren share_allT60agecat_15_64 share_t60agecat_15_64
ren share_allB40agecat_65p share_b40agecat_65p
ren share_allT60agecat_65p share_t60agecat_65p
ren share_allB40edu_noedu share_b40edu_noedu
ren share_allT60edu_noedu share_t60edu_noedu
ren share_allB40edu_pri share_b40edu_pri
ren share_allT60edu_pri share_t60edu_pri
ren share_allB40edu_sec share_b40edu_sec
ren share_allT60edu_sec share_t60edu_sec
ren share_allB40edu_ter share_b40edu_ter
ren share_allT60edu_ter share_t60edu_ter
ren si_mpm_educ mpm_education_attainment
ren si_mpm_edue mpm_education_enrollment
ren si_mpm_elec mpm_electricity 
ren si_mpm_imps mpm_sanitation
ren si_mpm_impw mpm_water
ren si_mpm_poor mpm_monetary
ren si_mpm_mdhc mpm_headcount

la var country_code "Country/Economy code"
la var year "Year"
la var welfare_time "Time income or consumption refers to"
la var survey_coverage "Survey coverage"
la var is_interpolated "Data is interpolated"
la var survey_acronym "Survey acronym"
la var survey_comparability "Survey comparability"
la var comparable_spell "Comparability over time at country level"
la var welfare_type "Welfare measured by income or consumption"
la var ppp_year "PPP Year"
la var headcount_ipl "% of population living in households with consumption or income per person below the international poverty line (IPL) at {PPP Year} international prices. "
la var headcount_lmicpl   "% of population living in households with consumption or income per person below the global poverty line typical of Lower-middle-income countries (LMIC-PL) at {PPP Year} international prices. "
la var headcount_umicpl "% of population living in households with consumption or income per person below the global poverty line typical of Upper-middle-income countries (UMIC-PL ) at {PPP Year} international prices."
la var headcount_national "National poverty headcount ratio is the percentage of the population living below the national poverty line. "
la var headcount_national_footnote "National poverty headcount ratio footnote"
la var gini "GINI index (World Bank estimate)"
la var theil "Theil index (World Bank estimate)"
la var share_b40_female "Proportional of female group in the bottom 40%"
la var share_t60_female "Proportional of female group in the top 60%"
la var share_b40_male "Proportional of male group in the bottom 40%"
la var share_t60_male "Proportional of male group in the top 60%"
la var share_b40_rural "Proportional of rural group in the bottom 40%"
la var share_t60_rural "Proportional of rural group in the top 60%"
la var share_b40_urban "Proportional of urban group in the bottom 40%"
la var share_t60_urban "Proportional of urban group in the top 60%"
la var share_b40agecat_0_14 "Proportional of 0 to 14 years old group in the bottom 40%"
la var share_t60agecat_0_14 "Proportional of 0 to 14 years old group in the top 60%"
la var share_b40agecat_15_64 "Proportional of 15 to 64 years old group in the bottom 40%"
la var share_t60agecat_15_64 "Proportional of 15 to 64 years old group in the top 60%"
la var share_b40agecat_65p "Proportional of 65 and older group in the bottom 40%"
la var share_t60agecat_65p "Proportional of 65 and older group in the top 60%"
la var share_b40edu_noedu "Proportional of no education group in the bottom 40%"
la var share_t60edu_noedu "Proportional of no education group in the top 60%"
la var share_b40edu_pri "Proportional of primary education group in the bottom 40%"
la var share_t60edu_pri "Proportional of primary education group in the top 60%"
la var share_b40edu_sec "Proportional of secondary education group in the bottom 40%"
la var share_t60edu_sec "Proportional of secondary education group in the top 60%"
la var share_b40edu_ter "Proportional of tertiary education group in the bottom 40%"
la var share_t60edu_ter "Proportional of tertiary education group in the top 60%"
la var mpm_education_attainment "Multidimensional poverty, educational attainment (% of population deprived) "
la var mpm_education_enrollment "Multidimensional poverty, educational enrollment (% of population deprived)"
la var mpm_electricity  "Multidimensional poverty, electricity (% of population deprived)"
la var mpm_sanitation "Multidimensional poverty, sanitation (% of population deprived)"
la var mpm_water "Multidimensional poverty, drinking water (% of population deprived)"
la var mpm_monetary "Multidimensional poverty, Monetary poverty (% of population deprived)"
la var mpm_headcount "Multidimensional poverty, headcount ratio (% of population)"

drop if country_code=="ALB" & year==2018 & welfare_type=="INC"

order country_code year welfare_time survey_coverage is_interpolated survey_acronym survey_comparability comparable_spell welfare_type ppp_year

sort country_code year ppp_year welfare_type
compress

saveold "${git_aux}\flat_cp.dta", replace
/*
merge m:1 countrycode pppyear welfaretype using `chart6'
ta _merge
drop _merge
drop if countrycode==""
sort countrycode year pppyear welfaretype
saveold "$dataout\cp_flatdata_opt2", replace
*/