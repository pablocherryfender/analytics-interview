-- ============================================================
-- Model   : fct_timesheet_weekly
-- Layer   : Information Mart / Fact
-- Purpose : Weekly hours metrics by employee and project
-- ============================================================

{{ config(materialized='table') }}

WITH timesheet AS (
    SELECT
        th.TIMESHEET_HK,
        th.TIMESHEET_BK AS TIMESHEET_ID,
        sat.WORK_DATE,
        sat.HOURS_WORKED,
        sat.BILLABLE_FLAG
    FROM {{ ref('hub_timesheet') }} th
    LEFT JOIN {{ ref('sat_timesheet_hours') }} sat
      ON th.TIMESHEET_HK = sat.TIMESHEET_HK
    QUALIFY ROW_NUMBER() OVER (PARTITION BY th.TIMESHEET_HK ORDER BY sat.LOAD_TIMESTAMP DESC) = 1
),
employee AS (
    SELECT
        he.EMPLOYEE_HK,
        he.EMPLOYEE_BK AS EMPLOYEE_ID
    FROM {{ ref('hub_employee') }} he
),
project AS (
    SELECT
        hp.PROJECT_HK,
        hp.PROJECT_BK AS PROJECT_ID
    FROM {{ ref('hub_project') }} hp
),
lnk_employee AS (
    SELECT
        TIMESHEET_HK,
        EMPLOYEE_HK
    FROM {{ ref('lnk_timesheet_employee') }}
),
lnk_assignment AS (
    SELECT
        lta.TIMESHEET_HK,
        lap.PROJECT_HK
    FROM {{ ref('lnk_timesheet_assignment') }} lta
    LEFT JOIN {{ ref('lnk_assignment_project') }} lap
      ON lta.ASSIGNMENT_HK = lap.ASSIGNMENT_HK
)
SELECT
    t.TIMESHEET_ID,
    e.EMPLOYEE_ID,
    p.PROJECT_ID,
    t.WORK_DATE,
    t.HOURS_WORKED,
    t.BILLABLE_FLAG,
    CASE WHEN t.BILLABLE_FLAG = 'Y' THEN t.HOURS_WORKED ELSE 0 END AS BILLABLE_HOURS
FROM timesheet t
LEFT JOIN lnk_employee le
  ON t.TIMESHEET_HK = le.TIMESHEET_HK
LEFT JOIN employee e
  ON le.EMPLOYEE_HK = e.EMPLOYEE_HK
LEFT JOIN lnk_assignment la
  ON t.TIMESHEET_HK = la.TIMESHEET_HK
LEFT JOIN project p
  ON la.PROJECT_HK = p.PROJECT_HK
