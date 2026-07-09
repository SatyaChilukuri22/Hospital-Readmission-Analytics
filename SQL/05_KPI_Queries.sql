-- ==========================================================
-- Project : Hospital Readmission Analysis
-- File    : 05_KPI_Queries.sql
-- Purpose : Calculate business KPIs to identify factors
--           influencing hospital readmissions and support
--           healthcare decision-making.
-- ==========================================================

-- ==========================================================
-- KPI 1 : Overall 30-Day Readmission Rate
-- ==========================================================

-- Overall patient readmission rate

SELECT
    COUNT(*) AS total_patients,
    SUM(readmit_30) AS readmitted_30_days,
    ROUND(SUM(readmit_30) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM patient_encounters;


-- ==========================================================
-- KPI 2 : Readmission Rate by Gender
-- ==========================================================

SELECT
    gender,
    COUNT(*) AS total_patients,
    SUM(readmit_30) AS readmitted,
    ROUND(SUM(readmit_30) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM patient_encounters
GROUP BY gender
ORDER BY readmission_rate_pct DESC;

-- ==========================================================
-- KPI 3 : Readmission Rate by Race
-- ==========================================================

-- Readmission distribution across race

SELECT
    race,
    COUNT(*) AS total_patients,
    SUM(readmit_30) AS readmitted,
    ROUND(SUM(readmit_30) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM patient_encounters
WHERE race IS NOT NULL
GROUP BY race
ORDER BY readmission_rate_pct DESC;

-- ==========================================================
-- KPI 4 : Readmission Rate by Age Group
-- ==========================================================

-- Readmission across age groups

SELECT
    age,
    COUNT(*) AS total_patients,
    SUM(readmit_30) AS readmitted,
    ROUND(SUM(readmit_30) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM patient_encounters
GROUP BY age
ORDER BY age;

-- ==========================================================
-- KPI 5 : Average Hospital Stay by Readmission
-- ==========================================================

-- Average hospital stay for each readmission category

SELECT
    readmit_30,
    ROUND(AVG(time_in_hospital), 2) AS avg_hospital_stay
FROM patient_encounters
GROUP BY readmit_30;

-- ==========================================================
-- KPI 6 : Average Number of Medications
-- ==========================================================

-- Average medications by readmission status

SELECT
    readmit_30,
    ROUND(AVG(num_medications), 2) AS avg_medications
FROM patient_encounters
GROUP BY readmit_30;

-- ==========================================================
-- KPI 7 : Average Laboratory Procedures
-- ==========================================================

-- Average lab procedures by readmission status

SELECT
    readmit_30,
    ROUND(AVG(num_lab_procedures), 2) AS avg_lab_tests
FROM patient_encounters
GROUP BY readmit_30;

-- ==========================================================
-- KPI 8 : Emergency Visits vs Readmission
-- ==========================================================

-- Emergency visits by readmission category

SELECT
    readmit_30,
    ROUND(AVG(number_emergency), 2) AS avg_emergency_visits
FROM patient_encounters
GROUP BY readmit_30;


-- ==========================================================
-- KPI 9 : Inpatient Visits vs Readmission
-- ==========================================================

-- Inpatient visits by readmission category

SELECT
    readmit_30,
    ROUND(AVG(number_inpatient), 2) AS avg_inpatient_visits
FROM patient_encounters
GROUP BY readmit_30;

-- ==========================================================
-- KPI 10 : Prior Outpatient Visits vs Readmission
-- ==========================================================

-- Outpatient visits by readmission category

SELECT
    readmit_30,
    ROUND(AVG(number_outpatient), 2) AS avg_outpatient_visits
FROM patient_encounters
GROUP BY readmit_30;

-- ==========================================================
-- KPI 11 : Readmission Rate by Diabetes Medication Status
-- ==========================================================

-- Readmission based on diabetes medication

SELECT
    diabetesMed,
    COUNT(*) AS total_patients,
    SUM(readmit_30) AS readmitted,
    ROUND(SUM(readmit_30) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM patient_encounters
GROUP BY diabetesMed
ORDER BY readmission_rate_pct DESC;

-- ==========================================================
-- KPI 12 : Readmission Rate by Insulin Usage
-- ==========================================================

SELECT
    insulin,
    COUNT(*) AS total_patients,
    SUM(readmit_30) AS readmitted,
    ROUND(SUM(readmit_30) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM patient_encounters
GROUP BY insulin
ORDER BY readmission_rate_pct DESC;

-- ==========================================================
-- KPI 13 : Readmission Rate by HbA1c Test Result
-- ==========================================================

SELECT
    A1Cresult,
    COUNT(*) AS total_patients,
    SUM(readmit_30) AS readmitted,
    ROUND(SUM(readmit_30) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM patient_encounters
GROUP BY A1Cresult
ORDER BY readmission_rate_pct DESC;

-- ==========================================================
-- KPI 14 : Readmission Rate by Medical Specialty (Top 10 by volume)
-- ==========================================================

SELECT
    medical_specialty,
    COUNT(*) AS total_patients,
    SUM(readmit_30) AS readmitted,
    ROUND(SUM(readmit_30) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM patient_encounters
WHERE medical_specialty IS NOT NULL
GROUP BY medical_specialty
ORDER BY total_patients DESC
LIMIT 10;

-- ==========================================================
-- KPI 15 : Readmission Rate by Primary Diagnosis (Top 10 by volume)
-- ==========================================================

SELECT
    diag_1,
    COUNT(*) AS total_patients,
    SUM(readmit_30) AS readmitted,
    ROUND(SUM(readmit_30) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM patient_encounters
WHERE diag_1 IS NOT NULL
GROUP BY diag_1
HAVING COUNT(*) > 100
ORDER BY total_patients DESC
LIMIT 10;

-- ==========================================================
-- KPI 16 : Readmission Rate by Admission Type
-- ==========================================================

SELECT
    admission_type_id,
    COUNT(*) AS total_patients,
    SUM(readmit_30) AS readmitted,
    ROUND(SUM(readmit_30) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM patient_encounters
GROUP BY admission_type_id
ORDER BY readmission_rate_pct DESC;

-- ==========================================================
-- KPI 17 : Readmission Rate by Discharge Disposition
-- ==========================================================

SELECT
    discharge_disposition_id,
    COUNT(*) AS total_patients,
    SUM(readmit_30) AS readmitted,
    ROUND(SUM(readmit_30) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM patient_encounters
GROUP BY discharge_disposition_id
ORDER BY readmission_rate_pct DESC;

-- ==========================================================
-- KPI 18 : Length of Stay Buckets vs Readmission Rate
-- ==========================================================

SELECT
    CASE 
        WHEN time_in_hospital <= 3 THEN '1-3 days'
        WHEN time_in_hospital <= 7 THEN '4-7 days'
        ELSE '8+ days'
    END AS los_bucket,
    COUNT(*) AS total_patients,
    SUM(readmit_30) AS readmitted,
    ROUND(SUM(readmit_30) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM patient_encounters
GROUP BY los_bucket
ORDER BY readmission_rate_pct DESC;

-- ==========================================================
-- KPI 19 : Age Groups Ranked by Readmission Volume (highest volume, not rate)
-- ==========================================================

SELECT
    age,
    SUM(readmit_30) AS readmitted_patients
FROM patient_encounters
GROUP BY age
ORDER BY readmitted_patients DESC;

-- ==========================================================
-- KPI 20 : High-Risk Patient Segmentation
-- Combines length of stay + prior inpatient visits into a
-- risk category, then validates it against actual readmission.
-- ==========================================================

WITH risk_flagged AS (
    SELECT
        encounter_id,
        readmit_30,
        CASE 
            WHEN time_in_hospital > 7 AND number_inpatient >= 2 THEN 'High Risk'
            WHEN time_in_hospital > 4 OR number_inpatient >= 1 THEN 'Medium Risk'
            ELSE 'Low Risk'
        END AS risk_category
    FROM patient_encounters
)
SELECT
    risk_category,
    COUNT(*) AS total_patients,
    SUM(readmit_30) AS readmitted,
    ROUND(SUM(readmit_30) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM risk_flagged
GROUP BY risk_category
ORDER BY readmission_rate_pct DESC;