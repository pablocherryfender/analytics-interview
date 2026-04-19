-- ============================================================
-- Model   : sat_timesheet_hours
-- Layer   : Raw Vault / Satellite
-- Parent  : hub_timesheet
-- Purpose : SCD2 tracking of submitted timesheet measures
-- ============================================================

{{ config(materialized='incremental', unique_key=['TIMESHEET_HK', 'LOAD_TIMESTAMP']) }}

WITH source AS (

    SELECT * FROM {{ ref('stg_timesheet') }}

),

records AS (

    SELECT
        TIMESHEET_HK,
        LOAD_TIMESTAMP,
        RECORD_SOURCE,
        TIMESHEET_DETAILS_HDF AS TIMESHEET_HOURS_HDF,
        WORK_DATE,
        HOURS_WORKED,
        BILLABLE_FLAG
    FROM source

)

{% if is_incremental() %}

SELECT r.*
FROM records r
LEFT JOIN {{ this }} existing
    ON  r.TIMESHEET_HK         = existing.TIMESHEET_HK
    AND r.TIMESHEET_HOURS_HDF  = existing.TIMESHEET_HOURS_HDF
WHERE existing.TIMESHEET_HK IS NULL

{% else %}

SELECT * FROM records

{% endif %}
