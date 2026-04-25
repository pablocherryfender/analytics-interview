-- ============================================================
-- Model   : hub_project
-- Layer   : Raw Vault / Hub
-- Purpose : Unique PROJECT business keys with first-seen metadata
-- ============================================================

{{ config(materialized='incremental', unique_key=['PROJECT_HK']) }}

WITH source AS (

    SELECT * FROM {{ ref('stg_project') }}

),

new_records AS (

    SELECT DISTINCT
        PROJECT_HK,
        PROJECT_ID           AS PROJECT_BK,
        LOAD_TIMESTAMP,
        RECORD_SOURCE
    FROM source

)

{% if is_incremental() %}

SELECT nr.*
FROM new_records nr
LEFT JOIN {{ this }} existing ON nr.PROJECT_HK = existing.PROJECT_HK
WHERE existing.PROJECT_HK IS NULL

{% else %}

SELECT * FROM new_records

{% endif %}
