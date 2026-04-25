-- ============================================================
-- Model   : hub_timesheet
-- Layer   : Raw Vault / Hub
-- Purpose : Unique TIMESHEET business keys
-- ============================================================

{{ config(materialized='incremental', unique_key=['TIMESHEET_HK']) }}

WITH source AS (

    SELECT * FROM {{ ref('stg_timesheet') }}

),

new_records AS (

    SELECT DISTINCT
        TIMESHEET_HK,
        TIMESHEET_ID        AS TIMESHEET_BK,
        LOAD_TIMESTAMP,
        RECORD_SOURCE
    FROM source

)

{% if is_incremental() %}

SELECT nr.*
FROM new_records nr
LEFT JOIN {{ this }} existing ON nr.TIMESHEET_HK = existing.TIMESHEET_HK
WHERE existing.TIMESHEET_HK IS NULL

{% else %}

SELECT * FROM new_records

{% endif %}
