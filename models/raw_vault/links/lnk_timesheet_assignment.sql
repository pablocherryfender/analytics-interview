-- ============================================================
-- Model   : lnk_timesheet_assignment
-- Layer   : Raw Vault / Link
-- Purpose : Relationship between TIMESHEET and ASSIGNMENT entities
-- ============================================================

{{ config(materialized='incremental', unique_key=['TIMESHEET_ASSIGNMENT_HK']) }}

WITH source AS (

    SELECT * FROM {{ ref('stg_timesheet') }}

),

new_records AS (

    SELECT DISTINCT
        MD5(TIMESHEET_HK || '||' || ASSIGNMENT_HK) AS TIMESHEET_ASSIGNMENT_HK,
        TIMESHEET_HK,
        PROJECT_HK AS ASSIGNMENT_HK,
        LOAD_TIMESTAMP,
        RECORD_SOURCE
    FROM source

)

{% if is_incremental() %}

SELECT nr.*
FROM new_records nr
LEFT JOIN {{ this }} existing ON nr.TIMESHEET_ASSIGNMENT_HK = existing.TIMESHEET_ASSIGNMENT_HK
WHERE existing.TIMESHEET_ASSIGNMENT_HK IS NULL

{% else %}

SELECT * FROM new_records

{% endif %}
