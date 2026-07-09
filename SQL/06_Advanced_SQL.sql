-- ==========================================================
-- Project : Hospital Readmission Analysis
-- File    : 06_Advanced_SQL.sql
-- Purpose : Demonstrate advanced SQL techniques including
--           CTEs, Window Functions, Ranking, Running Totals,
--           and Business Analytics.
-- ==========================================================

--- ==========================================================
--- Top 10 Diagnosis Codes by Patient Volume
--- ==========================================================

-- Rank diagnosis codes by number of readmitted patients

WITH diagnosis_readmission AS (
    SELECT
        diag_1,
        COUNT(*) AS readmitted_patients
    FROM patient_encounters
    WHERE readmit_30 = 1
      AND diag_1 IS NOT NULL
    GROUP BY diag_1
)
SELECT
    diag_1,
    readmitted_patients,
    RANK() OVER (ORDER BY readmitted_patients DESC) AS diagnosis_rank
FROM diagnosis_readmission
LIMIT 10;

-- ==========================================================
-- Rank medical specialties by readmission rate
-- ==========================================================

WITH specialty_readmission AS (
    SELECT
        medical_specialty,
        COUNT(*) AS total_patients,
        SUM(readmit_30) AS readmitted,
        ROUND(SUM(readmit_30) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
    FROM patient_encounters
    WHERE medical_specialty IS NOT NULL
    GROUP BY medical_specialty
    HAVING COUNT(*) > 100
)
SELECT
    medical_specialty,
    total_patients,
    readmitted,
    readmission_rate_pct,
    RANK() OVER (ORDER BY readmission_rate_pct DESC) AS specialty_rank
FROM specialty_readmission
LIMIT 15;

-- ==========================================================
-- Rank age groups by patient count
-- ==========================================================

WITH age_counts AS (

    SELECT
        age,
        COUNT(*) AS patient_count
    FROM patient_encounters
    GROUP BY age

)

SELECT
    age,
    patient_count,
    DENSE_RANK() OVER (ORDER BY patient_count DESC) AS age_rank
FROM age_counts;

-- ==========================================================
-- Rank admission types by number of admissions
-- ==========================================================

WITH admission_counts AS (

    SELECT
        admission_type_id,
        COUNT(*) AS total_admissions
    FROM patient_encounters
    GROUP BY admission_type_id

)

SELECT
    admission_type_id,
    total_admissions,
    RANK() OVER (ORDER BY total_admissions DESC) AS admission_rank
FROM admission_counts;

-- ==========================================================
-- Rank discharge disposition by patient count
-- ==========================================================

WITH discharge_counts AS (

    SELECT
        discharge_disposition_id,
        COUNT(*) AS patient_count
    FROM patient_encounters
    GROUP BY discharge_disposition_id

)

SELECT
    discharge_disposition_id,
    patient_count,
    DENSE_RANK() OVER (ORDER BY patient_count DESC) AS discharge_rank
FROM discharge_counts;

-- ==========================================================
-- Rank insulin usage categories
-- ==========================================================

WITH insulin_counts AS (

    SELECT
        insulin,
        COUNT(*) AS patient_count
    FROM patient_encounters
    GROUP BY insulin

)

SELECT
    insulin,
    patient_count,
    RANK() OVER (ORDER BY patient_count DESC) AS insulin_rank
FROM insulin_counts;


-- ==========================================================
-- Rank HbA1c test result categories
-- ==========================================================

WITH hba1c_counts AS (

    SELECT
        A1Cresult,
        COUNT(*) AS patient_count
    FROM patient_encounters
    GROUP BY A1Cresult

)

SELECT
    A1Cresult,
    patient_count,
    DENSE_RANK() OVER (ORDER BY patient_count DESC) AS result_rank
FROM hba1c_counts;

-- ==========================================================
-- Rank maximum glucose serum results
-- ==========================================================

WITH glucose_counts AS (

    SELECT
        max_glu_serum,
        COUNT(*) AS patient_count
    FROM patient_encounters
    GROUP BY max_glu_serum

)

SELECT
    max_glu_serum,
    patient_count,
    RANK() OVER (ORDER BY patient_count DESC) AS glucose_rank
FROM glucose_counts;

-- ==========================================================
-- Rank patients by number of diagnoses
-- ==========================================================

SELECT
    encounter_id,
    patient_nbr,
    number_diagnoses,
    DENSE_RANK() OVER (ORDER BY number_diagnoses DESC) AS diagnosis_rank
FROM patient_encounters
LIMIT 20;

-- ==========================================================
-- Rank patients by laboratory procedures
-- ==========================================================

SELECT
    encounter_id,
    patient_nbr,
    num_lab_procedures,
    ROW_NUMBER() OVER (ORDER BY num_lab_procedures DESC) AS lab_rank
FROM patient_encounters
LIMIT 20;


-- ==========================================================
-- Running total of patients by age group
-- ==========================================================

WITH age_summary AS (

    SELECT
        age,
        COUNT(*) AS patient_count
    FROM patient_encounters
    GROUP BY age

)

SELECT
    age,
    patient_count,
    SUM(patient_count) OVER (ORDER BY age) AS running_total
FROM age_summary;