-- ============================================================
-- Model   : dim_employee_current
-- Layer   : Information Mart / Dimension
-- Purpose : Current employee profile with latest contact and department
-- ============================================================

{{ config(materialized='table') }}

WITH hub AS (
    SELECT
        EMPLOYEE_HK,
        EMPLOYEE_BK AS EMPLOYEE_ID,
        LOAD_TIMESTAMP AS FIRST_SEEN_AT
    FROM {{ ref('hub_employee') }}
),
latest_details AS (
    SELECT
        EMPLOYEE_HK,
        EMPLOYEE_NAME,
        JOB_TITLE,
        START_DATE,
        LOAD_TIMESTAMP
    FROM {{ ref('sat_employee_details') }}
    QUALIFY ROW_NUMBER() OVER (PARTITION BY EMPLOYEE_HK ORDER BY LOAD_TIMESTAMP DESC) = 1
),
latest_contact AS (
    SELECT
        EMPLOYEE_HK,
        EMAIL,
        PHONE,
        LOAD_TIMESTAMP
    FROM {{ ref('sat_employee_contact') }}
    QUALIFY ROW_NUMBER() OVER (PARTITION BY EMPLOYEE_HK ORDER BY LOAD_TIMESTAMP DESC) = 1
),
latest_dept_link AS (
    SELECT
        EMPLOYEE_HK,
        DEPARTMENT_HK,
        LOAD_TIMESTAMP
    FROM {{ ref('lnk_employee_department') }}
    QUALIFY ROW_NUMBER() OVER (PARTITION BY EMPLOYEE_HK ORDER BY LOAD_TIMESTAMP DESC) = 1
),
latest_dept AS (
    SELECT
        DEPARTMENT_HK,
        DEPARTMENT_NAME,
        LOAD_TIMESTAMP
    FROM {{ ref('sat_department_info') }}
    QUALIFY ROW_NUMBER() OVER (PARTITION BY DEPARTMENT_HK ORDER BY LOAD_TIMESTAMP DESC) = 1
)
SELECT
    h.EMPLOYEE_HK,
    h.EMPLOYEE_ID,
    h.FIRST_SEEN_AT,
    d.EMPLOYEE_NAME,
    d.JOB_TITLE,
    d.START_DATE,
    c.EMAIL,
    c.PHONE,
    dept.DEPARTMENT_NAME
FROM hub h
LEFT JOIN latest_details d ON h.EMPLOYEE_HK = d.EMPLOYEE_HK
LEFT JOIN latest_contact c ON h.EMPLOYEE_HK = c.EMPLOYEE_HK
LEFT JOIN latest_dept_link dl ON h.EMPLOYEE_HK = dl.EMPLOYEE_HK
LEFT JOIN latest_dept dept ON dl.DEPARTMENT_HK = dept.DEPARTMENT_HK
