-- ============================================================
-- Model   : sat_employee_contact
-- Layer   : Raw Vault / Satellite
-- Parent  : hub_employee
-- Purpose : SCD2 tracking of EMPLOYEE email and phone
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
        EMPLOYEE_CONTACT_HDF,
        EMAIL,
        PHONE
    FROM source

)

{% if is_incremental() %}

SELECT r.*
FROM records r
LEFT JOIN {{ this }} existing
    ON  r.EMPLOYEE_HK           = existing.EMPLOYEE_HK
    AND r.EMPLOYEE_CONTACT_HDF  = existing.EMPLOYEE_CONTACT_HDF
WHERE existing.EMPLOYEE_HK IS NULL

{% else %}

SELECT * FROM records

{% endif %}
