# Personal Money Tracker

## Product & Technical Documentation

**Frontend:** Flutter Android application
**Backend:** Node.js + Express.js
**Database:** MySQL
**Application Type:** Personal finance / money tracking Android application
**Bank Integration:** None
**Payment/Card Integration:** None

---

# 1. Product Overview

The Personal Money Tracker is a lightweight Flutter mobile application designed to help a user understand:

* How much money they receive.
* How much money they spend.
* Which expenses are fixed.
* Which expenses are variable.
* How much allowance remains.
* How much can safely be spent each day.
* How much money remains at the end of the month.
* Where the money is stored: Cash, Whish, or other manually created wallets.
* How money is distributed between multiple accounts and sub-accounts.

The application does not connect to banks, debit cards, credit cards, or payment gateways.

The client is an Android application, not a web dashboard. “Dashboard” in this
document means the authenticated Home screen inside the Android app and the API
aggregation that supplies it.

All financial information is entered manually by the user.

The main philosophy is:

**Simple input → automatic calculations → clear financial overview.**

---

# 2. Product Goals

The application should allow the user to answer the following questions immediately:

* How much money do I currently have?
* How much did I earn this month?
* How much additional income did I receive?
* How much do I spend every month on fixed expenses?
* How much have I spent dynamically?
* How much of my allowance remains?
* How much can I spend today?
* How much money remains this month?
* How much money is in Cash?
* How much money is in Whish?
* How much money exists inside each personal account?
* How much money exists across all accounts combined?

---

# 3. Out of Scope

The initial application will NOT include:

* Bank API integrations
* Credit card integrations
* Debit card integrations
* Payment processing
* Card issuing
* Bank statement synchronization
* Investment tracking
* Cryptocurrency tracking
* Loan management
* Debt management
* Invoice management
* Business accounting
* Tax management
* Complex bookkeeping
* Stock portfolio tracking

The purpose is personal money management, not accounting software.

---

# 4. Core Application Concepts

The system is built around six main concepts:

1. Accounts
2. Wallets
3. Income
4. Spending
5. Allowance
6. Monthly financial calculation

---

# 5. Account Structure

The application should support multiple accounts.

Example:

```text
My Money
│
├── Personal
│   ├── Cash
│   └── Whish
│
├── Work
│   ├── Cash
│   └── Whish
│
└── Savings
    ├── Cash
    └── Whish
```

The user can create as many accounts as needed.

Examples:

* Personal
* Work
* Savings
* Travel
* Family
* Emergency
* Side Business

Each account can contain one or more wallets.

---

# 6. Sub-Accounts

Accounts may optionally contain sub-accounts.

Example:

```text
Personal
│
├── Daily Spending
│   ├── Cash
│   └── Whish
│
├── Entertainment
│   └── Cash
│
└── Savings
    └── Cash
```

The system therefore supports:

```text
User
  ↓
Main Account
  ↓
Optional Sub-Account
  ↓
Wallet
```

Sub-accounts are optional.

A simple user can use:

```text
Personal
├── Cash
└── Whish
```

without creating any additional hierarchy.

---

# 7. Wallets

A wallet represents where the money physically or digitally exists.

Default wallet types:

* Cash
* Whish

The architecture should allow additional manual wallet types in the future.

Examples:

* Cash
* Whish
* OMT
* Other

Each wallet contains:

| Field           | Description          |
| --------------- | -------------------- |
| Name            | Wallet display name  |
| Type            | Cash / Whish / Other |
| Account         | Parent account       |
| Opening Balance | Initial amount       |
| Current Balance | Calculated balance   |
| Currency        | USD, LBP, etc.       |
| Active          | Active / archived    |

Example:

```text
Personal

Cash
$350

Whish
$600

Total Personal Balance
$950
```

---

# 8. Main Features

| Module    | Feature                            |
| --------- | ---------------------------------- |
| Income    | Main monthly income                |
| Income    | Additional income                  |
| Spending  | Static spending                    |
| Spending  | Dynamic spending                   |
| Allowance | Monthly allowance                  |
| Allowance | Daily allowance                    |
| Money     | Remaining money                    |
| Wallets   | Cash                               |
| Wallets   | Whish                              |
| Accounts  | Multiple accounts                  |
| Accounts  | Optional sub-accounts              |
| Accounts  | Multiple wallets per account       |
| Transfers | Move money between wallets         |
| Dashboard | Monthly financial overview         |
| History   | Income and spending history        |
| Settings  | Currency and financial preferences |

---

# 9. Main Income

Main Income represents regular expected income.

Examples:

* Monthly salary
* Regular monthly payment

Example:

```text
Main Income

Salary
$2,000
```

Fields:

| Field         | Required |
| ------------- | -------- |
| Amount        | Yes      |
| Date received | Yes      |
| Account       | Yes      |
| Wallet        | Yes      |
| Description   | No       |
| Notes         | No       |

Example:

```text
Salary: $2,000
Received into: Personal → Whish
```

The Whish balance increases by $2,000.

---

# 10. Additional Income

Additional Income represents money received outside the user's normal main income.

Examples:

* Freelance job
* Bonus
* Commission
* Gift
* Side work
* Refund
* Extra payment

Example:

```text
Additional Income

Freelance Project
$300
```

Fields:

* Amount
* Date
* Description
* Account
* Wallet
* Optional notes

Additional income contributes to total monthly income.

Formula:

```text
Total Income =
Main Income
+
Additional Income
```

Example:

```text
Main Income        $2,000
Additional Income    $400
─────────────────────────
Total Income       $2,400
```

---

# 11. Static Spending

Static Spending represents regular or predictable expenses.

Examples:

* Rent
* Internet
* Generator
* Phone
* Gym
* Subscription
* Insurance
* Parking
* Fixed household expense

Example:

```text
Rent          $500
Internet       $30
Gym            $50
Generator      $80
──────────────────
Static Total  $660
```

Static spending should support recurring monthly entries.

Fields:

* Name
* Amount
* Account
* Wallet
* Due day
* Start date
* Recurring yes/no
* Active/inactive
* Notes

Example:

```text
Internet

Amount: $30
Due: Every month on the 10th
Pay from: Personal → Whish
```

---

# 12. Static Spending Workflow

The user creates:

```text
Gym
$50
Monthly
```

The application remembers the expense.

When the new month begins, it appears as an expected static expense.

The user can mark it:

* Paid
* Pending
* Skipped

Once paid, it becomes an actual spending transaction.

This prevents the application from assuming money was spent before it actually was.

---

# 13. Dynamic Spending

Dynamic Spending represents normal variable expenses.

Examples:

* Coffee
* Food
* Fuel
* Shopping
* Restaurant
* Taxi
* Entertainment
* Groceries
* Miscellaneous

Dynamic spending is manually added whenever money is spent.

Example:

```text
Coffee
$5

Wallet:
Cash
```

The Cash balance decreases by $5.

---

# 14. Dynamic Spending Fields

Required:

* Amount
* Wallet
* Date

Optional:

* Category
* Description
* Notes

Example categories:

* Food
* Coffee
* Fuel
* Transportation
* Shopping
* Entertainment
* Groceries
* Health
* Other

Categories should remain customizable.

---

# 15. Quick Add Spending

Adding spending must be extremely fast.

Recommended flow:

```text
+ Add

$12

Food

Cash

Save
```

The user should not need to complete unnecessary fields.

Default quick entry screen:

```text
Amount
Category
Wallet
Save
```

Advanced information can remain optional.

---

# 16. Monthly Allowance

The Monthly Allowance represents how much money the user allows themselves to spend dynamically during the month.

Example:

```text
Monthly Allowance
$800
```

Static expenses are separate.

For example:

```text
Monthly Income       $2,000

Static Expenses        $700

Dynamic Allowance      $800
```

The allowance is primarily used for variable/dynamic spending.

---

# 17. Allowance Used

Formula:

```text
Allowance Used =
Total Dynamic Spending
```

Example:

```text
Monthly Allowance       $800

Dynamic Spending        $520

Allowance Remaining     $280
```

---

# 18. Allowance Remaining

Formula:

```text
Allowance Remaining =
Monthly Allowance
-
Dynamic Spending
```

Example:

```text
$800 - $520 = $280
```

If dynamic spending exceeds allowance:

```text
Allowance: $800
Spent:     $850

Remaining: -$50
```

The app should clearly indicate that the user exceeded their allowance by $50.

---

# 19. Daily Allowance

Daily Allowance is automatically calculated.

Formula:

```text
Daily Allowance =
Remaining Monthly Allowance
÷
Remaining Days
```

Example:

```text
Allowance Remaining: $300

Days Remaining: 15

Daily Allowance:
$20
```

The amount automatically changes whenever:

* Money is spent.
* The day changes.
* The monthly allowance changes.

---

# 20. Daily Allowance Example

Suppose:

```text
September Allowance
$600
```

By September 10:

```text
Dynamic Spending
$200
```

Remaining:

```text
$400
```

There are 21 days remaining including September 10.

Daily allowance becomes approximately:

```text
$19.05/day
```

The application displays:

```text
Available Today
$19.05
```

---

# 21. Today's Spending

The dashboard should show:

```text
Daily Allowance     $20

Spent Today         $13

Remaining Today      $7
```

Formula:

```text
Remaining Today =
Daily Allowance
-
Today's Dynamic Spending
```

---

# 22. Remaining Money

Remaining Money is different from allowance.

Allowance controls variable spending.

Remaining Money represents the actual monthly financial result.

Formula:

```text
Remaining Money =
Total Monthly Income
-
Static Spending
-
Dynamic Spending
```

Example:

```text
Main Income           $2,000
Additional Income       $400

Total Income           $2,400

Static Spending          $700
Dynamic Spending         $520

Total Spending         $1,220

Remaining Money        $1,180
```

---

# 23. Wallet Balance

Wallet balance represents actual money stored in the wallet.

Example:

```text
Cash
$380

Whish
$800
```

Total:

```text
$1,180
```

Wallet balances must be calculated from transactions rather than manually changed whenever possible.

---

# 24. Transfer Between Wallets

Users can move money between wallets.

Example:

```text
Transfer

From:
Personal → Whish

To:
Personal → Cash

Amount:
$100
```

Before:

```text
Whish $600
Cash  $200
```

After:

```text
Whish $500
Cash  $300
```

A transfer is:

* NOT income.
* NOT spending.
* NOT additional income.
* NOT static spending.
* NOT dynamic spending.

It only changes the location of money.

---

# 25. Transfers Between Accounts

Transfers can also occur between accounts.

Example:

```text
Personal → Cash
        ↓
Savings → Cash

$200
```

The overall user's money remains unchanged.

Only the account balances change.

---

# 26. Dashboard

The dashboard is the primary screen.

Recommended layout:

```text
September 2026

TOTAL BALANCE
$3,180

Cash
$1,280

Whish
$1,900

────────────────────

THIS MONTH

Income
$2,400

Static Spending
$700

Dynamic Spending
$520

Remaining Money
$1,180

────────────────────

ALLOWANCE

Monthly Allowance
$800

Used
$520

Remaining
$280

Daily Allowance
$20

Spent Today
$14

Available Today
$6
```

---

# 27. Dashboard Account Selector

At the top of the dashboard:

```text
All Accounts ▼
```

The user can select:

* All Accounts
* Personal
* Work
* Savings
* Any other account

If "All Accounts" is selected, calculations combine all accounts.

If "Personal" is selected, only transactions belonging to Personal are displayed.

---

# 28. Dashboard Month Selector

The user should be able to move between months.

Example:

```text
← August  | September | October →
```

Historical months remain accessible.

---

# 29. Main Flutter Navigation

Keep navigation small.

Recommended bottom navigation:

```text
Home
Spending
Accounts
Settings
```

A central floating button:

```text
+
```

opens the Add menu.

---

# 30. Add Menu

Tapping "+" shows:

```text
Add

Income
Additional Income
Static Spending
Dynamic Spending
Transfer
```

Dynamic Spending should be the fastest action.

---

# 31. Home Screen

Home contains:

* Total balance
* Cash total
* Whish total
* Income
* Additional income
* Static spending
* Dynamic spending
* Remaining money
* Monthly allowance
* Allowance used
* Allowance remaining
* Daily allowance
* Spending today

---

# 32. Spending Screen

The Spending screen shows transaction history.

Example:

```text
Today

Coffee
Dynamic Spending
-$5
Cash

Fuel
Dynamic Spending
-$30
Cash

Internet
Static Spending
-$30
Whish
```

Filters:

* All
* Static
* Dynamic

Optional filters:

* Account
* Wallet
* Date

---

# 33. Income History

Income transactions can be displayed using the same history screen.

Example:

```text
September 1

Salary
Main Income
+$2,000
Whish

September 6

Freelance Project
Additional Income
+$300
Cash
```

---

# 34. Accounts Screen

Example:

```text
Accounts

Personal
$1,200
   Cash      $400
   Whish     $800

Work
$700
   Cash      $100
   Whish     $600

Savings
$2,000
   Cash      $2,000
```

Tapping an account displays its wallets and transactions.

---

# 35. Create Account

Fields:

```text
Account Name
```

Optional:

```text
Parent Account
```

Example:

```text
Name:
Daily Spending

Parent:
Personal
```

Result:

```text
Personal
└── Daily Spending
```

---

# 36. Create Wallet

Fields:

* Wallet name
* Wallet type
* Account
* Currency
* Opening balance

Example:

```text
Wallet Name:
My Whish

Type:
Whish

Account:
Personal

Currency:
USD

Opening Balance:
$500
```

---

# 37. Settings Screen

Settings should contain:

### General

* Preferred currency
* Month settings
* Default account
* Default wallet

### Categories

* Add category
* Edit category
* Disable category

### Accounts

* Manage accounts
* Manage wallets

### Security

* PIN
* Biometrics
* Logout

### Data

* Backup
* Restore
* Export

---

# 38. Monthly Financial Lifecycle

At the beginning of a month:

1. A monthly financial period is created.
2. Monthly allowance is copied from the previous/default allowance if configured.
3. Active static expenses appear for the month.
4. The user enters their main income when received.
5. Additional income can be recorded throughout the month.
6. Static expenses are marked paid when paid.
7. Dynamic expenses are recorded daily.
8. Allowance recalculates automatically.
9. Daily allowance recalculates automatically.
10. Remaining money recalculates automatically.

---

# 39. Calculation Rules

## Total Main Income

```text
SUM(MAIN_INCOME)
```

---

## Additional Income

```text
SUM(ADDITIONAL_INCOME)
```

---

## Total Income

```text
MAIN_INCOME
+
ADDITIONAL_INCOME
```

---

## Static Spending

```text
SUM(STATIC_SPENDING)
```

Only actual/paid static expenses should count.

---

## Dynamic Spending

```text
SUM(DYNAMIC_SPENDING)
```

---

## Total Spending

```text
STATIC_SPENDING
+
DYNAMIC_SPENDING
```

---

## Remaining Money

```text
TOTAL_INCOME
-
TOTAL_SPENDING
```

---

## Allowance Remaining

```text
MONTHLY_ALLOWANCE
-
DYNAMIC_SPENDING
```

---

## Daily Allowance

```text
MAX(ALLOWANCE_REMAINING, 0)
÷
REMAINING_DAYS_IN_MONTH
```

---

## Remaining Today

```text
DAILY_ALLOWANCE
-
TODAY_DYNAMIC_SPENDING
```

---

# 40. Negative Values

The system must support negative remaining values.

Example:

```text
Allowance
$500

Spent
$550

Allowance Remaining
-$50
```

Do not automatically clamp the actual financial result to zero.

Only the suggested future daily allowance may become zero when the allowance has already been exceeded.

---

# 41. Account Balance Formula

Wallet balance:

```text
Opening Balance
+
Income Received
+
Transfers In
-
Static Spending
-
Dynamic Spending
-
Transfers Out
```

---

# 42. Total Account Balance

```text
SUM(All Wallet Balances In Account)
```

---

# 43. Total User Balance

```text
SUM(All Active Wallet Balances)
```

---

# 44. Backend Architecture

Recommended architecture:

```text
Flutter
   │
   │ HTTPS / REST API
   ▼
Node.js + Express.js
   │
   ├── Authentication Middleware
   ├── Validation
   ├── Controllers
   ├── Services
   ├── Calculation Services
   └── Database Layer
           │
           ▼
         MySQL
```

---

# 45. Backend Folder Structure

Recommended:

```text
backend/
│
├── src/
│   ├── config/
│   │   ├── database.js
│   │   └── env.js
│   │
│   ├── controllers/
│   │   ├── auth.controller.js
│   │   ├── account.controller.js
│   │   ├── wallet.controller.js
│   │   ├── transaction.controller.js
│   │   ├── staticExpense.controller.js
│   │   ├── monthlyPlan.controller.js
│   │   ├── transfer.controller.js
│   │   └── dashboard.controller.js
│   │
│   ├── services/
│   │   ├── account.service.js
│   │   ├── wallet.service.js
│   │   ├── transaction.service.js
│   │   ├── staticExpense.service.js
│   │   ├── transfer.service.js
│   │   ├── allowance.service.js
│   │   └── dashboard.service.js
│   │
│   ├── routes/
│   │
│   ├── middleware/
│   │   ├── auth.middleware.js
│   │   ├── validation.middleware.js
│   │   └── error.middleware.js
│   │
│   ├── validators/
│   │
│   ├── models/
│   │
│   ├── utils/
│   │
│   └── app.js
│
├── server.js
├── package.json
└── .env
```

---

# 46. REST API Base

Use:

```text
/api/v1
```

Example:

```text
/api/v1/accounts
/api/v1/wallets
/api/v1/transactions
```

Every endpoint returns a success envelope (`{ "success": true, "data": ... }`)
or an error envelope (`{ "success": false, "message": ..., "code": ... }`).
Public resource identifiers are UUID strings. Response monetary values are
two-decimal strings and JSON field names are camelCase.

---

# 47. Authentication

Even if the application is currently for one person, authentication should exist.

Endpoints:

```text
POST /api/v1/auth/register
POST /api/v1/auth/login
POST /api/v1/auth/refresh
POST /api/v1/auth/logout
GET  /api/v1/auth/me
```

Recommended authentication:

* JWT access token
* Refresh token
* Secure password hashing
* Flutter secure storage

---

# 48. Accounts API

```text
GET    /api/v1/accounts
POST   /api/v1/accounts
GET    /api/v1/accounts/:accountId
PATCH  /api/v1/accounts/:accountId
DELETE /api/v1/accounts/:accountId
```

Sub-accounts use:

```text
parentAccountId
```

internally. The API uses public UUID strings and the JSON field is `parentAccountId`.

The Flutter UI should display account names rather than requiring the user to enter identifiers.

---

# 49. Wallet API

```text
GET    /api/v1/wallets
POST   /api/v1/wallets
GET    /api/v1/wallets/:walletId
PATCH  /api/v1/wallets/:walletId
DELETE /api/v1/wallets/:walletId
```

Optional filter:

```text
GET /api/v1/wallets?accountId=...
```

Categories are returned and edited with public UUIDs:

```text
GET    /api/v1/categories
GET    /api/v1/categories/:categoryId
POST   /api/v1/categories
PATCH  /api/v1/categories/:categoryId
DELETE /api/v1/categories/:categoryId
```

---

# 50. Transactions API

```text
GET    /api/v1/transactions
POST   /api/v1/transactions
GET    /api/v1/transactions/:transactionId
PATCH  /api/v1/transactions/:transactionId
DELETE /api/v1/transactions/:transactionId
```

Filters:

```text
?month=
?year=
?type=
?accountId=
?walletId=
?categoryId=
?limit=1..250
?offset=0,1,2,...
```

Results remain ordered newest first. `offset` is applied after the filters and can be combined with `limit` for infinite scrolling; a page is complete when fewer than `limit` items are returned. `page` is also accepted as a one-based alternative to `offset` (`offset` and `page` cannot be combined).

---

# 51. Transaction Types

Backend enum/application values:

```text
MAIN_INCOME
ADDITIONAL_INCOME
STATIC_SPENDING
DYNAMIC_SPENDING
```

Transfers should preferably be handled separately.

---

# 52. Static Spending API

```text
GET    /api/v1/static-expenses
POST   /api/v1/static-expenses
GET    /api/v1/static-expenses/:templateId
PATCH  /api/v1/static-expenses/:templateId
DELETE /api/v1/static-expenses/:templateId
```

Monthly occurrences:

```text
GET  /api/v1/static-expenses/occurrences?year=2026&month=9
POST /api/v1/static-expenses/occurrences/generate
POST /api/v1/static-expenses/occurrences/:occurrenceId/pay
POST /api/v1/static-expenses/occurrences/:occurrenceId/skip
```

Request example:

```json
{
  "walletId": "b130e64c-7c85-4089-a292-628fdfd4e68e",
  "amount": "30.00",
  "paidAt": "2026-09-10T00:00:00.000Z"
}
```

The path identifier is the monthly occurrence UUID, not the recurring template UUID. This generates a `STATIC_SPENDING` transaction and changes the occurrence from `PENDING` to `PAID`. A pending occurrence can instead be skipped. The legacy template payment path is not part of the canonical contract.

---

# 53. Monthly Plan API

```text
GET  /api/v1/monthly-plans/:year/:month
POST /api/v1/monthly-plans
PATCH /api/v1/monthly-plans/:planId
```

Monthly plan contains primarily:

* Month
* Year
* Allowance

---

# 54. Transfer API

```text
POST /api/v1/transfers
GET  /api/v1/transfers
GET  /api/v1/transfers/:transferId
DELETE /api/v1/transfers/:transferId
```

Example:

```json
{
  "fromWalletId": "b130e64c-7c85-4089-a292-628fdfd4e68e",
  "toWalletId": "d0d6df76-2d4f-48d5-8f9c-b5b5a3190f23",
  "amount": "100.00",
  "transferDate": "2026-09-10"
}
```

Wallets must belong to the authenticated user, be different wallets, and use the same currency. Backend must perform the transfer atomically.

---

# 55. Dashboard API

Recommended endpoint:

```text
GET /api/v1/dashboard?year=2026&month=9
```

Response should contain everything Flutter needs for the dashboard.

Example:

```json
{
  "user": { "id": "b130e64c-7c85-4089-a292-628fdfd4e68e", "name": "Alex", "email": "alex@example.com", "preferredCurrency": "USD", "timezone": "UTC" },
  "period": { "year": 2026, "month": 9, "timezone": "UTC", "accountId": "all", "currencyCode": "USD" },
  "balances": [{ "currencyCode": "USD", "accountId": "b130e64c-7c85-4089-a292-628fdfd4e68e", "accountName": "Personal", "walletId": "d0d6df76-2d4f-48d5-8f9c-b5b5a3190f23", "walletName": "Cash", "walletTypeCode": "CASH", "currentBalance": "1280.00" }],
  "summaryByCurrency": [{ "currencyCode": "USD", "mainIncome": "2000.00", "additionalIncome": "400.00", "totalIncome": "2400.00", "staticSpending": "700.00", "dynamicSpending": "520.00", "totalSpending": "1220.00", "remainingMoney": "1180.00" }],
  "allowanceByCurrency": [{ "currencyCode": "USD", "monthlyAllowance": "800.00", "allowanceUsed": "520.00", "allowanceRemaining": "280.00", "dailyAllowance": "20.00", "spentToday": "14.00", "remainingToday": "6.00", "remainingDays": 20, "planId": "e5a0f3e6-0c16-4ed9-a0be-42c3d3d4f2d1" }],
  "staticExpenses": [],
  "recentTransactions": []
}
```

The complete response is wrapped in `{ "success": true, "data": ... }`. `balances`, `summaryByCurrency`, and `allowanceByCurrency` are grouped arrays so USD, LBP, EUR, and other currencies are never added together without an exchange-rate contract. Monetary values in `data` are two-decimal strings; identifiers are public UUID strings; JSON names are camelCase.

Flutter should not independently reimplement all business calculations.

The backend should be the source of truth.

---

# 56. MySQL Database Architecture

Core tables:

```text
users
accounts
wallets
categories
monthly_plans
static_expense_templates
transactions
transfers
refresh_tokens
```

---

# 57. users Table

```text
users
```

Fields:

| Column             | Type         |
| ------------------ | ------------ |
| id                 | BIGINT       |
| public_id          | CHAR/VARCHAR |
| name               | VARCHAR      |
| email              | VARCHAR      |
| password_hash      | VARCHAR      |
| preferred_currency | VARCHAR      |
| created_at         | DATETIME     |
| updated_at         | DATETIME     |

Use internal numeric IDs in the database.

Expose non-sequential public identifiers through APIs where preferred.

---

# 58. accounts Table

```text
accounts
```

Fields:

| Column            | Type              |
| ----------------- | ----------------- |
| id                | BIGINT            |
| user_id           | BIGINT            |
| parent_account_id | BIGINT NULL       |
| name              | VARCHAR           |
| description       | VARCHAR/TEXT NULL |
| is_active         | BOOLEAN           |
| created_at        | DATETIME          |
| updated_at        | DATETIME          |

Relationship:

```text
users
  1
  │
  └── many accounts
```

Self-referencing relationship:

```text
accounts.parent_account_id
      ↓
accounts.id
```

This enables sub-accounts.

---

# 59. wallets Table

```text
wallets
```

Fields:

| Column          | Type          |
| --------------- | ------------- |
| id              | BIGINT        |
| user_id         | BIGINT        |
| account_id      | BIGINT        |
| name            | VARCHAR       |
| wallet_type     | ENUM/VARCHAR  |
| currency        | VARCHAR       |
| opening_balance | DECIMAL(18,2) |
| is_active       | BOOLEAN       |
| created_at      | DATETIME      |
| updated_at      | DATETIME      |

Wallet types initially:

```text
CASH
WHISH
OTHER
```

---

# 60. categories Table

```text
categories
```

Fields:

| Column        | Type     |
| ------------- | -------- |
| id            | BIGINT   |
| user_id       | BIGINT   |
| name          | VARCHAR  |
| category_type | VARCHAR  |
| is_active     | BOOLEAN  |
| created_at    | DATETIME |
| updated_at    | DATETIME |

Initial categories:

* Food
* Coffee
* Fuel
* Transportation
* Shopping
* Entertainment
* Groceries
* Health
* Other

---

# 61. monthly_plans Table

```text
monthly_plans
```

Fields:

| Column            | Type          |
| ----------------- | ------------- |
| id                | BIGINT        |
| user_id           | BIGINT        |
| year              | SMALLINT      |
| month             | TINYINT       |
| monthly_allowance | DECIMAL(18,2) |
| created_at        | DATETIME      |
| updated_at        | DATETIME      |

Unique constraint:

```text
user_id + year + month
```

Only one plan should exist per user/month.

---

# 62. static_expense_templates Table

```text
static_expense_templates
```

Fields:

| Column            | Type          |
| ----------------- | ------------- |
| id                | BIGINT        |
| user_id           | BIGINT        |
| account_id        | BIGINT        |
| default_wallet_id | BIGINT NULL   |
| name              | VARCHAR       |
| amount            | DECIMAL(18,2) |
| due_day           | TINYINT       |
| start_date        | DATE          |
| end_date          | DATE NULL     |
| is_active         | BOOLEAN       |
| created_at        | DATETIME      |
| updated_at        | DATETIME      |

Examples:

```text
Rent
Internet
Gym
Generator
```

---

# 63. transactions Table

```text
transactions
```

Fields:

| Column                     | Type          |
| -------------------------- | ------------- |
| id                         | BIGINT        |
| user_id                    | BIGINT        |
| account_id                 | BIGINT        |
| wallet_id                  | BIGINT        |
| category_id                | BIGINT NULL   |
| static_expense_template_id | BIGINT NULL   |
| transaction_type           | VARCHAR/ENUM  |
| amount                     | DECIMAL(18,2) |
| description                | VARCHAR       |
| notes                      | TEXT NULL     |
| transaction_date           | DATETIME      |
| created_at                 | DATETIME      |
| updated_at                 | DATETIME      |

Transaction types:

```text
MAIN_INCOME
ADDITIONAL_INCOME
STATIC_SPENDING
DYNAMIC_SPENDING
```

All amounts should be stored as positive values.

Transaction type determines whether the balance increases or decreases.

---

# 64. transfers Table

```text
transfers
```

Fields:

| Column         | Type          |
| -------------- | ------------- |
| id             | BIGINT        |
| user_id        | BIGINT        |
| from_wallet_id | BIGINT        |
| to_wallet_id   | BIGINT        |
| amount         | DECIMAL(18,2) |
| notes          | TEXT NULL     |
| transfer_date  | DATETIME      |
| created_at     | DATETIME      |

Transfers must never appear as income or spending.

---

# 65. Database Relationships

Simplified:

```text
USER
 │
 ├── ACCOUNTS
 │      │
 │      ├── SUB-ACCOUNTS
 │      │
 │      └── WALLETS
 │
 ├── MONTHLY PLANS
 │
 ├── CATEGORIES
 │
 ├── STATIC EXPENSE TEMPLATES
 │
 ├── TRANSACTIONS
 │
 └── TRANSFERS
```

---

# 66. Balance Strategy

Do not make `current_balance` the primary source of truth.

Calculate balances from:

```text
Opening Balance
+
Ledger Activity
```

This prevents balance inconsistencies.

If performance becomes important later, cached balances can be introduced.

---

# 67. Transaction Safety

Any operation affecting multiple financial records must use a MySQL database transaction.

Especially:

* Transfers
* Transaction edits
* Transaction deletion
* Static expense payment

Example:

```text
BEGIN

Validate wallet
Validate balance
Create transfer
Update related data

COMMIT
```

On failure:

```text
ROLLBACK
```

---

# 68. Backend Validation

Every money amount must:

* Be numeric.
* Be greater than zero.
* Use decimal-safe database fields.
* Never use floating-point database types for currency.

Use:

```text
DECIMAL(18,2)
```

or a suitable higher precision where necessary.

---

# 69. Transfer Validation

A transfer must verify:

```text
from_wallet != to_wallet
amount > 0
source wallet belongs to user
destination wallet belongs to user
```

Optionally prevent transferring more than the source wallet balance.

---

# 70. Ownership Security

Every API operation must be scoped to the authenticated user.

Never perform:

```sql
SELECT * FROM wallets WHERE id = ?
```

without ownership verification.

Use logically:

```sql
WHERE id = ?
AND user_id = authenticated_user
```

The same applies to:

* Accounts
* Transactions
* Categories
* Monthly plans
* Transfers
* Static expenses

---

# 71. Flutter Architecture

Recommended structure:

```text
lib/
│
├── core/
│   ├── api/
│   ├── config/
│   ├── constants/
│   ├── errors/
│   ├── storage/
│   ├── theme/
│   └── utils/
│
├── features/
│   ├── auth/
│   ├── home/
│   ├── accounts/
│   ├── wallets/
│   ├── transactions/
│   ├── income/
│   ├── spending/
│   ├── allowance/
│   ├── transfers/
│   └── settings/
│
└── main.dart
```

Within a feature:

```text
feature/
├── models/
├── pages/
├── widgets/
├── repositories/
├── services/
└── state/
```

---

# 72. Flutter Recommended Technology

Recommended components:

### Networking

```text
Dio
```

### Routing

```text
go_router
```

### State Management

```text
Riverpod
```

### Secure Storage

```text
flutter_secure_storage
```

### Local Preferences

```text
shared_preferences
```

These choices may be replaced with existing project standards if the Flutter project already uses another architecture.

---

# 73. Flutter Screens

Minimum screen list:

```text
Splash
Login

Home

Transaction History
Add Income
Add Additional Income
Add Dynamic Spending

Static Spending List
Add Static Spending
Static Spending Details

Accounts
Account Details
Create Account

Wallets
Wallet Details
Create Wallet

Transfer Money

Monthly Allowance

Categories

Settings
Profile
```

---

# 74. Home Widgets

Reusable Flutter widgets:

```text
TotalBalanceCard
WalletBalanceRow
MonthlySummaryCard
IncomeSummaryCard
SpendingSummaryCard
AllowanceProgressCard
DailyAllowanceCard
TodaySpendingCard
AccountSelector
MonthSelector
RecentTransactionsList
```

---

# 75. Add Dynamic Spending Screen

Recommended UI:

```text
Add Spending

Amount
[ $ 0.00 ]

Category
[ Food ▼ ]

Pay From
[ Cash ▼ ]

Date
[ Today ]

Description
[ Optional ]

        Save
```

The keyboard should automatically open on the amount field.

---

# 76. Account Selection UX

Never ask the user to manually enter an account ID.

Use:

```text
Account
[ Personal ▼ ]
```

and:

```text
Wallet
[ Cash ▼ ]
```

The Flutter app internally sends the related identifier to the API.

---

# 77. Static Expense UX

Example:

```text
Internet

$30

Monthly
Due on 10th

Default Wallet
Whish

Status
Pending

[ Mark Paid ]
```

When paid:

```text
Paid September 10
```

and a spending transaction is created.

---

# 78. Monthly Allowance UX

Example:

```text
September Allowance

$800

Spent
$520

Remaining
$280

35% Remaining

Daily Allowance
$20
```

A simple progress indicator can visually represent allowance usage.

---

# 79. Data Editing

Users must be able to edit accidental entries.

Example:

```text
Coffee
$50
```

was supposed to be:

```text
Coffee
$5
```

Editing the transaction must automatically recalculate:

* Wallet balance
* Dynamic spending
* Remaining money
* Allowance remaining
* Daily allowance

---

# 80. Data Deletion

Deleting a transaction must also recalculate all affected values.

The backend should perform the recalculation automatically.

Flutter should refresh the dashboard after successful deletion.

---

# 81. Date Handling

All transactions require a transaction date.

Store timestamps consistently on the backend.

The frontend displays them in the user's local timezone.

Monthly calculations must use the user's configured timezone.

---

# 82. Currency

Each wallet has one currency and transfers are same-currency only. The backend supports multiple currencies per user.

Example:

```text
Personal Cash
USD

Personal Whish
USD
```

If using LBP:

```text
LBP Cash
LBP
```

Do not automatically combine different currencies into a total unless an exchange-rate system is implemented. Display separate totals and allowance cards by currency using the dashboard arrays.

Example:

```text
USD Total
$1,800

LBP Total
45,000,000 LBP
```

---

# 83. Security

Minimum security requirements:

* Password hashing using bcrypt/Argon2.
* JWT authentication.
* Refresh token handling.
* HTTPS only in production.
* Secure Flutter token storage.
* API rate limiting.
* Input validation.
* SQL injection protection.
* Authentication middleware.
* User ownership validation.
* No sensitive information in application logs.

---

# 84. Error Handling

Backend response standard:

Successful:

```json
{
  "success": true,
  "data": {}
}
```

Error:

```json
{
  "success": false,
  "message": "Insufficient wallet balance",
  "code": "INSUFFICIENT_BALANCE"
}
```

Flutter should map error codes into user-friendly messages.

---

# 85. Important Edge Cases

The application must correctly handle:

### No income

Remaining money can be negative.

### Allowance exceeded

Allowance remaining becomes negative.

### Wallet reaches zero

Spending should be prevented if negative wallet balances are disabled.

### Editing older transaction

Historical month totals and wallet balances must recalculate.

### Deleted transaction

Balances and dashboard values must recalculate.

### Static expense changes

Changing future static expense amount should not modify historical paid transactions.

### Transfer

Must never affect total income or total spending.

### Multiple accounts

Selecting one account only displays its financial activity.

---

# 86. Default Application Setup

When a new user registers, optionally create:

```text
Personal
├── Cash
└── Whish
```

Default categories:

```text
Food
Coffee
Groceries
Fuel
Transportation
Shopping
Entertainment
Health
Other
```

The user can edit them later.

---

# 87. Example Full Monthly Workflow

User starts September.

Opening balances:

```text
Cash
$300

Whish
$200
```

Total:

```text
$500
```

Salary received:

```text
+$2,000
Whish
```

Additional freelance income:

```text
+$400
Cash
```

Balances now:

```text
Cash
$700

Whish
$2,200
```

Static spending:

```text
Rent      -$500
Internet   -$30
Gym        -$50
Generator  -$80

Total
-$660
```

Dynamic spending:

```text
Food         -$200
Fuel         -$120
Entertainment -$100

Total
-$420
```

Monthly financial summary:

```text
Main Income
$2,000

Additional Income
$400

Total Income
$2,400

Static Spending
$660

Dynamic Spending
$420

Total Spending
$1,080

Remaining Money
$1,320
```

If allowance:

```text
$800
```

Then:

```text
Allowance Used
$420

Allowance Remaining
$380
```

If 19 days remain:

```text
Daily Allowance
$20/day
```

---

# 88. MVP Definition

The first production-ready version should contain:

### Authentication

* Register
* Login
* Logout

### Accounts

* Create account
* Edit account
* Archive account
* Sub-accounts

### Wallets

* Cash
* Whish
* Opening balance
* Wallet balance

### Income

* Main income
* Additional income

### Spending

* Static spending
* Dynamic spending

### Allowance

* Monthly allowance
* Used allowance
* Remaining allowance
* Daily allowance

### Financial Overview

* Total income
* Total spending
* Remaining money
* Total balance

### Transfers

* Wallet-to-wallet
* Account-to-account

### History

* Transaction history
* Edit transaction
* Delete transaction

### Dashboard

* Current month summary
* Account selector
* Month selector

---

# 89. Recommended Implementation Phases

## Phase 1 — Foundation

Build:

* Node.js project
* MySQL connection
* Environment configuration
* Authentication
* User model
* API structure
* Flutter project foundation
* Routing
* Authentication flow

---

## Phase 2 — Accounts & Wallets

Build:

* Accounts
* Sub-accounts
* Cash wallet
* Whish wallet
* Opening balances
* Account balances
* Total balance

---

## Phase 3 — Income & Spending

Build:

* Main income
* Additional income
* Dynamic spending
* Categories
* Transaction history
* Edit/delete transaction

---

## Phase 4 — Static Spending

Build:

* Static expense templates
* Monthly recurring expenses
* Pending/paid state
* Mark-paid workflow

---

## Phase 5 — Allowance

Build:

* Monthly allowance
* Allowance used
* Allowance remaining
* Daily allowance
* Today spending
* Remaining today

---

## Phase 6 — Transfers

Build:

* Cash ↔ Whish
* Account ↔ Account
* Transfer history
* Transaction-safe backend logic

---

## Phase 7 — Dashboard

Build final dashboard containing:

* Total balance
* Cash balance
* Whish balance
* Main income
* Additional income
* Static spending
* Dynamic spending
* Remaining money
* Monthly allowance
* Allowance remaining
* Daily allowance

---

## Phase 8 — Final Quality

Complete:

* Validation
* Security
* Error handling
* Loading states
* Empty states
* Responsive Flutter layouts
* Transaction tests
* API tests
* Calculation tests
* Authentication tests

---

# 90. Acceptance Criteria

The application is considered functionally complete when:

1. A user can create multiple accounts.
2. Accounts can contain sub-accounts.
3. Each account can contain Cash and/or Whish wallets.
4. Wallet balances are accurate.
5. Main income can be added.
6. Additional income can be added.
7. Static spending can be configured.
8. Static spending can be marked paid.
9. Dynamic spending can be entered quickly.
10. Monthly allowance can be configured.
11. Allowance used calculates automatically.
12. Allowance remaining calculates automatically.
13. Daily allowance recalculates automatically.
14. Today's spending is calculated.
15. Remaining monthly money is calculated.
16. Money can be transferred between wallets.
17. Transfers don't count as spending or income.
18. Historical transactions can be viewed.
19. Transactions can be edited.
20. Transactions can be deleted.
21. The dashboard can display one account or all accounts.
22. Previous months can be viewed.
23. Every record is scoped securely to its owner.
24. Financial calculations remain consistent after editing or deleting transactions.

---

# 91. Final Product Structure

The final application can be summarized as:

```text
PERSONAL MONEY TRACKER

                    ┌───────────────┐
                    │     USER      │
                    └───────┬───────┘
                            │
                  ┌─────────┴─────────┐
                  │                   │
              ACCOUNTS            MONTH PLAN
                  │                   │
           ┌──────┴──────┐      ┌────┴─────┐
           │             │      │          │
      SUB-ACCOUNTS     WALLETS Allowance Static
                         │
                    ┌────┴────┐
                    │         │
                  CASH       WHISH
                    │         │
                    └────┬────┘
                         │
                   TRANSACTIONS
                         │
            ┌────────────┼────────────┐
            │            │            │
          INCOME       SPENDING    TRANSFER
            │            │
       ┌────┴────┐   ┌───┴────┐
       │         │   │        │
      MAIN      EXTRA STATIC DYNAMIC
```

The resulting Flutter application remains simple from the user's perspective:

```text
HOME
│
├── Money Available
├── Income
├── Spending
├── Remaining Money
├── Monthly Allowance
└── Daily Allowance

SPENDING
│
├── Static
├── Dynamic
└── History

ACCOUNTS
│
├── Personal
│   ├── Cash
│   └── Whish
│
├── Work
└── Additional Accounts

SETTINGS
```

The backend and database provide enough structure to keep the financial data reliable, while the Flutter interface remains intentionally lightweight and easy to use.

---

# 92. Recommended Final Stack

```text
Mobile Application
Flutter + Dart

State Management
Riverpod

Navigation
go_router

HTTP Client
Dio

Secure Local Storage
flutter_secure_storage

Backend
Node.js + Express.js

Authentication
JWT Access + Refresh Tokens

Database
MySQL

API
REST / JSON

Production Communication
HTTPS
```

This architecture provides a clean foundation for the exact application described without introducing unnecessary banking, accounting, or enterprise features.
