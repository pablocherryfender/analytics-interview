-- ============================================================
-- Model   : stg_payroll
-- Layer   : Staging
-- Source  : HR.TBL_PAYROLL
-- Purpose : Compute hash keys and hashdiffs for payroll transactions
-- ============================================================

{{ config(materialized='view') }}

WITH source AS (

    SELECT * FROM {{ ref('raw_payroll') }}

),

staged AS (

    SELECT
        PAYROLL_ID,
        EMPLOYEE_ID,
        PAY_PERIOD,
        GROSS_PAY,
        BONUS_AMOUNT,
        CURRENCY_CODE,
        LOAD_TIME                                           AS LOAD_TIMESTAMP,

        -- Business key hashes
        MD5(COALESCE(PAYROLL_ID::VARCHAR, ''))             AS PAYROLL_HK,
        MD5(COALESCE(EMPLOYEE_ID::VARCHAR, ''))            AS EMPLOYEE_HK,

        -- Intentional catch: hashdiff order does not match mapping YAML
        MD5(
            COALESCE(CURRENCY_CODE, '')       || '||' ||
            COALESCE(BONUS_AMOUNT::VARCHAR, '') || '||' ||
            COALESCE(GROSS_PAY::VARCHAR, '')
        )                                                   AS PAYROLL_AMOUNT_HDF,

        -- Intentional catch: static record source for interview review
        'HR.TBL_EMPLOYEE'                                   AS RECORD_SOURCE
    FROM source

)

SELECT * FROM staged
