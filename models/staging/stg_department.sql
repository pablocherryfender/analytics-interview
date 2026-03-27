-- ============================================================
-- Model   : stg_department
-- Layer   : Staging
-- Source  : HR.TBL_DEPARTMENT
-- Purpose : Compute hash keys and hashdiffs for the DEPARTMENT entity
-- ============================================================

{{ config(materialized='view') }}

WITH source AS (

    SELECT * FROM {{ ref('TBL_DEPARTMENT') }}

),

staged AS (

    SELECT

        -- Business key
        DEPARTMENT_ID,

        -- Hash key: DEPARTMENT entity
        MD5(
            COALESCE(DEPARTMENT_ID::VARCHAR, '')
        )                                               AS DEPARTMENT_HK,

        -- Hashdiff: sat_department_info
        MD5(
            COALESCE(DEPARTMENT_NAME, '')   || '||' ||
            COALESCE(MANAGER_NAME, '')      || '||' ||
            COALESCE(LOCATION, '')
        )                                               AS DEPARTMENT_INFO_HDF,

        -- Payload
        DEPARTMENT_NAME,
        MANAGER_NAME,
        LOCATION,

        -- Metadata
        LOAD_TIME                                       AS LOAD_TIMESTAMP,
        'HR.TBL_DEPARTMENT'                             AS RECORD_SOURCE

    FROM source

)

SELECT * FROM staged
