# QA Validator Skill

## Purpose

Run automated data quality checks after model generation. All checks execute SQL via dbt — no direct database access needed.

## When to Use

- After models are generated or modified
- On demand: "Validate TBL_EMPLOYEE" or "Run QA on hub_employee"
- Before promoting models to production

---

## Workflow

### Step 1: Identify Models

Confirm all models in the lineage exist:

```
Invoke: dbt_ls
Parameters: {"select": "+hub_employee+"}
```

Expected models:
- `stg_employee`
- `hub_employee`
- `sat_employee_details`
- `sat_employee_contact`
- `lnk_employee_department`

### Step 2: Execute Checks

For each check, run SQL via dbt:

```
Invoke: dbt_run
Parameters: {
  "sql_query": "SELECT COUNT(*) AS null_count FROM {{ ref('stg_employee') }} WHERE EMPLOYEE_HK IS NULL",
  "limit": 10
}
```

**Staging checks**
- Null hash keys
- Null hashdiffs
- Null business keys
- Null load timestamp

**Hub checks**
- Duplicate hash keys (hub must be unique)
- Null business keys

**Satellite checks**
- Orphan records (EMPLOYEE_HK not in hub_employee)
- Null hashdiff
- Duplicate hash key + load timestamp combinations

**Link checks**
- Orphan EMPLOYEE_HK (not in hub_employee)
- Orphan DEPARTMENT_HK (not in hub_department)

### Step 3: Report Results

```markdown
| Check | Model | Result | Detail |
|-------|-------|--------|--------|
| Null hash keys | stg_employee | PASS | 0 nulls |
| Duplicate keys | hub_employee | PASS | 0 duplicates |
| Orphan records | sat_employee_details | PASS | 0 orphans |
```

---

## Critical Rules

1. **ALWAYS use `dbt_run`** for SQL execution — never shell or direct DB access
2. **NEVER skip checks** — run all applicable checks even if early ones fail
3. **ALWAYS report warnings separately** from errors
4. **Use `limit: 10`** on queries returning rows (avoid large result sets)
5. **Do NOT modify data** — read-only validation only
6. **Run all layers** — staging, hubs, links, satellites, business vault
