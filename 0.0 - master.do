*===============================================================================
// D4G project - PIP (GMI data to PIP)
*===============================================================================
set more off
clear all
*===============================================================================
//Macros
*===============================================================================
** main path **
global rd SM24
global oldrd AM23
global cpiv v10
global main "\\wbgfscifs01\GTSD\03.projects_corp\06.GMI\06.GMI_${rd}\06.GMI_${rd}_QA"
global oldpath "\\wbgfscifs01\GTSD\03.projects_corp\06.GMI\06.GMI_${oldrd}\06.GMI_${oldrd}_QA"
global dataout "$main\03.output\01.data\PIP"
global dataout2 "$oldpath\03.output\01.data\PIP"
global datain_GMI "$main\03.output\01.data"
global datain_GMI2 "$main\03.output\01.data\2011ppp"
*global oldpath "\\wbgfscifs01\GTSD\03.projects_corp\06.GMI\06.GMI_${oldrd}\06.GMI_${oldrd}_QA"
global datain_GPWG "\\wbgfscifs01\GTSD\03.projects_corp\04.GPWG\04.GPWG_${rd}\04.GPWG_${rd}_QA"
global dofiles "$main\01.programs\02.dofile\PIP"
global datain_PEB "\\wbgfscifs01\GTSD\03.projects_corp\01.PEB\01.PEB_${rd}\01.PEB_${rd}_QA"
global git_aux "\\wbgfscifs01\GTSD\03.projects_corp\06.GMI\PIP_aux_cp"
loc rdfull = substr("$rd",1,2)+"20"+substr("$rd",3,2)
global datain_PEB_ttl "\\wurepliprdfs01\gpvfile\gpv\Knowledge_Learning\Global_Stats_Team\PEB\\`rdfull'\02.tool_output\01.PovEcon_input"

//2017ppp
global icpyr 2017
global cpiyr 2017
global pov = 2.15
//2011ppp
global icpyr2 2011
global cpiyr2 2011
global pov2 = 1.9

** PIP setting **
global pip_ver2 "20240326_2011_02_02_PROD" // update w/ command 'pip ver' use most recent 2011 version
global pip_ver1 "20240326_2017_01_02_PROD" // update w/ command 'pip ver' use most recent 2017 version
global pip_server "prod" // This needs to be dev or the prod of the upcoming round. If you use the old round pip version, it will send outdated info to the PIP team 

** indicators **
global display = 1 	   //1 - display process; 0 - mute all output display
global remove "RUS-VNDN-2014 RUS-VNDN-2015 RUS-VNDN-2016 RUS-VNDN-2017 RUS-VNDN-2018 RUS-VNDN-2019" //example "SRB-EUSILC-2018"

*===============================================================================
//general dataset(long version/writer preference)
*===============================================================================
** 0.1  get all PIP pov by diff line (once per round)** (was PCN but changed to Pip cnh, 9/12/23)
run "$dofiles\0.1 - Getting all PIP pov by different lines.do"

** 0.2  prepare pfw (once per round)**
run "$dofiles\0.2 - pfw.do"

** 1.0 Prepare data for key indicator section **
do "$dofiles\1.0 - Key indicator sections.do"

** 1.1 Graphs 1 and 2 - poverty
do "$dofiles\1.1 - indicator_values_country_chart1_chart2_KI2.do"

** 1.2 Graph 3. Inequality
do "$dofiles\1.2 - indicator_values_country_chart3.do"

** 1.3 Graph 4. Key distribution
do "$dofiles\1.3 - indicator_values_country_chart4.do"

** 1.4 Graph 5. MPM data
do "$dofiles\1.4.0 - MPM_allround.do"
do "$dofiles\1.4.1 - indicator_values_country_chart5.do"

** 1.5 Graph 6. ShP/Median data
*do "$dofiles\1.5.0 - SHP_allround.do"
do "$dofiles\1.5.1 - indicator_values_country_chart6_KI4.do"

** 2.0 - combine 2011ppp and 2017ppp
do "$dofiles\2.0 - combine 2011ppp and 2017ppp.do"

**  3.0 - flat_cp.do"
do "$dofiles\3.0 - flat_cp.do"




