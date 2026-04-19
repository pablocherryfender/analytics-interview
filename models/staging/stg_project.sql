-- ============================================================
-- Model   : stg_project
-- Layer   : Staging
-- Source  : HR.TBL_PROJECT
-- Purpose : Compute hash keys and hashdiffs for PROJECT entity
-- ============================================================

{{ config(materialized='view') }}

WITH source AS (

    SELECT * FROM {{ ref('TBL_PROJECT') }}

),

staged AS (

    SELECT
        PROJECT_ID,
        PROJECT_NAME,
        CLIENT_NAME,
        START_DATE,
        END_DATE,
        PROJECT_STATUS,
        LOAD_TIME AS LOAD_TIMESTAMP,

        MD5(COALESCE(PROJECT_ID::VARCHAR, '')) AS PROJECT_HK,

        MD5(
            COALESCE(PROJECT_NAME, '') || '||' ||
            COALESCE(CLIENT_NAME, '') || '||' ||
            COALESCE(START_DATE::VARCHAR, '') || '||' ||
            COALESCE(END_DATE::VARCHAR, '') || '||' ||
            COALESCE(PROJECT_STATUS, '')
        ) AS PROJECT_INFO_HDF,

        'HR.TBL_PROJECT' AS RECORD_SOURCE
    FROM source

)

SELECT * FROM staged
