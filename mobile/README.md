# Personal Money Tracker Android app

Android client built with Flutter, Riverpod, Dio, go_router,
flutter_secure_storage, and shared_preferences. Sensitive access/refresh tokens
are kept in secure storage; preferences are server-backed and can be cached
locally without storing credentials.

The API client unwraps the `{ success, data }` envelope, maps backend error
codes to typed exceptions, refreshes access tokens once after a 401, and keeps
money as `Decimal` values. Freezed/json_serializable models are generated with:

```text
dart run build_runner build
```

Transaction history uses offset pagination for infinite scrolling. Dashboard
summaries, balances, and allowances stay grouped by `currencyCode`; transfers
and recurring-expense payments use the backend's UUID-based resource routes.

This repository targets Android. The dashboard is the in-app Home screen backed
by the REST API; this project does not provide a web dashboard.

Run on the Android emulator against the local API with:

```text
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1
```

For a physical Android device, replace `10.0.2.2` with the computer's LAN IP
address and keep the device and computer on the same network. Local HTTP is for
development only; production builds must use an HTTPS API URL and Android release
signing configuration.
For local APK verification without a keystore, the release build is intentionally
unsigned. Production CI should provide `MONEY_TRACKER_RELEASE_STORE_FILE`,
`MONEY_TRACKER_RELEASE_STORE_PASSWORD`, `MONEY_TRACKER_RELEASE_KEY_ALIAS`, and
`MONEY_TRACKER_RELEASE_KEY_PASSWORD` as Gradle properties.

Build the Android release APK with:

```text
flutter build apk --release --dart-define=API_BASE_URL=https://api.example.com/api/v1
```
