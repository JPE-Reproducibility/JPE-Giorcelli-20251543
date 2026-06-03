**********Copyright and Creativity: Evidence from Italian Opera in the Napoleonic Age
**********Authors: Michela Giorcelli (UCLA and NBER) and Petra Moser (NYU-Stern, NBER and CEPR)
**********Date: March 2020
**********Replication of MT25 Table 6: Using Bertrand et al. (2004) Clustering Procedure


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

***Collapse to state × period means
collapse (mean) operas, by(state state1 post1801)

***Define treatment and post variable
gen copyright=(state=="lombardy" | state=="venetia")
gen copyright_post1801=copyright*post1801

***Column 1: State Fixed Effects
reg operas copyright_post post i.state1
outreg2 using "${replication}/MT25_Table6.xls", replace ctitle("Col 1 State FE") keep(copyright_post1801 post) nocon dec(3) addtext(State FE, YES, Year FE, NO, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO)

***Column 2: No State Fixed Effects
reg operas copyright_post post copyright
outreg2 using "${replication}/MT25_Table6.xls", append ctitle("Col 1 No FE") keep(copyright_post post copyright) nocon dec(3) addtext(State FE, NO, Year FE, NO, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO)
