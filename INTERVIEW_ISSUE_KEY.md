# Interview issue key (for reviewers)

Use this guide to evaluate whether a candidate can identify architectural, platform, and modeling issues in an AI-generated dbt/Data Vault codebase.

## High severity (architecture, correctness)

1. `stg_employee.sql` violates project rule by using `materialized='table'` instead of a staging view.
2. `stg_employee.sql` hashdiff order for `EMPLOYEE_DETAILS_HDF` does not match mapping order in `mappings/hr/TBL_EMPLOYEE.yml`.
3. `models/raw_vault/satellites/sat_payroll_amounts.sql` references `PAYROLL_AMOUNTS_HDF`, but upstream stage creates `PAYROLL_AMOUNT_HDF`.
4. `mappings/hr/TBL_PAYROLL.yml` uses non-existent source business keys (`PAYROLL_EVENT_ID`, `BASE_SALARY`, `EFFECTIVE_DATE`) that conflict with seed/model columns.

## Medium severity (performance, integrity, maintainability)

5. `models/staging/stg_payroll.sql` hard-codes `RECORD_SOURCE` as `'HR.TBL_EMPLOYEE'` instead of payroll source lineage.
6. `mappings/hr/TBL_PAYROLL.yml` link name (`lnk_employee_payroll`) disagrees with model file (`lnk_payroll_employee.sql`), creating lineage ambiguity.
7. `profiles.snowflake.interview.yml` uses `threads: 32` for interview scale and likely small warehouse, a common cost/perf anti-pattern.
8. `profiles.snowflake.interview.yml` runs in `PUBLIC` schema with broad `ANALYST` role; weak environment isolation for dev/test interview exercises.

## Low severity (detail-level, cross-platform awareness)

9. `models/consumer/fact_employee_payroll.sql` depends on `QUALIFY`; while valid on Snowflake, this should trigger discussion of adapter portability (DuckDB/Postgres differences).
10. `profiles.snowflake.interview.yml` sets `client_session_keep_alive: true` and a static `query_tag`; both reduce operational hygiene and make cost attribution less useful in shared Snowflake environments.

## AI-native workflow issues to probe

- There is no model-level YAML for tests/docs in `models/**`, despite substantial SQL growth.
- The repo includes mappings and instructions, but no automated check ensuring staging hashdiff expressions align to mapping `hashdiff_columns`.
- Generated code comments identify intentional catches, but there is no CI gate for such markers (e.g., no lint rule, no pre-commit check, no PR template checklist).
