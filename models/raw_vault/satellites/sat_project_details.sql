-- ============================================================
-- Model   : sat_project_details
-- Layer   : Raw Vault / Satellite
-- Parent  : hub_project
-- Purpose : SCD2 tracking of project descriptive attributes
-- ============================================================

{{ config(materialized='incremental', unique_key=['PROJECT_HK', 'LOAD_TIMESTAMP']) }}

WITH source AS (

    SELECT * FROM {{ ref('stg_project') }}

),

records AS (

    SELECT
        PROJECT_HK,
        LOAD_TIMESTAMP,
        RECORD_SOURCE,
        PROJECT_DETAILS_HDF,
        PROJECT_NAME,
        STATUS,
        START_DATE,
        END_DATE,
        BUDGET_AMOUNT
    FROM source

)

{% if is_incremental() %}

SELECT r.*
FROM records r
LEFT JOIN {{ this }} existing
    ON  r.PROJECT_HK          = existing.PROJECT_HK
    AND r.PROJECT_DETAILS_HDF = existing.PROJECT_DETAILS_HDF
WHERE existing.PROJECT_HK IS NULL

{% else %}

SELECT * FROM records

{% endif %}
