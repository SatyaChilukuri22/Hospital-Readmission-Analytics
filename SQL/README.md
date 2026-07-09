# SQL Scripts – Hospital Readmission Analysis

This folder contains all SQL scripts used for the Hospital Readmission Analysis project. The scripts cover database creation, data import, data cleaning, exploratory data analysis (EDA), KPI calculation, and advanced SQL analytics using PostgreSQL.

---

## SQL Files

### 01_Database.sql
Creates the project database and defines the `patient_encounters` table structure.

**Key Tasks**
- Create `healthcare_analysis` database
- Create `patient_encounters` table
- Define appropriate data types
- Set `encounter_id` as the primary key

---

### 02_Data_Import.sql
Validates the imported dataset after loading the CSV into PostgreSQL.

**Key Tasks**
- Verify total records imported
- Preview sample data
- Validate table schema using `information_schema`

---

### 03_Data_Cleaning.sql
Performs data quality checks and cleans the dataset for analysis.

**Key Tasks**
- Identify duplicate records
- Replace `'?'` values with `NULL`
- Standardize gender values
- Correct age category formatting
- Create the `readmit_30` flag
- Validate cleaned data

---

### 04_Exploratory_Analysis.sql
Performs exploratory data analysis (EDA) to understand patient demographics, hospital utilization, and clinical characteristics.

**Analysis Includes**
- Patient demographics
- Admission analysis
- Hospital stay analysis
- Medication analysis
- Laboratory procedures
- Emergency, outpatient, and inpatient visits
- Readmission distribution
- HbA1c and glucose analysis
- Medical specialties
- Primary diagnosis distribution

---

### 05_KPI_Queries.sql
Calculates business KPIs used in the Power BI dashboard.

**KPIs Include**
- Overall 30-day readmission rate
- Readmission by gender
- Readmission by race
- Readmission by age group
- Readmission by admission type
- Readmission by discharge disposition
- Length of stay analysis
- Diabetes medication analysis
- Insulin usage
- HbA1c results
- Medical specialty analysis
- Diagnosis analysis
- Risk segmentation

---

### 06_Advanced_SQL.sql
Demonstrates advanced SQL techniques for healthcare analytics.

**Techniques Used**
- Common Table Expressions (CTEs)
- Window Functions
- `ROW_NUMBER()`
- `RANK()`
- `DENSE_RANK()`
- Running Totals
- Patient ranking
- Diagnosis ranking
- Medical specialty ranking

---

## SQL Concepts Demonstrated

- Database Design
- Data Cleaning
- Data Validation
- Aggregate Functions
- GROUP BY
- CASE Statements
- Common Table Expressions (CTEs)
- Window Functions
- Ranking Functions
- Running Totals
- Business KPI Calculations
- Healthcare Analytics

---

## Database

**PostgreSQL**

Database Name:

```text
healthcare_analysis
```

Main Table:

```text
patient_encounters
```

---

These SQL scripts prepare the cleaned healthcare dataset and generate all analytical outputs used in the Power BI dashboard.
