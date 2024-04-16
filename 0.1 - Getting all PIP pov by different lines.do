///////////////////////////////  2017ppp     ///////////////////////////////////
//PIP data - prep for Chart 1 and 2
pip, clear  povline(0.01) country(all) version(${pip_ver1}) server(${pip_server})
cap append using "$dataout\pip_all_lines_${icpyr}"
save "$dataout\pip_all_lines_${icpyr}", replace

qui forv i=0.05(0.05)10 {
	dis `i'
	cap pip, clear  povline(`i') country(all)  version(${pip_ver1}) server(${pip_server})
	if _rc==0 {
		cap append using "$dataout\pip_all_lines_${icpyr}"
		save "$dataout\pip_all_lines_${icpyr}", replace
	}
	else {
	    noi dis "Not done - `i'"
	}
}

qui forv i=11(1)21 {
	dis `i'
	cap pip, clear  povline(`i') country(all)  version(${pip_ver1}) server(${pip_server})
	if _rc==0 {
		cap append using "$dataout\pip_all_lines_${icpyr}"
		save "$dataout\pip_all_lines_${icpyr}", replace
	}
	else {
	    noi dis "Not done - `i'"
	}
}

pip, clear  povline(21.7) country(all)  version(${pip_ver1}) server(${pip_server})
cap append using "$dataout\pip_all_lines_${icpyr}"
save "$dataout\pip_all_lines_${icpyr}", replace

s
///////////////////////////////  2011ppp     ///////////////////////////////////
//PIP data - prep for Chart 1 and 2 (2011ppp)
pip, clear  povline(0.01) country(all) version(${pip_ver2})
tempfile dataall
save `dataall', replace

qui forv i=0.05(0.05)10 {
	dis `i'
	cap pip, clear  povline(`i') country(all) version(${pip_ver2})
	if _rc==0 {
	    append using `dataall'
		save `dataall', replace
	}
	else {
	    noi dis "Not done - `i'"
	}
}

qui forv i=11(1)21 {
	dis `i'
	cap pip, clear  povline(`i') country(all) version(${pip_ver2})
	if _rc==0 {
	    append using `dataall'
		save `dataall', replace
	}
	else {
	    noi dis "Not done - `i'"
	}
}

pip, clear  povline(21.7) country(all) version(${pip_ver2})
append using `dataall'
save "$dataout\pip_all_lines_${icpyr2}", replace
s
//speical treatment for GNB
// 2011ppp
use "$dataout\pip_all_lines_${icpyr2}", clear
keep if country_code == "GNB" & year == 1991
sort country_code poverty_line
loc j = 1
forv i=5.5(0.05)10 {
	set obs `=_N+1'
	replace poverty_line = `i' in `=_N'
}

forv i=11(1)21{
	set obs `=_N+1'
	replace poverty_line = `i' in `=_N'
}
set obs `=_N+1'
replace poverty_line = 21.7 if _n==_N

loc var country_code country_name region_code region_name reporting_level year welfare_time welfare_type mean comparable_spell survey_coverage distribution_type is_interpolated survey_time survey_acronym survey_comparability hfce gdp ppp cpi population
foreach v of loc var{
	replace `v' = `v'[1]
}
tempfile a
save `a', replace

use "$dataout\pip_all_lines_${icpyr2}", clear
drop if country_code == "GNB" & year == 1991
append using `a'
save "$dataout\pip_all_lines_${icpyr2}", replace

// 2017ppp
use "$dataout\pip_all_lines_${icpyr}", clear
keep if country_code == "GNB" & year == 1991
sort country_code poverty_line
loc j = 1
forv i=6.5(0.05)10 {
	set obs `=_N+1'
	replace poverty_line = `i' in `=_N'
}

forv i=11(1)21{
	set obs `=_N+1'
	replace poverty_line = `i' in `=_N'
}
set obs `=_N+1'
replace poverty_line = 21.7 if _n==_N

loc var country_code country_name region_code region_name reporting_level year welfare_time welfare_type mean comparable_spell survey_coverage distribution_type is_interpolated survey_time survey_acronym survey_comparability hfce gdp ppp cpi population
foreach v of loc var{
	replace `v' = `v'[1]
}
tempfile a
save `a', replace

use "$dataout\pip_all_lines_${icpyr}", clear
drop if country_code == "GNB" & year == 1991
append using `a'
save "$dataout\pip_all_lines_${icpyr}", replace