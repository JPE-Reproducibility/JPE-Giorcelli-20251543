## Potential Personal Identifiable Information (PII)

⚠️ We found the following instances of potentially personally identifying information. This may be completely legitimate but might be worth checking. *As a reminder, privacy legislation in many countries (e.g. GDPR in EU) prohibits the dissemination of personal identifiable information without prior (and documented) consent of individuals.* If indeed you want to publish such information with your replication package, you should probably have obtained IRB approval for this - please check!

**Summary:**
- Data files with PII indicators: 5
- Variables flagged in data: 16
- Code files with PII references: 9
- PII references in code: 226

### Summary of Flagged Files

| File Type | File | Variables/References | PII Categories |
|-----------|------|----------------------|----------------|
| Data | `additional_operas.dta` | 1 | name |
| Data | `city_level_operas_1781_1820.dta` | 6 | city |
| Data | `composers_return_year.dta` | 1 | name |
| Data | `operas_raw_data.dta` | 3 | city, name, son |
| Data | `theater_raw_data.dta` | 5 | city |
| Code | `GM20_city_level_analysis.do` | 45 | city, loc |
| Code | `GM20_composer_level_analysis.do` | 24 | name, loc |
| Code | `GM20_state_level_analysis.do` | 112 | city, son, loc |
| Code | `Replication_PreTrends.do` | 2 | loc |
| Code | `Replication_Table3_GM20.do` | 12 | city |
| Code | `Replication_Table4_MT25.do` | 23 | city, son |
| Code | `Replication_Table5_MT25.do` | 2 | son |
| Code | `Replication_Table7_MT25.do` | 2 | loc |
| Code | `Replication_TableB1_MT25.do` | 4 | son |

*See [Appendix](report-pii-appendix.md) for detailed listing of all flagged instances.*
