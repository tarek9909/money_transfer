import request from "supertest";
import { afterAll, describe, expect, it } from "vitest";
import { app } from "../src/app.js";
import { pool } from "../src/db.js";

const live = process.env.RUN_LIVE_API === "1";
const uuid =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
const money = /^-?\d+\.\d{2}$/;

function success(response: request.Response, status = 200) {
  expect(response.status, JSON.stringify(response.body)).toBe(status);
  expect(response.headers["content-type"]).toContain("application/json");
  expect(response.body.success).toBe(true);
  expect(response.body).toHaveProperty("data");
  return response.body.data as any;
}

function failure(response: request.Response, status: number, code: string) {
  expect(response.status).toBe(status);
  expect(response.headers["content-type"]).toContain("application/json");
  expect(response.body).toMatchObject({ success: false, code });
}

function expectMoney(value: unknown) {
  expect(typeof value).toBe("string");
  expect(value).toMatch(money);
}

function expectId(value: unknown) {
  expect(typeof value).toBe("string");
  expect(value).toMatch(uuid);
}

describe.skipIf(!live)("live API route and response contract", () => {
  const createdUsers: string[] = [];

  afterAll(async () => {
    // This is a disposable local test database. Remove only the users created
    // by this suite, including their restricted foreign-key children.
    if (createdUsers.length) {
      const connection = await pool.getConnection();
      try {
        await connection.query("SET FOREIGN_KEY_CHECKS = 0");
        for (const publicId of createdUsers) {
          const [rows] = await connection.execute(
            "SELECT id FROM users WHERE public_id = ?",
            [publicId],
          );
          const userId = (rows as Array<{ id: number }>)[0]?.id;
          if (!userId) continue;
          for (const table of [
            "refresh_tokens",
            "static_expense_occurrences",
            "transactions",
            "transfers",
            "static_expense_templates",
            "monthly_plans",
            "categories",
            "wallets",
            "user_preferences",
            "accounts",
            "users",
          ])
            await connection.execute(
              table === "users"
                ? "DELETE FROM users WHERE id = ?"
                : `DELETE FROM ${table} WHERE user_id = ?`,
              [userId],
            );
        }
        await connection.query("SET FOREIGN_KEY_CHECKS = 1");
      } finally {
        connection.release();
      }
    }
    await pool.end();
  });

  it("exercises authentication, CRUD, ledger, recurring expenses, plans, transfers, dashboard, and isolation", async () => {
    const today = new Date();
    const date = `${today.getUTCFullYear()}-${String(today.getUTCMonth() + 1).padStart(2, "0")}-${String(today.getUTCDate()).padStart(2, "0")}`;
    const year = today.getUTCFullYear();
    const month = today.getUTCMonth() + 1;
    const email = `live-${Date.now()}@example.com`;

    const health = success(await request(app).get("/health"));
    expect(health).toEqual({ status: "ok" });

    failure(await request(app).get("/api/v1/accounts"), 401, "UNAUTHORIZED");
    failure(
      await request(app)
        .post("/api/v1/auth/register")
        .send({ email: "invalid" }),
      400,
      "VALIDATION_ERROR",
    );

    const registered = success(
      await request(app).post("/api/v1/auth/register").send({
        name: "Live API Tester",
        email,
        password: "a-secure-password-123",
        preferredCurrency: "USD",
      }),
      201,
    );
    expectId(registered.user.id);
    expect(registered.user).toMatchObject({
      name: "Live API Tester",
      email,
      preferredCurrency: "USD",
      timezone: "UTC",
    });
    expect(typeof registered.session.accessToken).toBe("string");
    expect(typeof registered.session.refreshToken).toBe("string");
    createdUsers.push(registered.user.id);
    let accessToken = registered.session.accessToken as string;
    let refreshToken = registered.session.refreshToken as string;

    const loggedIn = success(
      await request(app).post("/api/v1/auth/login").send({
        email: email.toUpperCase(),
        password: "a-secure-password-123",
      }),
    );
    expectId(loggedIn.user.id);
    expect(typeof loggedIn.session.accessToken).toBe("string");
    const rotated = success(
      await request(app).post("/api/v1/auth/refresh").send({ refreshToken }),
    );
    expect(typeof rotated.session.accessToken).toBe("string");
    accessToken = rotated.session.accessToken;
    refreshToken = rotated.session.refreshToken;
    failure(
      await request(app)
        .post("/api/v1/auth/refresh")
        .send({ refreshToken: registered.session.refreshToken }),
      401,
      "INVALID_REFRESH_TOKEN",
    );

    const auth = { Authorization: `Bearer ${accessToken}` };
    const me = success(await request(app).get("/api/v1/auth/me").set(auth));
    expect(me).toMatchObject({
      id: registered.user.id,
      email,
      preferredCurrency: "USD",
      timezone: "UTC",
    });

    const preferences = success(
      await request(app).get("/api/v1/users/me/preferences").set(auth),
    );
    expect(preferences).toMatchObject({
      financialMonthStart: 1,
      allowNegativeWallets: false,
      timezone: "UTC",
      preferredCurrency: "USD",
    });
    const walletTypes = success(
      await request(app).get("/api/v1/wallet-types").set(auth),
    );
    expect(Array.isArray(walletTypes)).toBe(true);
    expect(walletTypes.length).toBeGreaterThanOrEqual(2);
    expect(walletTypes[0]).toEqual(
      expect.objectContaining({
        code: expect.any(String),
        displayName: expect.any(String),
        isSystem: expect.any(Boolean),
      }),
    );

    const accounts = success(
      await request(app).get("/api/v1/accounts").set(auth),
    );
    expect(Array.isArray(accounts)).toBe(true);
    expect(accounts.length).toBeGreaterThan(0);
    const account = accounts[0];
    expectId(account.id);
    expect(account).toEqual(
      expect.objectContaining({
        name: expect.any(String),
        isActive: true,
        wallets: expect.any(Array),
      }),
    );
    const cash = account.wallets.find(
      (wallet: any) => wallet.walletTypeCode === "CASH",
    );
    const whish = account.wallets.find(
      (wallet: any) => wallet.walletTypeCode === "WHISH",
    );
    expect(cash).toBeDefined();
    expect(whish).toBeDefined();
    expectId(cash.id);
    expectMoney(cash.currentBalance);

    const accountDetail = success(
      await request(app).get(`/api/v1/accounts/${account.id}`).set(auth),
    );
    expect(accountDetail.id).toBe(account.id);
    expect(accountDetail.wallets.length).toBeGreaterThanOrEqual(2);
    const accountPatch = success(
      await request(app)
        .patch(`/api/v1/accounts/${account.id}`)
        .set(auth)
        .send({ description: "Updated live account" }),
    );
    expect(accountPatch.description).toBe("Updated live account");

    const childAccount = success(
      await request(app)
        .post("/api/v1/accounts")
        .set(auth)
        .send({ name: "Live Child", parentAccountId: account.id }),
      201,
    );
    expect(childAccount.parentAccountId).toBe(account.id);
    const childPatch = success(
      await request(app)
        .patch(`/api/v1/accounts/${childAccount.id}`)
        .set(auth)
        .send({ name: "Live Child Updated" }),
    );
    expect(childPatch.name).toBe("Live Child Updated");
    success(
      await request(app)
        .delete(`/api/v1/accounts/${childAccount.id}`)
        .set(auth),
    );

    const preferenceAccount = success(
      await request(app)
        .post("/api/v1/accounts")
        .set(auth)
        .send({ name: "Live Preference Account" }),
      201,
    );
    const preferenceWallet = success(
      await request(app).post("/api/v1/wallets").set(auth).send({
        accountId: preferenceAccount.id,
        name: "Live Preference Wallet",
        walletTypeCode: "OTHER",
        currencyCode: "USD",
        openingBalance: "0.00",
      }),
      201,
    );
    failure(
      await request(app)
        .patch("/api/v1/users/me/preferences")
        .set(auth)
        .send({
          defaultAccountId: account.id,
          defaultWalletId: preferenceWallet.id,
        }),
      400,
      "ACCOUNT_WALLET_MISMATCH",
    );
    const updatedPreferences = success(
      await request(app).patch("/api/v1/users/me/preferences").set(auth).send({
        defaultAccountId: account.id,
        defaultWalletId: cash.id,
        financialMonthStart: 2,
        allowNegativeWallets: true,
      }),
    );
    expect(updatedPreferences).toMatchObject({
      defaultAccountId: account.id,
      defaultWalletId: cash.id,
      financialMonthStart: 2,
      allowNegativeWallets: true,
    });

    const newWallet = success(
      await request(app).post("/api/v1/wallets").set(auth).send({
        accountId: account.id,
        name: "Live Reserve",
        walletTypeCode: "OTHER",
        currencyCode: "USD",
        openingBalance: "5.00",
      }),
      201,
    );
    expectId(newWallet.id);
    expect(newWallet.accountId).toBe(account.id);
    expectMoney(newWallet.openingBalance);
    const walletDetail = success(
      await request(app).get(`/api/v1/wallets/${newWallet.id}`).set(auth),
    );
    expect(walletDetail.id).toBe(newWallet.id);
    const walletPatch = success(
      await request(app)
        .patch(`/api/v1/wallets/${newWallet.id}`)
        .set(auth)
        .send({ name: "Live Reserve Updated" }),
    );
    expect(walletPatch.name).toBe("Live Reserve Updated");
    const wallets = success(
      await request(app)
        .get(`/api/v1/wallets?accountId=${account.id}`)
        .set(auth),
    );
    expect(wallets.some((wallet: any) => wallet.id === newWallet.id)).toBe(
      true,
    );

    const categories = success(
      await request(app).get("/api/v1/categories").set(auth),
    );
    const incomeCategories = success(
      await request(app).get("/api/v1/categories?appliesTo=INCOME").set(auth),
    );
    const spendingCategories = success(
      await request(app).get("/api/v1/categories?appliesTo=SPENDING").set(auth),
    );
    expect(categories.length).toBeGreaterThan(0);
    expect(
      incomeCategories.some((category: any) => category.appliesTo === "INCOME"),
    ).toBe(true);
    expect(
      spendingCategories.some(
        (category: any) => category.appliesTo === "SPENDING",
      ),
    ).toBe(true);
    const salary = incomeCategories.find(
      (category: any) => category.appliesTo === "INCOME",
    );
    const food = spendingCategories.find(
      (category: any) => category.appliesTo === "SPENDING",
    );
    const customCategory = success(
      await request(app)
        .post("/api/v1/categories")
        .set(auth)
        .send({ name: "Live Category", appliesTo: "SPENDING" }),
      201,
    );
    const categoryDetail = success(
      await request(app)
        .get(`/api/v1/categories/${customCategory.id}`)
        .set(auth),
    );
    expect(categoryDetail).toEqual(
      expect.objectContaining({ id: customCategory.id, name: "Live Category" }),
    );
    const categoryPatch = success(
      await request(app)
        .patch(`/api/v1/categories/${customCategory.id}`)
        .set(auth)
        .send({ name: "Live Category Updated" }),
    );
    expect(categoryPatch.name).toBe("Live Category Updated");

    const income = success(
      await request(app).post("/api/v1/transactions").set(auth).send({
        transactionType: "MAIN_INCOME",
        amount: "100.00",
        walletId: cash.id,
        categoryId: salary.id,
        description: "Live salary",
        transactionDate: date,
      }),
      201,
    );
    expectId(income.id);
    expect(income).toEqual(
      expect.objectContaining({
        transactionType: "MAIN_INCOME",
        accountId: account.id,
        walletId: cash.id,
        accountName: expect.any(String),
        walletName: expect.any(String),
      }),
    );
    expectMoney(income.amount);
    const incomeDetail = success(
      await request(app).get(`/api/v1/transactions/${income.id}`).set(auth),
    );
    expect(incomeDetail.id).toBe(income.id);
    const incomePatch = success(
      await request(app)
        .patch(`/api/v1/transactions/${income.id}`)
        .set(auth)
        .send({ amount: "90.00", description: "Live salary updated" }),
    );
    expect(incomePatch.amount).toBe("90.00");

    const spending = success(
      await request(app).post("/api/v1/transactions").set(auth).send({
        transactionType: "DYNAMIC_SPENDING",
        amount: "20.00",
        walletId: cash.id,
        categoryId: food.id,
        description: "Live groceries",
        transactionDate: date,
      }),
      201,
    );
    expect(spending.transactionType).toBe("DYNAMIC_SPENDING");
    const transactionList = success(
      await request(app)
        .get(`/api/v1/transactions?year=${year}&month=${month}&limit=10`)
        .set(auth),
    );
    expect(
      transactionList.some((transaction: any) => transaction.id === income.id),
    ).toBe(true);
    expect(
      transactionList.some(
        (transaction: any) => transaction.id === spending.id,
      ),
    ).toBe(true);
    const filteredTransactions = success(
      await request(app)
        .get(`/api/v1/transactions?walletId=${cash.id}&type=DYNAMIC_SPENDING`)
        .set(auth),
    );
    expect(
      filteredTransactions.every(
        (transaction: any) =>
          transaction.walletId === cash.id &&
          transaction.transactionType === "DYNAMIC_SPENDING",
      ),
    ).toBe(true);
    const pagedTransactions = await request(app)
      .get(`/api/v1/transactions?year=${year}&month=${month}&limit=1&offset=1`)
      .set(auth)
      .expect(200);
    expect(pagedTransactions.headers["x-pagination-limit"]).toBe("1");
    expect(pagedTransactions.headers["x-pagination-offset"]).toBe("1");
    expect(success(pagedTransactions)).toHaveLength(1);

    const plan = success(
      await request(app).post("/api/v1/monthly-plans").set(auth).send({
        planYear: year,
        planMonth: month,
        currencyCode: "USD",
        monthlyAllowance: "50.00",
        notes: "Live plan",
      }),
      201,
    );
    expect(plan).toEqual(
      expect.objectContaining({
        currencyCode: "USD",
        monthlyAllowance: "50.00",
        allowanceUsed: "20.00",
        allowanceRemaining: "30.00",
        planId: expect.any(String),
      }),
    );
    const planByPeriod = success(
      await request(app)
        .get(`/api/v1/monthly-plans/${year}/${month}?currencyCode=USD`)
        .set(auth),
    );
    expect(planByPeriod.planId).toBe(plan.planId);
    const planPatch = success(
      await request(app)
        .patch(`/api/v1/monthly-plans/${plan.planId}`)
        .set(auth)
        .send({ monthlyAllowance: "60.00" }),
    );
    expect(planPatch.monthlyAllowance).toBe("60.00");
    const currentPlan = success(
      await request(app)
        .get("/api/v1/monthly-plans/current?currencyCode=USD")
        .set(auth),
    );
    expect(currentPlan).toEqual(
      expect.objectContaining({
        currencyCode: "USD",
        monthlyAllowance: expect.any(String),
      }),
    );

    const template = success(
      await request(app)
        .post("/api/v1/static-expenses")
        .set(auth)
        .send({
          accountId: account.id,
          defaultWalletId: cash.id,
          categoryId: food.id,
          name: "Live recurring expense",
          defaultAmount: "10.00",
          dueDay: today.getUTCDate(),
          startDate: `${year}-01-01`,
          notes: "Live test template",
        }),
      201,
    );
    expectId(template.id);
    expect(template).toEqual(
      expect.objectContaining({
        accountId: account.id,
        defaultWalletId: cash.id,
        dueDay: today.getUTCDate(),
        isActive: true,
      }),
    );
    const templatePatch = success(
      await request(app)
        .patch(`/api/v1/static-expenses/${template.id}`)
        .set(auth)
        .send({ name: "Live recurring expense updated" }),
    );
    expect(templatePatch.name).toBe("Live recurring expense updated");
    const templateDetail = success(
      await request(app)
        .get(`/api/v1/static-expenses/${template.id}`)
        .set(auth),
    );
    expect(templateDetail).toEqual(
      expect.objectContaining({
        id: template.id,
        name: "Live recurring expense updated",
      }),
    );
    const staticCollection = success(
      await request(app)
        .get(`/api/v1/static-expenses?year=${year}&month=${month}`)
        .set(auth),
    );
    expect(staticCollection).toEqual(
      expect.objectContaining({
        year,
        month,
        templates: expect.any(Array),
        occurrences: expect.any(Array),
      }),
    );
    const occurrence = staticCollection.occurrences.find(
      (item: any) => item.templateId === template.id,
    );
    expect(occurrence).toBeDefined();
    expect(occurrence).toEqual(
      expect.objectContaining({
        templateId: template.id,
        accountId: account.id,
        currencyCode: "USD",
        status: "PENDING",
      }),
    );
    const generated = success(
      await request(app)
        .post("/api/v1/static-expenses/occurrences/generate")
        .set(auth)
        .send({ year, month }),
    );
    expect(generated).toEqual({ generated: true, year, month });
    const occurrenceCollection = success(
      await request(app)
        .get(`/api/v1/static-expenses/occurrences?year=${year}&month=${month}`)
        .set(auth),
    );
    expect(
      occurrenceCollection.some((item: any) => item.id === occurrence.id),
    ).toBe(true);
    const paid = success(
      await request(app)
        .post(`/api/v1/static-expenses/occurrences/${occurrence.id}/pay`)
        .set(auth)
        .send({ walletId: cash.id, amount: "10.00" }),
    );
    expect(paid).toEqual(
      expect.objectContaining({
        paid: true,
        transactionId: expect.any(String),
      }),
    );
    const paidOccurrences = success(
      await request(app)
        .get(`/api/v1/static-expenses/occurrences?year=${year}&month=${month}`)
        .set(auth),
    );
    expect(
      paidOccurrences.find((item: any) => item.id === occurrence.id).status,
    ).toBe("PAID");
    success(
      await request(app)
        .delete(`/api/v1/transactions/${paid.transactionId}`)
        .set(auth),
    );
    const reopenedOccurrences = success(
      await request(app)
        .get(`/api/v1/static-expenses/occurrences?year=${year}&month=${month}`)
        .set(auth),
    );
    expect(
      reopenedOccurrences.find((item: any) => item.id === occurrence.id).status,
    ).toBe("PENDING");
    success(
      await request(app)
        .post(`/api/v1/static-expenses/occurrences/${occurrence.id}/skip`)
        .set(auth),
    );
    failure(
      await request(app)
        .post(`/api/v1/static-expenses/occurrences/${occurrence.id}/skip`)
        .set(auth),
      409,
      "OCCURRENCE_NOT_PENDING",
    );

    const transfer = success(
      await request(app).post("/api/v1/transfers").set(auth).send({
        fromWalletId: cash.id,
        toWalletId: whish.id,
        amount: "10.00",
        transferDate: date,
        notes: "Live transfer",
      }),
      201,
    );
    const transferDetail = success(
      await request(app)
        .get(`/api/v1/transfers/${transfer.id}`)
        .set(auth),
    );
    expect(transferDetail).toEqual(
      expect.objectContaining({ id: transfer.id, amount: "10.00" }),
    );
    expect(transfer).toEqual(
      expect.objectContaining({
        transferred: true,
        fromWalletId: cash.id,
        toWalletId: whish.id,
        amount: "10.00",
        currencyCode: "USD",
      }),
    );
    const transfers = success(
      await request(app)
        .get(`/api/v1/transfers?year=${year}&month=${month}`)
        .set(auth),
    );
    expect(transfers.some((item: any) => item.id === transfer.id)).toBe(true);
    success(
      await request(app).delete(`/api/v1/transfers/${transfer.id}`).set(auth),
    );
    failure(
      await request(app).delete(`/api/v1/transfers/${transfer.id}`).set(auth),
      404,
      "TRANSFER_NOT_FOUND",
    );
    failure(
      await request(app).post("/api/v1/transfers").set(auth).send({
        fromWalletId: cash.id,
        toWalletId: cash.id,
        amount: "1.00",
        transferDate: date,
      }),
      400,
      "SAME_WALLET",
    );

    const dashboard = success(
      await request(app)
        .get(
          `/api/v1/dashboard?year=${year}&month=${month}&accountId=${account.id}&currencyCode=USD`,
        )
        .set(auth),
    );
    expect(dashboard).toEqual(
      expect.objectContaining({
        user: expect.any(Object),
        period: expect.objectContaining({
          year,
          month,
          accountId: account.id,
          currencyCode: "USD",
        }),
        balances: expect.any(Array),
        summaryByCurrency: expect.any(Array),
        allowanceByCurrency: expect.any(Array),
        staticExpenses: expect.any(Array),
        recentTransactions: expect.any(Array),
      }),
    );
    expect(dashboard.summaryByCurrency[0]).toEqual(
      expect.objectContaining({
        currencyCode: "USD",
        totalIncome: expect.any(String),
        totalSpending: expect.any(String),
        remainingMoney: expect.any(String),
      }),
    );

    success(
      await request(app)
        .delete(`/api/v1/categories/${customCategory.id}`)
        .set(auth),
    );
    success(
      await request(app)
        .delete(`/api/v1/static-expenses/${template.id}`)
        .set(auth),
    );
    success(
      await request(app).delete(`/api/v1/wallets/${newWallet.id}`).set(auth),
    );
    success(
      await request(app)
        .delete(`/api/v1/wallets/${preferenceWallet.id}`)
        .set(auth),
    );
    success(
      await request(app)
        .delete(`/api/v1/accounts/${preferenceAccount.id}`)
        .set(auth),
    );

    const secondEmail = `live-second-${Date.now()}@example.com`;
    const second = success(
      await request(app).post("/api/v1/auth/register").send({
        name: "Second User",
        email: secondEmail,
        password: "a-secure-password-123",
        preferredCurrency: "USD",
      }),
      201,
    );
    createdUsers.push(second.user.id);
    failure(
      await request(app)
        .get(`/api/v1/accounts/${account.id}`)
        .set({ Authorization: `Bearer ${second.session.accessToken}` }),
      404,
      "ACCOUNT_NOT_FOUND",
    );

    success(
      await request(app).post("/api/v1/auth/logout").send({ refreshToken }),
    );
    failure(
      await request(app).post("/api/v1/auth/refresh").send({ refreshToken }),
      401,
      "INVALID_REFRESH_TOKEN",
    );
  }, 120_000);
});
