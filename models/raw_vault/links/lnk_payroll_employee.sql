-- ============================================================
-- Model   : lnk_payroll_employee
-- Layer   : Raw Vault / Link
-- Purpose : Relationship between PAYROLL and EMPLOYEE entities
-- ============================================================

{{ config(materialized='incremental', unique_key=['PAYROLL_EMPLOYEE_HK']) }}

WITH source AS (

    SELECT * FROM {{ ref('stg_payroll') }}

),

new_records AS (

    SELECT DISTINCT
        MD5(PAYROLL_HK || '||' || EMPLOYEE_HK)  AS PAYROLL_EMPLOYEE_HK,
        PAYROLL_HK,
        EMPLOYEE_HK,
        LOAD_TIMESTAMP,
        RECORD_SOURCE
    FROM source

)

{% if is_incremental() %}

SELECT nr.*
FROM new_records nr
LEFT JOIN {{ this }} existing ON nr.PAYROLL_EMPLOYEE_HK = existing.PAYROLL_EMPLOYEE_HK
WHERE existing.PAYROLL_EMPLOYEE_HK IS NULL

{% else %}

SELECT * FROM new_records

{% endif %}
