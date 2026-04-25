-- ============================================================
-- Model   : fct_project_capacity
-- Layer   : Information Mart / Fact
-- Purpose : Weekly project capacity and actual hours snapshot
-- ============================================================

{{ config(materialized='table') }}

WITH project_dim AS (
    SELECT
        PROJECT_HK,
        PROJECT_CODE,
        PROJECT_NAME
    FROM {{ ref('dim_project_current') }}
),
employee_project AS (
    SELECT
        PROJECT_HK,
        COUNT(DISTINCT EMPLOYEE_HK) AS ASSIGNED_EMPLOYEES,
        SUM(ALLOCATION_PCT) AS TOTAL_ALLOCATION_PCT
    FROM {{ ref('fct_employee_project_allocation') }}
    GROUP BY 1
),
timesheet_hours AS (
    SELECT
        PROJECT_HK,
        WEEK_START_DATE,
        SUM(HOURS_WORKED) AS REPORTED_HOURS
    FROM {{ ref('fct_timesheet_weekly') }}
    GROUP BY 1, 2
)

SELECT
    ts.WEEK_START_DATE,
    pd.PROJECT_CODE,
    pd.PROJECT_NAME,
    COALESCE(ep.ASSIGNED_EMPLOYEES, 0) AS ASSIGNED_EMPLOYEES,
    COALESCE(ep.TOTAL_ALLOCATION_PCT, 0) AS TOTAL_ALLOCATION_PCT,
    ts.REPORTED_HOURS,
    (COALESCE(ep.ASSIGNED_EMPLOYEES, 0) * 40) AS CAPACITY_HOURS
FROM timesheet_hours ts
LEFT JOIN project_dim pd
  ON ts.PROJECT_HK = pd.PROJECT_HK
LEFT JOIN employee_project ep
  ON ts.PROJECT_HK = ep.PROJECT_HK
