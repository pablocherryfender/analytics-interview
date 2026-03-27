# Analytics Engineer — Technical Challenge

## Context

This repo implements a Data Vault 2.0 pipeline using dbt (plain SQL, no macros).

An AI agent onboarded the HR source tables `TBL_EMPLOYEE` and `TBL_DEPARTMENT` and generated all dbt models. The mapping YAMLs in `mappings/` are the ground truth — treat them as correct. The generated code in `models/` may not be.

**Your task**: Review the AI-generated output. Find all issues before this reaches production.

---

## Repo Overview

```
.ai/
  AGENTS.md                              — agent instructions, workflow, critical rules
  skills/qa-validator/SKILL.md           — QA validation skill

mappings/
  hr/TBL_EMPLOYEE.yml                    — source mapping (ground truth, no bugs)
  hr/TBL_DEPARTMENT.yml                  — source mapping (ground truth, no bugs)

models/
  staging/
    stg_employee.sql
    stg_department.sql
  raw_vault/
    hubs/
      hub_employee.sql
      hub_department.sql
    links/
      lnk_employee_department.sql
    satellites/
      sat_employee_details.sql
      sat_employee_contact.sql
      sat_department_info.sql
  consumer/
    dim_employee.sql

dbt_project.yml                          — project configuration
```

---

## Tasks

### Task 1 — Code Review

Review all files. For each issue:

1. **Where** — file and section
2. **What** — describe the problem clearly
3. **Why** — what fails in production because of this?
4. **Fix** — write the corrected code


### Task 2 — Reflection (15 min)

Answer briefly:

1. Review `.ai/AGENTS.md` and the generated models together. Identify any case where the generated code is consistent with the agent instructions but the instructions themselves are wrong. What does this tell you about AI-driven development workflows?
2. How would you set up a review process in a team to catch these issues before they reach production?

---

## What We Assess

- Data Vault 2.0 understanding (hubs, links, satellites, SCD2, hashdiff)
- dbt project conventions
- Ability to read and cross-reference documentation
- How you use AI — quality of prompts, ability to validate AI output

---

## Rules

- 25 minutes total
- No other AI tools
- No need to run any code — static review only
