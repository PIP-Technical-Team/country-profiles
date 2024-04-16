//PIP data - chart 6
//This is the dofile for the data in Chart 6 (Shared Prosperity/Median income) of the country profile in PIP page.
//Missing: we need to add in the comparable data (or keep only comparable data for this chart)

*global datain C:\Users\wb327173\OneDrive - WBG\Downloads\ECA\Global\D4G\GMI
*global dataout c:\Users\wb327173\OneDrive - WBG\Downloads\ECA\SOL\Project X\Data for PIP\
global datadir 
/////////////////////////////////////  2011ppp  ////////////////////////////////

*use "$datadir/2011ppp/GMI_shp_forcheck_all.dta", clear
use "$datain_GMI2/GMI_shp_forcheck_all.dta", clear
rename *, lower
ren meanall meantotal
keep countrycode period welftype median meanb40 meantotal growthb40 growthm50 growthtotal seq surveyt
reshape wide median meanb40 meantotal surveyt, i(countrycode period welftype growthb40 growthm50 growthtotal) j(seq)
merge m:1 countrycode using "$main\02.input\region.dta", keepusing(region countryname) keep(3) nogen
order region countrycode countryname period welftype growthb40 growthm50 growthtotal meanb401 median1 meantotal1 meanb402 median2 meantotal2 surveyt1 surveyt2
sort region countrycode welftype period
gen pppyear = 2011
ren period spell
gen growthpre = growthb40 - growthtotal
keep countrycode spell welftype growthb40 growthtotal growthm50 growthpre pppyear

ren growthb40 gr1
ren growthtotal gr2
ren growthm50 gr3
ren growthpre gr4
reshape long gr, i( countrycode spell welftype pppyear) j(group) 

gen xyzDCxyzDistribution = "b40" if group==1
replace xyzDCxyzDistribution = "tot" if group==2
replace xyzDCxyzDistribution = "m50" if group==3
replace xyzDCxyzDistribution = "premium" if group==4

ren gr xyzDPxyzSI_SPR_PCAP_ZG
drop group
ren countrycode xyzDMxyzCountry	
ren spell xyzDMxyzYearRange	
gen xyzDMxyzInterpolation= "FALSE"
ren welftype xyzDCxyzWelfareType
ren pppyear xyzDCxyzPPPYear
order xyzDMxyzCountry xyzDMxyzYearRange	xyzDMxyzInterpolation xyzDCxyzWelfareType xyzDCxyzDistribution xyzDPxyzSI_SPR_PCAP_ZG
su

gen year = substr(xyzDMxyzYearRange, 1,4)
destring year, replace
gen countrycode = xyzDMxyzCountry
merge m:1 countrycode year using "${dataout}\pfw2.dta", keepusing(survey_coverage) keep(1 3) nogen
replace survey_coverage = "N" if survey_coverage == ""
drop countrycode year
ren survey_coverage xyzDMxyzCoverage

export delimited _all using "$dataout\indicator_values_country_chart6_KI4_${icpyr2}.csv",  delim(",") datafmt replace

//Chart6_KI4 data shared prosperity
ren *, lower
ren xyzdpxyzsi_spr_pcap_zg ind_
reshape wide ind_ , i( xyzdmxyzcountry xyzdmxyzyearrange xyzdmxyzinterpolation xyzdcxyzwelfaretype xyzdcxyzpppyear ) j( xyzdcxyzdistribution ) string

replace xyzdmxyzyearrange = subinstr( xyzdmxyzyearrange,"-","_",.)
reshape wide ind_b40 ind_m50 ind_premium ind_tot, i( xyzdmxyzcountry xyzdmxyzinterpolation xyzdcxyzwelfaretype xyzdcxyzpppyear ) j( xyzdmxyzyearrange ) string

isid xyzdmxyzcountry xyzdcxyzwelfaretype xyzdcxyzpppyear
ren xyzdmxyzcountry country_code
ren xyzdcxyzpppyear ppp_year
ren xyzdcxyzwelfaretype welfare_type
ren xyzdmxyzinterpolation  is_interpolated

la var country_code "Country/Economy code"
la var is_interpolated "Data is interpolated"
la var welfare_type "Welfare measured by income or consumption"
la var ppp_year "PPP Year"
ren ind_* growth_*
sort country_code welfare_type ppp_year

compress
saveold "${dataout2}\flat_shp_${icpyr2}.dta", replace

/////////////////////////////////////  2017ppp  ////////////////////////////////
use "$datain_GMI/GMI_shp_forcheck_all.dta", clear
rename *, lower
ren meanall meantotal
keep countrycode period welftype median meanb40 meantotal growthb40 growthm50 growthtotal seq surveyt
reshape wide median meanb40 meantotal surveyt, i(countrycode period welftype growthb40 growthm50 growthtotal) j(seq)
merge m:1 countrycode using "$main\02.input\region.dta", keepusing(region countryname) keep(3) nogen
order region countrycode countryname period welftype growthb40 growthm50 growthtotal meanb401 median1 meantotal1 meanb402 median2 meantotal2 surveyt1 surveyt2
sort region countrycode welftype period
gen pppyear = 2017
ren period spell
gen growthpre = growthb40 - growthtotal
keep countrycode spell welftype growthb40 growthtotal growthm50 growthpre pppyear

ren growthb40 gr1
ren growthtotal gr2
ren growthm50 gr3
ren growthpre gr4
reshape long gr, i( countrycode spell welftype pppyear) j(group) 

gen xyzDCxyzDistribution = "b40" if group==1
replace xyzDCxyzDistribution = "tot" if group==2
replace xyzDCxyzDistribution = "m50" if group==3
replace xyzDCxyzDistribution = "premium" if group==4

ren gr xyzDPxyzSI_SPR_PCAP_ZG
drop group
ren countrycode xyzDMxyzCountry	
ren spell xyzDMxyzYearRange	
gen xyzDMxyzInterpolation= "FALSE"
ren welftype xyzDCxyzWelfareType
ren pppyear xyzDCxyzPPPYear
order xyzDMxyzCountry xyzDMxyzYearRange	xyzDMxyzInterpolation xyzDCxyzWelfareType xyzDCxyzDistribution xyzDPxyzSI_SPR_PCAP_ZG
su

gen year = substr(xyzDMxyzYearRange, 1,4)
destring year, replace
gen countrycode = xyzDMxyzCountry
merge m:1 countrycode year using "${dataout}\pfw2.dta", keepusing(survey_coverage) keep(1 3) nogen
replace survey_coverage = "N" if survey_coverage == ""
drop countrycode year
ren survey_coverage xyzDMxyzCoverage

export delimited _all using "$dataout\indicator_values_country_chart6_KI4_${icpyr}.csv",  delim(",") datafmt replace

//Chart6_KI4 data shared prosperity
ren *, lower
ren xyzdpxyzsi_spr_pcap_zg ind_
reshape wide ind_ , i( xyzdmxyzcountry xyzdmxyzyearrange xyzdmxyzinterpolation xyzdcxyzwelfaretype xyzdcxyzpppyear ) j( xyzdcxyzdistribution ) string

replace xyzdmxyzyearrange = subinstr( xyzdmxyzyearrange,"-","_",.)
reshape wide ind_b40 ind_m50 ind_premium ind_tot, i( xyzdmxyzcountry xyzdmxyzinterpolation xyzdcxyzwelfaretype xyzdcxyzpppyear ) j( xyzdmxyzyearrange ) string

isid xyzdmxyzcountry xyzdcxyzwelfaretype xyzdcxyzpppyear
ren xyzdmxyzcountry country_code
ren xyzdcxyzpppyear ppp_year
ren xyzdcxyzwelfaretype welfare_type
ren xyzdmxyzinterpolation  is_interpolated

la var country_code "Country/Economy code"
la var is_interpolated "Data is interpolated"
la var welfare_type "Welfare measured by income or consumption"
la var ppp_year "PPP Year"
ren ind_* growth_*
sort country_code welfare_type ppp_year
compress
saveold "${dataout}\flat_shp_${icpyr}.dta", replace

use "${dataout2}\flat_shp_${icpyr2}.dta", clear
append using "${dataout}\flat_shp_${icpyr}.dta"
saveold "${git_aux}\flat_shp.dta", replace
