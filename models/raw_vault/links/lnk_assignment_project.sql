-- ============================================================
-- Model   : lnk_assignment_project
-- Layer   : Raw Vault / Link
-- Purpose : Relationship between ASSIGNMENT and PROJECT entities
-- ============================================================

{{ config(materialized='incremental', unique_key=['ASSIGNMENT_PROJECT_HK']) }}

WITH source AS (

    SELECT * FROM {{ ref('stg_assignment') }}

),

new_records AS (

    SELECT DISTINCT
        MD5(ASSIGNMENT_HK || '||' || PROJECT_HK)  AS ASSIGNMENT_PROJECT_HK,
        ASSIGNMENT_HK,
        PROJECT_HK,
        LOAD_TIMESTAMP,
        RECORD_SOURCE
    FROM source

)

{% if is_incremental() %}

SELECT nr.*
FROM new_records nr
LEFT JOIN {{ this }} existing ON nr.ASSIGNMENT_PROJECT_HK = existing.ASSIGNMENT_PROJECT_HK
WHERE existing.ASSIGNMENT_PROJECT_HK IS NULL

{% else %}

SELECT * FROM new_records

{% endif %}
