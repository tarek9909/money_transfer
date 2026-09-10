# Personal Money Tracker

End-to-end personal finance tracker with an Android Flutter client and a
TypeScript/Express/MySQL API.

## Repository layout

- [`backend/`](backend/README.md) — REST API, schema bootstrap, migrations, tests.
- [`mobile/`](mobile/README.md) — Flutter/Riverpod client and tests.
- Local MySQL Server is used directly; Docker is not required.

## Development

Install MySQL Server 8+ locally, create the `personal_money_tracker` database and
the least-privilege user described in [`backend/README.md`](backend/README.md),
then configure `backend/.env`. Run the development-only `backend/DB.SQL` bootstrap,
then `npm run migrate` and `npm run dev` from `backend/`.

Run the checks:

```text
cd backend
npm run build
npm test

cd ../mobile
flutter analyze
flutter test
flutter build apk --release --dart-define=API_BASE_URL=https://api.example.com/api/v1
```

Production builds must provide a real HTTPS API URL, release signing, a secure
production JWT secret, a least-privilege database user, backups, and append-only
migrations. Never run the clean-install SQL against production data.
# money_transfer
