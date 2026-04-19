-- ============================================================
-- Model   : lnk_employee_project
-- Layer   : Raw Vault / Link
-- Purpose : Relationship between EMPLOYEE and PROJECT entities
-- ============================================================

{{ config(materialized='incremental', unique_key=['EMPLOYEE_PROJECT_HK']) }}

WITH source AS (

    SELECT * FROM {{ ref('stg_assignment') }}

),

new_records AS (

    SELECT DISTINCT
        MD5(EMPLOYEE_HK || '||' || PROJECT_HK) AS EMPLOYEE_PROJECT_HK,
        EMPLOYEE_HK,
        PROJECT_HK,
        LOAD_TIMESTAMP,
        RECORD_SOURCE
    FROM source

)

{% if is_incremental() %}

SELECT nr.*
FROM new_records nr
LEFT JOIN {{ this }} existing ON nr.EMPLOYEE_PROJECT_HK = existing.EMPLOYEE_PROJECT_HK
WHERE existing.EMPLOYEE_PROJECT_HK IS NULL

{% else %}

SELECT * FROM new_records

{% endif %}
