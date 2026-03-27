-- ============================================================
-- Model   : hub_employee
-- Layer   : Raw Vault / Hub
-- Purpose : Unique EMPLOYEE business keys with first-seen metadata
-- ============================================================

{{ config(materialized='incremental', unique_key=['EMPLOYEE_HK']) }}

WITH source AS (

    SELECT * FROM {{ ref('stg_employee') }}

),

new_records AS (

    SELECT DISTINCT
        EMPLOYEE_HK,
        EMPLOYEE_ID         AS EMPLOYEE_BK,
        LOAD_TIMESTAMP,
        RECORD_SOURCE
    FROM source

)

{% if is_incremental() %}

SELECT nr.*
FROM new_records nr
LEFT JOIN {{ this }} existing ON nr.EMPLOYEE_HK = existing.EMPLOYEE_HK
WHERE existing.EMPLOYEE_HK IS NULL

{% else %}

SELECT * FROM new_records

{% endif %}
