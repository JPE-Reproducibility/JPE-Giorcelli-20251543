**********Copyright and Creativity: Evidence from Italian Opera in the Napoleonic Age
**********Authors: Michela Giorcelli (UCLA and NBER) and Petra Moser (NYU-Stern, NBER and CEPR)
**********Date: March 2020
**********Replication of MT25 Table 4, Panel B: Using City-Level Data to Replicate State-Level Results

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
* Load city panel and create state mapping
* -----------------------------------------------
use "$intermediate_data/city_level_operas_1781_1820.dta", clear

* Map cities to states
gen state = ""
replace state = "d_modena"     if inlist(city, "modena", "reggio_emilia")
replace state = "d_parma"      if inlist(city, "parma", "piacenza")
replace state = "gd_tuscany"   if inlist(city, "florence", "livorno")
replace state = "lombardy"     if inlist(city, "milan", "bergamo", "brescia", "mantua")
replace state = "papal_state"  if inlist(city, "rome", "bologna", "ferrara", "ancona")
replace state = "sardinia"     if inlist(city, "turin", "genoa")
replace state = "two_sicilies" if inlist(city, "naples", "palermo", "messina")
replace state = "venetia"      if inlist(city, "venice", "padova", "verona", "vicenza", "rovigo")

gen state1 = .
replace state1 = 1 if state == "d_modena"
replace state1 = 2 if state == "d_parma"
replace state1 = 3 if state == "gd_tuscany"
replace state1 = 4 if state == "lombardy"
replace state1 = 5 if state == "papal_state"
replace state1 = 6 if state == "sardinia"
replace state1 = 7 if state == "two_sicilies"
replace state1 = 8 if state == "venetia"

assert state != ""

* -----------------------------------------------
* Excluding Milan, Venice or both
* -----------------------------------------------
gen operas_no_milan  = operas_city * (city != "milan")
gen operas_novenice  = operas_city * (city != "venice")
gen opera_nomi_nove  = operas_city * (city != "milan" & city != "venice")

* -----------------------------------------------
* Collapse to state-year
* -----------------------------------------------
collapse (sum) operas = operas_city ///
               operas_no_milan operas_novenice opera_nomi_nove, ///
        by(state state1 year)


* -----------------------------------------------
* Create treatment and post variables
* -----------------------------------------------

gen copyright=(state=="lombardy"| state=="venetia")
gen post1801=(year>=1801)
gen copyright_post1801=copyright*post1801


*********************EXCLUDING VENICE**********************************

***Column 1: OLS
reg operas_novenice copyright_post1801 i.state1 i.year, nocon robust
outreg2 using "${replication}/MT25_Table4.xls", replace ctitle("Col 1 No Venice") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO)

***Column 2: Poisson
poisson operas_novenice copyright_post1801 i.state1 i.year,  vce(robust)
margins, dydx(copyright_post1801)  post
outreg2 using "${replication}/MT25_Table4.xls", append ctitle("Col 2 No Venice") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, YES)


*********************EXCLUDING MILAN************************************

***Column 3: OLS
reg operas_no_milan copyright_post1801 i.state1 i.year, nocon robust
outreg2 using "${replication}/MT25_Table4.xls", append ctitle("Col 3 No Milan") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO)

***Column 4: Poisson
poisson operas_no_milan copyright_post1801 i.state1 i.year, vce(robust)
margins, dydx(copyright_post1801)  post
outreg2 using "${replication}/MT25_Table4.xls", append ctitle("Col 4 No Milan") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, YES)

*********************EXCLUDING MILAN AND VENICE**************************

***Column 5: OLS
reg opera_nomi_nove copyright_post1801 i.state1 i.year, nocon robust
outreg2 using "${replication}/MT25_Table4.xls", append ctitle("Col 5 No Milan-Venice") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO)

***Column 6: Poisson
poisson opera_nomi_nove copyright_post1801 i.state1 i.year, vce(robust)
margins, dydx(copyright_post1801)  post
outreg2 using "${replication}/MT25_Table4.xls", append ctitle("Col 6 No Milan-Venice") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, YES)

*********************EXCLUDING VENETIA**********************************
preserve

drop if state=="venetia"

***Column 7: OLS
reg operas copyright_post1801 i.state1 i.year, nocon robust
outreg2 using "${replication}/MT25_Table4.xls", append ctitle("Col 7 No Venetia") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, NO)

***Column 8: Poisson
poisson operas copyright_post1801 i.state1 i.year, vce(robust)
margins, dydx(copyright_post1801)  post
outreg2 using "${replication}/MT25_Table4.xls", append ctitle("Col 8 No Venetia") keep(copyright_post1801) nocon dec(3) addtext(State FE, YES, Year FE, YES, Linear Pre-Trend, NO, State-Specific Pre-Trend, NO, Poisson, YES)

restore
