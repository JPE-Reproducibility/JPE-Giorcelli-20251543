**********Copyright and Creativity: Evidence from Italian Opera in the Napoleonic Age
**********Authors: Michela Giorcelli (UCLA and NBER) and Petra Moser (NYU-Stern, NBER and CEPR)
**********Date: March 2020
**********Using data from MT25 Table B1

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

***Putting a zero for state-year listed in MT25 Table B1
replace operas=0 if (state=="d_modena" & year==1781) | (state=="d_modena" & year==1787) | (state=="d_modena" & year==1788) | (state=="d_parma" & year==1788) | (state=="d_modena" & year==1789) | (state=="d_parma" & year==1789) | (state=="d_modena" & year==1790) | (state=="d_modena" & year==1791) | (state=="d_modena" & year==1792) | (state=="d_modena" & year==1793) | (state=="d_modena" & year==1795) | (state=="d_parma" & year==1795) | (state=="sardinia" & year==1795) | (state=="d_modena" & year==1796) | (state=="d_modena" & year==1797) | (state=="d_modena" & year==1799) | (state=="d_modena" & year==1800) | (state=="d_modena" & year==1801) | (state=="d_modena" & year==1803) | (state=="d_parma" & year==1803) | (state=="d_modena" & year==1804) | (state=="d_modena" & year==1805) | (state=="d_parma" & year==1805) | (state=="d_modena" & year==1806) | (state=="d_parma" & year==1806) | (state=="d_parma" & year==1807) | (state=="d_modena" & year==1807) | (state=="sardinia" & year==1807) | (state=="d_modena" & year==1808) | (state=="d_modena" & year==1809) |  (state=="d_modena" & year==1810) | (state=="d_parma" & year==1810) | (state=="d_modena" & year==1811) | (state=="d_modena" & year==1812) | (state=="d_modena" & year==1813) | (state=="d_modena" & year==1814) | (state=="d_modena" & year==1815) | (state=="d_modena" & year==1816) | (state=="d_parma" & year==1816) |  (state=="d_modena" & year==1817) | (state=="d_parma" & year==1817) | (state=="d_parma" & year==1818) | (state=="d_modena" & year==1819) | (state=="d_parma" & year==1819) | (state=="d_parma" & year==1820)  | (state=="gd_tuscany" & year==1820) 


***Run regressions

xtset state1 year

***Column 1: State and Year Fixed Effects
reg operas copyright_post1801 i.state1 i.year, nocon robust
outreg2 using "${replication}/MT25_TableB1.xls", dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State Specific Pre-Trend, NO) keep(copyright_post1801) replace

***Column 2: Year Fixed Effects
reg operas copyright_post1801 copyright i.year, nocon robust
outreg2 using "${replication}/MT25_TableB1.xls", dec(3) addtext(State FE, NO, Year FE, YES, Linear Pre-Trend, NO, State Specific Pre-Trend, NO) keep(copyright_post1801 copyright) append

***Column 3: State and Year Fixed Effects + Linear Pre-Trend for Lombardy and Venetia
reg operas copyright_post1801 i.state1 i.year linear_pretrend, nocon robust
outreg2 using "${replication}/MT25_TableB1.xls", dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, YES, State Specific Pre-Trend, NO) keep(copyright_post1801) append

***Column 4: State and Year Fixed Effects + State Specific Pre-Trend
reg operas copyright_post1801 i.state1 i.year pretrend_modena pretrend_parma pretrend_tuscany pretrend_lombardy pretrend_papal_state pretrend_sardinia pretrend_sicily pretrend_venetia, nocon robust
outreg2 using "${replication}/MT25_TableB1.xls", dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State Specific Pre-Trend, YES) keep(copyright_post1801) append

***Column 5: Poisson
poisson operas copyright_post1801 i.state1 i.year, vce(robust)
margins, dydx(copyright_post1801) post
outreg2 using "${replication}/MT25_TableB1.xls", dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State Specific Pre-Trend, NO) keep(copyright_post1801) append


***Excluding Modena and Parma
***Load data
use "$intermediate_data/operas_1781_1820.dta", clear

***Drop Modena and Parma
drop if state=="d_modena" | state=="d_parma"

***Run regressions

xtset state1 year

***Column 1: State and Year Fixed Effects
reg operas copyright_post1801 i.state1 i.year, nocon robust

outreg2 using "${replication}/MT25_TableB1_Excluding_Modena_Parma.xls", dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State Specific Pre-Trend, NO) keep(copyright_post1801) replace

***Column 2: Year Fixed Effects
reg operas copyright_post1801 copyright i.year, nocon robust

outreg2 using "${replication}/MT25_TableB1_Excluding_Modena_Parma.xls", dec(3) addtext(State FE, NO, Year FE, YES, Linear Pre-Trend, NO, State Specific Pre-Trend, NO) keep(copyright_post1801 copyright) append

***Column 3: State and Year Fixed Effects + Linear Pre-Trend for Lombardy and Venetia
reg operas copyright_post1801 i.state1 i.year linear_pretrend, nocon robust

outreg2 using "${replication}/MT25_TableB1_Excluding_Modena_Parma.xls", dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, YES, State Specific Pre-Trend, NO) keep(copyright_post1801) append

***Column 4: State and Year Fixed Effects + State Specific Pre-Trend
reg operas copyright_post1801 i.state1 i.year pretrend_modena pretrend_parma pretrend_tuscany pretrend_lombardy pretrend_papal_state pretrend_sardinia pretrend_sicily pretrend_venetia, nocon robust

outreg2 using "${replication}/MT25_TableB1_Excluding_Modena_Parma.xls", dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State Specific Pre-Trend, YES) keep(copyright_post1801) append

***Column 5: Poisson
poisson operas copyright_post1801 i.state1 i.year, vce(robust)
margins, dydx(copyright_post1801) post

outreg2 using "${replication}/MT25_TableB1_Excluding_Modena_Parma.xls", dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State Specific Pre-Trend, NO) keep(copyright_post1801) append


