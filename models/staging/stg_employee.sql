-- ============================================================
-- Model   : stg_employee
-- Layer   : Staging
-- Source  : HR.TBL_EMPLOYEE
-- Purpose : Compute hash keys and hashdiffs for the EMPLOYEE entity
-- ============================================================

{{ config(materialized='table') }}

WITH source AS (

    SELECT * FROM {{ ref('TBL_EMPLOYEE') }}

),

staged AS (

    SELECT

        -- Business key
        EMPLOYEE_ID,

        -- Hash key: EMPLOYEE entity
        MD5(
            COALESCE(EMPLOYEE_ID::VARCHAR, '')
        )                                               AS EMPLOYEE_HK,

        -- Hash key: DEPARTMENT entity (for link)
        MD5(
            COALESCE(DEPARTMENT_ID::VARCHAR, '')
        )                                               AS DEPARTMENT_HK,

        -- Hashdiff: sat_employee_details
        MD5(
            COALESCE(JOB_TITLE, '')         || '||' ||
            COALESCE(EMPLOYEE_NAME, '')     || '||' ||
            COALESCE(START_DATE::VARCHAR, '')
        )                                               AS EMPLOYEE_DETAILS_HDF,

        -- Hashdiff: sat_employee_contact
        MD5(
            COALESCE(EMAIL, '')             || '||' ||
            COALESCE(PHONE, '')
        )                                               AS EMPLOYEE_CONTACT_HDF,

        -- Payload: employee details
        EMPLOYEE_NAME,
        JOB_TITLE,
        START_DATE,

        -- Payload: employee contact
        EMAIL,
        PHONE,

        -- Link foreign key
        DEPARTMENT_ID,

        -- Metadata
        LOAD_TIME                                       AS LOAD_TIMESTAMP,
        'HR.TBL_EMPLOYEE'                               AS RECORD_SOURCE

    FROM source

)

SELECT * FROM staged
