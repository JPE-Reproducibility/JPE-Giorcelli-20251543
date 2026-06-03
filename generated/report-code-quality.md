## Code Quality

### Stata

[CRITICAL] Hardcoded absolute path detected — the package will not run on another machine. (GM20_city_level_analysis.do, line 11)
  → cap cd	"/Users/michelag/MICHELA GIORCELLI Dropbox/Michela Giorcelli/opera replication/Comment_JPE/"	// Michela

[CRITICAL] Hardcoded absolute path detected — the package will not run on another machine. (GM20_composer_level_analysis.do, line 10)
  → cap cd	"/Users/michelag/MICHELA GIORCELLI Dropbox/Michela Giorcelli/opera replication/Comment_JPE/"	// Michela

[CRITICAL] Hardcoded absolute path detected — the package will not run on another machine. (GM20_state_level_analysis.do, line 10)
  → cap cd	"/Users/michelag/MICHELA GIORCELLI Dropbox/Michela Giorcelli/opera replication/Comment_JPE/"	// Michela

[CRITICAL] Hardcoded absolute path detected — the package will not run on another machine. (Replication_PreTrends.do, line 11)
  → cap cd	"/Users/michelag/MICHELA GIORCELLI Dropbox/Michela Giorcelli/opera replication/Comment_JPE/"	// Michela

[CRITICAL] Hardcoded absolute path detected — the package will not run on another machine. (Replication_Table3_GM20.do, line 11)
  → cap cd	"/Users/michelag/MICHELA GIORCELLI Dropbox/Michela Giorcelli/opera replication/Comment_JPE/"	// Michela

[CRITICAL] Hardcoded absolute path detected — the package will not run on another machine. (Replication_Table4_MT25.do, line 11)
  → cap cd	"/Users/michelag/MICHELA GIORCELLI Dropbox/Michela Giorcelli/opera replication/Comment_JPE/"	// Michela

[CRITICAL] Hardcoded absolute path detected — the package will not run on another machine. (Replication_Table5_MT25.do, line 12)
  → cap cd	"/Users/michelag/MICHELA GIORCELLI Dropbox/Michela Giorcelli/opera replication/Comment_JPE/"	// Michela

[CRITICAL] Hardcoded absolute path detected — the package will not run on another machine. (Replication_Table6_MT25.do, line 12)
  → cap cd	"/Users/michelag/MICHELA GIORCELLI Dropbox/Michela Giorcelli/opera replication/Comment_JPE/"	// Michela

[CRITICAL] Hardcoded absolute path detected — the package will not run on another machine. (Replication_Table7_MT25.do, line 11)
  → cap cd	"/Users/michelag/MICHELA GIORCELLI Dropbox/Michela Giorcelli/opera replication/Comment_JPE/"	// Michela

[CRITICAL] Hardcoded absolute path detected — the package will not run on another machine. (Replication_TableB1_MT25.do, line 11)
  → cap cd	"/Users/michelag/MICHELA GIORCELLI Dropbox/Michela Giorcelli/opera replication/Comment_JPE/"	// Michela

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (GM20_city_level_analysis.do, line 26)
  → keep if year >= 1781 & year <= 1820

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (GM20_composer_level_analysis.do, line 24)
  → keep if year >= 1781 & year <= 1820

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (GM20_composer_level_analysis.do, line 239)
  → keep if year >= 1781 & year <= 1820

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Replication_Table4_MT25.do, line 111)
  → drop if state=="venetia"

