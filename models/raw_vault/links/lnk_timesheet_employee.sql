-- ============================================================
-- Model   : lnk_timesheet_employee
-- Layer   : Raw Vault / Link
-- Purpose : Relationship between TIMESHEET and EMPLOYEE entities
-- ============================================================

{{ config(materialized='incremental', unique_key=['TIMESHEET_EMPLOYEE_HK']) }}

WITH source AS (

    SELECT * FROM {{ ref('stg_timesheet') }}

),

new_records AS (

    SELECT DISTINCT
        MD5(TIMESHEET_HK || '||' || EMPLOYEE_HK)  AS TIMESHEET_EMPLOYEE_HK,
        TIMESHEET_HK,
        EMPLOYEE_HK,
        LOAD_TIMESTAMP,
        RECORD_SOURCE
    FROM source

)

{% if is_incremental() %}

SELECT nr.*
FROM new_records nr
LEFT JOIN {{ this }} existing ON nr.TIMESHEET_EMPLOYEE_HK = existing.TIMESHEET_EMPLOYEE_HK
WHERE existing.TIMESHEET_EMPLOYEE_HK IS NULL

{% else %}

SELECT * FROM new_records

{% endif %}
