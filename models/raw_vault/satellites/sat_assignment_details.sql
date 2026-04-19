-- ============================================================
-- Model   : sat_assignment_details
-- Layer   : Raw Vault / Satellite
-- Parent  : hub_assignment
-- Purpose : SCD2 assignment-level attributes
-- ============================================================

{{ config(materialized='incremental', unique_key=['ASSIGNMENT_HK', 'LOAD_TIMESTAMP']) }}

WITH source AS (

    SELECT * FROM {{ ref('stg_assignment') }}

),

records AS (

    SELECT
        ASSIGNMENT_HK,
        LOAD_TIMESTAMP,
        RECORD_SOURCE,
        ASSIGNMENT_DETAILS_HDF,
        ROLE_ON_PROJECT,
        ALLOCATION_PCT,
        START_DATE,
        END_DATE
    FROM source

)

{% if is_incremental() %}

SELECT r.*
FROM records r
LEFT JOIN {{ this }} existing
    ON  r.ASSIGNMENT_HK          = existing.ASSIGNMENT_HK
    AND r.ASSIGNMENT_DETAILS_HDF = existing.ASSIGNMENT_DETAILS_HDF
WHERE existing.ASSIGNMENT_HK IS NULL

{% else %}

SELECT * FROM records

{% endif %}
