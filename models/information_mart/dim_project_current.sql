-- ============================================================
-- Model   : dim_project_current
-- Layer   : Information Mart / Dimension
-- Purpose : Current-state project dimension
-- ============================================================

{{ config(materialized='table') }}

WITH hub AS (
    SELECT
        PROJECT_HK,
        PROJECT_BK,
        LOAD_TIMESTAMP AS FIRST_SEEN_AT
    FROM {{ ref('hub_project') }}
),
latest_project AS (
    SELECT
        PROJECT_HK,
        PROJECT_NAME,
        PROJECT_STATUS,
        START_DATE,
        END_DATE,
        BUDGET,
        LOAD_TIMESTAMP
    FROM {{ ref('sat_project_details') }}
    QUALIFY ROW_NUMBER() OVER (PARTITION BY PROJECT_HK ORDER BY LOAD_TIMESTAMP DESC) = 1
)

SELECT
    h.PROJECT_HK,
    h.PROJECT_BK AS PROJECT_ID,
    p.PROJECT_NAME,
    p.PROJECT_STATUS,
    p.START_DATE,
    p.END_DATE,
    p.BUDGET,
    h.FIRST_SEEN_AT
FROM hub h
LEFT JOIN latest_project p
  ON h.PROJECT_HK = p.PROJECT_HK
