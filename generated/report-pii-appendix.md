## Appendix: Detailed PII Detection Results

*Generated on 2026-06-03 10:18:59*

This appendix lists all detected instances of potential personally identifiable information (PII) in the project files. Each entry shows the matched PII terms and, for data files, sample values to help verify whether the flagged content is indeed sensitive.

### Data Files

**/replication-package/Intermediate Data/city_level_operas_1781_1820.dta**

- Variable: `city` (label: *place*)
  - Matched terms: city
  - Sample values: ancona, bergamo, bologna
- Variable: `city1` (label: *place*)
  - Matched terms: city
  - Sample values: 1.0, 2.0, 3.0
- Variable: `operas_city`
  - Matched terms: city
  - Sample values: 0.0, 1.0, 2.0
- Variable: `operas_city_amazon`
  - Matched terms: city
  - Sample values: 0.0, 1.0, 2.0
- Variable: `operas_city_annals`
  - Matched terms: city
  - Sample values: 0.0, 1.0, 2.0
- Variable: `operas_city_met`
  - Matched terms: city
  - Sample values: 0.0, 1.0, 2.0

**/replication-package/Raw Data/additional_operas.dta**

- Variable: `composer_name` (label: *(first) composer_name*)
  - Matched terms: name
  - Sample values: andreozzi, brambilla, carafa

**/replication-package/Raw Data/composers_return_year.dta**

- Variable: `composer_name`
  - Matched terms: name
  - Sample values: cimarosa, mugnes, motte

**/replication-package/Raw Data/operas_raw_data.dta**

- Variable: `city`
  - Matched terms: city
  - Sample values: genoa, milan, rome
- Variable: `composer_name`
  - Matched terms: name
  - Sample values: abadia, albertazzi, andreozzi
- Variable: `season_repeat`
  - Matched terms: son
  - Sample values: 1.0, 14.0, 3.0

**/replication-package/Raw Data/theater_raw_data.dta**

- Variable: `city` (label: *place*)
  - Matched terms: city
  - Sample values: ancona, bergamo, brescia
- Variable: `operas_city`
  - Matched terms: city
  - Sample values: 1.0, 2.0, 3.0
- Variable: `operas_city_amazon`
  - Matched terms: city
  - Sample values: 0.0, 1.0, 2.0
- Variable: `operas_city_annals`
  - Matched terms: city
  - Sample values: 1.0, 0.0, 2.0
- Variable: `operas_city_met`
  - Matched terms: city
  - Sample values: 1.0, 0.0, 2.0

### Code Files

**/replication-package/Dofiles/GM20_Dofiles/GM20_city_level_analysis.do**

- Line 33: city
  ```
  collapse (sum) operas_city=one operas_city_annals=annals ///
  ```
- Line 34: city
  ```
  operas_city_amazon=amazon operas_city_met=met, by(city year)
  ```
- Line 43: city
  ```
  collapse (sum) operas_city=one operas_city_annals operas_city_amazon operas_city_met, by(city year)
  ```
- Line 48: city
  ```
  collapse (sum) operas_city operas_city_annals operas_city_amazon operas_city_met, by(city year)
  ```
- Line 51: city
  ```
  fillin city year
  ```
- Line 52: city
  ```
  replace operas_city=0 if _fillin==1
  ```
- Line 53: city
  ```
  replace operas_city_amazon=0 if _fillin==1
  ```
- Line 54: city
  ```
  replace operas_city_annals=0 if _fillin==1
  ```
- Line 55: city
  ```
  replace operas_city_met=0 if _fillin==1
  ```
- Line 57: city
  ```
  ***Map city to state
  ```
- Line 60: city
  ```
  replace state1 = 1 if inlist(city, "modena", "reggio_emilia")
  ```
- Line 62: city
  ```
  replace state1 = 2 if inlist(city, "parma", "piacenza")
  ```
- Line 64: city
  ```
  replace state1 = 3 if inlist(city, "florence", "livorno")
  ```
- Line 66: city
  ```
  replace state1 = 4 if inlist(city, "milan", "bergamo", "brescia", "mantua")
  ```
- Line 68: city
  ```
  replace state1 = 5 if inlist(city, "rome", "bologna", "ferrara", "ancona")
  ```
- Line 70: city
  ```
  replace state1 = 6 if inlist(city, "turin", "genoa")
  ```
- Line 72: city
  ```
  replace state1 = 7 if inlist(city, "naples", "palermo", "messina")
  ```
- Line 74: city
  ```
  replace state1 = 8 if inlist(city, "venice", "padova", "verona", "vicenza", "rovigo")
  ```
- Line 78: city
  ```
  gen two_theater=(city=="milan"  | city=="venice" | city=="rome" | city=="naples" | city=="turin" | c
  ```
- Line 85: city
  ```
  encode city, gen(city1)
  ```
- Line 88: city
  ```
  xtset city1 year
  ```
- Line 91: city
  ```
  reg operas_city copyright_post1801 i.city1 i.year if one_theater==1, nocon robust
  ```
- Line 92: city
  ```
  sum operas_city if year<=1800 & one_theater==1
  ```
- Line 93: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 97: city
  ```
  reg operas_city  copyright_post1801 i.city1 i.year if two_theater==1, nocon robust
  ```
- Line 98: city
  ```
  sum operas_city if year<=1800 & two_theater==1
  ```
- Line 99: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 104: city
  ```
  reg operas_city_annals copyright_post1801 i.city1 i.year if one_theater==1, nocon robust
  ```
- Line 105: city
  ```
  sum operas_city_annals if year<=1800 & one_theater==1
  ```
- Line 106: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 110: city
  ```
  reg operas_city_annals  copyright_post1801 i.city1 i.year if two_theater==1, nocon robust
  ```
- Line 111: city
  ```
  sum operas_city_annals if year<=1800 & two_theater==1
  ```
- Line 112: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 117: city
  ```
  reg operas_city_amazon copyright_post1801 i.city1 i.year if one_theater==1, nocon robust
  ```
- Line 118: city
  ```
  sum operas_city_amazon if year<=1800 & one_theater==1
  ```
- Line 119: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 123: city
  ```
  reg operas_city_amazon copyright_post1801 i.city1 i.year if two_theater==1, nocon robust
  ```
- Line 124: city
  ```
  sum operas_city_amazon if year<=1800 & two_theater==1
  ```
- Line 125: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 130: city
  ```
  reg operas_city_met copyright_post1801 i.city1 i.year if one_theater==1, nocon robust
  ```
- Line 131: city
  ```
  sum operas_city_met if year<=1800 & one_theater==1
  ```
- Line 132: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 136: city
  ```
  reg operas_city_met copyright_post1801 i.city1 i.year if two_theater==1, nocon robust
  ```
- Line 137: city
  ```
  sum operas_city_met if year<=1800 & two_theater==1
  ```
- Line 138: loc
  ```
  local premean : di %5.3f r(mean)
  ```

**/replication-package/Dofiles/GM20_Dofiles/GM20_composer_level_analysis.do**

- Line 40: name
  ```
  keep composer_id composer_name state state1 year title annals amazon met
  ```
- Line 48: name
  ```
  keep composer_id composer_name state state1 year title annals amazon met
  ```
- Line 54: name
  ```
  collapse (sum) comp_operas=c annals met amazon (first) composer_name state, ///
  ```
- Line 84: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 92: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 98: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 106: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 112: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 120: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 126: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 134: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 142: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 148: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 156: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 162: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 170: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 176: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 185: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 193: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 199: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 207: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 213: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 221: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 227: loc
  ```
  local premean : di %5.3f r(mean)
  ```

**/replication-package/Dofiles/GM20_Dofiles/GM20_state_level_analysis.do**

- Line 43: city
  ```
  gen _temp = (state == "lombardy" & city != "milan")
  ```
- Line 52: city
  ```
  gen _temp = (state == "venetia" & city != "venice")
  ```
- Line 70: son
  ```
  bys state year:  egen season_count = mean(season_repeat)
  ```
- Line 76: son
  ```
  keep operas operas_annals operas_amazon operas_met state year operas_no_milan operas_novenice opera_
  ```
- Line 96: loc
  ```
  local states d_modena d_parma gd_tuscany lombardy papal_state sardinia two_sicilies venetia
  ```
- Line 98: loc
  ```
  foreach s of local states {
  ```
- Line 106: loc
  ```
  local variables annals amazon met
  ```
- Line 107: loc
  ```
  foreach variable of local variables {
  ```
- Line 131: loc
  ```
  if "`var'" == "operas" local label "New Operas"
  ```
- Line 132: loc
  ```
  if "`var'" == "operas_annals" local label "Annals (Loewenberg)"
  ```
- Line 133: loc
  ```
  if "`var'" == "operas_met" local label "Met Opera"
  ```
- Line 134: loc
  ```
  if "`var'" == "operas_amazon" local label "Amazon"
  ```
- Line 137: loc
  ```
  local c_all = r(mean)
  ```
- Line 139: loc
  ```
  local nc_all = r(mean)
  ```
- Line 140: loc
  ```
  local d_all = `c_all' - `nc_all'
  ```
- Line 143: loc
  ```
  local c_pre = r(mean)
  ```
- Line 145: loc
  ```
  local nc_pre = r(mean)
  ```
- Line 146: loc
  ```
  local d_pre = `c_pre' - `nc_pre'
  ```
- Line 149: loc
  ```
  local c_post = r(mean)
  ```
- Line 151: loc
  ```
  local nc_post = r(mean)
  ```
- Line 152: loc
  ```
  local d_post = `c_post' - `nc_post'
  ```
- Line 167: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 173: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 179: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 185: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 188: son
  ```
  ***Column 5: Poisson
  ```
- Line 189: son
  ```
  poisson operas copyright_post1801 i.state1 i.year if year<=1820, vce(robust)
  ```
- Line 192: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 204: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 210: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 217: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 223: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 230: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 236: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 264: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 270: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 276: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 282: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 302: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 308: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 314: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 320: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 323: son
  ```
  ***Column 5: Poisson
  ```
- Line 324: son
  ```
  poisson pred_operas copyright_post1801 i.state1 i.year if year<=1820, vce(robust)
  ```
- Line 327: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 339: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 342: son
  ```
  ***Column 2: Poisson, Excluding Venice
  ```
- Line 343: son
  ```
  poisson operas_novenice copyright_post1801 i.state1 i.year if year<=1820, vce(robust)
  ```
- Line 346: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 352: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 355: son
  ```
  ***Column 4: Poisson, Excluding Milan
  ```
- Line 356: son
  ```
  poisson operas_no_milan copyright_post1801 i.state1 i.year if year<=1820, vce(robust)
  ```
- Line 359: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 365: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 368: son
  ```
  ***Column 6: Poisson, Excluding Milan and Venice
  ```
- Line 369: son
  ```
  poisson opera_nomi_nove copyright_post1801 i.state1 i.year if year<=1820, vce(robust)
  ```
- Line 372: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 378: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 381: son
  ```
  ***Column 8: Poisson, Excluding Venetia
  ```
- Line 382: son
  ```
  poisson operas copyright_post1801 i.state1 i.year if state~="venetia" & year<=1820, vce(robust)
  ```
- Line 385: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 397: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 403: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 409: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 415: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 418: son
  ```
  ***Column 5: Poisson
  ```
- Line 419: son
  ```
  poisson operas copyright_post1801 years_occupation i.state1 i.year if year<=1820, vce(robust)
  ```
- Line 422: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 434: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 440: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 446: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 452: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 458: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 464: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 473: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 479: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 485: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 491: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 497: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 503: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 512: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 518: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 524: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 530: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 536: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 542: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 549: loc
  ```
  local variables annals amazon met
  ```
- Line 551: loc
  ```
  foreach variable of local variables {
  ```
- Line 559: loc
  ```
  local variables annals amazon met
  ```
- Line 560: loc
  ```
  foreach variable of local variables {
  ```
- Line 571: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 577: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 584: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 590: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 597: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 603: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 608: son
  ```
  ****************TABLE A10: Analysis of Repeat Performance, OLS and Poisson *************************
  ```
- Line 618: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 624: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 627: son
  ```
  ***Column 3: Poisson
  ```
- Line 628: son
  ```
  poisson repeated_count copyright_post1801 i.state1 i.year if year<=1820, vce(robust)
  ```
- Line 631: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 638: son
  ```
  reg season_count copyright_post1801 i.state1 i.year if year<=1820, nocon robust
  ```
- Line 639: son
  ```
  sum season_count if post1801==0 & year<=1820
  ```
- Line 640: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 644: son
  ```
  reg season_count copyright_post1801 copyright i.year if year<=1820, nocon robust
  ```
- Line 645: son
  ```
  sum season_count if post1801==0 & year<=1820
  ```
- Line 646: loc
  ```
  local premean : di %5.3f r(mean)
  ```
- Line 649: son
  ```
  ***Column 6: Poisson
  ```
- Line 650: son
  ```
  poisson season_count copyright_post1801 i.state1 i.year if year<=1820, vce(robust)  /* FIX: was i.ye
  ```
- Line 652: son
  ```
  sum season_count if post1801==0 & year<=1820
  ```
- Line 653: loc
  ```
  local premean : di %5.3f r(mean)
  ```

**/replication-package/Dofiles/MT25_Dofiles/Replication_PreTrends.do**

- Line 46: loc
  ```
  levelsof state, local(state)
  ```
- Line 47: loc
  ```
  foreach s of local state {
  ```

**/replication-package/Dofiles/MT25_Dofiles/Replication_Table3_GM20.do**

- Line 52: city
  ```
  * PANEL B: CITY-LEVEL DATASET
  ```
- Line 55: city
  ```
  use "$intermediate_data/city_level_operas_1781_1820.dta", clear
  ```
- Line 60: city
  ```
  replace state1 = 1 if inlist(city, "modena", "reggio_emilia")
  ```
- Line 62: city
  ```
  replace state1 = 2 if inlist(city, "parma", "piacenza")
  ```
- Line 64: city
  ```
  replace state1 = 3 if inlist(city, "florence", "livorno")
  ```
- Line 66: city
  ```
  replace state1 = 4 if inlist(city, "milan", "bergamo", "brescia", "mantua")
  ```
- Line 68: city
  ```
  replace state1 = 5 if inlist(city, "rome", "bologna", "ferrara", "ancona")
  ```
- Line 70: city
  ```
  replace state1 = 6 if inlist(city, "turin", "genoa")
  ```
- Line 72: city
  ```
  replace state1 = 7 if inlist(city, "naples", "palermo", "messina")
  ```
- Line 74: city
  ```
  replace state1 = 8 if inlist(city, "venice", "padova", "verona", "vicenza", "rovigo")
  ```
- Line 77: city
  ```
  collapse (sum) operas=operas_city operas_annals=operas_city_annals ///
  ```
- Line 78: city
  ```
  operas_amazon=operas_city_amazon operas_met=operas_city_met, ///
  ```

**/replication-package/Dofiles/MT25_Dofiles/Replication_Table4_MT25.do**

- Line 4: city
  ```
  **********Replication of MT25 Table 4, Panel B: Using City-Level Data to Replicate State-Level Resul
  ```
- Line 23: city
  ```
  * Load city panel and create state mapping
  ```
- Line 25: city
  ```
  use "$intermediate_data/city_level_operas_1781_1820.dta", clear
  ```
- Line 29: city
  ```
  replace state = "d_modena"     if inlist(city, "modena", "reggio_emilia")
  ```
- Line 30: city
  ```
  replace state = "d_parma"      if inlist(city, "parma", "piacenza")
  ```
- Line 31: city
  ```
  replace state = "gd_tuscany"   if inlist(city, "florence", "livorno")
  ```
- Line 32: city
  ```
  replace state = "lombardy"     if inlist(city, "milan", "bergamo", "brescia", "mantua")
  ```
- Line 33: city
  ```
  replace state = "papal_state"  if inlist(city, "rome", "bologna", "ferrara", "ancona")
  ```
- Line 34: city
  ```
  replace state = "sardinia"     if inlist(city, "turin", "genoa")
  ```
- Line 35: city
  ```
  replace state = "two_sicilies" if inlist(city, "naples", "palermo", "messina")
  ```
- Line 36: city
  ```
  replace state = "venetia"      if inlist(city, "venice", "padova", "verona", "vicenza", "rovigo")
  ```
- Line 53: city
  ```
  gen operas_no_milan  = operas_city * (city != "milan")
  ```
- Line 54: city
  ```
  gen operas_novenice  = operas_city * (city != "venice")
  ```
- Line 55: city
  ```
  gen opera_nomi_nove  = operas_city * (city != "milan" & city != "venice")
  ```
- Line 60: city
  ```
  collapse (sum) operas = operas_city ///
  ```
- Line 80: son
  ```
  ***Column 2: Poisson
  ```
- Line 81: son
  ```
  poisson operas_novenice copyright_post1801 i.state1 i.year,  vce(robust)
  ```
- Line 92: son
  ```
  ***Column 4: Poisson
  ```
- Line 93: son
  ```
  poisson operas_no_milan copyright_post1801 i.state1 i.year, vce(robust)
  ```
- Line 103: son
  ```
  ***Column 6: Poisson
  ```
- Line 104: son
  ```
  poisson opera_nomi_nove copyright_post1801 i.state1 i.year, vce(robust)
  ```
- Line 117: son
  ```
  ***Column 8: Poisson
  ```
- Line 118: son
  ```
  poisson operas copyright_post1801 i.state1 i.year, vce(robust)
  ```

**/replication-package/Dofiles/MT25_Dofiles/Replication_Table5_MT25.do**

- Line 50: son
  ```
  ***Column 5: Poisson
  ```
- Line 51: son
  ```
  poisson operas copyright_post1801 i.state1 i.year, cluster(state1)
  ```

**/replication-package/Dofiles/MT25_Dofiles/Replication_Table7_MT25.do**

- Line 25: loc
  ```
  local variables annals met amazon
  ```
- Line 28: loc
  ```
  foreach variable of local variables {
  ```

**/replication-package/Dofiles/MT25_Dofiles/Replication_TableB1_MT25.do**

- Line 49: son
  ```
  ***Column 5: Poisson
  ```
- Line 50: son
  ```
  poisson operas copyright_post1801 i.state1 i.year, vce(robust)
  ```
- Line 86: son
  ```
  ***Column 5: Poisson
  ```
- Line 87: son
  ```
  poisson operas copyright_post1801 i.state1 i.year, vce(robust)
  ```

