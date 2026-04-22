-- Fail if mart fact emits negative total hours.
SELECT
    EMPLOYEE_ID,
    TOTAL_HOURS
FROM {{ ref('fct_timesheet_weekly') }}
WHERE TOTAL_HOURS < 0
