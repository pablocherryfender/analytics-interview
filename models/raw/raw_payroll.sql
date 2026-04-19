-- ============================================================
-- Model   : raw_payroll
-- Layer   : Raw
-- Source  : HR.TBL_PAYROLL
-- Purpose : Lightweight source projection used by staging models
-- ============================================================

{{ config(materialized='view') }}

SELECT
    PAYROLL_ID,
    EMPLOYEE_ID,
    PAY_PERIOD,
    GROSS_PAY,
    BONUS_AMOUNT,
    CURRENCY_CODE,
    LOAD_TIME
FROM {{ ref('TBL_PAYROLL') }}
