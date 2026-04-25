# Analytics Engineering Interviews — Multi-Role Challenge

## Context

This repository is a dbt project with:

- `staging` models for hash keys, hashdiffs, and metadata
- `raw_vault` hubs, links, satellites
- `information_mart` dimensional/reporting layer for BI consumption

The implementation was AI-generated and intentionally includes realistic problems across data modeling, dbt engineering, and architecture concerns.  
Your task is to review quality, correctness, and operational readiness.

## Scope

- 25+ dbt models across multiple source domains (`employee`, `department`, `project`, `assignment`, `timesheet`)
- mapping YAML files in `mappings/hr/` as source-of-truth intent
- local DuckDB execution profile
- Snowflake review profile with intentional configuration concerns

## Tasks

### Task 1 — Identify 10 issues (role-aware)

Find **exactly 10 issues** and group them by severity:

- **High**: architecture/correctness/data integrity
- **Medium**: maintainability/performance/lineage quality
- **Low**: implementation detail, consistency, platform nuance

For each issue, include:

1. where (file + section)
2. what (problem)
3. impact (why it matters)
4. fix (specific change)

Also tag each issue with:

- **Developer-level** (model/test/sql implementation review), or
- **Architect-level** (platform, governance, operating model, cross-domain design)

### Task 2 — Validate tests and model graph

Review `models/schema.yml` and singular tests under `tests/`:

- Which tests are useful?
- Which important tests are missing?
- Which tests may fail for the wrong reason?
- Which tests belong to developer responsibility vs architecture ownership?

### Task 3 — Snowflake and AI workflow review

Review `profiles.snowflake.interview.yml` and `.ai/AGENTS.md`:

- identify Snowflake anti-patterns or risky defaults
- identify where AI workflow guidance is insufficient
- propose minimum release gates for AI-generated dbt changes

### Task 4 — Information Mart review

Review `models/information_mart/` and answer:

- Is dimensional grain clearly defined for each fact?
- Do mart joins create duplication or correctness risk?
- Are SCD/current-state assumptions explicit and safe?
- Which mart concerns are developer-level vs architect-level?

## Candidate hint option

If you are stuck, use `CANDIDATE_HINTS.md` for directional pointers only.
Interviewers should grade with `ROLE_INTERVIEW_RUBRIC.md`.

## Rules

- no external AI tools
- static review is acceptable; running dbt is optional
