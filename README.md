# Hospital Readmission Analytics Dashboard

An end-to-end healthcare analytics project analyzing 30-day hospital readmissions using Excel, SQL (PostgreSQL), and Power BI — from raw data cleaning through an interactive, four-page decision-support dashboard.

---

## Business Question

Which patient segments have the highest 30-day readmission risk, what clinical and demographic factors drive that risk, and what would reducing readmissions by a given percentage save a hospital system?

---

## Tools Used

| Tool | Purpose |
|---|---|
| Microsoft Excel | Initial data exploration, pivot table distribution checks, first-pass cleaning |
| PostgreSQL (pgAdmin) | Data cleaning, transformation, KPI calculation, advanced SQL (CTEs, window functions) |
| Power BI Desktop | Data modeling (Power Query), DAX measures, interactive 4-page dashboard |

---

## Dataset

**Diabetes 130-US Hospitals for Years 1999–2008** (public dataset, Kaggle/UCI)

- ~102,000 hospital encounters across 130 US hospitals
- One row = one patient encounter (not one patient — some patients appear multiple times)
- Fields include demographics, admission details, diagnoses, lab/medication activity, and readmission status
- **Note:** this is a cross-sectional dataset with no date/timestamp field, so trend-over-time or monthly analysis is not possible. Readmission is defined per the dataset's `readmitted` field, filtered to the `<30` category for the 30-day readmission flag used throughout this project.

---

## Methodology

### 1. Excel — Initial Cleaning & Exploration

- Loaded raw `diabetic_data.csv`, converted to a Table (Ctrl+T) for filtering
- Identified missing/junk values marked as `'?'` across `race`, `weight`, `payer_code`, `medical_specialty`
- Built pivot table distributions for `age`, `race`, `gender`, `readmitted`, `admission_type_id`, `discharge_disposition_id` to check for skew, typos, and unexpected categories before touching SQL
- **Dropped the `weight` column** — over 90% missing (`'?'`), unusable for analysis; decision documented rather than silently discarded
- Checked `encounter_id` for duplicates via Conditional Formatting → Highlight Duplicate Values (confirmed zero duplicates, validating it as a true primary key)
- Applied `TRIM()` on select text columns to catch hidden leading/trailing whitespace
- Attempted to clean `age` bracket formatting (`[70-80)` → `70-80`) — this step later turned out to be where Excel's date autocorrect silently corrupted values (e.g., `10-20` became `Oct-20`); caught and permanently fixed downstream in SQL
- Exported the cleaned data as `cleaned_diabetic_data.csv` (kept pivot tables on a separate sheet in the working `.xlsx`; exported only the single data sheet to CSV, since CSV can't hold multiple sheets)

### 2. SQL (PostgreSQL) — Cleaning, Modeling, Analysis

**`01_Database.sql`** — Created the `healthcare_analysis` database and the `patient_encounters` table (47 columns, matched to the cleaned CSV).

**`02_Data_Import.sql`** — Imported the CSV via pgAdmin's Import/Export wizard; verified row count and table structure against `information_schema.columns`.

**`03_Data_Cleaning.sql`**
- Replaced `'?'` placeholders with `NULL` in `race`, `payer_code`, `medical_specialty`, `diag_1`, `diag_2`, `diag_3`
- Standardized `gender` (`Unknown/Invalid` → `Unknown`)
- Diagnosed and fixed the Excel date-corruption bug in `age` (e.g., `Oct-20` → `10-20`), restoring correct bracket values at the source of truth
- Created the standardized **`readmit_30`** flag (`<30` = 1, else 0) — used as the single consistent definition for every KPI from this point forward
- Ran final data-quality validation (record counts, remaining missing values)

**`04_Exploratory_Analysis.sql`** — Full EDA covering demographics (gender, race, age), admission analysis (type, source, discharge disposition), hospital stay statistics, lab/medication averages, emergency/outpatient/inpatient visit distributions, readmission distribution, HbA1c/glucose results, top medical specialties, and top diagnoses.

**`05_KPI_Queries.sql`** — 20 KPIs built entirely on `readmit_30`, all expressed as rates (not raw counts): readmission rate by gender, race, age, length-of-stay bucket, admission type, discharge disposition, insulin usage, A1C result, diabetes medication status, top diagnoses, and top specialties. Also built and validated the **risk segmentation model** (High / Medium / Low Risk, based on length of stay + prior inpatient visits) against actual readmission outcomes.

**`06_Advanced_SQL.sql`** — CTEs combined with `RANK()`, `DENSE_RANK()`, and `ROW_NUMBER()` window functions to rank diagnoses, specialties, age groups, admission types, discharge dispositions, and insulin/A1C/glucose categories by volume or readmission rate. Includes a running total of patients by age group using `SUM() OVER (ORDER BY age)`.

### 3. Power Query (inside Power BI) — Final Data Prep for the Model

- Connected to PostgreSQL via **Advanced Options → custom SQL statement** rather than importing the raw table — pulled only the 21 columns relevant to the dashboard
- Resolved a column-name casing mismatch (`A1Cresult` / `diabetesMed` were stored lowercase by Postgres) by adjusting the source SQL query
- Verified and corrected data types (Whole Number vs. Text) across every column
- Created custom column **`age_sort_order`** using `Text.BeforeDelimiter([age], "-")`, ensuring age brackets sort numerically (`0-10, 10-20, ... 90-100`) instead of alphabetically
- Created custom column **`risk_category`**, replicating the SQL High/Medium/Low Risk logic directly in the data model
- Created custom column **`a1c_sort_order`**, mapping `None / Norm / >7 / >8` to 1–4 so charts sort in correct clinical severity order rather than alphabetically
- Renamed columns for readability (`a1cresult` → `A1C_Result`, `diabetesmed` → `Diabetes_Medication`)
- Standardized the `race` value `AfricanAmerican` → `African American`
- Applied **Sort by Column** in Model view so `age` always sorts by `age_sort_order` and `A1C_Result` always sorts by `a1c_sort_order`, automatically, in every visual that uses them
- Closed & Applied to load the finalized model into Power BI's data model

### 4. Power BI — DAX Measures & Dashboard Build

Core measures created (`Total Patients`, `Total Readmitted 30d`, `Readmission Rate %`, `Avg Length of Stay`, `Avg Medications`, `Avg Lab Procedures`, plus segment-specific measures like `High Risk Patients`, `Female Readmission Rate`, `Male Readmission Rate`), followed by a Numeric Range parameter (`Readmission Reduction %`) and supporting measures (`Projected Readmissions Avoided`, `Projected Annual Savings`) to power the interactive What-If Simulator page.

---

## Dashboard Structure

### Page 1 — Executive Overview
KPI summary (Total Patients, Readmission Rate, Avg Length of Stay, Avg Medications), 30-day readmission distribution, readmission rate by age group, patient distribution by risk category, and a patient-volume-by-age-and-risk breakdown.

### Page 2 — Risk & Demographics
Readmission outcomes by gender, readmission rate by race, readmission rate trend by length of stay, and patient volume by age group × risk category (heatmap).

### Page 3 — Clinical Drivers
Diagnosis volume vs. readmission rate, readmission rate by medical specialty, average medications & lab procedures by readmission status, and readmission rate by HbA1c test result.

### Page 4 — What-If Simulator
An interactive parameter lets the user adjust a target readmission-reduction percentage and see the projected number of readmissions avoided and the projected annual cost savings, compared against current readmissions — plus a business insights summary tying findings from Pages 2 and 3 into the recommendation.

Every page includes a **Key Takeaways** callout summarizing the page's core finding in plain language.

---

## Key Findings

- **Overall 30-day readmission rate: 11.16%** (11,360 of ~102,000 encounters)
- Readmission risk **rises sharply after age 40** and remains elevated through the 60–90 age range
- **High-Risk patients are only ~2.8% of the population** (2,843 patients) but represent the highest-leverage group for intervention, driven by long hospital stays (7+ days) and 2+ prior inpatient admissions
- **Gender and race are not meaningful drivers** of readmission risk (11.06% male vs. 11.25% female; broadly similar across race groups) — clinical and utilization factors matter more than demographics
- **Readmission risk climbs steadily with length of stay**, suggesting longer stays signal more complex, higher-risk cases
- **Nephrology and Internal Medicine** show the highest readmission rates among high-volume medical specialties
- **Patients with no HbA1c test on record show the highest readmission rate** of any A1C category — an untested/unscreened glucose control status appears to be a hidden risk marker
- **What-if projection:** a 10% reduction in the current readmission rate could avoid an estimated **1,480 readmissions per year**, translating to a projected **~$22M in potential annual savings** (illustrative cost estimate — see limitations)

---

## Business Recommendation

Prioritize discharge planning and post-discharge follow-up for the High-Risk segment first — it is the smallest patient group but carries the highest readmission rate and therefore the highest return on a targeted intervention. Secondary priority: patients with elevated or missing A1C results and those under Nephrology/Internal Medicine care, both linked to higher readmission rates in the Clinical Drivers analysis.

---

## Limitations & Assumptions

- The dataset spans 1999–2008 and is not current; findings reflect historical patterns, not present-day hospital operations
- No geographic field exists in this dataset, so location-based analysis (e.g., by state or hospital) was not possible
- The $15,000-per-avoided-readmission figure used in the What-If Simulator is an **illustrative estimate** for demonstration purposes, not sourced from actual hospital billing or claims data. A production version of this model would use hospital-specific cost data.
- `payer_code` and `medical_specialty` had substantial missing data (`'?'` placeholder values), which were converted to `NULL` and excluded from relevant aggregations rather than imputed.

---

## Project Files

```
├── excel/
│   └── cleaned_diabetic_data.csv
├── sql/
│   ├── 01_Database.sql
│   ├── 02_Data_Import.sql
│   ├── 03_Data_Cleaning.sql
│   ├── 04_Exploratory_Analysis.sql
│   ├── 05_KPI_Queries.sql
│   └── 06_Advanced_SQL.sql
├── powerbi/
│   └── healthcare_readmission_dashboard.pbix
├── screenshots/
│   └── (dashboard page exports)
└── README.md
```
