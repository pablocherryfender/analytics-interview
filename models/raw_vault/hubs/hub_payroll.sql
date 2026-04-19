-- ============================================================
-- Model   : hub_payroll
-- Layer   : Raw Vault / Hub
-- Purpose : Unique PAYROLL business keys with first-seen metadata
-- ============================================================

{{ config(materialized='incremental', unique_key=['PAYROLL_HK']) }}

WITH source AS (

    SELECT * FROM {{ ref('stg_payroll') }}

),

new_records AS (

    SELECT DISTINCT
        PAYROLL_HK,
        PAYROLL_ID          AS PAYROLL_BK,
        LOAD_TIMESTAMP,
        RECORD_SOURCE
    FROM source

)

{% if is_incremental() %}

SELECT nr.*
FROM new_records nr
LEFT JOIN {{ this }} existing ON nr.PAYROLL_HK = existing.PAYROLL_HK
WHERE existing.PAYROLL_HK IS NULL

{% else %}

SELECT * FROM new_records

{% endif %}
