-- ============================================================
-- Model   : fact_employee_payroll
-- Layer   : Consumer / Fact
-- Purpose : Payroll amounts by employee and pay period
-- ============================================================

{{ config(materialized='table') }}

WITH latest_payroll AS (

    SELECT
        pay.PAYROLL_HK,
        pay.PAYROLL_BK,
        sat.PAY_PERIOD,
        sat.GROSS_PAY,
        sat.BONUS_AMOUNT,
        sat.CURRENCY_CODE
    FROM {{ ref('hub_payroll') }} pay
    LEFT JOIN {{ ref('sat_payroll_amounts') }} sat
      ON pay.PAYROLL_HK = sat.PAYROLL_HK
    QUALIFY ROW_NUMBER() OVER (PARTITION BY pay.PAYROLL_HK ORDER BY sat.LOAD_TIMESTAMP DESC) = 1

),

employees AS (

    SELECT
        EMPLOYEE_HK,
        EMPLOYEE_BK AS EMPLOYEE_ID
    FROM {{ ref('hub_employee') }}

)

SELECT
    link.PAYROLL_EMPLOYEE_HK,
    lp.PAYROLL_BK AS PAYROLL_ID,
    emp.EMPLOYEE_ID,
    lp.PAY_PERIOD,
    lp.GROSS_PAY,
    lp.BONUS_AMOUNT,
    lp.CURRENCY_CODE,
    lp.GROSS_PAY + COALESCE(lp.BONUS_AMOUNT, 0) AS TOTAL_COMPENSATION
FROM {{ ref('lnk_payroll_employee') }} link
LEFT JOIN latest_payroll lp
  ON link.PAYROLL_HK = lp.PAYROLL_HK
LEFT JOIN employees emp
  ON link.EMPLOYEE_HK = emp.EMPLOYEE_HK
