-- ==========================================================
-- Project : Hospital Readmission Analysis
-- File    : 03_Data_Cleaning.sql
-- Purpose : Perform data quality assessment, clean missing
--           values, standardize categorical data, and
--           validate the dataset before analysis.
-- ==========================================================

-- ==========================================================
-- DATA QUALITY ASSESSMENT
-- ==========================================================
-- Check the total number of records in the dataset.

SELECT COUNT(*) AS total_records
FROM patient_encounters;

-- ==========================================================
-- DUPLICATE RECORD CHECK
-- ==========================================================

-- Verify that encounter_id is unique for every patient encounter.

SELECT encounter_id,
       COUNT(*) AS duplicate_count
FROM patient_encounters
GROUP BY encounter_id
HAVING COUNT(*) > 1;

-- Check for duplicate patient encounters.

SELECT
    patient_nbr,
    encounter_id,
    COUNT(*) AS duplicate_count
FROM patient_encounters
GROUP BY patient_nbr, encounter_id
HAVING COUNT(*) > 1;

-- ==========================================================
-- MISSING VALUE ASSESSMENT
-- ==========================================================

-- Identify columns containing placeholder values ('?')
-- that represent missing data.

SELECT
    SUM(CASE WHEN race='?' THEN 1 ELSE 0 END) AS missing_race,
    SUM(CASE WHEN payer_code='?' THEN 1 ELSE 0 END) AS missing_payer_code,
    SUM(CASE WHEN medical_specialty='?' THEN 1 ELSE 0 END) AS missing_specialty,
    SUM(CASE WHEN diag_1='?' THEN 1 ELSE 0 END) AS missing_diag1,
    SUM(CASE WHEN diag_2='?' THEN 1 ELSE 0 END) AS missing_diag2,
    SUM(CASE WHEN diag_3='?' THEN 1 ELSE 0 END) AS missing_diag3
FROM patient_encounters;

-- ==========================================================
-- STANDARDIZE MISSING VALUES
-- ==========================================================

-- Replace placeholder values ('?') with NULL to improve
-- data quality and ensure accurate analysis.
-- Clean Race
UPDATE patient_encounters
SET race = NULL
WHERE race = '?';

-- Clean Payer Code

UPDATE patient_encounters
SET payer_code = NULL
WHERE payer_code = '?';

-- Clean Medical Specialty

UPDATE patient_encounters
SET medical_specialty = NULL
WHERE medical_specialty = '?';

-- ==========================================================
-- CLEAN DIAGNOSIS COLUMNS
-- ==========================================================

-- Standardize diagnosis columns by replacing invalid
-- placeholder values with NULL.

-- Clean Primary Diagnosis

UPDATE patient_encounters 
SET diag_1 = NULL 
WHERE diag_1 = '?';

-- Clean Secondary Diagnosis

UPDATE patient_encounters 
SET diag_2 = NULL 
WHERE diag_2 = '?';

-- Clean Tertiary Diagnosis

UPDATE patient_encounters 
SET diag_3 = NULL 
WHERE diag_3 = '?';

-- ==========================================================
-- STANDARDIZE GENDER VALUES
-- ==========================================================

-- Replace inconsistent gender values with a standardized
-- category.

UPDATE patient_encounters
SET gender = 'Unknown'
WHERE gender = 'Unknown/Invalid';

-- Verify gender categories.

SELECT
    gender,
    COUNT(*) AS patient_count
FROM patient_encounters
GROUP BY gender
ORDER BY patient_count DESC;

-- ==========================================================
-- DIAGNOSE AGE COLUMN CORRUPTION
-- ==========================================================

-- Excel auto-converted number-range text (e.g. "10-20") into 
-- date format (e.g. "Oct-20") during CSV editing. 
-- Inspect all distinct values before fixing.

SELECT age, COUNT(*) AS record_count
FROM patient_encounters
GROUP BY age
ORDER BY age;


-- ==========================================================
-- FIX AGE COLUMN: CORRECT EXCEL DATE AUTO-CONVERSION
-- ==========================================================

-- Excel misinterpreted numeric age ranges as dates during 
-- CSV handling (e.g. "10-20" became "Oct-20"). Restoring 
-- original age bracket format here.

UPDATE patient_encounters SET age = '0-10'   WHERE age = 'Jan-10';
UPDATE patient_encounters SET age = '10-20'  WHERE age = 'Oct-20';
UPDATE patient_encounters SET age = '20-30'  WHERE age = 'Nov-20';
UPDATE patient_encounters SET age = '30-40'  WHERE age = 'Dec-30';
UPDATE patient_encounters SET age = '40-50'  WHERE age = 'Apr-40';
UPDATE patient_encounters SET age = '50-60'  WHERE age = 'May-50';
UPDATE patient_encounters SET age = '60-70'  WHERE age = 'Jun-60';
UPDATE patient_encounters SET age = '70-80'  WHERE age = 'Jul-70';
UPDATE patient_encounters SET age = '80-90'  WHERE age = 'Aug-80';
UPDATE patient_encounters SET age = '90-100' WHERE age = 'Sep-90';

-- ==========================================================
-- VERIFY AGE COLUMN CLEANED
-- ==========================================================

SELECT age, COUNT(*) AS record_count
FROM patient_encounters
GROUP BY age
ORDER BY age;

-- ==========================================================
-- VALIDATE CATEGORICAL COLUMNS
-- ==========================================================

-- Validate Readmission Categories

SELECT
    readmitted,
    COUNT(*) AS patient_count
FROM patient_encounters
GROUP BY readmitted
ORDER BY patient_count DESC;


-- Validate Age Groups

SELECT
    age,
    COUNT(*) AS patient_count
FROM patient_encounters
GROUP BY age
ORDER BY age;

-- ======================================================
-- Validate Numeric Columns
-- ======================================================

-- Hospital Stay

SELECT
    MIN(time_in_hospital) AS min_stay,
    MAX(time_in_hospital) AS max_stay,
    AVG(time_in_hospital) AS avg_stay
FROM patient_encounters;

-- Number of Medications

SELECT
    MIN(num_medications),
    MAX(num_medications),
    AVG(num_medications)
FROM patient_encounters;

-- Laboratory Procedures

SELECT
    MIN(num_lab_procedures),
    MAX(num_lab_procedures),
    AVG(num_lab_procedures)
FROM patient_encounters;

-- ==========================================================
-- CREATE READMISSION FLAG
-- ==========================================================

-- Add a binary flag for patients readmitted within 30 days.

ALTER TABLE patient_encounters
ADD COLUMN IF NOT EXISTS readmit_30 INT;


UPDATE patient_encounters
SET readmit_30 =
CASE
    WHEN readmitted = '<30' THEN 1
    ELSE 0
END;


-- Verify readmission flag.

SELECT
    readmitted,
    readmit_30,
    COUNT(*) AS patient_count
FROM patient_encounters
GROUP BY readmitted, readmit_30
ORDER BY readmitted;

-- ==========================================================
-- VERIFY CLEANING RESULTS
-- ==========================================================

-- Confirm all placeholder values have been removed.

SELECT
    SUM(CASE WHEN race='?' THEN 1 ELSE 0 END) AS race_missing,
    SUM(CASE WHEN payer_code='?' THEN 1 ELSE 0 END) AS payer_missing,
    SUM(CASE WHEN medical_specialty='?' THEN 1 ELSE 0 END) AS specialty_missing,
    SUM(CASE WHEN diag_1='?' THEN 1 ELSE 0 END) AS diag1_missing,
    SUM(CASE WHEN diag_2='?' THEN 1 ELSE 0 END) AS diag2_missing,
    SUM(CASE WHEN diag_3='?' THEN 1 ELSE 0 END) AS diag3_missing
FROM patient_encounters;



-- ==========================================================
-- FINAL DATA QUALITY VALIDATION
-- ==========================================================

-- Final validation of the cleaned dataset.

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT encounter_id) AS unique_encounters,
    COUNT(DISTINCT patient_nbr) AS unique_patients
FROM patient_encounters;
