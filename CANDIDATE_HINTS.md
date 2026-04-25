# Candidate Hints (Fast Navigation)

Use this only if you are stuck.  
These are directional clues, not solutions.

## Start here

1. Compare mappings to staging SQL:
   - `mappings/hr/TBL_EMPLOYEE.yml`
   - `mappings/hr/TBL_PROJECT.yml`
   - `mappings/hr/TBL_ASSIGNMENT.yml`
   - `mappings/hr/TBL_TIMESHEET.yml`
   - `models/staging/stg_*.sql`

2. Then trace from staging into vault:
   - hubs: `models/raw_vault/hubs/*.sql`
   - links: `models/raw_vault/links/*.sql`
   - satellites: `models/raw_vault/satellites/*.sql`

3. Then inspect information mart:
   - `models/information_mart/*.sql`
   - verify grain, joins, and aggregation logic

4. Finally inspect tests and config:
   - `models/schema.yml`
   - `tests/*.sql`
   - `profiles.snowflake.interview.yml`
   - `.ai/AGENTS.md`
   - `ROLE_INTERVIEW_RUBRIC.md`

## High severity hints

- One staging model violates the materialization rule.
- At least one hashdiff uses the wrong column order versus mapping.
- At least one satellite references a hashdiff name that does not exist in its staging model.
- At least one seed-to-staging flow has key mismatches that cause runtime failure.

## Medium severity hints

- One stage has incorrect record source lineage metadata.
- At least one hub/link uses an invalid key source assumption.
- One model references a column that is not present in upstream source.
- At least one relationship path looks structurally right but semantically wrong.
- At least one mart model has grain or join logic that can silently duplicate measures.

## Low severity hints

- Naming consistency is not uniform across mappings, columns, and model names.
- Some tests are useful but incomplete for a production-grade DV project.
- Snowflake profile includes settings worth debating for cost/security/operations.
- At least one mart metric name does not perfectly match what it actually computes.

## Suggested method

1. Build a quick matrix: mapping field -> stage alias -> vault usage.
2. Validate each link has both foreign hash keys sourced correctly.
3. Check every satellite hashdiff field name end-to-end.
4. Confirm mart model grain and deduping logic before trusting KPI outputs.
5. Run targeted `dbt build --select ...` on one domain at a time.
