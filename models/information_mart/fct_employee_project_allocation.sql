-- ============================================================
-- Model   : fct_employee_project_allocation
-- Layer   : Information Mart / Fact
-- Purpose : Current employee-project assignment allocation facts
-- ============================================================

{{ config(materialized='table') }}

WITH latest_ctx AS (
    SELECT
        EMPLOYEE_PROJECT_HK,
        ROLE_CODE,
        ALLOCATION_PCT,
        LOAD_TIMESTAMP
    FROM {{ ref('sat_employee_assignment_context') }}
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY EMPLOYEE_PROJECT_HK
        ORDER BY LOAD_TIMESTAMP DESC
    ) = 1
),
bridge AS (
    SELECT
        l.EMPLOYEE_PROJECT_HK,
        he.EMPLOYEE_BK  AS EMPLOYEE_ID,
        hp.PROJECT_BK   AS PROJECT_ID
    FROM {{ ref('lnk_employee_project') }} l
    LEFT JOIN {{ ref('hub_employee') }} he ON l.EMPLOYEE_HK = he.EMPLOYEE_HK
    LEFT JOIN {{ ref('hub_project') }} hp ON l.PROJECT_HK = hp.PROJECT_HK
)

SELECT
    b.EMPLOYEE_PROJECT_HK,
    b.EMPLOYEE_ID,
    b.PROJECT_ID,
    c.ROLE_CODE,
    c.ALLOCATION_PCT
FROM bridge b
LEFT JOIN latest_ctx c
  ON b.EMPLOYEE_PROJECT_HK = c.EMPLOYEE_PROJECT_HK
