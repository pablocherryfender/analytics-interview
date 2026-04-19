# Candidate Hints (Fast Navigation)

Use this only if you are stuck.  
These are *directional hints*, not full answers.

## Where to look first

1. Start with mapping vs model alignment:
   - `mappings/hr/TBL_EMPLOYEE.yml`
   - `mappings/hr/TBL_PAYROLL.yml`
   - `models/staging/stg_employee.sql`
   - `models/staging/stg_payroll.sql`

2. Then check vault dependencies:
   - `models/raw_vault/satellites/sat_payroll_amounts.sql`
   - `models/raw_vault/links/lnk_payroll_employee.sql`
   - `models/raw_vault/hubs/hub_payroll.sql`

3. Finally review platform/config:
   - `profiles.snowflake.interview.yml`
   - `dbt_project.yml`
   - `.ai/AGENTS.md`

## Hints by category

### High severity hints (architecture/correctness)

- One staging model breaks a core project rule in `.ai/AGENTS.md`.
- One hashdiff expression order does not match mapping order.
- One satellite references a hashdiff column name that does not exist upstream.
- One mapping uses business/payload fields that are not in the actual source seed.

### Medium severity hints (performance/integrity)

- One staging model has incorrect lineage metadata (`RECORD_SOURCE`).
- One link naming convention is inconsistent between mapping and model file.
- Snowflake profile has at least one concurrency/cost anti-pattern.
- Snowflake profile has at least one environment isolation/security smell.

### Low severity hints (detail-level)

- One consumer model uses SQL syntax that is valid in Snowflake but should trigger portability discussion.
- One Snowflake session/query tagging choice can hurt observability hygiene in shared environments.

## Suggested review method

1. Compare each mapping field list to the SQL SELECT list and aliases.
2. Trace hash keys/hashdiff names from staging -> hub/link/satellite.
3. Validate that names are consistent across mapping, SQL, and model filenames.
4. Review Snowflake config from cost, security, and operations viewpoints.
