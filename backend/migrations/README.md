# Database migrations

`backend/DB.SQL` is the reviewed initial schema and is a development/fresh-install
bootstrap only. It contains the intentional clean-install `DROP` statements and
must never be run against a production database with existing data.

Production deployments bootstrap a new database from an approved initial-schema
baseline, record version `001_initial`, and then run the numbered migrations with
`npm run migrate`. Migrations are immutable and append-only.

The first post-baseline migration is `002_schema_hardening.sql`, which documents
the timezone, currency-aware monthly plans, and hardened static occurrence rules.
`003_static_occurrence_invariants.sql` strengthens the status/terminal-field
invariants for installations created from an earlier baseline.
