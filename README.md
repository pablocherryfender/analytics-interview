# analytics-interview

Technical challenge for Analytics Engineer candidates.

See [CHALLENGE.md](CHALLENGE.md) for instructions.

## Stack

- dbt Core + dbt-duckdb (local, no cloud database required)
- Data Vault 2.0 (Hubs, Links, Satellites) — plain SQL, no macro libraries
- AI-driven development workflow (`.ai/` folder)

## Setup (optional — not required for the challenge)

```bash
pip install dbt-duckdb

dbt deps
dbt seed
dbt compile
dbt run
```
