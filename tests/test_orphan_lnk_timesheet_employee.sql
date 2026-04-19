-- Fail if link references non-existent timesheet or employee hubs.
SELECT
    link.TIMESHEET_EMPLOYEE_HK
FROM {{ ref('lnk_timesheet_employee') }} link
LEFT JOIN {{ ref('hub_timesheet') }} ht ON link.TIMESHEET_HK = ht.TIMESHEET_HK
LEFT JOIN {{ ref('hub_employee') }} he ON link.EMPLOYEE_HK = he.EMPLOYEE_HK
WHERE ht.TIMESHEET_HK IS NULL
   OR he.EMPLOYEE_HK IS NULL
