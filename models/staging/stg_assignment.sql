-- ============================================================
-- Model   : stg_assignment
-- Layer   : Staging
-- Source  : HR.TBL_ASSIGNMENT
-- Purpose : Hash keys and hashdiffs for assignment events
-- ============================================================

{{ config(materialized='view') }}

WITH source AS (
    SELECT * FROM {{ ref('TBL_ASSIGNMENT') }}
),
staged AS (
    SELECT
        MD5(
            COALESCE(EMPLOYEE_ID::VARCHAR, '') || '||' ||
            COALESCE(PROJECT_ID::VARCHAR, '')  || '||' ||
            COALESCE(START_DATE::VARCHAR, '')
        ) AS ASSIGNMENT_ID,
        EMPLOYEE_ID,
        PROJECT_ID,
        ROLE_NAME,
        ALLOCATION_PCT,
        ASSIGNMENT_STATUS,
        START_DATE,
        END_DATE,
        LOAD_TIME AS LOAD_TIMESTAMP,

        MD5(COALESCE(ASSIGNMENT_ID::VARCHAR, ''))                          AS ASSIGNMENT_HK,
        MD5(COALESCE(EMPLOYEE_ID::VARCHAR, ''))                            AS EMPLOYEE_HK,
        MD5(COALESCE(PROJECT_ID::VARCHAR, ''))                             AS PROJECT_HK,

        MD5(
            COALESCE(ROLE_NAME, '')         || '||' ||
            COALESCE(ALLOCATION_PCT::VARCHAR, '') || '||' ||
            COALESCE(ASSIGNMENT_STATUS, '') || '||' ||
            COALESCE(START_DATE::VARCHAR, '') || '||' ||
            COALESCE(END_DATE::VARCHAR, '')
        )                                                                   AS ASSIGNMENT_DETAILS_HDF,

        MD5(
            COALESCE(ROLE_NAME, '')         || '||' ||
            COALESCE(ALLOCATION_PCT::VARCHAR, '') || '||' ||
            COALESCE(ASSIGNMENT_STATUS, '')
        )                                                                   AS ASSIGNMENT_CONTEXT_HDF,

        'HR.TBL_ASSIGNMENT'                                                 AS RECORD_SOURCE
    FROM source
)

SELECT * FROM staged
