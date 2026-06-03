**********Copyright and Creativity: Evidence from Italian Opera in the Napoleonic Age
**********Authors: Michela Giorcelli (UCLA and NBER) and Petra Moser (NYU-Stern, NBER and CEPR)
**********Date: March 2020
**********Replication of GM20 Table 3, from city and composer level datasets

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


* -----------------------------------------------
* PANEL A: STATE-LEVEL DATASET
* -----------------------------------------------

use "$intermediate_data/operas_1781_1820.dta", clear

xtset state1 year

***Column 1: All operas
reg operas copyright_post1801 i.state1 i.year, nocon robust
outreg2 using "${replication}/GM20_Table3.xls", replace ctitle("Col 1") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Dataset, State-Year)


***Column 2: Annals
reg operas_annals copyright_post1801 i.state1 i.year, nocon robust
outreg2 using "${replication}/GM20_Table3.xls", append ctitle("Col 2") keep(copyright_post1801 copyright) nocon dec(3) addtext(State FE, NO, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Dataset, State-Year)


***Column 3: Met
reg operas_met copyright_post1801 i.state1 i.year, nocon robust
outreg2 using "${replication}/GM20_Table3.xls", append ctitle("Col 3") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, YES, State-Specific Pre-Trend, NO, Poisson, NO, Dataset, State-Year)


***Column 4: Amazon
reg operas_amazon copyright_post1801 i.state1 i.year, nocon robust
outreg2 using "${replication}/GM20_Table3.xls", append ctitle("Col 4") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, YES, Poisson, NO, Dataset, State-Year)


* -----------------------------------------------
* PANEL B: CITY-LEVEL DATASET
* -----------------------------------------------

use "$intermediate_data/city_level_operas_1781_1820.dta", clear

***Add state variable 
gen state1 = .
gen state = ""
replace state1 = 1 if inlist(city, "modena", "reggio_emilia")
replace state = "d_modena" if state1 == 1
replace state1 = 2 if inlist(city, "parma", "piacenza")
replace state = "d_parma" if state1 == 2
replace state1 = 3 if inlist(city, "florence", "livorno")
replace state = "gd_tuscany" if state1 == 3
replace state1 = 4 if inlist(city, "milan", "bergamo", "brescia", "mantua")
replace state = "lombardy" if state1 == 4
replace state1 = 5 if inlist(city, "rome", "bologna", "ferrara", "ancona")
replace state = "papal_state" if state1 == 5
replace state1 = 6 if inlist(city, "turin", "genoa")
replace state = "sardinia" if state1 == 6
replace state1 = 7 if inlist(city, "naples", "palermo", "messina")
replace state = "two_sicilies" if state1 == 7
replace state1 = 8 if inlist(city, "venice", "padova", "verona", "vicenza", "rovigo")
replace state = "venetia" if state1 == 8

collapse (sum) operas=operas_city operas_annals=operas_city_annals ///
    operas_amazon=operas_city_amazon operas_met=operas_city_met, ///
    by(state1 year)

gen copyright = inlist(state1, 4, 8)
gen post1801 = (year >= 1801)
gen copyright_post1801 = copyright * post1801

***Run regressions
xtset state1 year

***Column 1: All operas
reg operas copyright_post1801 i.state1 i.year, nocon robust
outreg2 using "${replication}/GM20_Table3.xls", append ctitle("Col 1") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Dataset, City-Year)


***Column 2: Annals
reg operas_annals copyright_post1801 i.state1 i.year, nocon robust
outreg2 using "${replication}/GM20_Table3.xls", append ctitle("Col 2") keep(copyright_post1801 copyright) nocon dec(3) addtext(State FE, NO, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Dataset, City-Year)


***Column 3: Met
reg operas_met copyright_post1801 i.state1 i.year, nocon robust
outreg2 using "${replication}/GM20_Table3.xls", append ctitle("Col 3") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, YES, State-Specific Pre-Trend, NO, Poisson, NO, Dataset, City-Year)


***Column 4: Amazon
reg operas_amazon copyright_post1801 i.state1 i.year, nocon robust
outreg2 using "${replication}/GM20_Table3.xls", append ctitle("Col 4") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, YES, Poisson, NO, Dataset, City-Yearr)



* -----------------------------------------------
* PANEL C: COMPOSER-LEVEL DATASET
* -----------------------------------------------

use "$intermediate_data/composer_level_data.dta", clear

collapse (sum) operas=comp_operas operas_annals=annals ///
    operas_met=met operas_amazon=amazon, by(state1 year)

gen copyright = inlist(state1, 4, 8)
gen post1801 = (year >= 1801)
gen copyright_post1801 = copyright * post1801

* Fill to balanced panel (8 states × 40 years)
fillin state1 year
replace operas = 0 if _fillin == 1
replace operas_annals = 0 if _fillin == 1
replace operas_met = 0 if _fillin == 1
replace operas_amazon = 0 if _fillin == 1
drop _fillin


***Run regressions
xtset state1 year

***Column 1: All operas
reg operas copyright_post1801 i.state1 i.year, nocon robust
outreg2 using "${replication}/GM20_Table3.xls", append ctitle("Col 1") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Dataset, Composer-Year)


***Column 2: Annals
reg operas_annals copyright_post1801 i.state1 i.year, nocon robust
outreg2 using "${replication}/GM20_Table3.xls", append ctitle("Col 2") keep(copyright_post1801 copyright) nocon dec(3) addtext(State FE, NO, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO, Dataset, Composer-Year)


***Column 3: Met
reg operas_met copyright_post1801 i.state1 i.year, nocon robust
outreg2 using "${replication}/GM20_Table3.xls", append ctitle("Col 3") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, YES, State-Specific Pre-Trend, NO, Poisson, NO, Dataset, Composer-Year)


***Column 4: Amazon
reg operas_amazon copyright_post1801 i.state1 i.year, nocon robust
outreg2 using "${replication}/GM20_Table3.xls", append ctitle("Col 4") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, YES, Poisson, NO, Dataset, Composer-Yearr)


