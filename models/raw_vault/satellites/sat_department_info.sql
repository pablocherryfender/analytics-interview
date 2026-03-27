-- ============================================================
-- Model   : sat_department_info
-- Layer   : Raw Vault / Satellite
-- Parent  : hub_department
-- Purpose : SCD2 tracking of DEPARTMENT name, manager and location
-- ============================================================

{{ config(materialized='incremental', unique_key=['DEPARTMENT_HK', 'LOAD_TIMESTAMP']) }}

WITH source AS (

    SELECT * FROM {{ ref('stg_department') }}

),

records AS (

    SELECT
        DEPARTMENT_HK,
        LOAD_TIMESTAMP,
        RECORD_SOURCE,
        DEPARTMENT_INFO_HDF,
        DEPARTMENT_NAME,
        MANAGER_NAME,
        LOCATION
    FROM source

)

{% if is_incremental() %}

SELECT r.*
FROM records r
LEFT JOIN {{ this }} existing
    ON  r.DEPARTMENT_HK         = existing.DEPARTMENT_HK
    AND r.DEPARTMENT_INFO_HDF   = existing.DEPARTMENT_INFO_HDF
WHERE existing.DEPARTMENT_HK IS NULL

{% else %}

SELECT * FROM records

{% endif %}
