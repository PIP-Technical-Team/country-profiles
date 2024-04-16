//PIP data - This is for the WDI indicator used in the Key Indicator section table
*global dataout c:\Users\wb327173\OneDrive - WBG\Downloads\ECA\SOL\Project X\Data for PIP\

//need to use wbopendata to get the data
//need to think of a workflow to update data in Spring for national poverty line before it is available in WDI

//indicator_values_country_KI1.csv (NATIONAL POVERTY RATE)
use "$datain_PEB\02.input\peb_npl.dta", clear
keep if case == "line"
*merge 1:1 countrycode year case indicator using "$datain_PEB\02.input\peb_npl_EUROSTAT.dta", nogen
*replace values = 24.1 if countrycode == "FJI" & year == "2019"
destring year, replace
bys countrycode (year): egen ymax = max(year)
keep countrycode year values source comparable ymax
ren (countrycode year values source comparable) (xyzDMxyzCountry xyzDMxyzRequestYear xyzDPxyzsi_pov_nahc xyzDMxyzComparability xyzDMxyzFootnote)
order xyzDMxyzCountry xyzDMxyzRequestYear
drop if xyzDPxyzsi_pov_nahc==.
drop xyzDMxyzComparability
su
export delimited _all using "${git_aux}\indicator_values_country_KI1.csv",  delim(",") datafmt replace

//other data from WDI

wbopendata, indicator(SP.POP.TOTL; NY.GNP.PCAP.CD;NY.GDP.MKTP.KD.ZG) long clear

replace sp_pop_totl = sp_pop_totl/1000000

ren countrycode xyzDMxyzCountry	
ren year xyzDMxyzRequestYear
ren sp_pop_totl xyzDPxyzsp_pop_totl	
ren ny_gnp_pcap_cd xyzDPxyzny_gnp_pcap_cd	
ren ny_gdp_mktp_kd_zg xyzDPxyzny_gdp_mktp_kd_zg

keep xyzDMxyzCountry xyzDMxyzRequestYear xyzDPxyzsp_pop_totl xyzDPxyzny_gnp_pcap_cd xyzDPxyzny_gdp_mktp_kd_zg
drop if xyzDPxyzsp_pop_totl==. & xyzDPxyzny_gnp_pcap_cd==. & xyzDPxyzny_gdp_mktp_kd_zg==.
su

export delimited _all using "${git_aux}\indicator_values_country_KI5_KI6_KI7.csv",  delim(",") datafmt replace

