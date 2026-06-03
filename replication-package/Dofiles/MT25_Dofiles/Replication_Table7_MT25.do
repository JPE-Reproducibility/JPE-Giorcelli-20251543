**********Copyright and Creativity: Evidence from Italian Opera in the Napoleonic Age
**********Authors: Michela Giorcelli (UCLA and NBER) and Petra Moser (NYU-Stern, NBER and CEPR)
**********Date: March 2020
**********Replication of MT25 Table 7: Excluding the Most Prolific Composers 

clear all
set more off


*------------------------------------------------------------------------------*
cap cd	"/Users/michelag/MICHELA GIORCELLI Dropbox/Michela Giorcelli/opera replication/Comment_JPE/"	// Michela
*** ADD YOUR PATH

global	path = "`c(pwd)'/Response Replication Package"

global	data "${path}/Raw Data"
global	intermediate_data "${path}/Intermediate Data"
global	output	"${path}/Output/GM20_Output"
global	replication	"${path}/Output/MT25_Replication"
*------------------------------------------------------------------------------*

***Load composer-level dataset 
use "$intermediate_data/composer_level_data.dta", clear

local variables annals met amazon

***Generate quality variables
foreach variable of local variables {
gen `variable'_share=`variable'/comp_operas
}


***********PANEL B: EXCLUDING TOP 10% COMPOSERS (< 7 operas)****************************
***Column 1: All Operas
reghdfe comp_operas copyright_post1801 if tot_operas<7, absorb(composer_id state1 year) vce(robust)
outreg2 using "${replication}/MT25_Table7.xls", replace ctitle("Col 1 All") keep(copyright_post1801) nocon dec(3) addtext(Composer FE, YES, State FE, YES, Year FE, YES, Sample, <7, Panel, B)

****HISTORICALLY POPULAR OPERAS IN LOEWENBERG (1978)

***Column 2: Count
reghdfe annals copyright_post1801 if tot_operas<7, absorb(composer_id state1 year) vce(robust)
outreg2 using "${replication}/MT25_Table7.xls", append ctitle("Col 2 Annals-Count") keep(copyright_post1801) nocon dec(3) addtext(Composer FE, YES, State FE, YES, Year FE, YES, Sample, <7, Panel, B)

***Column 3: Share
reghdfe annals_share copyright_post1801 if comp_operas<7, absorb(composer_id state1 year) vce(robust)
outreg2 using "${replication}/MT25_Table7.xls", append ctitle("Col 3 Annals-Share") keep(copyright_post1801) nocon dec(3) addtext(Composer FE, YES, State FE, YES, Year FE, YES, Sample, <7, Panel, B)

****OPERAS PERFORMED AT THE METROPOLITAN, 1900-2014

***Column 4: Count
reghdfe met copyright_post1801 if tot_operas<7, absorb(composer_id state1 year) vce(robust)
outreg2 using "${replication}/MT25_Table7.xls", append ctitle("Col 4 Met-Count") keep(copyright_post1801) nocon dec(3) addtext(Composer FE, YES, State FE, YES, Year FE, YES, Sample, <7, Panel, B)

***Column 5: Share
reghdfe met_share copyright_post1801 if tot_operas<7, absorb(composer_id state1 year) vce(robust)
outreg2 using "${replication}/MT25_Table7.xls", append ctitle("Col 5 Met-Share") keep(copyright_post1801) nocon dec(3) addtext(Composer FE, YES, State FE, YES, Year FE, YES, Sample, <7, Panel, B)

****DURABLE OPERAS ON AMAZON TODAY

***Column 6: Count
reghdfe amazon copyright_post1801 if tot_operas<7, absorb(composer_id state1 year) vce(robust)
outreg2 using "${replication}/MT25_Table7.xls", append ctitle("Col 6 Amazon-Count") keep(copyright_post1801) nocon dec(3) addtext(Composer FE, YES, State FE, YES, Year FE, YES, Sample, <7, Panel, B)

***Column 7: Share
reghdfe amazon_share copyright_post1801 if tot_operas<7, absorb(composer_id state1 year) vce(robust)
outreg2 using "${replication}/MT25_Table7.xls", append ctitle("Col 7 Amazon-Share") keep(copyright_post1801) nocon dec(3) addtext(Composer FE, YES, State FE, YES, Year FE, YES, Sample, <7, Panel, B)
