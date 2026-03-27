-- ============================================================
-- Model   : dim_employee
-- Layer   : Consumer / Dimension
-- Purpose : Current-state employee dimension joining hub + satellites
-- ============================================================

{{ config(materialized='table') }}

WITH hub AS (

    SELECT
        EMPLOYEE_HK,
        EMPLOYEE_BK,
        LOAD_TIMESTAMP  AS FIRST_SEEN_AT,
        RECORD_SOURCE
    FROM {{ ref('hub_employee') }}

),

details AS (

    SELECT
        EMPLOYEE_HK,
        EMPLOYEE_NAME,
        JOB_TITLE,
        START_DATE,
        LOAD_TIMESTAMP
    FROM {{ ref('sat_employee_details') }}
    QUALIFY ROW_NUMBER() OVER (PARTITION BY EMPLOYEE_HK ORDER BY LOAD_TIMESTAMP DESC) = 1

),

contact AS (

    SELECT
        EMPLOYEE_HK,
        EMAIL,
        PHONE,
        LOAD_TIMESTAMP
    FROM {{ ref('sat_employee_contact') }}
    QUALIFY ROW_NUMBER() OVER (PARTITION BY EMPLOYEE_HK ORDER BY LOAD_TIMESTAMP DESC) = 1

),

department AS (

    SELECT
        EMPLOYEE_HK,
        DEPARTMENT_HK,
        LOAD_TIMESTAMP
    FROM {{ ref('lnk_employee_department') }}
    QUALIFY ROW_NUMBER() OVER (PARTITION BY EMPLOYEE_HK ORDER BY LOAD_TIMESTAMP DESC) = 1

),

dept_info AS (

    SELECT
        DEPARTMENT_HK,
        DEPARTMENT_NAME,
        LOAD_TIMESTAMP
    FROM {{ ref('sat_department_info') }}
    QUALIFY ROW_NUMBER() OVER (PARTITION BY DEPARTMENT_HK ORDER BY LOAD_TIMESTAMP DESC) = 1

)

SELECT
    hub.EMPLOYEE_HK,
    hub.EMPLOYEE_BK         AS EMPLOYEE_ID,
    hub.FIRST_SEEN_AT,
    details.EMPLOYEE_NAME,
    details.JOB_TITLE,
    details.START_DATE,
    contact.EMAIL,
    contact.PHONE,
    dept_info.DEPARTMENT_NAME
FROM hub
LEFT JOIN details     ON hub.EMPLOYEE_HK        = details.EMPLOYEE_HK
LEFT JOIN contact     ON hub.EMPLOYEE_HK        = contact.EMPLOYEE_HK
LEFT JOIN department  ON hub.EMPLOYEE_HK        = department.EMPLOYEE_HK
LEFT JOIN dept_info   ON department.DEPARTMENT_HK = dept_info.DEPARTMENT_HK
