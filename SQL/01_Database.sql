-- ==========================================================
-- Project : Hospital Readmission Analysis
-- File    : 01_Database.sql
-- Database: PostgreSQL
-- Purpose : Create the project database and define the
--           patient_encounters table to store hospital
--           readmission data for analysis.
-- ==========================================================


-- ==========================================================
-- CREATE DATABASE
-- ==========================================================

-- Create a new database for the Hospital Readmission Analysis project.

CREATE DATABASE healthcare_analysis;

-- ==========================================================
-- CREATE PATIENT_ENCOUNTERS TABLE
-- ==========================================================
CREATE TABLE patient_encounters (
    encounter_id BIGINT PRIMARY KEY,
    patient_nbr BIGINT,
    race VARCHAR(50),
    gender VARCHAR(20),
    age VARCHAR(20),
    admission_type_id INT,
    discharge_disposition_id INT,
    admission_source_id INT,
    time_in_hospital INT,
    payer_code VARCHAR(20),
    medical_specialty VARCHAR(100),
    num_lab_procedures INT,
    num_procedures INT,
    num_medications INT,
    number_outpatient INT,
    number_emergency INT,
    number_inpatient INT,
    diag_1 VARCHAR(20),
    diag_2 VARCHAR(20),
    diag_3 VARCHAR(20),
    number_diagnoses INT,
    max_glu_serum VARCHAR(20),
    A1Cresult VARCHAR(20),
    metformin VARCHAR(20),
    repaglinide VARCHAR(20),
    nateglinide VARCHAR(20),
    chlorpropamide VARCHAR(20),
    glimepiride VARCHAR(20),
    acetohexamide VARCHAR(20),
    glipizide VARCHAR(20),
    glyburide VARCHAR(20),
    tolbutamide VARCHAR(20),
    pioglitazone VARCHAR(20),
    rosiglitazone VARCHAR(20),
    acarbose VARCHAR(20),
    miglitol VARCHAR(20),
    troglitazone VARCHAR(20),
    tolazamide VARCHAR(20),
    examide VARCHAR(20),
    citoglipton VARCHAR(20),
    insulin VARCHAR(20),
    "glyburide-metformin" VARCHAR(20),
    "glipizide-metformin" VARCHAR(20),
    "glimepiride-pioglitazone" VARCHAR(20),
    "metformin-rosiglitazone" VARCHAR(20),
    "metformin-pioglitazone" VARCHAR(20),
    "change" VARCHAR(10),
    diabetesMed VARCHAR(10),
    readmitted VARCHAR(10)
);
