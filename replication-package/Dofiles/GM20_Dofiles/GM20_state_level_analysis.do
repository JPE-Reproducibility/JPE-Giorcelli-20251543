**********Copyright and Creativity: Evidence from Italian Opera in the Napoleonic Age
**********Authors: Michela Giorcelli (UCLA and NBER) and Petra Moser (NYU-Stern, NBER and CEPR)
**********Date: March 2020

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

***Generate variables for the analysis in the raw data
****Operas count
bys state year: gen operas=_N

bys state year: gen n=_n

****Quality variables
replace annals=0 if annals==.
replace amazon=0 if amazon==.
replace met=0 if met==.

bys state year: egen operas_annals=total(annals)
bys state year: egen operas_amazon=total(amazon)
bys state year: egen operas_met=total(met)

****Excluding Milan
cap drop operas_no_milan
cap drop _temp
gen _temp = (state == "lombardy" & city != "milan")
bys year: egen operas_no_milan = total(_temp)
drop _temp

replace operas_no_milan=operas if state~="lombardy"

****Excluding Venice
cap drop operas_novenice
cap drop _temp
gen _temp = (state == "venetia" & city != "venice")
bys year: egen operas_novenice = total(_temp)
drop _temp

replace operas_novenice=operas if state~="venetia"

****Excluding Milan and Venice
gen opera_nomi_nove=operas_no_milan if state=="lombardy"
replace opera_nomi_nove=operas_novenice if state=="venetia"
replace opera_nomi_nove=operas if opera_nomi_nove==.

***Average Repeat Performance (average repeat performance per state and year)
gen rc_opera =repeated_performance/years_span
replace rc_opera = 0 if years_span==.
bysort state year: egen repeated_count = mean(rc_opera)
drop rc_opera

***Average Repeat Performance in premiere year
bys state year:  egen season_count = mean(season_repeat)

***Create state-year level dataset (dropping within state-year duplicates)
keep if n==1

***Keep only the variables used in the analysis
keep operas operas_annals operas_amazon operas_met state year operas_no_milan operas_novenice opera_nomi_nove repeated_count season_count

***Create treatment and post variables
gen copyright=(state=="lombardy"| state=="venetia")
gen post1801=(year>=1801)
gen copyright_post1801=copyright*post1801
encode state, gen(state1)

***Generate variables for the analysis in the state-year dataset

***Generate Linear Pre-Trend for Lombardy and Venetia
sort state year
by state: gen linear_pretrend = _n if year<1801 &  (state=="lombardy" | state=="venetia")
replace linear_pretrend=0 if linear_pretrend==.

***Generate State-Specific Linear Pre-Trend
sort state year
by state: gen trend = _n if year<1801
replace trend=0 if trend==.

local states d_modena d_parma gd_tuscany lombardy papal_state sardinia two_sicilies venetia

foreach s of local states {
    gen pretrend_`s' = trend * (state == "`s'")
}

drop trend


***Quality shares
local variables annals amazon met
foreach variable of local variables {
gen share_`variable'=operas_`variable'/operas
}

***Years of French presence
gen french_domination=1801 if state=="lombardy" | state=="venetia"
replace french_domination=1805 if state=="sardinia"
replace french_domination=1809 if state=="tuscany"
replace french_domination=1812 if state=="papal_state" | state=="two_sicilies"
replace french_domination=1805 if french_domination==.

gen years_occupation=year-french_domination


*************************************************************************************************************************************************
************************TABLE 1: New Operas Per State and Year across Eight States within Italy, 1781–1820***************************************
*************************************************************************************************************************************************

file open tab1 using "${output}/table1.txt", write replace
file write tab1 "Table 1: New Operas Per State and Year, 1781-1820" _n _n
file write tab1 _tab "All Years" _tab _tab _tab "Pre (1781-1800)" _tab _tab _tab "Post (1801-1820)" _tab _tab _n
file write tab1 _tab "Copyright" _tab "No Copyright" _tab "Diff" _tab "Copyright" _tab "No Copyright" _tab "Diff" _tab "Copyright" _tab "No Copyright" _tab "Diff" _n

foreach var in operas operas_annals operas_met operas_amazon {
    if "`var'" == "operas" local label "New Operas"
    if "`var'" == "operas_annals" local label "Annals (Loewenberg)"
    if "`var'" == "operas_met" local label "Met Opera"
    if "`var'" == "operas_amazon" local label "Amazon"

    sum `var' if copyright == 1 & year <= 1820
    local c_all = r(mean)
    sum `var' if copyright == 0 & year <= 1820
    local nc_all = r(mean)
    local d_all = `c_all' - `nc_all'

    sum `var' if copyright == 1 & year >= 1781 & year <= 1800
    local c_pre = r(mean)
    sum `var' if copyright == 0 & year >= 1781 & year <= 1800
    local nc_pre = r(mean)
    local d_pre = `c_pre' - `nc_pre'

    sum `var' if copyright == 1 & year >= 1801 & year <= 1820
    local c_post = r(mean)
    sum `var' if copyright == 0 & year >= 1801 & year <= 1820
    local nc_post = r(mean)
    local d_post = `c_post' - `nc_post'

    file write tab1 "`label'" _tab %5.3f (`c_all') _tab %5.3f (`nc_all') _tab %5.3f (`d_all') _tab %5.3f (`c_pre') _tab %5.3f (`nc_pre') _tab %5.3f (`d_pre') _tab %5.3f (`c_post') _tab %5.3f (`nc_post') _tab %5.3f (`d_post') _n
}
file close tab1


*************************************************************************************************************************************************
************************TABLE 3: Effects of Copyrights on the Creation of New Operas ************************************************************
*************************************************************************************************************************************************
xtset state1 year

***Column 1: State and Year Fixed Effects
reg operas copyright_post1801 i.state1 i.year if year<=1820, nocon robust
sum operas if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table3.xls", replace ctitle("Col 1") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 2: Year Fixed Effects
reg operas copyright_post1801 copyright i.year if year<=1820, nocon robust
sum operas if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table3.xls", append ctitle("Col 2") keep(copyright_post1801 copyright) nocon dec(3) addtext(State FE, NO, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 3: State and Year Fixed Effects + Linear Pre-Trend for Lombardy and Venetia
reg operas copyright_post1801 i.state1 i.year linear_pretrend if year<=1820, nocon robust
sum operas if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table3.xls", append ctitle("Col 3") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, YES, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 4: State and Year Fixed Effects + State Specific Pre-Trend
reg operas copyright_post1801 i.state1 i.year pretrend_* if year<=1820, nocon robust
sum operas if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table3.xls", append ctitle("Col 4") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, YES, Poisson, NO, Pre-Period Mean, `premean')

***Column 5: Poisson
poisson operas copyright_post1801 i.state1 i.year if year<=1820, vce(robust)
margins, dydx(copyright_post1801) post
sum operas if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table3.xls", append ctitle("Col 5 Poisson") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, YES, Pre-Period Mean, `premean')


*************************************************************************************************************************************************
************************TABLE 4: Effects of Copyrights on the Quality of New Operas  ************************************************************
*************************************************************************************************************************************************

****HISTORICALLY POPULAR OPERAS IN LOEWENBERG (1978)
***Column 1: Count
reg operas_annals copyright_post1801 i.state1 i.year if year<=1820, nocon robust
sum operas_annals if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table4.xls", replace ctitle("Annals Count") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 2: Share
reg share_annals copyright_post1801 i.state1 i.year if year<=1820, nocon robust
sum share_annals if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table4.xls", append ctitle("Annals Share") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

****OPERAS PERFORMED AT THE METROPOLITAN, 1900-2014
***Column 3: Count
reg operas_met copyright_post1801 i.state1 i.year if year<=1820, nocon robust
sum operas_met if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table4.xls", append ctitle("Met Count") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 4: Share
reg share_met copyright_post1801 i.state1 i.year if year<=1820, nocon robust
sum share_met if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table4.xls", append ctitle("Met Share") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

****DURABLE OPERAS ON AMAZON TODAY
***Column 5: Count
reg operas_amazon copyright_post1801 i.state1 i.year if year<=1820, nocon robust
sum operas_amazon if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table4.xls", append ctitle("Amazon Count") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 6: Share
reg share_amazon copyright_post1801 i.state1 i.year if year<=1820, nocon robust
sum share_amazon if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/table4.xls", append ctitle("Amazon Share") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')


*************************************************************************************************************************************************
************************FIGURE 2: New operas per state and year in Italy, 1781–1820  ************************************************************
*************************************************************************************************************************************************

bys copyright year: egen total_operas=mean(operas)

twoway line total_operas year if copyright==1, lcolor(black) || line total_operas year if copyright==0, ///
lpattern(dash) lcolor(black) ytitle("Mean New Operas per Year") xtitle("")  ///
xline(1801, lcolor(black) lpattern(shortdash)) text(8 1801.5 "1801 Copyright Law", placement(e)) ///
legend(label(1 "Lombardy & Venetia") label(2 "Other States")) ///
graphregion(color(white))
graph export "${output}/figure2.png", replace


*************************************************************************************************************************************************
****************TABLE A3: Collapsing Pre and Post-Period Observations with Clustering at the State Level*****************************************
*************************************************************************************************************************************************
xtset state1 year

egen cluster=group(state1 post1801) 

***Column 1: State and Year Fixed Effects
reg operas copyright_post1801 i.state1 i.year if year<=1820, nocon cluster(cluster)
sum operas if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA3.xls", replace ctitle("Col 1") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 2: Year Fixed Effects
reg operas copyright_post1801 copyright i.year if year<=1820, nocon cluster(cluster)
sum operas if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA3.xls", append ctitle("Col 2") keep(copyright_post1801 copyright) nocon dec(3) addtext(State FE, NO, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 3: State and Year Fixed Effects + Linear Pre-Trend for Lombardy and Venetia
reg operas copyright_post1801 i.state1 i.year linear_pretrend if year<=1820, nocon cluster(cluster)
sum operas if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA3.xls", append ctitle("Col 3") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, YES, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 4: State and Year Fixed Effects + State Specific Pre-Trend
reg operas copyright_post1801 i.state1 i.year pretrend_* if year<=1820, nocon cluster(cluster)
sum operas if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA3.xls", append ctitle("Col 4") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, YES, Poisson, NO, Pre-Period Mean, `premean')


*************************************************************************************************************************************************
****************TABLE A5: De-Trending the Dependent Variable ************************************************************************************
*************************************************************************************************************************************************
xtset state1 year

reg operas year i.state1 i.year if year<=1801 & (state=="lombardy" | state=="venetia")

predict res if e(sample), res

replace res=0 if missing(res)

gen pred_operas=operas-res

***Column 1: State and Year Fixed Effects
reg pred_operas copyright_post1801 i.state1 i.year if year<=1820, nocon robust
sum pred_operas if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA5.xls", replace ctitle("Col 1") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 2: Year Fixed Effects
reg pred_operas copyright_post1801 copyright i.year if year<=1820, nocon robust
sum pred_operas if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA5.xls", append ctitle("Col 2") keep(copyright_post1801 copyright) nocon dec(3) addtext(State FE, NO, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 3: State and Year Fixed Effects + Linear Pre-Trend for Lombardy and Venetia
reg pred_operas copyright_post1801 i.state1 i.year linear_pretrend if year<=1820, nocon robust
sum pred_operas if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA5.xls", append ctitle("Col 3") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, YES, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 4: State and Year Fixed Effects + State Specific Pre-Trend
reg pred_operas copyright_post1801 i.state1 i.year pretrend_* if year<=1820, nocon robust
sum pred_operas if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA5.xls", append ctitle("Col 4") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, YES, Poisson, NO, Pre-Period Mean, `premean')

***Column 5: Poisson
poisson pred_operas copyright_post1801 i.state1 i.year if year<=1820, vce(robust)
margins, dydx(copyright_post1801) post
sum pred_operas if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA5.xls", append ctitle("Col 5 Poisson") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, YES, Pre-Period Mean, `premean')


*************************************************************************************************************************************************
****************TABLE A6: Excluding Milan and Venice ********************************************************************************************
*************************************************************************************************************************************************
xtset state1 year

***Column 1: OLS, Excluding Venice
reg operas_novenice copyright_post1801 i.state1 i.year if year<=1820, nocon robust  
sum operas_novenice if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA6.xls", replace ctitle("OLS No Venice") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 2: Poisson, Excluding Venice
poisson operas_novenice copyright_post1801 i.state1 i.year if year<=1820, vce(robust)  
margins, dydx(copyright_post1801) post
sum operas_novenice if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA6.xls", append ctitle("Poisson No Venice") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, YES, Pre-Period Mean, `premean')

***Column 3: OLS, Excluding Milan
reg operas_no_milan copyright_post1801 i.state1 i.year if year<=1820, nocon robust
sum operas_no_milan if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA6.xls", append ctitle("OLS No Milan") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 4: Poisson, Excluding Milan
poisson operas_no_milan copyright_post1801 i.state1 i.year if year<=1820, vce(robust)
margins, dydx(copyright_post1801) post
sum operas_no_milan if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA6.xls", append ctitle("Poisson No Milan") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, YES, Pre-Period Mean, `premean')

***Column 5: OLS, Excluding Milan and Venice
reg opera_nomi_nove copyright_post1801 i.state1 i.year if year<=1820, nocon robust
sum opera_nomi_nove if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA6.xls", append ctitle("OLS No Both") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 6: Poisson, Excluding Milan and Venice
poisson opera_nomi_nove copyright_post1801 i.state1 i.year if year<=1820, vce(robust)
margins, dydx(copyright_post1801) post
sum opera_nomi_nove if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA6.xls", append ctitle("Poisson No Both") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, YES, Pre-Period Mean, `premean')

***Column 7: OLS, Excluding Venetia 
reg operas copyright_post1801 i.state1 i.year if state~="venetia" & year<=1820, nocon robust
sum operas if post1801==0 & year<=1820 & state~="venetia"
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA6.xls", append ctitle("OLS No Venetia") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 8: Poisson, Excluding Venetia 
poisson operas copyright_post1801 i.state1 i.year if state~="venetia" & year<=1820, vce(robust)
margins, dydx(copyright_post1801) post
sum operas if post1801==0 & year<=1820 & state~="venetia"
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA6.xls", append ctitle("Poisson No Venetia") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, YES, Pre-Period Mean, `premean')


*************************************************************************************************************************************************
****************TABLE A7: Controlling for Years of French Presence ******************************************************************************
*************************************************************************************************************************************************
xtset state1 year

***Column 1: State and Year Fixed Effects
reg operas copyright_post1801 years_occupation i.state1 i.year if year<=1820, nocon robust
sum operas if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA7.xls", replace ctitle("Col 1") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 2: Year Fixed Effects
reg operas copyright_post1801 copyright years_occupation i.year if year<=1820, nocon robust
sum operas if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA7.xls", append ctitle("Col 2") keep(copyright_post1801 copyright) nocon dec(3) addtext(State FE, NO, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 3: State and Year Fixed Effects + Linear Pre-Trend for Lombardy and Venetia
reg operas copyright_post1801 years_occupation i.state1 i.year linear_pretrend if year<=1820, nocon robust
sum operas if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA7.xls", append ctitle("Col 3") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, YES, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 4: State and Year Fixed Effects + State Specific Pre-Trend
reg operas copyright_post1801 years_occupation i.state1 i.year pretrend_* if year<=1820, nocon robust
sum operas if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA7.xls", append ctitle("Col 4") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, YES, Poisson, NO, Pre-Period Mean, `premean')

***Column 5: Poisson
poisson operas copyright_post1801 years_occupation i.state1 i.year if year<=1820, vce(robust)
margins, dydx(copyright_post1801) post
sum operas if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA7.xls", append ctitle("Col 5 Poisson") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, YES, Pre-Period Mean, `premean')


*************************************************************************************************************************************************
****************TABLE A8: Robustness Checks with Alternative Measure of Quality *****************************************************************
*************************************************************************************************************************************************
***PANEL A: HISTORICALLY POPULAR OPERAS IN LOEWENBERG (1978)

***Column 1: Year FE, Count
reg operas_annals copyright_post1801 copyright i.year if year<=1820, nocon robust
sum operas_annals if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA8.xls", replace ctitle("A1 Year FE Count") keep(copyright_post1801 copyright) nocon dec(3) addtext(State FE, NO, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 2: Year FE, Share
reg share_annals copyright_post1801 copyright i.year if year<=1820, nocon robust
sum share_annals if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA8.xls", append ctitle("A2 Year FE Share") keep(copyright_post1801 copyright) nocon dec(3) addtext(State FE, NO, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 3: Linear Pre-Trend for Lombardy & Venetia, Count
reg operas_annals copyright_post1801 i.state1 i.year linear_pretrend if year<=1820, nocon robust
sum operas_annals if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA8.xls", append ctitle("A3 LinPre Count") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, YES, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 4: Linear Pre-Trend for Lombardy & Venetia, Share
reg share_annals copyright_post1801 i.state1 i.year linear_pretrend if year<=1820, nocon robust
sum share_annals if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA8.xls", append ctitle("A4 LinPre Share") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, YES, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 5: State Specific Linear Pre-Trend, Count
reg operas_annals copyright_post1801 i.state1 i.year pretrend_* if year<=1820, nocon robust
sum operas_annals if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA8.xls", append ctitle("A5 StatePre Count") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, YES, Poisson, NO, Pre-Period Mean, `premean')

***Column 6: State Specific Linear Pre-Trend, Share
reg share_annals copyright_post1801 i.state1 i.year pretrend_* if year<=1820, nocon robust
sum share_annals if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA8.xls", append ctitle("A6 StatePre Share") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, YES, Poisson, NO, Pre-Period Mean, `premean')


***PANEL B: OPERAS PERFORMED AT THE METROPOLITAN, 1900-2014

***Column 1: Year FE, Count
reg operas_met copyright_post1801 copyright i.year if year<=1820, nocon robust
sum operas_met if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA8.xls", append ctitle("B1 Year FE Count") keep(copyright_post1801 copyright) nocon dec(3) addtext(State FE, NO, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 2: Year FE, Share
reg share_met copyright_post1801 copyright i.year if year<=1820, nocon robust
sum share_met if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA8.xls", append ctitle("B2 Year FE Share") keep(copyright_post1801 copyright) nocon dec(3) addtext(State FE, NO, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 3: Linear Pre-Trend for Lombardy & Venetia, Count
reg operas_met copyright_post1801 i.state1 i.year linear_pretrend if year<=1820, nocon robust
sum operas_met if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA8.xls", append ctitle("B3 LinPre Count") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, YES, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 4: Linear Pre-Trend for Lombardy & Venetia, Share
reg share_met copyright_post1801 i.state1 i.year linear_pretrend if year<=1820, nocon robust
sum share_met if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA8.xls", append ctitle("B4 LinPre Share") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, YES, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 5: State Specific Linear Pre-Trend, Count
reg operas_met copyright_post1801 i.state1 i.year pretrend_* if year<=1820, nocon robust
sum operas_met if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA8.xls", append ctitle("B5 StatePre Count") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, YES, Poisson, NO, Pre-Period Mean, `premean')

***Column 6: State Specific Linear Pre-Trend, Share
reg share_met copyright_post1801 i.state1 i.year pretrend_* if year<=1820, nocon robust
sum share_met if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA8.xls", append ctitle("B6 StatePre Share") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, YES, Poisson, NO, Pre-Period Mean, `premean')


***PANEL C: DURABLE OPERAS ON AMAZON TODAY

***Column 1: Year FE, Count
reg operas_amazon copyright_post1801 copyright i.year if year<=1820, nocon robust
sum operas_amazon if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA8.xls", append ctitle("C1 Year FE Count") keep(copyright_post1801 copyright) nocon dec(3) addtext(State FE, NO, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 2: Year FE, Share
reg share_amazon copyright_post1801 copyright i.year if year<=1820, nocon robust
sum share_amazon if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA8.xls", append ctitle("C2 Year FE Share") keep(copyright_post1801 copyright) nocon dec(3) addtext(State FE, NO, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 3: Linear Pre-Trend for Lombardy & Venetia, Count
reg operas_amazon copyright_post1801 i.state1 i.year linear_pretrend if year<=1820, nocon robust
sum operas_amazon if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA8.xls", append ctitle("C3 LinPre Count") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, YES, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 4: Linear Pre-Trend for Lombardy & Venetia, Share
reg share_amazon copyright_post1801 i.state1 i.year linear_pretrend if year<=1820, nocon robust
sum share_amazon if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA8.xls", append ctitle("C4 LinPre Share") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, YES, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 5: State Specific Linear Pre-Trend, Count
reg operas_amazon copyright_post1801 i.state1 i.year pretrend_* if year<=1820, nocon robust
sum operas_amazon if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA8.xls", append ctitle("C5 StatePre Count") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, YES, Poisson, NO, Pre-Period Mean, `premean')

***Column 6: State Specific Linear Pre-Trend, Share
reg share_amazon copyright_post1801 i.state1 i.year pretrend_* if year<=1820, nocon robust
sum share_amazon if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA8.xls", append ctitle("C6 StatePre Share") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, YES, Poisson, NO, Pre-Period Mean, `premean')


*************************************************************************************************************************************************
****************TABLE A9: De-Trending the Dependent Variable ************************************************************************************
*************************************************************************************************************************************************
local variables annals amazon met

foreach variable of local variables {
reg operas_`variable' year i.state1 i.year if year<=1801 & (state=="lombardy" | state=="venetia")
predict res_`variable' if e(sample), res
replace res_`variable'=0 if missing(res_`variable')
gen pred_operas_`variable'=operas_`variable'-res_`variable'
}


local variables annals amazon met
foreach variable of local variables {
reg share_`variable' year i.state1 i.year if year<=1801 & (state=="lombardy" | state=="venetia")
predict res_share_`variable' if e(sample), res
replace res_share_`variable'=0 if missing(res_share_`variable')
gen pred_share_`variable'=share_`variable'-res_share_`variable'
}

******************HISTORICALLY POPULAR OPERAS IN LOEWENBERG (1978)
***Column 1: Count
reg pred_operas_annals copyright_post1801 i.state1 i.year if year<=1820, nocon robust
sum pred_operas_annals if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA9.xls", replace ctitle("Annals Count") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 2: Share
reg pred_share_annals copyright_post1801 i.state1 i.year if year<=1820, nocon robust
sum pred_share_annals if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA9.xls", append ctitle("Annals Share") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

******************OPERAS PERFORMED AT THE METROPOLITAN, 1900-2014
***Column 3: Count
reg pred_operas_met copyright_post1801 i.state1 i.year if year<=1820, nocon robust
sum pred_operas_met if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA9.xls", append ctitle("Met Count") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 4: Share
reg pred_share_met copyright_post1801 i.state1 i.year if year<=1820, nocon robust
sum pred_share_met if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA9.xls", append ctitle("Met Share") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

******************DURABLE OPERAS ON AMAZON TODAY
***Column 5: Count
reg pred_operas_amazon copyright_post1801 i.state1 i.year if year<=1820, nocon robust
sum pred_operas_amazon if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA9.xls", append ctitle("Amazon Count") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 6: Share
reg pred_share_amazon copyright_post1801 i.state1 i.year if year<=1820, nocon robust
sum pred_share_amazon if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA9.xls", append ctitle("Amazon Share") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')


*************************************************************************************************************************************************
****************TABLE A10: Analysis of Repeat Performance, OLS and Poisson *********************************************************************
*************************************************************************************************************************************************

xtset state1 year

*******OVERALL POPULARITY: AVERAGE NUMBER OF REPEAT PERFORMANCE

***Column 1: OLS, State and Year FE
reg repeated_count copyright_post1801 i.state1 i.year if year<=1820, nocon robust
sum repeated_count if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA10.xls", replace ctitle("RC State+Year FE") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 2: OLS, Year FE
reg repeated_count copyright_post1801 copyright i.year if year<=1820, nocon robust
sum repeated_count if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA10.xls", append ctitle("RC Year FE") keep(copyright_post1801 copyright) nocon dec(3) addtext(State FE, NO, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 3: Poisson
poisson repeated_count copyright_post1801 i.state1 i.year if year<=1820, vce(robust)
margins, dydx(copyright_post1801) post
sum repeated_count if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA10.xls", append ctitle("RC Poisson") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, YES, Pre-Period Mean, `premean')


*******IMMEDIATE HIT: REPEAT PERFORMANCE IN THE YEAR OF THE PREMIERE

***Column 4: OLS, State and Year FE
reg season_count copyright_post1801 i.state1 i.year if year<=1820, nocon robust
sum season_count if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA10.xls", append ctitle("SC State+Year FE") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 5: OLS, Year FE
reg season_count copyright_post1801 copyright i.year if year<=1820, nocon robust
sum season_count if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA10.xls", append ctitle("SC Year FE") keep(copyright_post1801 copyright) nocon dec(3) addtext(State FE, NO, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Pre-Period Mean, `premean')

***Column 6: Poisson
poisson season_count copyright_post1801 i.state1 i.year if year<=1820, vce(robust)  /* FIX: was i.yearif */
margins, dydx(copyright_post1801) post
sum season_count if post1801==0 & year<=1820
local premean : di %5.3f r(mean)
outreg2 using "${output}/tableA10.xls", append ctitle("SC Poisson") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, YES, Pre-Period Mean, `premean')


di _n "=== ALL TABLES EXPORTED TO `outdir' ==="
