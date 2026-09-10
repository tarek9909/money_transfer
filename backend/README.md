# Personal Money Tracker API

Node.js/TypeScript + Express REST API for the Personal Money Tracker.

## Local setup

1. Install MySQL Server 8+ directly on the host. Docker is not required.
2. Create the database and a dedicated local user, for example from a MySQL client:
   `CREATE DATABASE IF NOT EXISTS personal_money_tracker CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; CREATE USER IF NOT EXISTS 'money_tracker'@'127.0.0.1' IDENTIFIED BY 'change-me'; GRANT ALL PRIVILEGES ON personal_money_tracker.* TO 'money_tracker'@'127.0.0.1';`
3. Copy `.env.example` to `.env` and keep `DATABASE_HOST=127.0.0.1`.
4. For a disposable development database only, run `DB.SQL` with the MySQL CLI.
   It is a clean-install bootstrap and intentionally drops the listed tables.
   From PowerShell, while inside `backend`: `mysql -u root -p -e "source DB.SQL"`.
5. Run `npm install`, then `npm run migrate`.
6. Run `npm run dev`.

To exercise the live API contract against the configured MySQL database from
PowerShell:

```powershell
$env:RUN_LIVE_API = "1"
npm run test:live
Remove-Item Env:RUN_LIVE_API
```

The live test creates disposable users and removes them when it finishes. It
checks the JSON envelope, public-ID shape, decimal-string shape, ownership
isolation, and the complete `/api/v1` route groups.

If MySQL binary logging is enabled on a local instance, migration `003` may
require a migration administrator or this local-only setting before it creates
its invariant triggers:

```sql
SET GLOBAL log_bin_trust_function_creators = 1;
```

Do not use that setting as a production substitute for a properly privileged
release migration account.

Production must never execute `DB.SQL` against an existing database. Start from a
reviewed initial-schema baseline recorded as `001_initial`, then run append-only
numbered migrations with `npm run migrate`.

## API

The API is rooted at `/api/v1` and returns `{ success, data }` for success and
`{ success: false, message, code }` for failures. Access-token subjects and all
resource identifiers returned to clients are public UUIDs. Database DECIMAL values
are read and returned as strings; decimal.js is used for server-side arithmetic.

`/health` is intentionally outside the versioned API for deployment probes.

## Production checklist

- Set `NODE_ENV=production` and a randomly generated JWT secret of at least 32 bytes.
- Use a dedicated least-privilege MySQL user and TLS-protected MySQL connection.
- Terminate HTTPS at the load balancer/reverse proxy and restrict `CORS_ORIGINS`.
- Keep logs structured and redact authorization headers, passwords, and refresh tokens.
- Back up MySQL, test restoration, and run migrations as a release step.
- Do not enable `multipleStatements` for application queries.
