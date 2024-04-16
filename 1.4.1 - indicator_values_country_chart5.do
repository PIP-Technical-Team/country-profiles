//PIP data - chart 5
//This is the dofile for the data in Chart 5 (MPM) of the country profile in PIP page.
//Missing: we need to add in the comparable data (or keep only comparable data for this chart)
/////////////////////////////////////  2017ppp  ////////////////////////////////
use "${dataout}\pfw.dta", clear
replace year = rep_year
gen welftype = "CONS" if datatype == 1
replace welftype = "INC" if datatype == 2
tempfile pfw
save `pfw', replace


// MPM data
*use "${datain_GPWG}\03.output\01.data\mpm\MPM_comp.dta" , clear
*use "${datain_GMI}\MPM_comp.dta" , clear
use "${datain_GMI}\MPM_draft_allv2.dta" , clear
destring year, replace
merge m:1 countrycode year survname using `pfw' , keepus(comparable_spell display_cp survey_coverage)
drop if _m == 2
keep if display_cp == 1 //from pfw 
drop _m display_cp

replace welftype = "INC" if upper(welftype) == "I"
replace welftype = "CONS" if upper(welftype) == "C" | welftype == "C/c"

ren dep_educ_com	xyzDPxyzSI_MPM_EDUC
ren dep_educ_enr	xyzDPxyzSI_MPM_EDUE
ren dep_infra_elec	xyzDPxyzSI_MPM_ELEC
ren dep_infra_imps	xyzDPxyzSI_MPM_IMPS
ren dep_infra_impw2	xyzDPxyzSI_MPM_IMPW
ren dep_poor1	xyzDPxyzSI_MPM_POOR
ren mdpoor_i1	xyzDPxyzSI_MPM_MDHC

ren countrycode xyzDMxyzCountry	
ren year xyzDMxyzRequestYear	
gen xyzDMxyzInterpolation = "FALSE"
ren	welftype xyzDCxyzWelfareType
*drop if xyzDMxyzCountry=="COM" & xyzDMxyzRequestYear==2014
*drop if xyzDMxyzCountry=="LSO" & xyzDMxyzRequestYear==2010
order xyzDMxyzCountry xyzDMxyzRequestYear xyzDMxyzInterpolation xyzDCxyzWelfareType xyzDPxyzSI_MPM_EDUC xyzDPxyzSI_MPM_EDUE xyzDPxyzSI_MPM_ELEC xyzDPxyzSI_MPM_IMPS xyzDPxyzSI_MPM_IMPW xyzDPxyzSI_MPM_POOR xyzDPxyzSI_MPM_MDHC
keep xyzDMxyzCountry xyzDMxyzRequestYear xyzDMxyzInterpolation xyzDCxyzWelfareType xyzDPxyzSI_MPM_EDUC xyzDPxyzSI_MPM_EDUE xyzDPxyzSI_MPM_ELEC xyzDPxyzSI_MPM_IMPS xyzDPxyzSI_MPM_IMPW xyzDPxyzSI_MPM_POOR xyzDPxyzSI_MPM_MDHC survname comparable_spell survey_coverage
su
export delimited _all using "$dataout\indicator_values_country_chart5_${icpyr}.csv",  delim(",") datafmt replace

/////////////////////////////////////  2011ppp  ////////////////////////////////
use "${dataout}\pfw.dta", clear
replace year = rep_year
gen welftype = "CONS" if datatype == 1
replace welftype = "INC" if datatype == 2
tempfile pfw
save `pfw', replace

// MPM data
*use "${datain_GPWG}\03.output\01.data\mpm\MPM_comp.dta" , clear
*use "${datain_GMI}\MPM_comp.dta" , clear
use "${datain_GMI2}\MPM_draft_allv2.dta" , clear
destring year, replace
merge m:1 countrycode year survname using `pfw' , keepus(comparable_spell display_cp survey_coverage)
drop if _m == 2
keep if display_cp == 1 //from pfw 
drop _m display_cp

replace welftype = "INC" if upper(welftype) == "I"
replace welftype = "CONS" if upper(welftype) == "C" | welftype == "C/c"

ren dep_educ_com	xyzDPxyzSI_MPM_EDUC
ren dep_educ_enr	xyzDPxyzSI_MPM_EDUE
ren dep_infra_elec	xyzDPxyzSI_MPM_ELEC
ren dep_infra_imps	xyzDPxyzSI_MPM_IMPS
ren dep_infra_impw2	xyzDPxyzSI_MPM_IMPW
ren dep_poor1	xyzDPxyzSI_MPM_POOR
ren mdpoor_i1	xyzDPxyzSI_MPM_MDHC

ren countrycode xyzDMxyzCountry	
ren year xyzDMxyzRequestYear	
gen xyzDMxyzInterpolation = "FALSE"
ren	welftype xyzDCxyzWelfareType
*drop if xyzDMxyzCountry=="COM" & xyzDMxyzRequestYear==2014
*drop if xyzDMxyzCountry=="LSO" & xyzDMxyzRequestYear==2010
order xyzDMxyzCountry xyzDMxyzRequestYear xyzDMxyzInterpolation xyzDCxyzWelfareType xyzDPxyzSI_MPM_EDUC xyzDPxyzSI_MPM_EDUE xyzDPxyzSI_MPM_ELEC xyzDPxyzSI_MPM_IMPS xyzDPxyzSI_MPM_IMPW xyzDPxyzSI_MPM_POOR xyzDPxyzSI_MPM_MDHC
keep xyzDMxyzCountry xyzDMxyzRequestYear xyzDMxyzInterpolation xyzDCxyzWelfareType xyzDPxyzSI_MPM_EDUC xyzDPxyzSI_MPM_EDUE xyzDPxyzSI_MPM_ELEC xyzDPxyzSI_MPM_IMPS xyzDPxyzSI_MPM_IMPW xyzDPxyzSI_MPM_POOR xyzDPxyzSI_MPM_MDHC survname comparable_spell survey_coverage
su
export delimited _all using "$dataout\indicator_values_country_chart5_${icpyr2}.csv",  delim(",") datafmt replace