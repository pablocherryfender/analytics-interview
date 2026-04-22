# Multi-Role Interview Rubric

This repository can be used for multiple interview tracks against the same codebase.

## Tracks

### 1) Analytics Engineer / dbt Developer

Focus:
- SQL correctness
- model dependency tracing
- Data Vault implementation fidelity
- test quality and failure analysis

Expected output:
- identify concrete model/test defects
- propose SQL-level fixes
- explain blast radius and validation plan

### 2) Analytics Architect / Data Platform Architect

Focus:
- architecture boundaries (staging, vault, mart)
- governance, lineage, and semantic contracts
- Snowflake operating model (cost/security/performance)
- AI-native SDLC controls and release gates

Expected output:
- prioritize risks by production impact
- propose target-state architecture and controls
- define role boundaries and operating standards

## Issue grading by role

Use this matrix while evaluating candidate answers.

| Level | Developer interview signal | Architect interview signal |
|------|------------------------------|----------------------------|
| High | runtime failures, wrong columns, bad joins, hashdiff mismatches, broken references | cross-layer contract breaks, model ownership gaps, release-risk defects, governance/security issues |
| Medium | incremental logic defects, inconsistent naming, weak tests, lineage metadata mistakes | domain boundary drift, missing standards, weak observability and quality strategy |
| Low | style, naming consistency, test ergonomics, minor portability caveats | documentation quality, process gaps, optimization opportunities |

## Developer-level question bank

1. Which models fail first in `dbt build`, and why?
2. Show one end-to-end hashdiff path (mapping -> staging -> satellite). Where can it silently fail?
3. Which tests in `models/schema.yml` are valuable, and which are misleading?
4. Identify one link model where keys are structurally valid but semantically questionable.
5. Propose a minimal fix set to make one domain (`project` or `timesheet`) build-clean.
6. Which mart model introduces a correctness risk due to join assumptions?
7. What additional data tests would you add before production?
8. Which issue is likely to pass compile but fail data integrity in production?

## Architect-level question bank

1. Is this layering strategy (staging + raw vault + information mart) coherent? What is missing?
2. Which defects should block release immediately, and who owns each fix?
3. How would you define data contracts between source mappings and dbt models?
4. How would you redesign CI gates to detect the planted errors automatically?
5. What Snowflake role/schema/warehouse strategy would you enforce for dev/test/prod?
6. How would you separate responsibilities between analytics engineers and platform engineers?
7. What AI-governance controls are mandatory before allowing generated SQL into main?
8. How would you measure quality drift over time across vault and mart layers?

## Suggested scoring

### Developer interview (100 points)
- 40 pts: defect identification accuracy
- 30 pts: fix quality (SQL and tests)
- 20 pts: reasoning and impact analysis
- 10 pts: communication clarity

### Architect interview (100 points)
- 35 pts: architectural diagnosis quality
- 25 pts: prioritization and risk framing
- 25 pts: operating model / governance proposal
- 15 pts: pragmatic rollout plan

## Pass indicators

Developer:
- finds multiple root-cause defects without overfitting to symptoms
- uses test evidence and model graph correctly
- proposes realistic, minimal, verifiable fixes

Architect:
- distinguishes implementation bugs from systemic process failures
- proposes enforceable controls, not abstract principles only
- aligns Snowflake ops, dbt standards, and AI workflow into one delivery model
