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


***Load raw data
use "${data}/operas_raw_data.dta", clear

keep if year >= 1781 & year <= 1820

***Keep only observations with theater information
keep if theater_info==1

gen one=1

collapse (sum) operas_city=one operas_city_annals=annals ///
               operas_city_amazon=amazon operas_city_met=met, by(city year)

tempfile A
save `A'			  
			   
***Load theater data
use "${data}/theater_raw_data.dta", clear

gen one = 1
collapse (sum) operas_city=one operas_city_annals operas_city_amazon operas_city_met, by(city year)

***Append raw data and theaters data
append using `A'

collapse (sum) operas_city operas_city_annals operas_city_amazon operas_city_met, by(city year)

***Filling with zero to make the panel balanced 
fillin city year
replace operas_city=0 if _fillin==1
replace operas_city_amazon=0 if _fillin==1
replace operas_city_annals=0 if _fillin==1
replace operas_city_met=0 if _fillin==1

***Map city to state
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

***Gen theater variables
gen two_theater=(city=="milan"  | city=="venice" | city=="rome" | city=="naples" | city=="turin" | city=="ferrara" | city=="florence")
gen one_theater=(two_theater==0)

***Gen treatment and post variables
gen copyright=(state=="lombardy" | state=="venetia")
gen post1801=(year>=1801)
gen copyright_post1801=copyright*post1801
encode city, gen(city1)

***Run regressions
xtset city1 year
***********ALL OPERAS
***Column 1: One Theater
reg operas_city copyright_post1801 i.city1 i.year if one_theater==1, nocon robust
sum operas_city if year<=1800 & one_theater==1
local premean : di %5.3f r(mean)
outreg2 using "${output}/table8.xls", replace ctitle("Col 1 All Operas") keep(copyright_post1801) nocon dec(3) addtext(City FE, YES, Year FE, YES, Theater, 1, Pre-Period Mean, `premean')

***Column 2: > One Theater
reg operas_city  copyright_post1801 i.city1 i.year if two_theater==1, nocon robust
sum operas_city if year<=1800 & two_theater==1
local premean : di %5.3f r(mean)
outreg2 using "${output}/table8.xls", append ctitle("Col 2 All Operas") keep(copyright_post1801) nocon dec(3) addtext(City FE, YES, Year FE, YES, Theater, 2, Pre-Period Mean, `premean')

****HISTORICALLY POPULAR OPERAS IN LOEWENBERG (1978)
***Column 3: One Theater
reg operas_city_annals copyright_post1801 i.city1 i.year if one_theater==1, nocon robust
sum operas_city_annals if year<=1800 & one_theater==1
local premean : di %5.3f r(mean)
outreg2 using "${output}/table8.xls", append ctitle("Col 3 Annals") keep(copyright_post1801) nocon dec(3) addtext(City FE, YES, Year FE, YES, Theater, 1, Pre-Period Mean, `premean')

***Column 4: > One Theater
reg operas_city_annals  copyright_post1801 i.city1 i.year if two_theater==1, nocon robust
sum operas_city_annals if year<=1800 & two_theater==1
local premean : di %5.3f r(mean)
outreg2 using "${output}/table8.xls", append ctitle("Col 4 Annals") keep(copyright_post1801) nocon dec(3) addtext(City FE, YES, Year FE, YES, Theater, 2, Pre-Period Mean, `premean')

****OPERAS PERFORMED AT THE METROPOLITAN, 1900-2014
***Column 5: One Theater
reg operas_city_amazon copyright_post1801 i.city1 i.year if one_theater==1, nocon robust
sum operas_city_amazon if year<=1800 & one_theater==1
local premean : di %5.3f r(mean)
outreg2 using "${output}/table8.xls", append ctitle("Col 5 Met") keep(copyright_post1801) nocon dec(3) addtext(City FE, YES, Year FE, YES, Theater, 1, Pre-Period Mean, `premean')

***Column 6: > One Theater
reg operas_city_amazon copyright_post1801 i.city1 i.year if two_theater==1, nocon robust
sum operas_city_amazon if year<=1800 & two_theater==1
local premean : di %5.3f r(mean)
outreg2 using "${output}/table8.xls", append ctitle("Col 6 Met") keep(copyright_post1801) nocon dec(3) addtext(City FE, YES, Year FE, YES, Theater, 2, Pre-Period Mean, `premean')

****DURABLE OPERAS ON AMAZON TODAY
***Column 7: One Theater
reg operas_city_met copyright_post1801 i.city1 i.year if one_theater==1, nocon robust
sum operas_city_met if year<=1800 & one_theater==1
local premean : di %5.3f r(mean)
outreg2 using "${output}/table8.xls", append ctitle("Col 7 Amazon") keep(copyright_post1801) nocon dec(3) addtext(City FE, YES, Year FE, YES, Theater, 1, Pre-Period Mean, `premean')

***Column 8: > One Theater
reg operas_city_met copyright_post1801 i.city1 i.year if two_theater==1, nocon robust
sum operas_city_met if year<=1800 & two_theater==1
local premean : di %5.3f r(mean)
outreg2 using "${output}/table8.xls", append ctitle("Col 8 Amazon") keep(copyright_post1801) nocon dec(3) addtext(City FE, YES, Year FE, YES, Theater, 2, Pre-Period Mean, `premean')
