**********Copyright and Creativity: Evidence from Italian Opera in the Napoleonic Age
**********Authors: Michela Giorcelli (UCLA and NBER) and Petra Moser (NYU-Stern, NBER and CEPR)
**********Date: March 2020
**********Estimating Pre-Trends

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

use "$intermediate_data/operas_1781_1820.dta", clear

xtset state1 year

***Generate linear pre-trend for Lombardy and Venetia, with no discontinuitity
gen time = year
gen treat = year >= 1801
gen pretrend_lv = (year - 1801) * (year < 1801) * copyright

***Run regressions
***Column 1: GM20 Pre_trend
reg operas copyright_post1801 linear_pretrend i.state1 i.year, noc robus
outreg2 using "${replication}/Pretrends.xls", dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend MG2020, YES, Linear Pre-Trend No Jumps, NO, State Specific Pre-Trend, NO) keep(copyright_post1801 linear_pretrend) replace

***Column 2: No-Discontinutity Pre_trend
reg operas copyright_post1801 pretrend_lv i.state1 i.year, noc robus
outreg2 using "${replication}/Pretrends.xls", dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend MG2020, No, Linear Pre-Trend No Jumps, YES, State Specific Pre-Trend, NO) keep(copyright_post1801 pretrend_lv) append


***Generate linear pre-trend for other states, GM2020
*bys state1: gen linear_pretrend2=_n if year<1801 & (state1~=4|state1~=8)
*replace linear_pretrend2=0 if linear_pretrend2==.

***Generate linear pre-trend for states without copyright, with no discontinuitity
levelsof state, local(state)
foreach s of local state {
    gen pretrend_nj_`s' = (year - 1801) * (year < 1801) if state=="`s'"
	replace pretrend_nj_`s'=0 if pretrend_nj_`s'==.
}

***Run regressions 

***Column 3: GM20 Pre_trend
reg operas copyright_post1801 pretrend_modena pretrend_parma pretrend_tuscany pretrend_lombardy pretrend_papal_state pretrend_sardinia pretrend_sicily pretrend_venetia i.state1 i.year, noc robus
outreg2 using "${replication}/Pretrends.xls", dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend MG2020, NO, Linear Pre-Trend No Jumps, NO, State Specific Pre-Trend, YES,  State Specific Pre-Trend No Jumps, NO) keep(copyright_post1801 pretrend_modena pretrend_parma pretrend_tuscany pretrend_lombardy pretrend_papal_state pretrend_sardinia pretrend_sicily pretrend_venetia) append

***Column 4: No-Discontinutity Pre_trend
reg operas copyright_post1801 pretrend_nj_d_modena pretrend_nj_d_parma pretrend_nj_gd_tuscany pretrend_nj_lombardy pretrend_nj_papal_state pretrend_nj_sardinia pretrend_nj_two_sicilies pretrend_nj_venetia i.state1 i.year, noc robust
outreg2 using "${replication}/Pretrends.xls", dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend MG2020, No, Linear Pre-Trend No Jumps, YES, State Specific Pre-Trend, NO, State Specific Pre-Trend No Jumps, YEs) keep(copyright_post1801 pretrend_nj_d_modena pretrend_nj_d_parma pretrend_nj_gd_tuscany pretrend_nj_lombardy pretrend_nj_papal_state pretrend_nj_sardinia pretrend_nj_two_sicilies pretrend_nj_venetia) append



