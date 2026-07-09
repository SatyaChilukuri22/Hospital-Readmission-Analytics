-- ==========================================================
-- Project : Hospital Readmission Analysis
-- File    : 02_Data_Import.sql
-- Database: PostgreSQL
-- Purpose : Import the cleaned diabetic patient dataset
--           into the patient_encounters table and verify
--           that all records have been successfully loaded.
-- ==========================================================

-- ==========================================================
-- Verify Data Import
-- ==========================================================

-- Verify that all records have been imported successfully.

SELECT COUNT(*) AS total_records
FROM patient_encounters;

-- Preview the first 10 records to confirm successful import.

SELECT *
FROM patient_encounters
LIMIT 10;

-- ==========================================================
-- Verify Table Structure
-- ==========================================================

-- Review the table schema to ensure all columns have the
-- correct data types.

SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'patient_encounters';