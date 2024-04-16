//PIP data - chart2 1 and 2
//This is the dofile for the data in Chart2 1/2 (Poverty) of the country profile in PIP page.
//Missing: we need to add in the comparable data (or keep only comparable data for this chart)

*global datain C:\Users\wb327173\OneDrive - WBG\Downloads\ECA\Global\D4G\GMI
*global dataout c:\Users\wb327173\OneDrive - WBG\Downloads\ECA\SOL\Project X\Data for PIP\

///////////////////////////////  2017ppp     ///////////////////////////////////
//1. pfw , year = rep_year
use "${dataout}\pfw.dta", clear
replace year = rep_year
tempfile pfw
save `pfw', replace

//2. poverty line
use "$dataout\pip_all_lines_${icpyr}" , clear
cap ren year reporting_year
//remove data
if "$remove" != ""{
	foreach i of global remove{
		`noi' di in r "data of `i' will be removed per requst by TTL"
		cap drop a*
		gen a = "`i'"
		cap split a, p(-)
		cap drop if country_code == a1 & string(reporting_year) == a2
		drop a*
		if (_rc){
			noi di in r "No data for `i'"
		}
		else{
			noi di in y "data of `i' removed."
		}
	}
} 

drop if country_code=="CHN" & (reporting_level=="rural"|reporting_level=="urban")
drop if country_code=="IDN" & (reporting_level=="rural"|reporting_level=="urban")
drop if country_code=="IND" & (reporting_level=="rural"|reporting_level=="urban")

//Added in SM24 
sort country_code reporting_year welfare_type poverty_line
by country_code reporting_year welfare_type poverty_line:  gen dup = cond(_N==1,0,_n)
drop if dup == 2
drop dup
////
isid country_code reporting_year welfare_type poverty_line

gen double xyzDPxyzSI_POV_ALL_POOR = headcount*population
ren (country_code reporting_year welfare_type) (countrycode year datatype)
merge m:1 countrycode  year datatype using `pfw' , keepus(comparability comparable_spell survname preferable display_cp)
drop if _m==2 
ren _merge merge

keep if display_cp==1
sort countrycode  year datatype poverty_line
ren countrycode xyzDMxyzCountry 
ren year xyzDMxyzRequestYear
ren welfare_time xyzDCxyzdatayear
gen xyzDCxyzWelfareType = "CONS" if datatype==1
replace xyzDCxyzWelfareType = "INC" if datatype==2
ren survname xyzDCxyzsurvname
ren comparability xyzDMxyzcomparability
ren comparable_spell xyzDMxyzcomparable_spell
*ren gini xyzDPxyzSI_POV_GINI	
*ren median xyzDPxyzSI_SPR_MED	
*ren mld xyzDPxyzSI_POV_MLD	
*ren theil xyzDPxyzSI_POV_THEIL
gen xyzDMxyzInterpolation = "FALSE"
gen xyzDCxyzCoverage = "N" if reporting_level=="national"
replace xyzDCxyzCoverage = "R" if reporting_level=="rural"
replace xyzDCxyzCoverage = "U" if reporting_level=="urban"

ren poverty_line xyzDMxyzPovertyLine 
ren headcount xyzDPxyzSI_POV_ALL
*drop if headcount==-1

order xyzDMxyzCountry xyzDMxyzRequestYear xyzDCxyzdatayear xyzDCxyzWelfareType xyzDCxyzCoverage xyzDMxyzInterpolation xyzDCxyzsurvname xyzDMxyzcomparability xyzDMxyzcomparable_spell xyzDMxyzPovertyLine xyzDPxyzSI_POV_ALL xyzDPxyzSI_POV_ALL_POOR
keep xyzDMxyzCountry xyzDMxyzRequestYear xyzDCxyzdatayear xyzDCxyzWelfareType xyzDCxyzCoverage xyzDMxyzInterpolation xyzDCxyzsurvname xyzDMxyzcomparability xyzDMxyzcomparable_spell xyzDMxyzPovertyLine xyzDPxyzSI_POV_ALL xyzDPxyzSI_POV_ALL_POOR

su

export delimited _all using "$dataout\indicator_values_country_chart1_chart2_KI2_${icpyr}.csv",  delim(",") datafmt replace

///////////////////////////////  2011ppp     ///////////////////////////////////
//1. pfw , year = rep_year
use "${dataout}\pfw.dta", clear
replace year = rep_year
tempfile pfw
save `pfw', replace

//2. poverty line
use "$dataout\pip_all_lines_${icpyr2}" , clear
cap ren year reporting_year
//remove data
if "$remove" != ""{
	foreach i of global remove{
		`noi' di in r "data of `i' will be removed per requst by TTL"
		cap drop a*
		gen a = "`i'"
		cap split a, p(-)
		cap drop if country_code == a1 & string(reporting_year) == a2
		drop a*
		if (_rc){
			noi di in r "No data for `i'"
		}
		else{
			noi di in y "data of `i' removed."
		}
	}
} 

drop if country_code=="CHN" & (reporting_level=="rural"|reporting_level=="urban")
drop if country_code=="IDN" & (reporting_level=="rural"|reporting_level=="urban")
drop if country_code=="IND" & (reporting_level=="rural"|reporting_level=="urban")

//Added in SM24 
sort country_code reporting_year welfare_type poverty_line
by country_code reporting_year welfare_type poverty_line:  gen dup = cond(_N==1,0,_n)
drop if dup == 2
drop dup
////

isid country_code reporting_year welfare_type poverty_line

gen double xyzDPxyzSI_POV_ALL_POOR = headcount*population
ren (country_code reporting_year welfare_type) (countrycode year datatype)
merge m:1 countrycode  year datatype using `pfw' , keepus(comparability comparable_spell survname preferable display_cp)
drop if _m==2 
ren _merge merge

keep if display_cp==1
sort countrycode  year datatype poverty_line
ren countrycode xyzDMxyzCountry 
ren year xyzDMxyzRequestYear
ren welfare_time xyzDCxyzdatayear
gen xyzDCxyzWelfareType = "CONS" if datatype==1
replace xyzDCxyzWelfareType = "INC" if datatype==2
ren survname xyzDCxyzsurvname
ren comparability xyzDMxyzcomparability
ren comparable_spell xyzDMxyzcomparable_spell
*ren gini xyzDPxyzSI_POV_GINI	
*ren median xyzDPxyzSI_SPR_MED	
*ren mld xyzDPxyzSI_POV_MLD	
*ren theil xyzDPxyzSI_POV_THEIL
gen xyzDMxyzInterpolation = "FALSE"
gen xyzDCxyzCoverage = "N" if reporting_level=="national"
replace xyzDCxyzCoverage = "R" if reporting_level=="rural"
replace xyzDCxyzCoverage = "U" if reporting_level=="urban"

ren poverty_line xyzDMxyzPovertyLine 
ren headcount xyzDPxyzSI_POV_ALL
*drop if headcount==-1

order xyzDMxyzCountry xyzDMxyzRequestYear xyzDCxyzdatayear xyzDCxyzWelfareType xyzDCxyzCoverage xyzDMxyzInterpolation xyzDCxyzsurvname xyzDMxyzcomparability xyzDMxyzcomparable_spell xyzDMxyzPovertyLine xyzDPxyzSI_POV_ALL xyzDPxyzSI_POV_ALL_POOR
keep xyzDMxyzCountry xyzDMxyzRequestYear xyzDCxyzdatayear xyzDCxyzWelfareType xyzDCxyzCoverage xyzDMxyzInterpolation xyzDCxyzsurvname xyzDMxyzcomparability xyzDMxyzcomparable_spell xyzDMxyzPovertyLine xyzDPxyzSI_POV_ALL xyzDPxyzSI_POV_ALL_POOR

su

export delimited _all using "$dataout\indicator_values_country_chart1_chart2_KI2_${icpyr2}.csv",  delim(",") datafmt replace
