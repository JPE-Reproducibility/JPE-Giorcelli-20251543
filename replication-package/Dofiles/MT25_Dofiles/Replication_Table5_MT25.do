**********Copyright and Creativity: Evidence from Italian Opera in the Napoleonic Age
**********Authors: Michela Giorcelli (UCLA and NBER) and Petra Moser (NYU-Stern, NBER and CEPR)
**********Date: March 2020
**********Replication of MT25 Table 5: Clustering Standard Errors at the State Level


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

***Load data
use "$intermediate_data/operas_1781_1820.dta", clear


***Clustering the Standard Errors at the State Level
xtset state1 year

***Column 1: State and Year Fixed Effects
reg operas copyright_post1801 i.state1 i.year, nocon cluster(state1)
outreg2 using "${replication}/MT25_Table5.xls", replace ctitle("Col 1") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO)


***Column 2: Year Fixed Effects
reg operas copyright_post1801 copyright i.year, nocon  cluster(state1)
outreg2 using "${replication}/MT25_Table5.xls", append ctitle("Col 2") keep(copyright_post1801 copyright) nocon dec(3) addtext(State FE, NO, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO)


***Column 3: State and Year Fixed Effects + Linear Pre-Trend for Lombardy and Venetia
reg operas copyright_post1801 i.state1 i.year linear_pretrend, nocon cluster(state1)
outreg2 using "${replication}/MT25_Table5.xls", append ctitle("Col 3") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, YES, State-Specific Pre-Trend, NO, Poisson, NO)


***Column 4: State and Year Fixed Effects + State Specific Pre-Trend
reg operas copyright_post1801 i.state1 i.year pretrend_modena pretrend_parma pretrend_tuscany pretrend_lombardy pretrend_papal_state pretrend_sardinia pretrend_sicily pretrend_venetia, nocon cluster(state1)
outreg2 using "${replication}/MT25_Table5.xls", append ctitle("Col 4") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, YES, Poisson, NO)


***Column 5: Poisson
poisson operas copyright_post1801 i.state1 i.year, cluster(state1)
margins, dydx(copyright_post1801)  post
outreg2 using "${replication}/MT25_Table5.xls", append ctitle("Col 5 Poisson") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, YES)
