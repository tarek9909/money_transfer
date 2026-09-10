# Complete Application Gaps Analysis (A to Z)

This document provides a comprehensive audit of all architectural, financial ledger, security, data integrity, runtime stability, and user-flow gaps identified across the Personal Money Tracker application (MySQL schema, Node.js/Express backend, and Flutter mobile client).

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Category A: Financial Calculation & Ledger Integrity Gaps](#2-category-a-financial-calculation--ledger-integrity-gaps)
   - [Gap 1: Double Subtraction in Daily Allowance Calculation](#gap-1-double-subtraction-in-daily-allowance-calculation)
   - [Gap 2: Negative Wallet Balance Guard Bypassed on Income Reduction](#gap-2-negative-wallet-balance-guard-bypassed-on-income-reduction)
   - [Gap 3: Negative Wallet Balance Guard Bypassed on Voiding Income and Transfers](#gap-3-negative-wallet-balance-guard-bypassed-on-voiding-income-and-transfers)
   - [Gap 4: Wallet Balance View Excludes Archived Wallets](#gap-4-wallet-balance-view-excludes-archived-wallets)
3. [Category B: Authentication, Session & Security Gaps](#3-category-b-authentication-session--security-gaps)
   - [Gap 5: Silent Session Expiry Without Navigation Redirect](#gap-5-silent-session-expiry-without-navigation-redirect)
   - [Gap 6: Dart Operator Precedence Bug in HTTP Refresh Guard](#gap-6-dart-operator-precedence-bug-in-http-refresh-guard)
   - [Gap 7: Missing Profile, Password & Account Self-Service Endpoints](#gap-7-missing-profile-password--account-self-service-endpoints)
   - [Gap 8: Absence of Brute-Force Rate Limiting on Auth Endpoints](#gap-8-absence-of-brute-force-rate-limiting-on-auth-endpoints)
4. [Category C: Missing Feature Flows & Unreachable Backend Endpoints](#4-category-c-missing-feature-flows--unreachable-backend-endpoints)
   - [Gap 9: Transfer History & Voiding Unreachable in Mobile Client](#gap-9-transfer-history--voiding-unreachable-in-mobile-client)
   - [Gap 10: Recurring Expense Template Management Unreachable](#gap-10-recurring-expense-template-management-unreachable)
   - [Gap 11: Account and Wallet Editing Unreachable](#gap-11-account-and-wallet-editing-unreachable)
   - [Gap 12: Income Category Management Inaccessible](#gap-12-income-category-management-inaccessible)
   - [Gap 13: Financial Month Start Preference is Completely Ignored](#gap-13-financial-month-start-preference-is-completely-ignored)
5. [Category D: Flutter Runtime Stability & Crash Risks](#5-category-d-flutter-runtime-stability--crash-risks)
   - [Gap 14: DropdownButton Assertion Crash on Archived Categories/Wallets](#gap-14-dropdownbutton-assertion-crash-on-archived-categorieswallets)
   - [Gap 15: Tab Controller Reinitialization on Dashboard Rebuild](#gap-15-tab-controller-reinitialization-on-dashboard-rebuild)
   - [Gap 16: Dialog Dismissal Prior to Asynchronous API Completion](#gap-16-dialog-dismissal-prior-to-asynchronous-api-completion)
   - [Gap 17: Unhandled Asynchronous Exceptions in Category Sheet](#gap-17-unhandled-asynchronous-exceptions-in-category-sheet)
6. [Category E: UI/UX & Data Integrity Gaps](#6-category-e-uiux--data-integrity-gaps)
   - [Gap 18: Raw Entity UUID Rendered on Recurring Expense Cards](#gap-18-raw-entity-uuid-rendered-on-recurring-expense-cards)
   - [Gap 19: Dead SharedPreferences Persistence on Home Dashboard](#gap-19-dead-sharedpreferences-persistence-on-home-dashboard)
   - [Gap 20: User Default Account and Wallet Preferences Ignored](#gap-20-user-default-account-and-wallet-preferences-ignored)
   - [Gap 21: Immediate Transaction Voiding on Swipe Without Confirmation](#gap-21-immediate-transaction-voiding-on-swipe-without-confirmation)
   - [Gap 22: Race Condition and False Error Snackbars on Recurring Expense Actions](#gap-22-race-condition-and-false-error-snackbars-on-recurring-expense-actions)
   - [Gap 23: Cash vs. Whish Breakdown Hidden on Dashboard](#gap-23-cash-vs-whish-breakdown-hidden-on-dashboard)
   - [Gap 24: Disconnected Month State Across Navigation Tabs](#gap-24-disconnected-month-state-across-navigation-tabs)
   - [Gap 25: Untyped Map Payloads Bypassing Freezed Request Models](#gap-25-untyped-map-payloads-bypassing-freezed-request-models)
7. [Comprehensive Summary Matrix](#7-comprehensive-summary-matrix)
8. [Prioritized Remediation Roadmap](#8-prioritized-remediation-roadmap)

---

## 1. Executive Summary

A comprehensive architectural and code-level audit was conducted across the entire money tracking ecosystem:
* **Database**: [backend/DB.SQL](file:///c:/Projects/money_tracker/backend/DB.SQL)
* **Backend API**: [backend/src/app.ts](file:///c:/Projects/money_tracker/backend/src/app.ts), [backend/src/financial.ts](file:///c:/Projects/money_tracker/backend/src/financial.ts)
* **Mobile Client**: [mobile/lib/](file:///c:/Projects/money_tracker/mobile/lib/)

The foundation is built on solid architectural principles: strict `DECIMAL(18,2)` database precision, multi-tenant row isolation via triggers, JWT access/refresh token rotation, and clean Dart models with `Decimal`. However, **25 distinct gaps** were identified across financial calculations, session lifecycle management, UI flows, and runtime stability that must be resolved to achieve production readiness.

---

## 2. Category A: Financial Calculation & Ledger Integrity Gaps

### Gap 1: Double Subtraction in Daily Allowance Calculation
* **Severity**: Critical (Financial Logic Error)
* **Affected Files**: 
  - [backend/src/financial.ts:L26-L40](file:///c:/Projects/money_tracker/backend/src/financial.ts#L26-L40)
  - [backend/src/app.ts:L633-L675](file:///c:/Projects/money_tracker/backend/src/app.ts#L633-L675)
* **Description**:
  In `allowanceSummary`, `usedRow` sums all dynamic spending for the entire month (which already includes `spentToday`).
  `allowanceRemaining` is calculated as `monthlyAllowance - used`.
  When `calculateDailyAllowance` is invoked:
  ```typescript
  const dailyAllowance = Decimal.max(allowanceRemaining, ZERO).div(remainingDays).toDecimalPlaces(2);
  return {
    dailyAllowance,
    remainingToday: dailyAllowance.minus(todaySpending).toDecimalPlaces(2), // <--- SUBTRACTED A SECOND TIME
    remainingDays,
  };
  ```
* **Impact**:
  Today's dynamic spending is subtracted **twice**: first inside `allowanceRemaining`, and then again from `dailyAllowance`.
  *Concrete Example*: If a user has an $800 allowance over 30 days and spends exactly their daily target ($20) on Day 1:
  - `used` = $20
  - `allowanceRemaining` = $780
  - `dailyAllowance` drops to $780 / 30 = $26.00
  - `remainingToday` evaluates to $26.00 - $20.00 = $6.00 instead of $0.00.
  Conversely, if remaining allowance was already depleted to $20 for the day, spending $20 produces a negative `remainingToday` of -$19.33.
* **Remediation**:
  Calculate `dailyAllowance` from `allowanceRemainingAtStartOfDay = allowanceRemaining + todaySpending`, then subtract `todaySpending` once to determine `remainingToday`.

---

### Gap 2: Negative Wallet Balance Guard Bypassed on Income Reduction
* **Severity**: High (Ledger Invariant Violation)
* **Affected Files**: 
  - [backend/src/app.ts:L1874-L1890](file:///c:/Projects/money_tracker/backend/src/app.ts#L1874-L1890)
* **Description**:
  In `PATCH /api/v1/transactions/:transactionId`, the condition guarding against negative balances is:
  ```typescript
  if (
    (old.transaction_type !== "MAIN_INCOME" && old.transaction_type !== "ADDITIONAL_INCOME") ||
    (type !== "MAIN_INCOME" && type !== "ADDITIONAL_INCOME")
  ) {
    await ensureWalletNotNegative(conn, user.userInternalId, String(old.wallet_id));
    ...
  }
  ```
  If both `old.transaction_type` and new `type` are `MAIN_INCOME`, the check evaluates to `false` and is skipped entirely.
* **Impact**:
  A user who records $5,000 salary and spends $4,500 (leaving $500 balance) can edit the salary transaction down to $500. The wallet balance drops to **-$4,000**, completely bypassing the `allowNegativeWallets = false` invariant.
* **Remediation**:
  Execute `ensureWalletNotNegative` on the wallet whenever the net adjustment reduces the wallet balance.

---

### Gap 3: Negative Wallet Balance Guard Bypassed on Voiding Income and Transfers
* **Severity**: High (Ledger Invariant Violation)
* **Affected Files**: 
  - [backend/src/app.ts:L1915-L1953](file:///c:/Projects/money_tracker/backend/src/app.ts#L1915-L1953) (`DELETE /transactions/:id`)
  - [backend/src/app.ts:L2655-L2696](file:///c:/Projects/money_tracker/backend/src/app.ts#L2655-L2696) (`DELETE /transfers/:id`)
* **Description**:
  Neither transaction voiding nor transfer voiding calls `ensureWalletNotNegative`.
* **Impact**:
  1. A user receives $1,000 income, spends $950, and then voids the $1,000 income transaction. The wallet balance drops to **-$950**.
  2. A transfer of $500 moves from Wallet A to Wallet B. Wallet B spends the $500. The user voids the transfer. Wallet B is debited $500, resulting in **-$500**.
* **Remediation**:
  Before committing the void operation, verify `ensureWalletNotNegative` on any wallet being debited.

---

### Gap 4: Wallet Balance View Excludes Archived Wallets
* **Severity**: Medium (Historical Balance Data Loss)
* **Affected Files**: 
  - [backend/DB.SQL:L1289-L1290](file:///c:/Projects/money_tracker/backend/DB.SQL#L1289-L1290)
  - [backend/src/app.ts:L1303-L1312](file:///c:/Projects/money_tracker/backend/src/app.ts#L1303-L1312)
* **Description**:
  The view definition in `DB.SQL` ends with:
  ```sql
  CREATE VIEW v_wallet_balances AS ... WHERE w.is_active = 1;
  ```
* **Impact**:
  Once a wallet is archived (`is_active = 0`), its record disappears from `v_wallet_balances`. When fetching the wallet detail via `GET /wallets/:walletId`, `vb.current_balance` returns `NULL`. The backend mapper defaults to `openingBalance`, falsely erasing all historical transactions from the archived wallet's final balance.
* **Remediation**:
  Remove `WHERE w.is_active = 1` from `v_wallet_balances`. Active filtering must only be applied by caller queries that explicitly request active wallets.

---

## 3. Category B: Authentication, Session & Security Gaps

### Gap 5: Silent Session Expiry Without Navigation Redirect
* **Severity**: High (Application Freeze on Expiry)
* **Affected Files**: 
  - [mobile/lib/core/api_client.dart:L174-L194](file:///c:/Projects/money_tracker/mobile/lib/core/api_client.dart#L174-L194)
  - [mobile/lib/core/providers.dart:L14-L71](file:///c:/Projects/money_tracker/mobile/lib/core/providers.dart#L14-L71)
  - [mobile/lib/core/router.dart:L19-L28](file:///c:/Projects/money_tracker/mobile/lib/core/router.dart#L19-L28)
* **Description**:
  When token refresh fails (`401 INVALID_REFRESH_TOKEN`), `ApiClient` purges tokens from `FlutterSecureStorage` and rethrows the exception. However, it does not inform Riverpod's `authProvider`.
* **Impact**:
  `authProvider` remains in `AsyncData(user)`. GoRouter's redirect guard does not trigger because it checks `auth.valueOrNull != null`. The user remains trapped on the authenticated screen, and every tap produces an unrecoverable "Your session has expired" error snackbar until the application is forcibly closed and restarted.
* **Remediation**:
  Provide an auth-cleared callback to `ApiClient` that sets `authProvider` state to `AsyncData(null)`, triggering GoRouter's automatic redirect to `/login`.

---

### Gap 6: Dart Operator Precedence Bug in HTTP Refresh Guard
* **Severity**: Low (Unnecessary Network Request)
* **Affected Files**: 
  - [mobile/lib/core/api_client.dart:L178](file:///c:/Projects/money_tracker/mobile/lib/core/api_client.dart#L178)
* **Description**:
  ```dart
  if (authenticated &&
      retry &&
      error.response?.statusCode == 401 &&
      await tokens.refreshToken != null)
  ```
  In Dart, equality `!=` binds tighter than `await`. This statement parses as:
  ```dart
  await (tokens.refreshToken != null)
  ```
  Because `tokens.refreshToken` is a `Future<String?>` instance, `Future != null` evaluates to `true`, and `await true` evaluates to `true`.
* **Impact**:
  Even if the user has no refresh token in storage, the client still executes `_refreshWithLock()`, triggering an HTTP call that is guaranteed to fail.
* **Remediation**:
  Wrap the expression with explicit parentheses: `(await tokens.refreshToken) != null`.

---

### Gap 7: Missing Profile, Password & Account Self-Service Endpoints
* **Severity**: Low (Incomplete Specification)
* **Affected Files**: 
  - [backend/src/app.ts](file:///c:/Projects/money_tracker/backend/src/app.ts)
* **Description**:
  The backend API contains no endpoints for:
  1. Updating user display name or email address (`PATCH /users/me`).
  2. Changing the account password (`POST /auth/change-password`).
  3. Forgot/reset password flows.
  4. Account self-deletion (`DELETE /users/me`).
* **Impact**:
  Users cannot manage their authentication credentials or profile information after initial registration.
* **Remediation**:
  Implement user profile update, password change, and soft account deletion endpoints.

---

### Gap 8: Absence of Brute-Force Rate Limiting on Auth Endpoints
* **Severity**: Low (Security Hardening)
* **Affected Files**: 
  - [backend/src/app.ts:L694-L700](file:///c:/Projects/money_tracker/backend/src/app.ts#L694-L700)
* **Description**:
  `POST /api/v1/auth/login` and `POST /api/v1/auth/register` share the global rate limiter of 300 requests per 15 minutes.
* **Impact**:
  An attacker can execute up to 300 credential-stuffing attempts every 15 minutes per IP without triggering a 429 Too Many Requests response.
* **Remediation**:
  Attach a dedicated rate limiter to `/auth/login` allowing at most 5-10 attempts per minute per IP.

---

## 4. Category C: Missing Feature Flows & Unreachable Backend Endpoints

### Gap 9: Transfer History & Voiding Unreachable in Mobile Client
* **Severity**: High (Dead Backend Capabilities & Incomplete UX)
* **Affected Files**: 
  - [mobile/lib/core/api_client.dart:L641-L655](file:///c:/Projects/money_tracker/mobile/lib/core/api_client.dart#L641-L655)
  - [mobile/lib/features/transfers/transfer_page.dart](file:///c:/Projects/money_tracker/mobile/lib/features/transfers/transfer_page.dart)
  - [mobile/lib/features/transactions/transactions_page.dart](file:///c:/Projects/money_tracker/mobile/lib/features/transactions/transactions_page.dart)
* **Description**:
  The backend exposes:
  - `GET /api/v1/transfers`
  - `GET /api/v1/transfers/:transferId`
  - `DELETE /api/v1/transfers/:transferId` (void transfer)
  These methods are wrapped in `ApiClient`, but **are never called by any UI component in the mobile app**.
* **Impact**:
  1. Once a transfer is submitted, it vanishes from the user's view; there is no transfer history screen.
  2. Transfers are omitted from the Activity screen (which only queries `/transactions`).
  3. A user has no way to void a mistaken transfer from the app.
  4. `transfer_page.dart` has no `notes` field and hardcodes `DateTime.now()` as the transfer date.
* **Remediation**:
  Implement a Transfer History view, add transfer voiding, include transfers in the Activity feed, and expose date/notes fields in `TransferPage`.

---

### Gap 10: Recurring Expense Template Management Unreachable
* **Severity**: High (Missing Feature Flow)
* **Affected Files**: 
  - [mobile/lib/features/static_expenses/static_expenses_page.dart:L52-L85](file:///c:/Projects/money_tracker/mobile/lib/features/static_expenses/static_expenses_page.dart#L52-L85)
* **Description**:
  `GET /api/v1/static-expenses` returns both `templates` and `occurrences`. However, `StaticExpensesPage` **exclusively renders the occurrences list**.
* **Impact**:
  1. Users cannot see, edit (`PATCH /static-expenses/:id`), or archive (`DELETE /static-expenses/:id`) recurring templates.
  2. `_newTemplate` in `static_expenses_page.dart` omits `categoryId`, `endDate`, and `notes`.
  3. Transactions created from recurring templates have `categoryId = NULL`.
* **Remediation**:
  Add a "Templates" tab or bottom sheet in `StaticExpensesPage` supporting full template viewing, editing, and archiving, and add category selection to template creation.

---

### Gap 11: Account and Wallet Editing Unreachable
* **Severity**: Medium (Missing Feature Flow)
* **Affected Files**: 
  - [mobile/lib/features/accounts/accounts_page.dart:L110-L174](file:///c:/Projects/money_tracker/mobile/lib/features/accounts/accounts_page.dart#L110-L174)
* **Description**:
  `AccountsPage` only provides an "Archive" action in popup menus for accounts and wallets.
* **Impact**:
  The backend endpoints `PATCH /api/v1/accounts/:accountId` and `PATCH /api/v1/wallets/:walletId` are unreachable. Users cannot rename an account/wallet, move an uncommitted wallet to another account, or update opening balances.
* **Remediation**:
  Add "Edit Account" and "Edit Wallet" options to the respective popup menus.

---

### Gap 12: Income Category Management Inaccessible
* **Severity**: Medium (Missing Feature Flow)
* **Affected Files**: 
  - [mobile/lib/features/settings/settings_page.dart:L250-L330](file:///c:/Projects/money_tracker/mobile/lib/features/settings/settings_page.dart#L250-L330)
* **Description**:
  In `SettingsPage`, `_manageCategories` reads only `categoriesProvider` (`appliesTo: 'SPENDING'`) and creates new categories with hardcoded `'appliesTo': 'SPENDING'`.
* **Impact**:
  Users cannot view, add, or archive custom Income categories. Furthermore, there is no way to edit the name or type of an existing category.
* **Remediation**:
  Add category type filtering (Spending vs. Income vs. Both) to `_manageCategories` and permit editing existing category names.

---

### Gap 13: Financial Month Start Preference is Completely Ignored
* **Severity**: Medium (Dead Configuration)
* **Affected Files**: 
  - [backend/src/app.ts](file:///c:/Projects/money_tracker/backend/src/app.ts)
  - [mobile/lib/features/settings/settings_page.dart](file:///c:/Projects/money_tracker/mobile/lib/features/settings/settings_page.dart)
* **Description**:
  The preference `financial_month_start` (day 1-28) is stored in `user_preferences`, but:
  1. All backend queries in `/dashboard`, `/transactions`, `/monthly-plans`, and `/static-expenses` hardcode calendar months: `YEAR(transaction_date) = ? AND MONTH(transaction_date) = ?`.
  2. `SettingsPage` omits `financialMonthStart` from its preference controls.
* **Impact**:
  Users whose financial month begins on payday (e.g., the 25th) cannot align their ledger with their actual pay period.
* **Remediation**:
  Either expose the setting and calculate month date ranges using `financial_month_start`, or document that V1 is strictly calendar-month bound.

---

## 5. Category D: Flutter Runtime Stability & Crash Risks

### Gap 14: DropdownButton Assertion Crash on Archived Categories/Wallets
* **Severity**: High (Runtime Exception)
* **Affected Files**: 
  - [mobile/lib/features/transactions/add_entry_page.dart:L114-L143](file:///c:/Projects/money_tracker/mobile/lib/features/transactions/add_entry_page.dart#L114-L143)
  - [mobile/lib/features/settings/settings_page.dart:L148-L188](file:///c:/Projects/money_tracker/mobile/lib/features/settings/settings_page.dart#L148-L188)
* **Description**:
  When editing a transaction referencing a category or wallet that was subsequently archived, `categoriesProvider` and `walletsProvider` do not return the archived entity.
* **Impact**:
  Flutter's `DropdownButtonFormField` throws an unhandled assertion crash:
  ```text
  Assertion failed: items == null || items.isEmpty || value == null || 
  items.where((DropdownMenuItem<T> item) => item.value == value).length == 1
  ```
  The exact same crash occurs in `SettingsPage` if the user's `defaultAccountId` or `defaultWalletId` was archived.
* **Remediation**:
  Verify that `value` exists within `items.map((e) => e.value)`. If not present, dynamically inject a disabled menu item for the archived entity or reset the selection to `null`.

---

### Gap 15: Tab Controller Reinitialization on Dashboard Rebuild
* **Severity**: Medium (UI Glitch)
* **Affected Files**: 
  - [mobile/lib/features/home/home_page.dart:L170-L188](file:///c:/Projects/money_tracker/mobile/lib/features/home/home_page.dart#L170-L188)
* **Description**:
  ```dart
  if (currencies.length > 1)
    DefaultTabController(
      length: currencies.length,
      child: TabBar(
        onTap: (index) => setState(() => selectedCurrency = currencies[index]),
        ...
      ),
    )
  ```
* **Impact**:
  `DefaultTabController` is instantiated without `initialIndex: currencies.indexOf(activeCurrency)`. Tapping the second tab triggers `setState()`, recreating `DefaultTabController` at index `0`. The tab indicator snaps back to the first currency while the content below renders the second currency.
* **Remediation**:
  Pass `initialIndex: currencies.indexOf(activeCurrency)` to `DefaultTabController`.

---

### Gap 16: Dialog Dismissal Prior to Asynchronous API Completion
* **Severity**: Medium (Data Loss on Failure)
* **Affected Files**: 
  - [mobile/lib/features/accounts/accounts_page.dart:L245-L258](file:///c:/Projects/money_tracker/mobile/lib/features/accounts/accounts_page.dart#L245-L258)
  - [mobile/lib/features/static_expenses/static_expenses_page.dart:L330-L357](file:///c:/Projects/money_tracker/mobile/lib/features/static_expenses/static_expenses_page.dart#L330-L357)
* **Description**:
  Dialogs invoke `Navigator.pop(context, true)` *before* awaiting the API creation call.
* **Impact**:
  If the network is down or the backend rejects the input (e.g., account hierarchy cycle), the dialog has already closed. All user-entered text is permanently discarded.
* **Remediation**:
  Execute the API request inside the dialog with a loading indicator; dismiss the dialog only after the request succeeds.

---

### Gap 17: Unhandled Asynchronous Exceptions in Category Sheet
* **Severity**: Medium (Unhandled Exception)
* **Affected Files**: 
  - [mobile/lib/features/settings/settings_page.dart:L268-L322](file:///c:/Projects/money_tracker/mobile/lib/features/settings/settings_page.dart#L268-L322)
* **Description**:
  Both `archiveCategory` and `createCategory` calls in `_manageCategories` are executed without `try / catch` blocks.
* **Impact**:
  Any network failure or backend conflict results in an unhandled Flutter exception, leaving the user interface in an unresponsive state.
* **Remediation**:
  Wrap both operations in `try / catch` blocks and display error messages via `ScaffoldMessenger`.

---

## 6. Category E: UI/UX & Data Integrity Gaps

### Gap 18: Raw Entity UUID Rendered on Recurring Expense Cards
* **Severity**: Medium (Visual Defect)
* **Affected Files**: 
  - [mobile/lib/features/static_expenses/static_expenses_page.dart:L102](file:///c:/Projects/money_tracker/mobile/lib/features/static_expenses/static_expenses_page.dart#L102)
* **Description**:
  Card subtitle is constructed as:
  ```dart
  subtitle: Text('${item.dueDate} · ${item.accountId}'),
  ```
* **Impact**:
  Renders raw database UUIDs (e.g., `2026-09-10 · 3b29c91d-0428-444f-b6e8-d1cf37d7a469`) instead of human-readable account names.
* **Remediation**:
  Display `${item.dueDate} · ${item.accountName ?? item.accountId}`.

---

### Gap 19: Dead SharedPreferences Persistence on Home Dashboard
* **Severity**: Low (Dead Code)
* **Affected Files**: 
  - [mobile/lib/features/home/home_page.dart:L22-L28](file:///c:/Projects/money_tracker/mobile/lib/features/home/home_page.dart#L22-L28)
  - [mobile/lib/features/home/home_page.dart:L88-L95](file:///c:/Projects/money_tracker/mobile/lib/features/home/home_page.dart#L88-L95)
* **Description**:
  `HomePage` writes `selected_month` and `selected_account` to `SharedPreferences` when changed, but **never reads them back in `initState`**.
* **Impact**:
  The user's account filter and month selection reset to defaults on every page navigation and app restart.
* **Remediation**:
  Read stored values during initialization or manage dashboard selection via Riverpod state.

---

### Gap 20: User Default Account and Wallet Preferences Ignored
* **Severity**: Medium (UX Inconsistency)
* **Affected Files**: 
  - [mobile/lib/features/transactions/add_entry_page.dart:L98-L100](file:///c:/Projects/money_tracker/mobile/lib/features/transactions/add_entry_page.dart#L98-L100)
  - [mobile/lib/features/home/home_page.dart:L17](file:///c:/Projects/money_tracker/mobile/lib/features/home/home_page.dart#L17)
* **Description**:
  Users configure `defaultAccountId` and `defaultWalletId` in Settings. However:
  - `AddEntryPage` defaults `walletId` to `wallets.first['id']`.
  - `HomePage` defaults `accountId` to `null` ("All accounts").
* **Impact**:
  Saved user preferences have zero effect on entry creation or dashboard filtering.
* **Remediation**:
  Initialize `walletId` with `preferences['defaultWalletId']` and `accountId` with `preferences['defaultAccountId']`.

---

### Gap 21: Immediate Transaction Voiding on Swipe Without Confirmation
* **Severity**: Medium (Accidental Data Destruction)
* **Affected Files**: 
  - [mobile/lib/features/transactions/transactions_page.dart:L165-L174](file:///c:/Projects/money_tracker/mobile/lib/features/transactions/transactions_page.dart#L165-L174)
* **Description**:
  `Dismissible` directly invokes `_void(item)` in `confirmDismiss` without an alert dialog.
* **Impact**:
  An inadvertent horizontal finger swipe permanently voids the transaction, recalculates balances, and rolls back any linked recurring occurrence without user confirmation.
* **Remediation**:
  Present a confirmation `AlertDialog` ("Void this transaction?") before executing `_void(item)`.

---

### Gap 22: Race Condition and False Error Snackbars on Recurring Expense Actions
* **Severity**: Medium (User Confusion on Success)
* **Affected Files**: 
  - [mobile/lib/features/static_expenses/static_expenses_page.dart:L146-L230](file:///c:/Projects/money_tracker/mobile/lib/features/static_expenses/static_expenses_page.dart#L146-L230)
* **Description**:
  `_pay` and `_skip` lack an in-progress boolean flag or disabled button state during execution.
* **Impact**:
  Double-tapping "Mark Paid" sends two concurrent requests. The first succeeds; the second returns `409 OCCURRENCE_NOT_PENDING`. The user sees a red error snackbar `"Only pending occurrences can be paid"` despite the bill being successfully paid.
* **Remediation**:
  Add an `isProcessing` guard to prevent duplicate submissions.

---

### Gap 23: Cash vs. Whish Breakdown Hidden on Dashboard
* **Severity**: Medium (Specification Deviation)
* **Affected Files**: 
  - [mobile/lib/features/home/home_page.dart:L243-L336](file:///c:/Projects/money_tracker/mobile/lib/features/home/home_page.dart#L243-L336)
* **Description**:
  Master Document Section 26 requires the dashboard to show Cash balance, Whish balance, and total balance. The backend returns individual wallet balances in `data.balances`.
* **Impact**:
  `_balanceCard` aggregates all balances by currency code into a single total, concealing the breakdown between physical Cash and digital Whish wallets.
* **Remediation**:
  Render the individual wallet cards (Cash, Whish, etc.) below the total balance header.

---

### Gap 24: Disconnected Month State Across Navigation Tabs
* **Severity**: Low (UX Inconvenience)
* **Affected Files**: 
  - [mobile/lib/features/home/home_page.dart:L16](file:///c:/Projects/money_tracker/mobile/lib/features/home/home_page.dart#L16)
  - [mobile/lib/features/transactions/transactions_page.dart:L31](file:///c:/Projects/money_tracker/mobile/lib/features/transactions/transactions_page.dart#L31)
  - [mobile/lib/features/static_expenses/static_expenses_page.dart:L14](file:///c:/Projects/money_tracker/mobile/lib/features/static_expenses/static_expenses_page.dart#L14)
* **Description**:
  Each screen manages its own local `DateTime month` state variable.
* **Impact**:
  Selecting a past month (e.g., August 2026) on Home and then navigating to Activity or Recurring Expenses resets the view to the current month (September 2026).
* **Remediation**:
  Store the selected viewing period in a shared `selectedPeriodProvider`.

---

### Gap 25: Untyped Map Payloads Bypassing Freezed Request Models
* **Severity**: Low (Code Architecture)
* **Affected Files**: 
  - [mobile/lib/core/models.dart:L283-L310](file:///c:/Projects/money_tracker/mobile/lib/core/models.dart#L283-L310)
  - [mobile/lib/core/api_client.dart](file:///c:/Projects/money_tracker/mobile/lib/core/api_client.dart)
  - [mobile/lib/features/transactions/add_entry_page.dart](file:///c:/Projects/money_tracker/mobile/lib/features/transactions/add_entry_page.dart)
* **Description**:
  Freezed classes `TransactionRequest` and `OccurrencePaymentRequest` exist in `models.dart`, but form pages pass raw untyped `Map<String, dynamic>` maps to `ApiClient`.
* **Impact**:
  Loss of compile-time type safety across form submissions.
* **Remediation**:
  Update `ApiClient` methods to accept typed request classes.

---

## 7. Comprehensive Summary Matrix

| Gap # | Category | Summary Description | Severity | Area |
| :---: | :--- | :--- | :---: | :--- |
| **1** | Financial Math | Double subtraction of today's spending in daily allowance formula | **Critical** | Backend / Math |
| **2** | Financial Ledger | Negative balance guard bypassed on income reductions | **High** | Backend / Transactions |
| **3** | Financial Ledger | Negative balance guard bypassed when voiding income/transfers | **High** | Backend / Transactions |
| **4** | Financial Ledger | `v_wallet_balances` excludes archived wallets, corrupting history | **Medium** | Database / Views |
| **5** | Security & Auth | Client fails to redirect to login on expired refresh token | **High** | Mobile / Auth |
| **6** | Security & Auth | Dart operator precedence causes false refresh attempts | **Low** | Mobile / Network |
| **7** | Security & Auth | Missing profile edit, password change, and self-deletion endpoints | **Low** | Backend / API |
| **8** | Security & Auth | Missing dedicated rate limiter on auth routes | **Low** | Backend / Security |
| **9** | Missing Flows | Transfer history and transfer voiding missing from mobile UI | **High** | Mobile / Transfers |
| **10** | Missing Flows | Recurring templates cannot be viewed, edited, or archived in UI | **High** | Mobile / Recurring |
| **11** | Missing Flows | Account and wallet editing missing from mobile UI | **Medium** | Mobile / Accounts |
| **12** | Missing Flows | Custom Income categories cannot be managed in Settings | **Medium** | Mobile / Categories |
| **13** | Missing Flows | `financial_month_start` preference is completely ignored | **Medium** | Backend & Mobile |
| **14** | Runtime Stability | `DropdownButtonFormField` crashes on archived category/wallet | **High** | Mobile / Widgets |
| **15** | Runtime Stability | Dashboard `DefaultTabController` resets on rebuild | **Medium** | Mobile / Home |
| **16** | Runtime Stability | Dialogs pop before API call completes, losing input on error | **Medium** | Mobile / UX |
| **17** | Runtime Stability | Unhandled async exceptions in category management sheet | **Medium** | Mobile / Settings |
| **18** | UI / Display | Raw entity UUID rendered in recurring expense card subtitle | **Medium** | Mobile / Recurring |
| **19** | UI / Display | SharedPreferences writes for month/account never read back | **Low** | Mobile / Storage |
| **20** | UI / Display | User default account/wallet preferences ignored in forms | **Medium** | Mobile / Forms |
| **21** | UI / Display | Transaction instantly voided on swipe without confirmation | **Medium** | Mobile / Activity |
| **22** | UI / Display | Race condition on Mark Paid displays false error snackbars | **Medium** | Mobile / Recurring |
| **23** | UI / Display | Cash vs. Whish breakdown hidden inside aggregated balance | **Medium** | Mobile / Home |
| **24** | UI / Display | Selected viewing month is disconnected across navigation tabs | **Low** | Mobile / State |
| **25** | Architecture | Untyped maps used instead of generated Freezed request classes | **Low** | Mobile / Models |

---

## 8. Prioritized Remediation Roadmap

### Phase 1: Critical Financial & Ledger Fixes
1. Fix daily allowance formula in `backend/src/financial.ts` to prevent double subtraction.
2. Add negative balance checks to `PATCH /transactions/:id`, `DELETE /transactions/:id`, and `DELETE /transfers/:id`.
3. Update `v_wallet_balances` in `backend/DB.SQL` to compute balances for all wallets regardless of `is_active`.

### Phase 2: Client Stability & Session Integrity
4. In `mobile/lib/core/api_client.dart`, notify `authProvider` to transition to `null` upon refresh failure.
5. Fix operator precedence in `api_client.dart`: `(await tokens.refreshToken) != null`.
6. Safeguard dropdowns in `add_entry_page.dart` and `settings_page.dart` against missing/archived IDs.
7. Wrap async category management operations in `settings_page.dart` with `try / catch`.
8. Retain dialog visibility in `AccountsPage` and `StaticExpensesPage` until network responses return.

### Phase 3: Core Feature Completion
9. Build Transfer History and Transfer Voiding screens/actions in mobile.
10. Build Recurring Expense Template management (view, edit, archive) in `static_expenses_page.dart`.
11. Implement Edit Account and Edit Wallet dialogs in `accounts_page.dart`.
12. Support Income category creation and management in `settings_page.dart`.

### Phase 4: UI/UX Refinement & Polish
13. Replace raw UUID with `accountName` in recurring expense cards.
14. Add confirmation alert dialog prior to swipe-to-void in `transactions_page.dart`.
15. Add `isProcessing` guard on "Mark Paid" and "Skip" buttons.
16. Show wallet breakdown (Cash vs. Whish) on the Home Dashboard card.
17. Fix `DefaultTabController` initial index in `home_page.dart`.
18. Synchronize selected month state across all tabs via Riverpod.
