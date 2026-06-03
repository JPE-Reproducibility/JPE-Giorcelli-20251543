**********Copyright and Creativity: Evidence from Italian Opera in the Napoleonic Age
**********Authors: Michela Giorcelli (UCLA and NBER) and Petra Moser (NYU-Stern, NBER and CEPR)
**********Date: March 2026

clear all
set more off


*------------------------------------------------------------------------------*
cap cd	"/Users/michelag/MICHELA GIORCELLI Dropbox/Michela Giorcelli/opera replication/Comment_JPE/"	// Michela
*** ADD YOUR PATH

global	path = "`c(pwd)'/Response Replication Package"

global	data "${path}/Raw Data"
global	intermediate_data "${path}/Intermediate Data"
global	output	"${path}/Output/GM20_Output"

*------------------------------------------------------------------------------*

***Load raw data
use "${data}/operas_raw_data.dta", clear

keep if year >= 1781 & year <= 1820

***Drop operas without state composition
drop if state_composition==""

***Gen state encoding
gen state1 = .
replace state1 = 1 if state == "d_modena"
replace state1 = 2 if state == "d_parma"
replace state1 = 3 if state == "gd_tuscany"
replace state1 = 4 if state == "lombardy"
replace state1 = 5 if state == "papal_state"
replace state1 = 6 if state == "sardinia"
replace state1 = 7 if state == "two_sicilies"
replace state1 = 8 if state == "venetia"

keep composer_id composer_name state state1 year title annals amazon met

***Append additional operas by same 192 composers
tempfile base
save `base'

***Append additional operas by same composers
use "${data}/additional_operas.dta", clear
keep composer_id composer_name state state1 year title annals amazon met

append using `base'

***Collapse to composer × state × year level
gen c = 1
collapse (sum) comp_operas=c annals met amazon (first) composer_name state, ///
    by(composer_id state1 year)

***Merge composer-level information
merge m:1 composer_id using "${data}/composer_roster.dta", ///
    keepusing(returning stayers tot_operas ret_france_austria) ///
    keep(master match) nogen

***Create treatment and post variables
gen copyright=(state=="lombardy"| state=="venetia")
gen post1801=(year>=1801)
gen copyright_post1801=copyright*post1801

***Generate interactions
gen returning_copyright_post1801 = returning * copyright_post1801
gen stayers_copyright_post1801 = stayers * copyright_post1801

***Generate shares
foreach v in annals met amazon {
    gen `v'_share = `v' / comp_operas
}

******************************************************************************
**************************TABLE 5*********************************************
******************************************************************************

***********PANEL A: ALL COMPOSERS************************************************
***Column 1: All Operas
reg comp_operas copyright_post1801 i.composer_id i.state1 i.year, nocon robust
sum comp_operas if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table5.xls", replace ctitle("All Operas") keep(copyright_post1801) nocon dec(3) addtext(Composer, FE, State FE, YES, Year FE, YES, Sample, Full, Pre-Period Mean, `premean')

****HISTORICALLY POPULAR OPERAS IN LOEWENBERG (1978)

***Column 2: Count
reg annals copyright_post1801 i.composer_id i.state1 i.year, nocon robust
sum annals if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table5.xls", append ctitle("Annals") keep(copyright_post1801) nocon dec(3) addtext(Composer, FE, State FE, YES, Year FE, YES, Sample, Full, Pre-Period Mean, `premean')

***Column 3: Share
reg annals_share copyright_post1801 i.composer_id i.state1 i.year, nocon robust
sum annals_share if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table5.xls", append ctitle("Annals Share") keep(copyright_post1801) nocon dec(3) addtext(Composer, FE, State FE, YES, Year FE, YES, Sample, Full, Pre-Period Mean, `premean')

****OPERAS PERFORMED AT THE METROPOLITAN, 1900-2014

***Column 4: Count
reg met copyright_post1801 i.composer_id i.state1 i.year, nocon robust
sum met if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table5.xls", append ctitle("Met") keep(copyright_post1801) nocon dec(3) addtext(Composer, FE, State FE, YES, Year FE, YES, Sample, Full,  Pre-Period Mean, `premean')

***Column 5: Share
reg met_share copyright_post1801 i.composer_id i.state1 i.year, nocon robust
sum met_share if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table5.xls", append ctitle("Met Share") keep(copyright_post1801) nocon dec(3) addtext(Composer, FE, State FE, YES, Year FE, YES, Sample, Full, Pre-Period Mean, `premean')

****DURABLE OPERAS ON AMAZON TODAY

***Column 6: Count
reg amazon copyright_post1801 i.composer_id i.state1 i.year, nocon robust
sum amazon if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table5.xls", append ctitle("Amazon") keep(copyright_post1801) nocon dec(3) addtext(Composer, FE, State FE, YES, Year FE, YES, Sample, Full,  Pre-Period Mean, `premean')

***Column 7: Share
reg amazon_share copyright_post1801 i.composer_id i.state1 i.year, nocon robust
sum amazon_share if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table5.xls", append ctitle("Amazon Share") keep(copyright_post1801) nocon dec(3) addtext(Composer, FE, State FE, YES, Year FE, YES, Sample, Full,  Pre-Period Mean, `premean')


***********PANEL B: EXCLUDING TOP 10% COMPOSERS****************************************
***Column 1: All Operas
reg comp_operas copyright_post1801 i.composer_id i.state1 i.year if tot_operas<30, nocon robust
sum comp_operas if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table5.xls", append ctitle("All Operas") keep(copyright_post1801) nocon dec(3) addtext(Composer, FE, State FE, YES, Year FE, YES, Sample, <10%, Pre-Period Mean, `premean')

****HISTORICALLY POPULAR OPERAS IN LOEWENBERG (1978)

***Column 2: Count
reg annals copyright_post1801 i.composer_id i.state1 i.year if tot_operas<30, nocon robust
sum annals if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table5.xls", append ctitle("Annals") keep(copyright_post1801) nocon dec(3) addtext(Composer, FE, State FE, YES, Year FE, YES, Sample, <10%, Pre-Period Mean, `premean')

***Column 3: Share
reg annals_share copyright_post1801 i.composer_id i.state1 i.year if tot_operas<30, nocon robust
sum annals_share if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table5.xls", append ctitle("Annals Share") keep(copyright_post1801) nocon dec(3) addtext(Composer, FE, State FE, YES, Year FE, YES, Sample, <10%, Pre-Period Mean, `premean')

****OPERAS PERFORMED AT THE METROPOLITAN, 1900-2014

***Column 4: Count
reg met copyright_post1801 i.composer_id i.state1 i.year if tot_operas<30, nocon robust
sum met if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table5.xls", append ctitle("Met") keep(copyright_post1801) nocon dec(3) addtext(Composer, FE, State FE, YES, Year FE, YES, Sample, <10%, Pre-Period Mean, `premean')

***Column 5: Share
reg met_share copyright_post1801 i.composer_id i.state1 i.year if tot_operas<30, nocon robust
sum met_share if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table5.xls", append ctitle("Met Share") keep(copyright_post1801) nocon dec(3) addtext(Composer, FE, State FE, YES, Year FE, YES, Sample, <10%, Pre-Period Mean, `premean')

****DURABLE OPERAS ON AMAZON TODAY

***Column 6: Count
reg amazon copyright_post1801 i.composer_id i.state1 i.year if tot_operas<30, nocon robust
sum amazon if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table5.xls", append ctitle("Amazon") keep(copyright_post1801) nocon dec(3) addtext(Composer, FE, State FE, YES, Year FE, YES, Sample, <10%, Pre-Period Mean, `premean')

***Column 7: Share
reg amazon_share copyright_post1801 i.composer_id i.state1 i.year if tot_operas<30, nocon robust
sum amazon_share if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table5.xls", append ctitle("Amazon Share") keep(copyright_post1801) nocon dec(3) addtext(Composer, FE, State FE, YES, Year FE, YES, Sample, <10%, Pre-Period Mean, `premean')



***********PANEL C: EXCLUDING TOP 20% COMPOSERS******************************************
***Column 1: All Operas
reg comp_operas copyright_post1801 i.composer_id i.state1 i.year if tot_operas<20, nocon robust
sum comp_operas if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table5.xls", append ctitle("All Operas") keep(copyright_post1801) nocon dec(3) addtext(Composer, FE, State FE, YES, Year FE, YES, Sample, <20%, Pre-Period Mean, `premean')

****HISTORICALLY POPULAR OPERAS IN LOEWENBERG (1978)

***Column 2: Count
reg annals copyright_post1801 i.composer_id i.state1 i.year if tot_operas<20, nocon robust
sum annals if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table5.xls", append ctitle("Annals") keep(copyright_post1801) nocon dec(3) addtext(Composer, FE, State FE, YES, Year FE, YES, Sample, <20%, Pre-Period Mean, `premean')

***Column 3: Share
reg annals_share copyright_post1801 i.composer_id i.state1 i.year if tot_operas<20, nocon robust
sum annals_share if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table5.xls", append ctitle("Annals Share") keep(copyright_post1801) nocon dec(3) addtext(Composer, FE, State FE, YES, Year FE, YES, Sample, <20%, Pre-Period Mean, `premean')

****OPERAS PERFORMED AT THE METROPOLITAN, 1900-2014

***Column 4: Count
reg met copyright_post1801 i.composer_id i.state1 i.year if tot_operas<20, nocon robust
sum met if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table5.xls", append ctitle("Met") keep(copyright_post1801) nocon dec(3) addtext(Composer, FE, State FE, YES, Year FE, YES, Sample, <20%, Pre-Period Mean, `premean')

***Column 5: Share
reg met_share copyright_post1801 i.composer_id i.state1 i.year if tot_operas<20, nocon robust
sum met_share if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table5.xls", append ctitle("Met Share") keep(copyright_post1801) nocon dec(3) addtext(Composer, FE, State FE, YES, Year FE, YES, Sample, <20%, Pre-Period Mean, `premean')

****DURABLE OPERAS ON AMAZON TODAY

***Column 6: Count
reg amazon copyright_post1801 i.composer_id i.state1 i.year if tot_operas<20, nocon robust
sum amazon if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table5.xls", append ctitle("Amazon") keep(copyright_post1801) nocon dec(3) addtext(Composer, FE, State FE, YES, Year FE, YES, Sample, <20%, Pre-Period Mean, `premean')

***Column 7: Share
reg amazon_share copyright_post1801 i.composer_id i.state1 i.year if tot_operas<20, nocon robust
sum amazon_share if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table5.xls", append ctitle("Amazon Share") keep(copyright_post1801) nocon dec(3) addtext(Composer, FE, State FE, YES, Year FE, YES, Sample, <20%, Pre-Period Mean, `premean')



******************************************************************************
**************************FIGURE 5********************************************
******************************************************************************

***Load raw data
use "${data}/composers_return_year.dta", clear

keep if year >= 1781 & year <= 1820

***Count composers flow by year
bys year: gen returning=_N

duplicates drop

twoway line returning year, text(8.2 1801.5 "1801 Copyright Law", placement(e)) ///
xline(1801, lcolor(black) lpattern(shortdash)) lcolor(black) xtitle("") ytitle("Number of Composers Returning to Lombardy and Venetia") graphregion(color(white)) 

graph export "${output}/Figure5.png", replace




