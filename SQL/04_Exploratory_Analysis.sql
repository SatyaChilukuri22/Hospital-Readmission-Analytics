-- ==========================================================
-- Project : Hospital Readmission Analysis
-- File    : 04_Exploratory_Analysis.sql
-- Database: PostgreSQL
-- Purpose : Explore the dataset to understand patient
--           demographics, hospital utilization, clinical
--           characteristics, and readmission patterns.
-- ==========================================================


-- ======================================================
-- Dataset Overview
-- ==================================================

---Total Patients

SELECT COUNT(*) AS total_patients
FROM patient_encounters;

-- Total Unique Patients

SELECT COUNT(DISTINCT patient_nbr) AS unique_patients
FROM patient_encounters;

-- Total Hospital Encounters

SELECT COUNT(DISTINCT encounter_id) AS total_encounters
FROM patient_encounters;

-- ======================================================
-- Patient Demographics
-- ======================================================

--- Gender Distribution

SELECT
    gender,
    COUNT(*) AS patient_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),2) AS percentage
FROM patient_encounters
GROUP BY gender
ORDER BY patient_count DESC;

---Race Distribution

SELECT
    race,
    COUNT(*) AS patient_count
FROM patient_encounters
GROUP BY race
ORDER BY patient_count DESC;


-- Age Distribution

SELECT
    age,
    COUNT(*) AS patient_count
FROM patient_encounters
GROUP BY age
ORDER BY age;


-- ======================================================
-- Admission Analysis
-- ======================================================

--- Admission Type
SELECT
    admission_type_id,
    COUNT(*) AS admissions
FROM patient_encounters
GROUP BY admission_type_id
ORDER BY admissions DESC;

--- Admission Source

SELECT
    admission_source_id,
    COUNT(*) AS patients
FROM patient_encounters
GROUP BY admission_source_id
ORDER BY patients DESC;

---Discharge Disposition

SELECT
    discharge_disposition_id,
    COUNT(*) AS patients
FROM patient_encounters
GROUP BY discharge_disposition_id
ORDER BY patients DESC;

-- ======================================================
-- Hospital Stay
-- ======================================================

--- Average Length of Stay

SELECT
    ROUND(AVG(time_in_hospital),2) AS avg_hospital_stay
FROM patient_encounters;

--- Stay Distribution

SELECT
    time_in_hospital,
    COUNT(*) AS patients
FROM patient_encounters
GROUP BY time_in_hospital
ORDER BY time_in_hospital;


-- ======================================================
-- Laboratory Analysis
-- ======================================================

--- Average Lab Tests

SELECT
    ROUND(AVG(num_lab_procedures),2) AS avg_lab_tests
FROM patient_encounters;

--- Maximum Lab Tests

SELECT
    MAX(num_lab_procedures) AS max_lab_tests
FROM patient_encounters;

-- ======================================================
-- Medication Analysis
-- ======================================================

--- Average Medications

SELECT
    ROUND(AVG(num_medications),2) AS avg_medications
FROM patient_encounters;

--- Medication Distribution

SELECT
    num_medications,
    COUNT(*) AS patients
FROM patient_encounters
GROUP BY num_medications
ORDER BY num_medications;

-- ======================================================
-- Emergency Visits
-- ======================================================

SELECT
    number_emergency,
    COUNT(*) AS patients
FROM patient_encounters
GROUP BY number_emergency
ORDER BY number_emergency;

-- ======================================================
-- Outpatient Visits
-- ======================================================

SELECT
    number_outpatient,
    COUNT(*) AS patients
FROM patient_encounters
GROUP BY number_outpatient
ORDER BY number_outpatient;

-- ======================================================
-- Inpatient Visits
-- ======================================================


SELECT
    number_inpatient,
    COUNT(*) AS patients
FROM patient_encounters
GROUP BY number_inpatient
ORDER BY number_inpatient;

-- ======================================================
-- Diabetes Medication
-- ======================================================

SELECT
    diabetesMed,
    COUNT(*) AS patients
FROM patient_encounters
GROUP BY diabetesMed;

-- ======================================================
-- Readmission Distribution
-- ======================================================

SELECT
    readmitted,
    COUNT(*) AS patients,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),2) AS percentage
FROM patient_encounters
GROUP BY readmitted
ORDER BY patients DESC;

-- ======================================================
-- HbA1c Results
-- ======================================================

SELECT
    A1Cresult,
    COUNT(*) AS patients
FROM patient_encounters
GROUP BY A1Cresult
ORDER BY patients DESC;

-- ======================================================
-- Blood Glucose Results
-- ======================================================

SELECT
    max_glu_serum,
    COUNT(*) AS patients
FROM patient_encounters
GROUP BY max_glu_serum
ORDER BY patients DESC;

-- ======================================================
-- Top Medical Specialties
-- ======================================================

SELECT
    medical_specialty,
    COUNT(*) AS patient_count
FROM patient_encounters
WHERE medical_specialty IS NOT NULL
GROUP BY medical_specialty
ORDER BY patient_count DESC
LIMIT 10;

-- ======================================================
-- Top Primary Diagnoses
-- ======================================================

SELECT
    diag_1,
    COUNT(*) AS patient_count
FROM patient_encounters
GROUP BY diag_1
ORDER BY patient_count DESC
LIMIT 10;
