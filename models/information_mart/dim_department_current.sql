-- ============================================================
-- Model   : dim_department_current
-- Layer   : Information Mart / Dimension
-- Purpose : Current-state department dimension from vault
-- ============================================================

{{ config(materialized='table') }}

WITH hub AS (
    SELECT
        DEPARTMENT_HK,
        DEPARTMENT_BK AS DEPARTMENT_ID
    FROM {{ ref('hub_department') }}
),
latest_info AS (
    SELECT
        DEPARTMENT_HK,
        DEPARTMENT_NAME,
        MANAGER_NAME,
        LOCATION,
        LOAD_TIMESTAMP
    FROM {{ ref('sat_department_info') }}
    QUALIFY ROW_NUMBER() OVER (PARTITION BY DEPARTMENT_HK ORDER BY LOAD_TIMESTAMP DESC) = 1
)

SELECT
    h.DEPARTMENT_HK,
    h.DEPARTMENT_ID,
    i.DEPARTMENT_NAME,
    i.MANAGER_NAME,
    i.LOCATION,
    i.LOAD_TIMESTAMP AS SNAPSHOT_AT
FROM hub h
LEFT JOIN latest_info i
  ON h.DEPARTMENT_HK = i.DEPARTMENT_HK
