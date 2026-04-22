-- ============================================================
-- Model   : bridge_employee_assignment
-- Layer   : Information Mart / Bridge
-- Purpose : Resolve many-to-many employee-assignment-project paths
-- ============================================================

{{ config(materialized='table') }}

SELECT DISTINCT
    ep.EMPLOYEE_PROJECT_HK,
    ap.ASSIGNMENT_HK,
    ep.EMPLOYEE_HK,
    ep.PROJECT_HK
FROM {{ ref('lnk_employee_project') }} ep
LEFT JOIN {{ ref('lnk_assignment_project') }} ap
  ON ep.PROJECT_HK = ap.PROJECT_HK
