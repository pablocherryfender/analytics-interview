# AGENTS.md

**Project**: analytics-interview — Data Vault 2.0 via dbt (plain SQL)

---

## Skills

One skill is available in `.ai/skills/`:

| Skill | Trigger | What it does |
|-------|---------|-------------|
| **qa-validator** | "Validate {TABLE}" | Automated data quality checks via dbt |

---

## Development Workflow

After generating or modifying dbt models:

1. `qa-validator` — run data quality checks
2. `dbt_build` — compile, run and test all models in DAG order
3. Promote to production once both pass

---

## dbt Tools

| Tool | Purpose | When to use |
|------|---------|-------------|
| `dbt_compile` | Validate SQL syntax without executing | Quick syntax check |
| `dbt_build` | Run + test models in DAG order | Full validation after code generation |
| `dbt_show` | Execute arbitrary SQL, return results | Data inspection, QA checks, debugging |
| `dbt_ls` | List project resources by selector | Finding models, checking what exists |

---

## Project Structure

```
models/
├── staging/          stg_* (views)        — hash keys, hashdiffs, metadata
├── raw_vault/
│   ├── hubs/         hub_* (incremental)  — business entity keys
│   ├── links/        lnk_* (incremental)  — relationships between entities
│   └── satellites/   sat_* (incremental)  — SCD2 attribute history
└── consumer/
    └── dim_* / fact_* (tables)            — consumption-ready models
```

---

## Critical Rules

1. Staging models are always materialized as **views** — never tables
2. Hashdiff MD5 column order in the staging model must **exactly match** the `hashdiff_columns` order defined in the mapping YAML — any mismatch silently breaks SCD2 change detection
3. Hub models store only the **first-seen** load timestamp — never update existing records, only insert new hash keys
4. Satellite models detect changes using the **hashdiff** — a new row is inserted only when the hashdiff changes
5. Link hash keys are MD5 of all **foreign hash keys concatenated in a consistent order** — order must be documented in the mapping

---

## Hashdiff Columns

The `hashdiff_columns` list in each mapping YAML defines the **exact column order** used when computing the MD5 hashdiff in the staging model:

```
hashdiff_columns: [col_a, col_b, col_c]
→ MD5(COALESCE(col_a,'') || '||' || COALESCE(col_b,'') || '||' || COALESCE(col_c,''))
```

If the staging model computes the MD5 with a different column order, the hashdiff values will not match existing satellite records — SCD2 will fire on every load, inserting a new row for every record even when nothing changed. This failure is silent: no error is raised.

Always cross-check `hashdiff_columns` in the mapping against the staging model SQL.

---

## Naming Conventions

| Layer | Prefix | Materialization |
|-------|--------|----------------|
| Staging | `stg_` | view |
| Hub | `hub_` | incremental |
| Link | `lnk_` | incremental |
| Satellite | `sat_` | incremental |
| Dimension | `dim_` | table |
| Fact | `fact_` | table |
