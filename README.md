# analytics-interview

Technical challenge for Analytics Engineer candidates.

See [CHALLENGE.md](CHALLENGE.md) for instructions.

## Stack

- dbt Core + dbt-duckdb (local, no cloud database required)
- Data Vault 2.0 (Hubs, Links, Satellites) — plain SQL, no macro libraries
- AI-driven development workflow (`.ai/` folder)
- Snowflake profile example for interview evaluation (`profiles.snowflake.interview.yml`)

## Local Setup (for interviewer validation)

```bash
pip install dbt-duckdb

dbt deps
dbt seed
dbt compile
dbt run
```

## Interview Assets

- `CHALLENGE.md`: candidate-facing task and evaluation goals.
- `CANDIDATE_HINTS.md`: optional navigation hints for faster issue discovery.
- `INTERVIEW_ISSUE_KEY.md`: interviewer answer key with 10 ranked issues.
- `profiles.snowflake.interview.yml`: intentionally flawed Snowflake configuration for review.
