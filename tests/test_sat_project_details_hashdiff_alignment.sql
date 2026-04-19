-- Fails when sat_project_details hashdiff expression diverges from mapping intent.
WITH expected AS (
    SELECT
        PROJECT_HK,
        MD5(
            COALESCE(PROJECT_NAME, '') || '||' ||
            COALESCE(PROJECT_STATUS, '') || '||' ||
            COALESCE(BUDGET_AMOUNT::VARCHAR, '')
        ) AS EXPECTED_HDF
    FROM {{ ref('stg_project') }}
),
actual AS (
    SELECT
        PROJECT_HK,
        PROJECT_DETAILS_HDF
    FROM {{ ref('sat_project_details') }}
)
SELECT
    a.PROJECT_HK
FROM actual a
JOIN expected e
  ON a.PROJECT_HK = e.PROJECT_HK
WHERE a.PROJECT_DETAILS_HDF <> e.EXPECTED_HDF
