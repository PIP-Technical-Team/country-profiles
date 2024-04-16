//PIP data - chart 3
//This is the dofile for the data in Chart 3 (inequality) of the country profile in PIP page.


*** Do not run before having the DEV version sent to you from PIP (Andres is the focal point)

//setting
//1. pfw , year = rep_year
use "${dataout}\pfw.dta", clear
replace year = rep_year
tempfile pfw
save `pfw', replace

//2. theil
use "${datain_GMI}\dlw\GMI_ine_dlw.dta" , clear
gen datatype = 1 if welftype == "CONS"
replace datatype = 2 if welftype == "INC"
bys countrycode year survname datatype:gen a = _N
drop if strpos(filename,"BIN") & a!=2
drop if strpos(filename,"HIST") & a!=2
drop a
tempfile theil
save `theil', replace

//3. latest data by country in the regions (pip)
cap pip, clear country(all) version(${pip_ver1}) server(${pip_server})
cap drop ppp
gen ppp = $icpyr
tempfile pip
save `pip', replace

cap pip, clear country(all) version(${pip_ver2}) server(${pip_server})
cap drop ppp
gen ppp = $icpyr2
append using `pip'

drop if country_code=="CHN" & (reporting_level=="rural"|reporting_level=="urban")
drop if country_code=="IDN" & (reporting_level=="rural"|reporting_level=="urban")
drop if country_code=="IND" & (reporting_level=="rural"|reporting_level=="urban")
cap ren reporting_year year
isid country_code year welfare_type ppp
ren (country_code welfare_type comparable_spell) (countrycode datatype comparable_spell_pip) 
drop poverty_line

merge m:1 countrycode year datatype using `pfw' , keepus(comparability comparable_spell survname preferable display_cp)

list countrycode year survey_acronym if _m == 1
//check the output
//HTI2012, NIC(1993.1998,2001,2005), PHL(2000-2021) contain both INC/CONS welfare
//other surve

keep if _m == 3
*drop if _m==2
ren _merge merge

keep if display_cp==1
bys countrycode (year): gen latest = year == year[_N]


tostring year, replace
merge 1:1 countrycode year survname datatype ppp using `theil', keepus(theil region)
drop if _m==2
drop _m

replace theil=. if theil>1 
drop merge

replace gini = . if missing(gini)
//destring gini, replace

ren countrycode xyzDMxyzCountry 
ren year xyzDMxyzRequestYear
*ren survey_year  xyzDCxyzdatayear
gen xyzDCxyzWelfareType = "CONS" if datatype==1
replace xyzDCxyzWelfareType = "INC" if datatype==2
ren survname xyzDCxyzsurvname
ren comparability xyzDMxyzcomparability
ren comparable_spell xyzDMxyzcomparable_spell
ren gini xyzDPxyzSI_POV_GINI	

ren theil xyzDPxyzSI_POV_THEIL
gen xyzDMxyzInterpolation = "FALSE"
gen xyzDCxyzCoverage = "N" if reporting_level=="national"
replace xyzDCxyzCoverage = "R" if reporting_level=="rural"
replace xyzDCxyzCoverage = "U" if reporting_level=="urban"

order xyzDMxyzCountry xyzDMxyzRequestYear  xyzDCxyzWelfareType xyzDCxyzCoverage xyzDMxyzInterpolation xyzDCxyzsurvname xyzDMxyzcomparability xyzDMxyzcomparable_spell xyzDPxyzSI_POV_GINI xyzDPxyzSI_POV_THEIL // xyzDCxyzdatayear
keep xyzDMxyzCountry xyzDMxyzRequestYear  xyzDCxyzWelfareType xyzDCxyzCoverage xyzDMxyzInterpolation xyzDCxyzsurvname xyzDMxyzcomparability xyzDMxyzcomparable_spell xyzDPxyzSI_POV_GINI xyzDPxyzSI_POV_THEIL ppp // xyzDCxyzdatayear
tempfile raw
save `raw', replace

//4. output save 
///////////////////////////////  2017ppp     ///////////////////////////////////
use `raw', clear
keep if ppp == ${icpyr}
export delimited _all using "$dataout\indicator_values_country_chart3_${icpyr}.csv",  delim(",") datafmt replace

///////////////////////////////  2011ppp     ///////////////////////////////////
use `raw', clear
keep if ppp == ${icpyr2}
export delimited _all using "$dataout\indicator_values_country_chart3_${icpyr2}.csv",  delim(",") datafmt replace
