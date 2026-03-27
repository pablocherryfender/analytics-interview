-- ============================================================
-- Model   : sat_employee_details
-- Layer   : Raw Vault / Satellite
-- Parent  : hub_employee
-- Purpose : SCD2 tracking of EMPLOYEE name, job title and start date
-- ============================================================

{{ config(materialized='incremental', unique_key=['EMPLOYEE_HK', 'LOAD_TIMESTAMP']) }}

WITH source AS (

    SELECT * FROM {{ ref('stg_employee') }}

),

records AS (

    SELECT
        EMPLOYEE_HK,
        LOAD_TIMESTAMP,
        RECORD_SOURCE,
        EMPLOYEE_DETAILS_HDF,
        EMPLOYEE_NAME,
        JOB_TITLE,
        START_DATE
    FROM source

)

{% if is_incremental() %}

SELECT r.*
FROM records r
LEFT JOIN {{ this }} existing
    ON  r.EMPLOYEE_HK          = existing.EMPLOYEE_HK
    AND r.EMPLOYEE_DETAILS_HDF = existing.EMPLOYEE_DETAILS_HDF
WHERE existing.EMPLOYEE_HK IS NULL

{% else %}

SELECT * FROM records

{% endif %}
