-- ============================================================
-- Model   : lnk_employee_department
-- Layer   : Raw Vault / Link
-- Purpose : Relationship between EMPLOYEE and DEPARTMENT entities
-- ============================================================

{{ config(materialized='incremental', unique_key=['EMPLOYEE_DEPARTMENT_HK']) }}

WITH source AS (

    SELECT * FROM {{ ref('stg_employee') }}

),

new_records AS (

    SELECT DISTINCT
        MD5(EMPLOYEE_HK || '||' || DEPARTMENT_HK)  AS EMPLOYEE_DEPARTMENT_HK,
        EMPLOYEE_HK,
        DEPARTMENT_HK,
        LOAD_TIMESTAMP,
        RECORD_SOURCE
    FROM source

)

{% if is_incremental() %}

SELECT nr.*
FROM new_records nr
LEFT JOIN {{ this }} existing ON nr.EMPLOYEE_DEPARTMENT_HK = existing.EMPLOYEE_DEPARTMENT_HK
WHERE existing.EMPLOYEE_DEPARTMENT_HK IS NULL

{% else %}

SELECT * FROM new_records

{% endif %}
