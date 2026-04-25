-- ============================================================
-- Model   : stg_timesheet
-- Layer   : Staging
-- Source  : HR.TBL_TIMESHEET
-- Purpose : Compute hash keys and hashdiffs for timesheet events
-- ============================================================

{{ config(materialized='view') }}

WITH source AS (

    SELECT * FROM {{ ref('TBL_TIMESHEET') }}

),

staged AS (

    SELECT
        TIMESHEET_ID,
        EMPLOYEE_ID,
        PROJECT_ID,
        WORK_DATE,
        HOURS_WORKED,
        BILLABLE_FLAG,
        LOAD_TIME                                        AS LOAD_TIMESTAMP,

        MD5(COALESCE(TIMESHEET_ID::VARCHAR, ''))         AS TIMESHEET_HK,
        MD5(COALESCE(EMPLOYEE_ID::VARCHAR, ''))          AS EMPLOYEE_HK,
        MD5(COALESCE(PROJECT_ID::VARCHAR, ''))           AS PROJECT_HK,
        MD5(
            COALESCE(EMPLOYEE_ID::VARCHAR, '') || '||' ||
            COALESCE(PROJECT_ID::VARCHAR, '')  || '||' ||
            COALESCE(WORK_DATE::VARCHAR, '')
        )                                                AS ASSIGNMENT_HK,

        MD5(
            COALESCE(HOURS_WORKED::VARCHAR, '') || '||' ||
            COALESCE(BILLABLE_FLAG, '')         || '||' ||
            COALESCE(WORK_DATE::VARCHAR, '')
        )                                                AS TIMESHEET_DETAILS_HDF,

        'HR.TBL_TIMESHEET'                               AS RECORD_SOURCE
    FROM source

)

SELECT * FROM staged
