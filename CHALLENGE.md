# Analytics Engineer — Data Vault Interview Challenge

## Context

This repository is a **pure Data Vault 2.0** dbt project:

- `staging` models for hash keys, hashdiffs, and metadata
- `raw_vault` hubs, links, satellites only (no marts/consumer layer)

The implementation was AI-generated and intentionally includes realistic problems.  
Your task is to review quality, correctness, and operational readiness.

## Scope

- 20+ dbt models across multiple source domains (`employee`, `department`, `project`, `assignment`, `timesheet`)
- mapping YAML files in `mappings/hr/` as source-of-truth intent
- local DuckDB execution profile
- Snowflake review profile with intentional configuration concerns

## Tasks

### Task 1 — Identify 10 issues

Find **exactly 10 issues** and group them by severity:

- **High**: architecture/correctness/data integrity
- **Medium**: maintainability/performance/lineage quality
- **Low**: implementation detail, consistency, platform nuance

For each issue, include:

1. where (file + section)
2. what (problem)
3. impact (why it matters)
4. fix (specific change)

### Task 2 — Validate tests and model graph

Review `models/schema.yml` and singular tests under `tests/`:

- Which tests are useful?
- Which important tests are missing?
- Which tests may fail for the wrong reason?

### Task 3 — Snowflake and AI workflow review

Review `profiles.snowflake.interview.yml` and `.ai/AGENTS.md`:

- identify Snowflake anti-patterns or risky defaults
- identify where AI workflow guidance is insufficient
- propose minimum release gates for AI-generated dbt changes

## Candidate hint option

If you are stuck, use `CANDIDATE_HINTS.md` for directional pointers only.

## Rules

- no external AI tools
- static review is acceptable; running dbt is optional
