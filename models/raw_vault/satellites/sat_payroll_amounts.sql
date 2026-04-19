-- ============================================================
-- Model   : sat_payroll_amounts
-- Layer   : Raw Vault / Satellite
-- Parent  : hub_payroll
-- Purpose : SCD2 tracking of payroll amounts and currency
-- ============================================================

{{ config(materialized='incremental', unique_key=['PAYROLL_HK', 'LOAD_TIMESTAMP']) }}

WITH source AS (

    SELECT * FROM {{ ref('stg_payroll') }}

),

records AS (

    SELECT
        PAYROLL_HK,
        LOAD_TIMESTAMP,
        RECORD_SOURCE,
        PAYROLL_AMOUNTS_HDF,
        GROSS_PAY,
        BONUS_AMOUNT,
        CURRENCY_CODE
    FROM source

)

{% if is_incremental() %}

SELECT r.*
FROM records r
LEFT JOIN {{ this }} existing
    ON  r.PAYROLL_HK          = existing.PAYROLL_HK
    AND r.PAYROLL_AMOUNTS_HDF = existing.PAYROLL_AMOUNTS_HDF
WHERE existing.PAYROLL_HK IS NULL

{% else %}

SELECT * FROM records

{% endif %}
