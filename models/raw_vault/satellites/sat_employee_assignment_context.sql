-- ============================================================
-- Model   : sat_employee_assignment_context
-- Layer   : Raw Vault / Satellite
-- Parent  : lnk_employee_project
-- Purpose : Context attributes for employee-project assignment relationship
-- ============================================================

{{ config(materialized='incremental', unique_key=['EMPLOYEE_PROJECT_HK', 'LOAD_TIMESTAMP']) }}

WITH source AS (

    SELECT * FROM {{ ref('stg_assignment') }}

),

records AS (

    SELECT
        MD5(EMPLOYEE_HK || '||' || PROJECT_HK)          AS EMPLOYEE_PROJECT_HK,
        LOAD_TIMESTAMP,
        RECORD_SOURCE,
        ASSIGNMENT_CONTEXT_HDF,
        ROLE_ON_PROJECT,
        ALLOCATION_PCT
    FROM source

)

{% if is_incremental() %}

SELECT r.*
FROM records r
LEFT JOIN {{ this }} existing
    ON  r.EMPLOYEE_PROJECT_HK      = existing.EMPLOYEE_PROJECT_HK
    AND r.ASSIGNMENT_CONTEXT_HDF   = existing.ASSIGNMENT_CONTEXT_HDF
WHERE existing.EMPLOYEE_PROJECT_HK IS NULL

{% else %}

SELECT * FROM records

{% endif %}
