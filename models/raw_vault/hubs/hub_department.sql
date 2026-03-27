-- ============================================================
-- Model   : hub_department
-- Layer   : Raw Vault / Hub
-- Purpose : Unique DEPARTMENT business keys with first-seen metadata
-- ============================================================

{{ config(materialized='incremental', unique_key=['DEPARTMENT_HK']) }}

WITH source AS (

    SELECT * FROM {{ ref('stg_department') }}

),

new_records AS (

    SELECT DISTINCT
        DEPARTMENT_HK,
        DEPARTMENT_ID       AS DEPARTMENT_BK,
        LOAD_TIMESTAMP,
        RECORD_SOURCE
    FROM source

)

{% if is_incremental() %}

SELECT nr.*
FROM new_records nr
LEFT JOIN {{ this }} existing ON nr.DEPARTMENT_HK = existing.DEPARTMENT_HK
WHERE existing.DEPARTMENT_HK IS NULL

{% else %}

SELECT * FROM new_records

{% endif %}
