//PIP data - chart 4
////////////////////////////      2017ppp    ///////////////////////////////////
//main dataset
use "$datain_PEB\02.input\peb_key.dta", clear
drop if strpos(case,"z")
*replace welftype = "INC" if countrycode == "LCA" & year == "2016"

//remove data
if "$remove" != ""{
	foreach i of global remove{
		`noi' di in r "data of `i' will be removed per requst by TTL"
		cap drop a*
		gen a = "`i'"
		cap split a, p(-)
		cap drop if countrycode == a1 & string(year) == a2
		drop a*
		if (_rc){
			noi di in r "No data for `i'"
		}
		else{
			noi di in y "data of `i' removed."
		}
	}
}

gen case1 = substr(case, 1, 4)
gen case2 = substr(case, 5,.)
drop case
keep if strpos(case2,"T60") | strpos(case2,"B40")
replace value = . if value ==9999
ren source filename
split filename,p(_)
drop year filename1 filename4 filename5 filename6 filename7 filename9 filename8 welftype
ren (filename2 filename3) (year survname)
if "${rd}" == "AM23"{
	replace survname = "SLC-HBS" if countrycode == "LCA"
	replace year = "2016" if countrycode == "LCA"
}
merge m:1 countrycode year survname using "${datain_GMI}\comparablility.dta" ,keepusing(rep_year welftype) 
drop if _m == 2
drop _m
drop year
ren rep_year year

gen subgroup =     "RUR:       urban" if case1 == "rur1"
replace subgroup = "RUR:       rural" if case1 == "rur2"
replace subgroup = "EDU: no eduation" if case1 == "edu1"
replace subgroup = "EDU:     primary" if case1 == "edu2"
replace subgroup = "EDU:   secondary" if case1 == "edu3"
replace subgroup = "EDU:     teriary" if case1 == "edu4"
replace subgroup = "AGE:      0 - 14" if case1 == "gag1"
replace subgroup = "AGE:     15 - 64" if case1 == "gag2"
replace subgroup = "AGE:    above 64" if case1 == "gag3"
replace subgroup = "GEN:        male" if case1 == "gen1"
replace subgroup = "GEN:      female" if case1 == "gen2"
encode subgroup, gen(precase)

gen xyzDCxyzDistribution = substr(case2,1,3)

gen xyzDCxyzAgeGroup = "0-14" if case1 == "gag1"
replace xyzDCxyzAgeGroup = "15-64" if case1 == "gag2"
replace xyzDCxyzAgeGroup = ">65" if case1 == "gag3"

gen xyzDCxyzCoverage = "R" if case1 == "rur2"
replace xyzDCxyzCoverage = "U" if case1 == "rur1"

gen xyzDCxyzGender="Male" if case1 == "gen1"
replace xyzDCxyzGender="Female" if case1 == "gen2"

gen xyzDCxyzEducation = "Primary education" if case1 == "edu2"
replace xyzDCxyzEducation = "Tertiary education" if case1 == "edu4"
replace xyzDCxyzEducation = "Secondary education" if case1 == "edu3"
replace xyzDCxyzEducation = "No education" if  case1 == "edu1"

ren countrycode xyzDMxyzCountry
ren year xyzDMxyzRequestYear	
gen xyzDMxyzInterpolation = "FALSE"
ren welftype xyzDCxyzWelfareType
ren value xyzDPxyzSI_POV_SHARE_ALL

sort xyzDMxyzCountry xyzDMxyzRequestYear xyzDCxyzWelfareType precase xyzDCxyzDistribution
keep xyzDMxyzCountry xyzDMxyzRequestYear xyzDMxyzInterpolation xyzDCxyzWelfareType xyzDCxyzCoverage xyzDCxyzGender xyzDCxyzAgeGroup xyzDCxyzEducation xyzDCxyzDistribution xyzDPxyzSI_POV_SHARE_ALL 
order xyzDMxyzCountry xyzDMxyzRequestYear xyzDMxyzInterpolation xyzDCxyzWelfareType xyzDCxyzCoverage xyzDCxyzGender xyzDCxyzAgeGroup xyzDCxyzEducation xyzDCxyzDistribution	xyzDPxyzSI_POV_SHARE_ALL
gen ppp = ${icpyr}
su

export delimited _all using "$dataout\indicator_values_country_chart4_${icpyr}.csv",  delim(",") datafmt replace

////////////////////////////      2011ppp    ///////////////////////////////////
/*
//This is the dofile for the data in Chart 4 (distribution by key characteristics) of the country profile in PIP page.

//filter
*0. load keyupdatelast
import excel using "$datain_PEB_ttl/KeyUpdate.xlsx", sheet("KeyUpdateLATEST") firstrow case(lower) clear allstring
gen precase = ""				
replace precase = "edu1"  if regexm(indicator, "^Without")
replace precase = "edu2"  if regexm(indicator, "^Primary")
replace precase = "edu3"  if regexm(indicator, "^Secondary")
replace precase = "edu4"  if regexm(indicator, "^Tertiary")
replace precase = "gag1" if regexm(indicator, "^0 to 14 ")
replace precase = "gag2" if regexm(indicator, "^15 to 64")
replace precase = "gag3" if regexm(indicator, "^65 and ")
replace precase = "gen1" if regexm(indicator, "^[Ff]emale")
replace precase = "gen2" if regexm(indicator, "^[Mm]ale")
replace precase = "rur1"  if regexm(indicator, "^Urban")
replace precase = "rur2"  if regexm(indicator, "^Rural")

gen double d = date(date, "MDY")
gen double t = clock(time, "hms")

drop date time
rename (d t) (date time)

format date %td
format time %tcHH:MM:SS

gen double datetime = date*24*60*60*1000 + time
format datetime %tcDDmonCCYY_HH:MM:SS
		
tempfile temp
save `temp', replace

*1. load keypdate
import excel using "$datain_PEB_ttl/KeyUpdate.xlsx", sheet("KeyUpdate") firstrow case(lower) clear allstring
**1.1 datetime adjust
gen double d = date(date, "MDY")
gen double t = clock(time, "hms")

drop date time
rename (d t) (date time)

format date %td
format time %tcHH:MM:SS

gen double datetime = date*24*60*60*1000 + time
format datetime %tcDDmonCCYY_HH:MM:SS

*1.2 countrycode adjust
replace countrycode = trim(countrycode)
		
*1.3 Create precase
gen precase = ""				
replace precase = "edu1"  if regexm(indicator, "^Without")
replace precase = "edu2"  if regexm(indicator, "^Primary")
replace precase = "edu3"  if regexm(indicator, "^Secondary")
replace precase = "edu4"  if regexm(indicator, "^Tertiary")
replace precase = "gag1" if regexm(indicator, "^0 to 14 ")
replace precase = "gag2" if regexm(indicator, "^15 to 64")
replace precase = "gag3" if regexm(indicator, "^65 and ")
replace precase = "gen1" if regexm(indicator, "^[Ff]emale")
replace precase = "gen2" if regexm(indicator, "^[Mm]ale")
replace precase = "rur1"  if regexm(indicator, "^Urban")
replace precase = "rur2"  if regexm(indicator, "^Rural")
		
*1.4 max date per country
tempvar mdatetime
bysort countrycode precase: egen double `mdatetime' = max(datetime)
keep if datetime == `mdatetime' 

*1.4.1 udpate by keyupdatelast
merge 1:1 countrycode precase using `temp', replace update nogen
		
drop if regexm(indicator, "^Poverty line") 
keep countrycode publish precase 
keep if publish == "NO"
tempfile keyu
save `keyu', replace
*/

//LCA group data from SM22
if "${rd}" == "AM23"{
	use "\\wbgfscifs01\GTSD\03.projects_corp\01.PEB\01.PEB_SM22\01.PEB_SM22_QA\02.input\peb_key.dta", clear
	keep if countrycode == "LCA"
	drop id indicator source vc_09022022142026
	ren values value
	gen  survname = "SLC-HBS"
	gen icp = "${icpyr2}"
	gen welfarevar = "welfare"
	tempfile lca
	save `lca', replace
}
use "${datain_GMI2}\GMI_key.dta" , clear
*append using `lca'
keep if strpos(case,"T60") | strpos(case,"B40")
keep if welfarevar == "welfare"
gen case1 = substr(case, 1, 4)
gen case2 = substr(case, 5,.)
drop case
replace value = . if value ==9999

split filename,p(_)
drop year filename1 filename3 filename4 filename5 filename6 filename7 filename9 filename8 welftype
ren filename2 year
if "${rd}" == "AM23"{
	replace survname = "SLC-HBS" if countrycode == "LCA"
	replace year = "2016" if countrycode == "LCA"
}

merge m:1 countrycode year survname using "${datain_GMI}\comparablility.dta" ,keepusing(rep_year welftype) 
drop if _m == 2
drop _m
drop year
ren rep_year year

gen subgroup =     "RUR:       urban" if case1 == "rur1"
replace subgroup = "RUR:       rural" if case1 == "rur2"
replace subgroup = "EDU: no eduation" if case1 == "edu1"
replace subgroup = "EDU:     primary" if case1 == "edu2"
replace subgroup = "EDU:   secondary" if case1 == "edu3"
replace subgroup = "EDU:     teriary" if case1 == "edu4"
replace subgroup = "AGE:      0 - 14" if case1 == "gag1"
replace subgroup = "AGE:     15 - 64" if case1 == "gag2"
replace subgroup = "AGE:    above 64" if case1 == "gag3"
replace subgroup = "GEN:        male" if case1 == "gen1"
replace subgroup = "GEN:      female" if case1 == "gen2"
encode subgroup, gen(precase)

gen xyzDCxyzDistribution = substr(case2,1,3)

gen xyzDCxyzAgeGroup = "0-14" if case1 == "gag1"
replace xyzDCxyzAgeGroup = "15-64" if case1 == "gag2"
replace xyzDCxyzAgeGroup = ">65" if case1 == "gag3"

gen xyzDCxyzCoverage = "R" if case1 == "rur2"
replace xyzDCxyzCoverage = "U" if case1 == "rur1"

gen xyzDCxyzGender="Male" if case1 == "gen1"
replace xyzDCxyzGender="Female" if case1 == "gen2"

gen xyzDCxyzEducation = "Primary education" if case1 == "edu2"
replace xyzDCxyzEducation = "Tertiary education" if case1 == "edu4"
replace xyzDCxyzEducation = "Secondary education" if case1 == "edu3"
replace xyzDCxyzEducation = "No education" if  case1 == "edu1"

ren countrycode xyzDMxyzCountry
ren year xyzDMxyzRequestYear	
gen xyzDMxyzInterpolation = "FALSE"
ren welftype xyzDCxyzWelfareType
ren value xyzDPxyzSI_POV_SHARE_ALL

sort xyzDMxyzCountry xyzDMxyzRequestYear xyzDCxyzWelfareType precase xyzDCxyzDistribution
keep xyzDMxyzCountry xyzDMxyzRequestYear xyzDMxyzInterpolation xyzDCxyzWelfareType xyzDCxyzCoverage xyzDCxyzGender xyzDCxyzAgeGroup xyzDCxyzEducation xyzDCxyzDistribution xyzDPxyzSI_POV_SHARE_ALL 
order xyzDMxyzCountry xyzDMxyzRequestYear xyzDMxyzInterpolation xyzDCxyzWelfareType xyzDCxyzCoverage xyzDCxyzGender xyzDCxyzAgeGroup xyzDCxyzEducation xyzDCxyzDistribution	xyzDPxyzSI_POV_SHARE_ALL

//added AM24
sort xyzDMxyzCountry xyzDMxyzInterpolation xyzDMxyzRequestYear xyzDCxyzWelfareType xyzDCxyzCoverage xyzDCxyzGender xyzDCxyzAgeGroup xyzDCxyzEducation xyzDCxyzDistribution
by xyzDMxyzCountry xyzDMxyzInterpolation xyzDMxyzRequestYear xyzDCxyzWelfareType xyzDCxyzCoverage xyzDCxyzGender xyzDCxyzAgeGroup xyzDCxyzEducation xyzDCxyzDistribution:  gen dup = cond(_N==1,0,_n)
drop if dup ==2 
drop dup
//

tempfile a 
save `a',replace

import delimited "${dataout}\indicator_values_country_chart4_${icpyr}.csv", clear
ren (xyzdmxyzcountry xyzdmxyzrequestyear xyzdmxyzinterpolation xyzdcxyzwelfaretype xyzdcxyzcoverage xyzdcxyzgender xyzdcxyzagegroup xyzdcxyzeducation xyzdcxyzdistribution) (xyzDMxyzCountry xyzDMxyzRequestYear xyzDMxyzInterpolation xyzDCxyzWelfareType xyzDCxyzCoverage xyzDCxyzGender xyzDCxyzAgeGroup xyzDCxyzEducation xyzDCxyzDistribution)
tostring xyzDMxyzRequestYear, replace
merge 1:1 xyzDMxyzCountry xyzDMxyzInterpolation xyzDMxyzRequestYear xyzDCxyzWelfareType xyzDCxyzCoverage xyzDCxyzGender xyzDCxyzAgeGroup xyzDCxyzEducation xyzDCxyzDistribution using `a' // 
keep if _m == 3
drop _m
drop xyzdpxyzsi_pov_share_all
cap drop ppp
gen ppp = 2011
export delimited _all using "$dataout\indicator_values_country_chart4_${icpyr2}.csv",  delim(",") datafmt replace