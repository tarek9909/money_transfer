You are acting as a senior software architect, backend engineer, Flutter architect, database engineer, and technical project planner.

I am building a personal Money Tracker application.

Your first task is NOT to immediately start coding.

Your first task is to carefully analyze the full project documentation and the provided MySQL database schema, understand the intended product behavior end-to-end, identify any technical gaps or inconsistencies, and then produce a complete implementation plan for building the application.

The implementation plan must be detailed enough that another coding agent could follow it phase by phase without needing to redesign the architecture during implementation.

---

# 1. Technology Stack

The required stack is:

## Mobile Application

* Flutter
* Dart

The deliverable is an Android application. The dashboard is an in-app Home
screen, not a browser-based web dashboard. The `/api/v1/dashboard` endpoint is
the mobile client aggregation endpoint.

Recommended unless the existing project already uses alternatives:

* Riverpod for state management
* Dio for HTTP requests
* go_router for navigation
* flutter_secure_storage for authentication tokens
* shared_preferences only for non-sensitive local preferences

## Backend

* Node.js
* Express.js
* REST API
* JWT access tokens
* Refresh tokens
* MySQL
* Transaction-safe financial operations

## Database

Use the provided MySQL database schema as the primary database specification.

Do not casually replace or redesign the database.

If you identify something that should be changed, document:

1. What is wrong.
2. Why it matters.
3. What you recommend changing.
4. Whether the change is required before implementation or can wait.

Do not change the scope without justification.

---

# 2. Application Purpose

This is intentionally a simple personal money tracker.

It is NOT:

* A banking application
* An accounting ERP
* A card management platform
* A payment gateway
* An investment platform
* A loan management system
* A business finance dashboard

There is no bank-card integration.

There is no bank API integration.

There is no payment processing.

The user manually enters their financial activity.

The application then automatically calculates their balances, spending, allowance, and remaining money.

---

# 3. Core Features

The complete required product scope is:

## Main Income

Allow the user to record regular income such as salary.

Required behavior:

* Amount
* Date
* Account
* Wallet
* Optional description
* Optional category
* Optional notes

Income increases the selected wallet balance.

---

## Additional Income

Allow the user to record additional money such as:

* Freelance income
* Bonus
* Gift
* Commission
* Refund
* Side income
* Other extra income

Additional income increases the selected wallet balance.

---

## Static Spending

Static spending means predictable or recurring expenses.

Examples:

* Rent
* Internet
* Generator
* Phone
* Gym
* Subscription
* Insurance

The user should create a static expense template.

Each month the application should create or expose the appropriate monthly occurrence.

The occurrence must support:

* Pending
* Paid
* Skipped

A static expense must NOT reduce the wallet balance merely because it exists.

It only becomes actual spending once the user marks it paid.

When marked paid:

* Create a STATIC_SPENDING transaction.
* Connect it to the monthly occurrence.
* Deduct it from the chosen wallet.
* Update dashboard calculations.

Historical paid expenses must remain unchanged if the template is later edited.

---

## Dynamic Spending

Dynamic spending represents variable everyday expenses.

Examples:

* Food
* Coffee
* Fuel
* Transportation
* Shopping
* Entertainment
* Groceries
* Health
* Other

The dynamic-spending entry flow must be extremely fast.

The essential fields are:

* Amount
* Category
* Wallet
* Date

Optional:

* Description
* Notes

Dynamic spending reduces the selected wallet balance.

---

# 4. Monthly Allowance

The user can define a monthly dynamic-spending allowance.

Example:

Monthly allowance = $800.

The allowance is separate from static expenses.

Calculate:

Allowance Used =
Total Dynamic Spending for the month

Allowance Remaining =
Monthly Allowance - Dynamic Spending

The remaining allowance is allowed to become negative.

Example:

Allowance = $800
Dynamic Spending = $850
Allowance Remaining = -$50

Do not incorrectly force the actual remaining value to zero.

---

# 5. Daily Allowance

Daily allowance must automatically adjust throughout the month.

Calculation:

Daily Allowance =
MAX(Allowance Remaining, 0)
/
Remaining Days in the Month

Remaining days should include the current day.

Example:

Allowance Remaining = $300

Remaining Days = 15

Daily Allowance = $20

Also calculate:

Today's Dynamic Spending

and:

Remaining Today =
Daily Allowance - Today's Dynamic Spending

Daily allowance should recalculate whenever:

* A dynamic transaction is added.
* A dynamic transaction is edited.
* A dynamic transaction is deleted/voided.
* Monthly allowance changes.
* The calendar day changes.

Do not store daily allowance as static financial data unless there is a strong architectural reason.

Prefer calculating it from source financial information.

---

# 6. Remaining Money

Remaining Money is different from Remaining Allowance.

Formula:

Total Income =
Main Income + Additional Income

Total Spending =
Static Spending + Dynamic Spending

Remaining Money =
Total Income - Total Spending

Example:

Main Income = $2,000
Additional Income = $400
Static Spending = $700
Dynamic Spending = $520

Total Income = $2,400

Total Spending = $1,220

Remaining Money = $1,180

---

# 7. Accounts

The application supports multiple financial accounts.

Example:

Personal

Work

Savings

Travel

Emergency

Each account can have wallets.

Accounts may also optionally have sub-accounts.

Example:

Personal
├── Daily Spending
├── Entertainment
└── Savings

Do not force users to create sub-accounts.

Simple usage should remain possible.

---

# 8. Wallets

Initial wallet types are:

* Cash
* Whish

The architecture should also support:

* Other

Example:

Personal
├── Cash
└── Whish

Work
├── Cash
└── Whish

Savings
└── Cash

Each wallet belongs to an account.

Wallet balance must be based on:

Opening Balance
+
Income
+
Transfers In
------------

## Static Spending

## Dynamic Spending

Transfers Out

The balance must come from financial activity.

Do not make manually updated current_balance the primary source of truth.

---

# 9. Transfers

Allow money to move between wallets.

Examples:

Personal Whish → Personal Cash

Personal Cash → Savings Cash

Transfers:

* Do NOT count as income.
* Do NOT count as spending.
* Do NOT change the user's total money.
* Only change where the money is located.

Transfers must be transaction-safe.

For example:

START TRANSACTION

Validate ownership

Validate wallets

Validate currency

Validate source balance if negative balances are disabled

Create transfer

COMMIT

ROLLBACK on failure

Cross-currency transfer support is NOT required in V1.

---

# 10. Currency

Each wallet has its own currency.

The verified backend permits a user to hold multiple currencies at once. A
transfer is valid only when the source and destination wallets have the same
currency; cross-currency conversion is outside V1.

Initial expected currencies include:

* USD
* LBP

Potentially others may be supported.

Do NOT combine balances from different currencies into one total unless an FX/conversion system exists. The Flutter dashboard therefore renders one tab/card per currency.

Example:

USD Total: $2,000

LBP Total: 30,000,000 LBP

These should remain separate.

Do not invent exchange rates.

---

# 11. Main Flutter Navigation

Keep the product simple.

Recommended main navigation:

Home

Spending

Accounts

Settings

A central "+" action should allow the user to create:

* Main Income
* Additional Income
* Static Spending
* Dynamic Spending
* Transfer

Do not create unnecessary modules.

---

# 12. Home Dashboard

The Home screen should answer:

How much money do I have?

What happened financially this month?

What can I still spend?

Recommended dashboard information:

## Balance

* Total balance by currency
* Cash balance
* Whish balance

## Income

* Main income
* Additional income
* Total income

## Spending

* Static spending
* Dynamic spending
* Total spending

## Remaining

* Remaining money

## Allowance

* Monthly allowance
* Allowance used
* Allowance remaining
* Daily allowance
* Today's spending
* Remaining today

The user must be able to select:

* All Accounts
* A specific account

The user must also be able to navigate between months.

---

# 13. Spending Screen

The spending/history section should show:

* Static spending
* Dynamic spending
* Income if history is unified
* Transaction date
* Amount
* Wallet
* Category
* Description

Provide appropriate filters such as:

* All
* Static
* Dynamic
* Main Income
* Additional Income
* Account
* Wallet
* Month

Do not overcomplicate filtering.

---

# 14. Accounts Screen

The Accounts section should show a hierarchy such as:

Personal — $1,200

Cash — $400

Whish — $800

Work — $700

Cash — $100

Whish — $600

Savings — $2,000

Cash — $2,000

If currencies differ, show separate currency balances.

---

# 15. Settings

Settings should minimally support:

* Preferred currency
* Default account
* Default wallet
* Categories
* Account management
* Wallet management
* Authentication/security
* Logout

Future data export/backup may be accommodated architecturally but should not distract from V1 implementation unless already included in the provided documentation.

---

# 16. Authentication

Implement proper authentication.

Required:

* Register
* Login
* Refresh access token
* Logout
* Get current user

Use:

* Secure password hashing
* JWT access token
* Refresh token rotation/revocation strategy
* Hashed refresh tokens in database
* Secure storage on Flutter

Flutter must never store raw passwords.

Never trust user_id sent from the client.

Authenticated user identity must come from the verified token/session.

---

# 17. Database

Use the provided SQL database file as the authoritative starting point.

It includes the intended structures for:

* users
* user_preferences
* accounts
* wallet_types
* wallets
* default_categories
* categories
* monthly_plans
* static_expense_templates
* transactions
* static_expense_occurrences
* transfers
* refresh_tokens
* balance views
* monthly summary views
* allowance views
* triggers
* stored procedures

Study the entire SQL file before planning the backend.

Do not write backend logic that contradicts the database behavior.

---

# 18. IDs and Flutter UX

The database may use internal numeric IDs.

The API may expose public identifiers.

However, the UI must NEVER require users to manually type database IDs.

For example, never show:

Account ID:
[ 17 ]

Instead use:

Account:
[ Personal ▼ ]

The application internally sends the selected identifier.

The same applies to:

* Wallet
* Category
* Account
* Static expense
* Transaction relationships

---

# 19. Financial Precision

Money is a strict decimal value at every application boundary. Do not use
floating-point arithmetic for ledger calculations or UI aggregation.

Database:

Use DECIMAL.

Backend:

Use `decimal.js` and persist/read MySQL `DECIMAL(18,2)` values.

JSON:

All monetary response values are two-decimal strings, for example
`"amount": "1200.00"`. Public entity identifiers are UUID strings and JSON
fields use camelCase.

Flutter:

Use the `Decimal` type with the generated `DecimalConverter`; serialization
always writes a two-decimal string. Forms normalize user input before sending
it to the API.

Any implementation plan must explain how money precision is handled across:

MySQL → Node.js → JSON → Flutter.

---

# 20. Data Ownership

This is mandatory.

Every user-owned resource must be scoped to the authenticated user.

Examples:

* Accounts
* Wallets
* Categories
* Transactions
* Monthly plans
* Static expenses
* Transfers

Never rely only on:

WHERE id = ?

Use the authenticated user context as well.

Example concept:

WHERE resource_id = ?
AND user_id = authenticated_user_id

Do not allow cross-user data access through guessed identifiers.

---

# 21. Financial Integrity

The implementation plan must specifically address financial consistency.

Examples:

## Editing a transaction

If a transaction changes from:

$50

to:

$5

then automatically reflect this in:

* Wallet balance
* Spending total
* Remaining money
* Allowance used
* Allowance remaining
* Daily allowance

## Deleting a transaction

Prefer voiding/soft deletion rather than destroying history where appropriate.

Ensure views and calculations ignore voided/deleted entries.

## Editing static templates

Historical paid transactions must not change.

## Transfers

Must not affect monthly income or spending.

---

# 22. Negative Wallet Balance

The provided model supports a preference for whether negative wallet balances are allowed.

The implementation plan must define the behavior.

If disabled:

Reject spending/transfer operations that would take the selected wallet below zero.

Return a clear error such as:

INSUFFICIENT_BALANCE

If enabled:

Allow negative balance.

Balance-sensitive operations should use proper database locking where needed.

---

# 23. Backend Architecture

Use a clean layered backend architecture.

Recommended flow:

Route

→ Authentication Middleware

→ Validation Middleware

→ Controller

→ Service

→ Database/Repository

→ Response

Controllers should remain thin.

Financial logic should live in service/domain layers.

Avoid embedding large SQL/business calculations directly inside route files.

---

# 24. Suggested Backend Modules

Analyze and define modules around:

* Auth
* Users
* Accounts
* Wallets
* Categories
* Transactions
* Main Income
* Additional Income
* Dynamic Spending
* Static Expenses
* Monthly Plans
* Allowance
* Transfers
* Dashboard

Some of these may use the same transaction service internally.

Do not create duplicate business logic simply because the UI has separate forms.

For example:

Main Income

Additional Income

Static Spending

Dynamic Spending

may all ultimately be transaction records with different transaction types.

Use shared implementation where appropriate.

---

# 25. API Standard

Use:

/api/v1

Responses should follow a consistent format.

Successful:

{
"success": true,
"data": {}
}

Failure:

{
"success": false,
"message": "Insufficient wallet balance",
"code": "INSUFFICIENT_BALANCE"
}

The live API wraps every success in `{ "success": true, "data": ... }` and
every failure in `{ "success": false, "message": ..., "code": ..., "details": ... }`.
The Flutter Dio response interceptor unwraps `data`; its error layer maps
`INSUFFICIENT_BALANCE`, `ACCOUNT_WALLET_MISMATCH`,
`CROSS_CURRENCY_TRANSFER`, and `UNAUTHORIZED` to typed UI exceptions.

Define:

* Validation errors
* Authentication errors
* Authorization/ownership errors
* Not found
* Conflict
* Financial validation errors
* Internal errors

---

# 26. Required API Analysis

Your implementation plan must define the necessary endpoint groups and their purpose.

At minimum analyze:

## Auth

POST /api/v1/auth/register

POST /api/v1/auth/login

POST /api/v1/auth/refresh

POST /api/v1/auth/logout

GET /api/v1/auth/me

## Accounts

`GET/POST /api/v1/accounts`, `GET/PATCH/DELETE /api/v1/accounts/:accountId`
list, inspect, mutate, and archive accounts. Responses include nested wallet
data in account detail/list views.

## Wallets

`GET/POST /api/v1/wallets`, `GET/PATCH/DELETE /api/v1/wallets/:walletId`
list, inspect, mutate, and archive wallets. `accountId` filters the list.

## Categories

`GET /api/v1/categories`, `GET /api/v1/categories/:categoryId`,
`POST /api/v1/categories`, `PATCH /api/v1/categories/:categoryId`, and
`DELETE /api/v1/categories/:categoryId` list, inspect, mutate, and archive
the authenticated user's categories.

## Transactions

`GET /api/v1/transactions` supports `year`, `month`, `type`, `accountId`,
`walletId`, `categoryId`, `limit` (1–250), and `offset` (or one-based `page`)
for infinite scrolling. It returns newest-first arrays. The remaining routes
are `POST`, `GET /:transactionId`, `PATCH /:transactionId`, and
`DELETE /:transactionId`; delete means an auditable void.

## Static Expenses

Templates use `GET/POST /api/v1/static-expenses`,
`GET/PATCH/DELETE /api/v1/static-expenses/:templateId`.
Occurrences use `GET /api/v1/static-expenses/occurrences?year=&month=`,
`POST /api/v1/static-expenses/occurrences/generate`,
`POST /api/v1/static-expenses/occurrences/:occurrenceId/pay`, and
`POST /api/v1/static-expenses/occurrences/:occurrenceId/skip`.
Payment addresses the occurrence UUID, creates a `STATIC_SPENDING` transaction,
and moves `PENDING` to `PAID`.

## Monthly Plan

`GET /api/v1/monthly-plans/:year/:month` reads the allowance summary and
`POST/PATCH /api/v1/monthly-plans` (with the plan identifier on PATCH) creates
or updates the currency-specific plan. There is no `/monthly-plans/current`
route.

## Transfers

`POST /api/v1/transfers`, `GET /api/v1/transfers`,
`GET /api/v1/transfers/:transferId`, and
`DELETE /api/v1/transfers/:transferId` create, list, inspect, and void
same-currency wallet transfers atomically.

## Dashboard

Monthly summary

Balances

Allowance

Today's spending

Static expense status

Do not just list endpoints.

Specify what each should do and how the resources interact.

---

# 27. Dashboard Calculation Responsibility

Do NOT duplicate important financial formulas independently in Flutter and Node.js.

The backend should be the main source of truth for financial summaries.

Flutter can perform display-only calculations where harmless.

Define a dashboard response that minimizes excessive API calls.

Example concept:

GET /api/v1/dashboard?year=2026&month=9

Possible response sections:

user

period

balances (array, grouped by wallet and currency)

summaryByCurrency (array)

allowanceByCurrency (array)

staticExpenses (array of occurrences)

recentTransactions (array)

This is the verified `/api/v1/dashboard` structure. Monetary values are
two-decimal strings and `currencyCode` is present on each currency-specific
record, so Flutter must not bind to legacy flat totals.

The backend remains the source of truth for all financial calculations.

---

# 28. Flutter Architecture

Use feature-based organization.

Recommended direction:

lib/

core/

features/

The implemented network layer is a single Dio client configured with
`API_BASE_URL` (default Android emulator URL
`http://10.0.2.2:3000/api/v1`). A global response interceptor unwraps the
success envelope, maps error codes to typed exceptions, and retries one 401
request after silently rotating the refresh token stored in
`flutter_secure_storage`.

Data classes are generated with `freezed` and `json_serializable`; all public
JSON names are camelCase and monetary fields use `DecimalConverter`.

Each feature can include only what is needed:

models

pages

widgets

repositories

services

state

Do not generate empty folders merely for architecture purity.

Reuse shared widgets and models appropriately.

---

# 29. Flutter State

The implementation plan must define:

* Authentication state
* Current selected month
* Selected account
* Dashboard state
* Transaction history state
* Accounts state
* Wallets state
* Static expense state
* Monthly allowance state

Transaction history uses 50-item pages and requests the next `offset` when the
scroll position nears the end. A page is exhausted when its item count is
less than the requested limit. Mutations invalidate the affected wallet,
dashboard, occurrence, and history providers only.

Also define cache refresh behavior.

For example:

After creating dynamic spending:

1. Save transaction.
2. Refresh/update selected wallet.
3. Refresh dashboard.
4. Refresh transaction history.
5. Refresh allowance.
6. Do not unnecessarily refetch unrelated data.

---

# 30. Flutter UX Requirements

Keep forms simple.

Example Dynamic Spending:

Amount

Category

Wallet

Date

Description optional

Save

Do not expose unnecessary database/backend fields.

Income form:

Amount

Account

Wallet

Date

Description optional

Static expense template:

Name

Amount

Account

Default Wallet

Due Day

Start Date

Optional End Date

Category

Save

Transfer:

From Wallet

To Wallet

Amount

Date

Notes optional

---

# 31. Loading and Error States

Every Flutter screen that depends on APIs must define:

* Initial loading
* Refreshing
* Empty state
* Validation state
* API error
* Offline/network error
* Success feedback

Avoid screens that simply crash or remain blank when no data exists.

---

# 32. Month Handling

Historical monthly data is important.

The user should be able to navigate:

Previous Month

Current Month

Next/selected Month

The implementation plan must define:

* Month selection state
* Dashboard requests by month
* Static expense occurrences by month
* Monthly allowance by month
* Transaction filtering by month

Do not hard-code logic around the current month only.

---

# 33. Static Expense Monthly Generation

The backend calls the idempotent `sp_generate_static_expenses_for_month` when
the dashboard, monthly static-expense collection, or occurrence collection is
read. Flutter may also call `POST
/api/v1/static-expenses/occurrences/generate` explicitly after selecting a
month. The unique user/template/year/month invariant prevents duplicate
occurrences; no scheduler is required for V1.

---

# 34. Database Views

Review all provided database views.

Identify which ones should be used directly by backend services and which calculations are better implemented in Node.js.

Do not assume every view must be used.

Do not duplicate database calculations unnecessarily either.

Explain the tradeoff.

---

# 35. Security Requirements

The implementation plan must include:

* Input validation
* Parameterized queries / ORM protection
* Authentication
* User ownership scoping
* Rate limiting
* Helmet/security headers
* CORS
* Secure refresh-token handling
* Password hashing
* Environment secrets
* Production HTTPS
* Log redaction
* Safe error responses

Do not log:

* Passwords
* Tokens
* Sensitive authentication headers

---

# 36. Testing Requirements

Create a meaningful testing plan.

## Backend

Include:

* Authentication tests
* Account ownership tests
* Wallet tests
* Transaction tests
* Static expense tests
* Monthly allowance calculations
* Transfer tests
* Balance calculations
* Edit/delete recalculation tests
* Multiple-account tests
* Cross-user access tests
* Currency validation tests

Critical financial tests:

### Transfer

$500 Cash

transfer $100 to Whish

Expected:

Cash = $400

Whish increases by $100

Total user balance remains unchanged

Income unchanged

Spending unchanged

### Dynamic Spending

Allowance = $800

Dynamic spend = $200

Expected allowance remaining = $600

### Overspending

Allowance = $800

Dynamic spend = $850

Expected allowance remaining = -$50

Future daily allowance = $0

### Static Expense

Pending rent should not reduce balance.

Marking rent paid should reduce balance.

### Edited Expense

Expense changes $50 → $5.

All summaries must immediately reflect the $45 difference.

---

# 37. Flutter Testing

Plan for:

* Unit tests for formatters/calculation helpers
* Generated model round-trip tests (`freezed`/`json_serializable`)
* State/provider tests
* Widget tests for important forms
* Navigation/auth flow tests
* API error handling
* Add transaction flow
* Transfer flow
* Static expense payment flow
* Allowance display
* Account selection
* Month selection
* Pagination append/retry behavior

---

# 38. Implementation Philosophy

Keep the codebase:

* Simple
* Modular
* Testable
* Maintainable
* Secure
* Consistent

Do not over-engineer this into a microservice architecture.

One Node.js backend is enough.

One MySQL database is enough.

One Flutter app is enough.

Do not introduce technologies without a clear requirement.

Avoid unnecessary:

* Redis
* Kafka
* RabbitMQ
* GraphQL
* Microservices
* Kubernetes
* Event sourcing
* CQRS

unless you find an actual requirement that justifies them.

---

# 39. Your First Task

Before coding anything:

1. Read the complete product documentation.
2. Read the complete provided MySQL SQL file from beginning to end.
3. Inspect the current Flutter project if one exists.
4. Inspect the current backend project if one exists.
5. Inspect package/dependency files.
6. Inspect existing architecture.
7. Determine what already exists.
8. Determine what is incomplete.
9. Determine what conflicts with the specification.
10. Determine what can safely be reused.

Do NOT recreate an existing project if one already exists.

Do NOT replace working architecture unnecessarily.

Do NOT delete existing functionality unless required and justified.

---

# 40. Required Output — Architecture Assessment

Start your response with:

# Architecture Assessment

Include:

## Product Understanding

Summarize what the application is supposed to do.

## Existing Project Assessment

If source code already exists:

* Flutter status
* Backend status
* Database status
* Existing dependencies
* Existing architecture
* Existing reusable components

If no source code exists, state that this will be a greenfield implementation.

## Database Assessment

Review the SQL schema and state:

* What is correct
* Any issues found
* Any recommended changes
* Whether those changes are blocking

## Architecture Decisions

Confirm or recommend:

* Flutter state management
* Routing
* Networking
* Backend DB access approach
* Authentication
* Validation library
* Testing libraries
* API response structure

---

# 41. Required Output — Complete Implementation Plan

After the assessment, provide:

# Implementation Plan

Break implementation into clear phases.

Use this approximate sequence unless your analysis finds a better dependency order.

## Phase 0 — Project Audit & Setup

* Inspect existing project
* Environment configuration
* Dependencies
* Folder architecture
* Database migration/import
* Development configuration
* API conventions

## Phase 1 — Authentication & User Foundation

* User registration
* Login
* Refresh
* Logout
* Flutter auth state
* Secure token storage
* Protected routes

## Phase 2 — Accounts & Wallets

* Account CRUD
* Sub-account hierarchy
* Wallet CRUD
* Cash
* Whish
* Opening balances
* Balance queries
* Flutter accounts UI

## Phase 3 — Categories & Transactions

* Category management
* Transaction service
* Main income
* Additional income
* Dynamic spending
* History
* Edit/void
* Flutter forms

## Phase 4 — Static Spending

* Static templates
* Monthly occurrence creation
* Pending
* Paid
* Skipped
* Pay workflow
* Historical integrity

## Phase 5 — Monthly Allowance

* Monthly plan
* Allowance calculations
* Daily allowance
* Today spending
* Overspending behavior
* Flutter allowance UI

## Phase 6 — Transfers

* Wallet transfers
* Account transfers through wallets
* Database locking
* Insufficient balance
* Transfer history
* Flutter transfer UI

## Phase 7 — Dashboard

* Dashboard aggregation endpoint
* Total balance
* Cash/Whish
* Income
* Spending
* Remaining money
* Allowance
* Daily allowance
* Account filter
* Month selection

## Phase 8 — Settings & Polish

* User preferences
* Default wallet
* Default account
* Preferred currency
* Loading states
* Empty states
* Error states
* UX cleanup

## Phase 9 — Testing & Hardening

* Backend tests
* Flutter tests
* Security
* Ownership audit
* Financial consistency audit
* Performance/index review

## Phase 10 — Production Readiness

* Environment configuration
* Production database
* HTTPS/API setup
* Logging
* Build configuration
* Android/iOS release preparation
* Final regression testing

You may modify the phase breakdown if there is a technically stronger sequence, but explain why.

---

# 42. For Every Phase

For every implementation phase include a table with:

| Item                | Details                   |
| ------------------- | ------------------------- |
| Objective           | What the phase achieves   |
| Backend Work        | Backend tasks             |
| Database Work       | Database tasks            |
| Flutter Work        | Flutter tasks             |
| APIs                | Endpoints introduced/used |
| Files/Modules       | Expected files/modules    |
| Dependencies        | What must already exist   |
| Validation          | Important validation      |
| Security            | Security concerns         |
| Tests               | Required tests            |
| Acceptance Criteria | Conditions for completion |

Be specific.

Do not write generic lines such as:

"Build backend."

Instead write exactly what should be implemented.

---

# 43. API Implementation Matrix

Create an API implementation matrix.

Use columns such as:

| Method | Endpoint | Purpose | Auth | Request | Response | Main Validation | Flutter Consumer |

Cover every API required for the final product.

---

# 44. Database-to-API Mapping

Create a mapping such as:

| Feature | Tables/Views | Service | Endpoints | Flutter Feature |

Examples:

Main Income

Additional Income

Dynamic Spending

Static Spending

Allowance

Accounts

Wallets

Transfers

Dashboard

This ensures there are no database entities without implementation ownership.

---

# 45. Flutter Screen Matrix

Provide:

| Screen | Purpose | Data/API | Main Actions | States |

Include every required screen.

---

# 46. State/Data Flow

Explain the exact end-to-end flow for at least these actions:

## Add Main Income

Flutter form

→ validation

→ API

→ transaction service

→ MySQL

→ response

→ dashboard refresh

## Add Dynamic Spending

Same full flow.

## Pay Static Expense

Same full flow.

## Transfer Cash → Whish

Same full flow.

## Change Monthly Allowance

Same full flow.

## Edit/Delete Expense

Explain how financial summaries remain correct.

---

# 47. Critical Business Rules Checklist

Create a final checklist covering:

* Income increases balance.
* Spending decreases balance.
* Transfers don't affect income/spending.
* Static expense pending does not reduce balance.
* Static expense paid does reduce balance.
* Allowance only tracks dynamic spending.
* Static spending does not consume dynamic allowance.
* Remaining money includes both static and dynamic spending.
* Allowance may become negative.
* Daily allowance uses only positive remaining allowance.
* Different currencies remain separate.
* Cross-user records cannot be accessed.
* Historical transactions remain reliable.
* Editing/voiding transactions recalculates results correctly.

---

# 48. Risks and Edge Cases

Identify and plan for at least:

* Duplicate form submission
* Double-tapping "Mark Paid"
* Duplicate monthly static occurrences
* Editing paid static transaction
* Voiding a transaction connected to a static occurrence
* Wallet archive with existing financial history
* Account archive with active wallets
* Account hierarchy cycles
* Negative balance behavior
* Changing wallet/account relationships
* Cross-currency transfers
* Month boundaries
* February / 30-day month / due day 31
* Timezone effects
* Refresh-token theft/revocation
* Simultaneous wallet operations
* Floating-point/decimal errors
* Old Flutter cache after financial mutation

State how each risk should be handled.

---

# 49. Do Not Code Yet

This first response must be the implementation plan only.

Do NOT:

* Generate all application source code.
* Start replacing files.
* Create Flutter screens.
* Modify the database.
* Implement APIs.

You may show small pseudocode snippets only when necessary to explain architecture.

The purpose of this stage is to establish the full implementation plan before development begins.

---

# 50. Final Plan Verdict

At the end of your response, provide:

# Readiness Verdict

Use one:

READY TO IMPLEMENT

READY WITH MINOR CHANGES

NOT READY — BLOCKERS FOUND

If changes are needed, explicitly list them.

Then provide:

# Recommended Implementation Order

with the exact phase order that should be followed.

Finally provide:

# Phase 1 Start Criteria

State exactly what must be true before implementation begins.

Do not ask unnecessary questions if the supplied documentation, SQL file, and existing source code already provide the answer.

Make reasonable engineering decisions and clearly document assumptions rather than blocking progress unnecessarily.
