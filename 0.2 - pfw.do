//PIP data - prepare pfw
//note: update when we have more data.


//price framework
cap datalibweb, country(Support) year(2005) type(GMDRAW) surveyid(Support_2005_CPI_${cpiv}_M) filename(Survey_price_framework.dta) clear
/*import excel using "$datain_GPWG\02.input\Key variables in the Price framework - Tableau.xlsx" , sheet("CPI template information") firstrow  clear
*keep if show_portal == 1
*drop if new=="y"
*replace rep_year = 2017 if rep_year == 2018 & code == "TZA"
*replace year = rep_year if year!=rep_year
*tempfile pfw
*save `pfw', replace
*import excel using "$datain_GPWG\02.input\Key variables in the Price framework - Tableau.xlsx" , sheet("bi_welfare") firstrow  clear
*cap tostring new altname fieldwork_range newref cpi_domain_var ppp_domain_var tosplit_var, replace
*append using `pfw'
drop if code == "PLW" & datatype=="" // added cnh 9/12/23 as PLW was missing datatype
sort code year datatype // added cnh 9/12/23 as GBR has duplicate values in underlying dataset from gpwg
quietly by code year datatype:  gen dup = cond(_N==1,0,_n)
drop if dup>0
drop if drop == "y"
isid code year survname datatype

//drop old data
drop if code=="BRA" & survname=="PNAD" & year>=2012 & year<=2015
drop if code=="GEO" & survname=="SGH" & year==1997
drop if code=="RUS" & survname=="RLMS" & year==2001
drop if code=="AFG"
drop if code=="BIH" & year==2015
drop if code=="AZE" & year==2008
drop if code=="LSO" & year==2010
drop if code=="SRB" & year==2014 & datatype=="c"
*/
isid code year datatype

ren datatype datatype2
gen datatype = 1 if datatype2=="C" | datatype2=="c"
replace datatype = 2 if datatype2=="I" | datatype2=="i"

ren code countrycode

bys countrycode comparability (rep_year): egen minyear = min(rep_year)
bys countrycode comparability (rep_year): egen maxyear = max(rep_year)
gen comparable_spell = string(minyear) + "-" + string(maxyear)
replace comparable_spell = string(minyear) if minyear==maxyear
la var comparable_spell "Comparable spells"

save "${dataout}\pfw", replace

keep if survey_coverage  != "N"
save "${dataout}\pfw2", replace
