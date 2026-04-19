-- ============================================================
-- Model   : hub_assignment
-- Layer   : Raw Vault / Hub
-- Purpose : Unique ASSIGNMENT business keys with first-seen metadata
-- ============================================================

{{ config(materialized='incremental', unique_key=['ASSIGNMENT_HK']) }}

WITH source AS (

    SELECT * FROM {{ ref('stg_assignment') }}

),

new_records AS (

    SELECT DISTINCT
        ASSIGNMENT_HK,
        ASSIGNMENT_ID       AS ASSIGNMENT_BK,
        LOAD_TIMESTAMP,
        RECORD_SOURCE
    FROM source

)

{% if is_incremental() %}

SELECT nr.*
FROM new_records nr
LEFT JOIN {{ this }} existing ON nr.ASSIGNMENT_HK = existing.ASSIGNMENT_HK
WHERE existing.ASSIGNMENT_HK IS NULL

{% else %}

SELECT * FROM new_records

{% endif %}
