import crypto from "node:crypto";
import express, {
  type NextFunction,
  type Request,
  type Response,
} from "express";
import cors from "cors";
import helmet from "helmet";
import rateLimit from "express-rate-limit";
import { DateTime } from "luxon";
import { z, ZodError } from "zod";
import type { PoolConnection } from "mysql2/promise";
import { pool, type DbConnection } from "./db.js";
import { env, corsOrigins } from "./config.js";
import {
  createAccessToken,
  createRefreshToken,
  hashPassword,
  hashRefreshToken,
  verifyPassword,
  verifyAccessToken,
} from "./auth.js";
import { AppError } from "./errors.js";
import {
  authMiddleware,
  errorHandler,
  logger,
  notFound,
  requestLogger,
} from "./middleware.js";
import {
  calculateDailyAllowance,
  dateIsValid,
  ledgerEffect,
  localDate,
  money,
  positiveMoney,
  ZERO,
} from "./financial.js";
import type { AuthenticatedRequest, UserRow } from "./types.js";

type Row = Record<string, any>;
const idSchema = z.string().uuid();
const dateSchema = z
  .string()
  .refine(dateIsValid, "must be an ISO date (YYYY-MM-DD)");
const currencySchema = z
  .string()
  .trim()
  .toUpperCase()
  .regex(/^[A-Z]{3}$/, "must be a three-letter ISO currency code");
const optionalMoney = z.union([z.string(), z.number()]);
const transactionTypes = [
  "MAIN_INCOME",
  "ADDITIONAL_INCOME",
  "DYNAMIC_SPENDING",
] as const;

const registerSchema = z.object({
  name: z.string().trim().min(1).max(120),
  email: z.string().trim().email().max(190),
  password: z.string().min(10).max(128),
  preferredCurrency: currencySchema.optional(),
});
const loginSchema = z.object({
  email: z.string().trim().email(),
  password: z.string().min(1).max(128),
});
const accountSchema = z.object({
  name: z.string().trim().min(1).max(120),
  description: z.string().trim().max(500).optional().nullable(),
  parentAccountId: idSchema.optional().nullable(),
  sortOrder: z.number().int().optional(),
});
const walletSchema = z.object({
  accountId: idSchema,
  name: z.string().trim().min(1).max(120),
  walletTypeCode: z.string().trim().min(1).max(30).toUpperCase(),
  currencyCode: currencySchema,
  openingBalance: optionalMoney,
});
const categorySchema = z.object({
  name: z.string().trim().min(1).max(100),
  appliesTo: z.enum(["INCOME", "SPENDING", "BOTH"]).default("SPENDING"),
  sortOrder: z.number().int().optional(),
});
const txSchema = z.object({
  transactionType: z.enum(transactionTypes),
  amount: optionalMoney,
  walletId: idSchema,
  categoryId: idSchema.optional().nullable(),
  description: z.string().trim().max(255).optional().nullable(),
  notes: z.string().max(5000).optional().nullable(),
  transactionDate: dateSchema,
  transactionTime: z
    .string()
    .regex(/^([01]\d|2[0-3]):[0-5]\d(:[0-5]\d)?$/)
    .optional()
    .nullable(),
});
const templateSchema = z.object({
  accountId: idSchema,
  defaultWalletId: idSchema.optional().nullable(),
  categoryId: idSchema.optional().nullable(),
  name: z.string().trim().min(1).max(150),
  defaultAmount: optionalMoney,
  dueDay: z.number().int().min(1).max(31),
  startDate: dateSchema,
  endDate: dateSchema.optional().nullable(),
  notes: z.string().trim().max(500).optional().nullable(),
});
const planSchema = z.object({
  planYear: z.number().int().min(2000).max(2200),
  planMonth: z.number().int().min(1).max(12),
  currencyCode: currencySchema,
  monthlyAllowance: optionalMoney,
  notes: z.string().trim().max(500).optional().nullable(),
});
const transferSchema = z.object({
  fromWalletId: idSchema,
  toWalletId: idSchema,
  amount: optionalMoney,
  transferDate: dateSchema,
  transferTime: z
    .string()
    .regex(/^([01]\d|2[0-3]):[0-5]\d(:[0-5]\d)?$/)
    .optional()
    .nullable(),
  notes: z.string().trim().max(500).optional().nullable(),
});
const profileSchema = z.object({
  name: z.string().trim().min(1).max(120).optional(),
  email: z.string().trim().email().max(190).optional(),
});
const changePasswordSchema = z.object({
  currentPassword: z.string().min(1).max(128),
  newPassword: z.string().min(10).max(128),
});

function parse<T>(schema: z.ZodType<T>, value: unknown): T {
  try {
    return schema.parse(value);
  } catch (error) {
    if (error instanceof ZodError)
      throw new AppError(
        400,
        "VALIDATION_ERROR",
        "Request validation failed",
        error.issues.map((issue) => ({
          path: issue.path,
          message: issue.message,
        })),
      );
    throw error;
  }
}

function authOf(req: AuthenticatedRequest) {
  if (!req.auth)
    throw new AppError(401, "UNAUTHORIZED", "Authentication is required");
  return req.auth;
}

function ok(res: Response, data: unknown, status = 200) {
  return res.status(status).json({ success: true, data });
}
function iso(value: unknown): string | null {
  return value ? new Date(value as string | number | Date).toISOString() : null;
}
function publicMoney(value: unknown): string {
  return money(String(value)).toFixed(2);
}
function dateOnly(value: unknown): string {
  return value instanceof Date
    ? value.toISOString().slice(0, 10)
    : String(value).slice(0, 10);
}
function publicUser(row: Row) {
  return {
    id: row.public_id,
    name: row.name,
    email: row.email,
    preferredCurrency: row.preferred_currency,
    timezone: row.timezone ?? "UTC",
  };
}

async function rows(
  conn: DbConnection,
  sql: string,
  params: unknown[] = [],
): Promise<Row[]> {
  const [result] = await conn.execute(sql, params as any[]);
  return result as Row[];
}

async function one(
  conn: DbConnection,
  sql: string,
  params: unknown[] = [],
): Promise<Row | undefined> {
  const result = await rows(conn, sql, params);
  return result[0];
}

async function currentUser(conn: DbConnection, userId: string): Promise<Row> {
  const row = await one(
    conn,
    `SELECT u.id, u.public_id, u.name, u.email, u.preferred_currency, u.status, COALESCE(up.timezone, 'UTC') AS timezone
    FROM users u LEFT JOIN user_preferences up ON up.user_id = u.id
    WHERE u.public_id = ? AND u.status = 'ACTIVE' AND u.deleted_at IS NULL LIMIT 1`,
    [userId],
  );
  if (!row)
    throw new AppError(401, "UNAUTHORIZED", "Authentication is required");
  return row;
}

async function preferences(
  conn: DbConnection,
  userInternalId: string,
): Promise<Row> {
  const row = await one(
    conn,
    `SELECT up.*, a.public_id AS default_account_public_id, w.public_id AS default_wallet_public_id
    FROM user_preferences up
    LEFT JOIN accounts a ON a.id = up.default_account_id AND a.user_id = up.user_id
    LEFT JOIN wallets w ON w.id = up.default_wallet_id AND w.user_id = up.user_id
    WHERE up.user_id = ? LIMIT 1`,
    [userInternalId],
  );
  return (
    row ?? {
      timezone: "UTC",
      financial_month_start: 1,
      allow_negative_wallets: 0,
      default_account_public_id: null,
      default_wallet_public_id: null,
    }
  );
}

async function getAccount(
  conn: DbConnection,
  userInternalId: string,
  publicId: string,
  forUpdate = false,
): Promise<Row> {
  const row = await one(
    conn,
    `SELECT a.*, p.public_id AS parent_public_id FROM accounts a LEFT JOIN accounts p ON p.id = a.parent_account_id WHERE a.user_id = ? AND a.public_id = ? LIMIT 1${forUpdate ? " FOR UPDATE" : ""}`,
    [userInternalId, publicId],
  );
  if (!row) throw new AppError(404, "ACCOUNT_NOT_FOUND", "Account not found");
  return row;
}

async function getWallet(
  conn: DbConnection,
  userInternalId: string,
  publicId: string,
  active = false,
  forUpdate = false,
): Promise<Row> {
  const row = await one(
    conn,
    `SELECT w.*, a.public_id AS account_public_id, a.name AS account_name
    FROM wallets w JOIN accounts a ON a.id = w.account_id
    WHERE w.user_id = ? AND w.public_id = ?${active ? " AND w.is_active = 1 AND a.is_active = 1" : ""}
    LIMIT 1${forUpdate ? " FOR UPDATE" : ""}`,
    [userInternalId, publicId],
  );
  if (!row) throw new AppError(404, "WALLET_NOT_FOUND", "Wallet not found");
  return row;
}

async function getCategory(
  conn: DbConnection,
  userInternalId: string,
  publicId: string,
): Promise<Row> {
  const row = await one(
    conn,
    `SELECT * FROM categories WHERE user_id = ? AND public_id = ? AND is_active = 1 LIMIT 1`,
    [userInternalId, publicId],
  );
  if (!row) throw new AppError(404, "CATEGORY_NOT_FOUND", "Category not found");
  return row;
}

async function getTemplate(
  conn: DbConnection,
  userInternalId: string,
  publicId: string,
  forUpdate = false,
): Promise<Row> {
  const row = await one(
    conn,
    `SELECT s.*, a.public_id AS account_public_id, a.name AS account_name, w.public_id AS wallet_public_id,
      c.public_id AS category_public_id, c.name AS category_name
    FROM static_expense_templates s JOIN accounts a ON a.id = s.account_id
    LEFT JOIN wallets w ON w.id = s.default_wallet_id LEFT JOIN categories c ON c.id = s.category_id
    WHERE s.user_id = ? AND s.public_id = ? LIMIT 1${forUpdate ? " FOR UPDATE" : ""}`,
    [userInternalId, publicId],
  );
  if (!row)
    throw new AppError(
      404,
      "STATIC_EXPENSE_NOT_FOUND",
      "Static expense template not found",
    );
  return row;
}

async function getTransaction(
  conn: DbConnection,
  userInternalId: string,
  publicId: string,
  forUpdate = false,
): Promise<Row> {
  const row = await one(
    conn,
    `SELECT t.*, w.public_id AS wallet_public_id, w.name AS wallet_name, a.public_id AS account_public_id, a.name AS account_name,
      c.public_id AS category_public_id, s.public_id AS template_public_id
    FROM transactions t JOIN wallets w ON w.id = t.wallet_id JOIN accounts a ON a.id = t.account_id
    LEFT JOIN categories c ON c.id = t.category_id LEFT JOIN static_expense_templates s ON s.id = t.static_expense_template_id
    WHERE t.user_id = ? AND t.public_id = ? LIMIT 1${forUpdate ? " FOR UPDATE" : ""}`,
    [userInternalId, publicId],
  );
  if (!row)
    throw new AppError(404, "TRANSACTION_NOT_FOUND", "Transaction not found");
  return row;
}

async function lockWalletById(
  conn: DbConnection,
  userInternalId: string,
  internalId: string,
): Promise<Row> {
  const row = await one(
    conn,
    `SELECT * FROM wallets WHERE user_id = ? AND id = ? LIMIT 1 FOR UPDATE`,
    [userInternalId, internalId],
  );
  if (!row) throw new AppError(404, "WALLET_NOT_FOUND", "Wallet not found");
  return row;
}

async function walletBalance(
  conn: DbConnection,
  userInternalId: string,
  walletInternalId: string,
): Promise<import("decimal.js").default> {
  const wallet = await one(
    conn,
    `SELECT opening_balance FROM wallets WHERE user_id = ? AND id = ? LIMIT 1`,
    [userInternalId, walletInternalId],
  );
  if (!wallet) throw new AppError(404, "WALLET_NOT_FOUND", "Wallet not found");
  const tx = await one(
    conn,
    `SELECT COALESCE(SUM(CASE WHEN transaction_type IN ('MAIN_INCOME','ADDITIONAL_INCOME') THEN amount ELSE -amount END), 0) AS net
    FROM transactions WHERE user_id = ? AND wallet_id = ? AND status = 'POSTED' AND deleted_at IS NULL`,
    [userInternalId, walletInternalId],
  );
  const incoming = await one(
    conn,
    `SELECT COALESCE(SUM(amount), 0) AS value FROM transfers WHERE user_id = ? AND to_wallet_id = ? AND status = 'COMPLETED' AND deleted_at IS NULL`,
    [userInternalId, walletInternalId],
  );
  const outgoing = await one(
    conn,
    `SELECT COALESCE(SUM(amount), 0) AS value FROM transfers WHERE user_id = ? AND from_wallet_id = ? AND status = 'COMPLETED' AND deleted_at IS NULL`,
    [userInternalId, walletInternalId],
  );
  return money(wallet.opening_balance)
    .plus(money(tx?.net ?? 0))
    .plus(money(incoming?.value ?? 0))
    .minus(money(outgoing?.value ?? 0));
}

async function negativeWalletsAllowed(
  conn: DbConnection,
  userInternalId: string,
): Promise<boolean> {
  const row = await one(
    conn,
    `SELECT allow_negative_wallets FROM user_preferences WHERE user_id = ? LIMIT 1`,
    [userInternalId],
  );
  return Boolean(row?.allow_negative_wallets);
}

async function ensureWalletNotNegative(
  conn: DbConnection,
  userInternalId: string,
  walletInternalId: string,
) {
  if (await negativeWalletsAllowed(conn, userInternalId)) return;
  const balance = await walletBalance(conn, userInternalId, walletInternalId);
  if (balance.lt(0))
    throw new AppError(
      409,
      "INSUFFICIENT_BALANCE",
      "The wallet does not have enough available balance",
    );
}

async function lockWallets(
  conn: DbConnection,
  userInternalId: string,
  walletIds: string[],
) {
  const ids = [...new Set(walletIds)].sort((left, right) =>
    BigInt(left) < BigInt(right) ? -1 : 1,
  );
  for (const id of ids) await lockWalletById(conn, userInternalId, id);
}

function mapAccount(row: Row, walletRows: Row[] = []) {
  return {
    id: row.public_id,
    name: row.name,
    description: row.description,
    parentAccountId: row.parent_public_id ?? null,
    isActive: Boolean(row.is_active),
    wallets: walletRows.map(mapWallet),
  };
}

function mapWallet(row: Row) {
  return {
    id: row.public_id,
    accountId: row.account_public_id,
    accountName: row.account_name,
    name: row.name,
    walletTypeCode: row.wallet_type_code,
    currencyCode: row.currency_code,
    openingBalance: publicMoney(row.opening_balance),
    currentBalance: publicMoney(row.current_balance ?? row.opening_balance),
    isActive: Boolean(row.is_active),
  };
}

function mapCategory(row: Row) {
  return {
    id: row.public_id,
    name: row.name,
    appliesTo: row.applies_to,
    isActive: Boolean(row.is_active),
    sortOrder: row.sort_order,
  };
}
function mapTransfer(row: Row) {
  return {
    id: row.public_id,
    fromWalletId: row.from_wallet_public_id,
    fromWalletName: row.from_wallet_name,
    toWalletId: row.to_wallet_public_id,
    toWalletName: row.to_wallet_name,
    amount: publicMoney(row.amount),
    currencyCode: row.currency_code,
    notes: row.notes,
    transferDate: dateOnly(row.transfer_date),
    status: row.status,
  };
}
function mapTransaction(row: Row) {
  return {
    id: row.public_id,
    transactionType: row.transaction_type,
    amount: publicMoney(row.amount),
    currencyCode: row.currency_code,
    accountId: row.account_public_id,
    accountName: row.account_name ?? null,
    walletId: row.wallet_public_id,
    walletName: row.wallet_name ?? null,
    categoryId: row.category_public_id ?? null,
    categoryName: row.category_name ?? null,
    staticExpenseTemplateId: row.template_public_id ?? null,
    description: row.description,
    notes: row.notes,
    transactionDate: dateOnly(row.transaction_date),
    transactionTime: row.transaction_time,
    status: row.status,
    createdAt: iso(row.created_at),
  };
}
function mapTemplate(row: Row) {
  return {
    id: row.public_id,
    name: row.name,
    amount: publicMoney(row.default_amount),
    accountId: row.account_public_id,
    accountName: row.account_name,
    defaultWalletId: row.wallet_public_id ?? null,
    categoryId: row.category_public_id ?? null,
    categoryName: row.category_name ?? null,
    dueDay: row.due_day,
    startDate: dateOnly(row.start_date),
    endDate: row.end_date ? dateOnly(row.end_date) : null,
    notes: row.notes,
    isActive: Boolean(row.is_active),
  };
}
function mapOccurrence(row: Row) {
  return {
    id: row.occurrence_public_id ?? row.public_id,
    templateId: row.template_public_id ?? null,
    name: row.name,
    accountId: row.account_public_id,
    accountName: row.account_name ?? null,
    walletId: row.wallet_public_id ?? null,
    walletName: row.wallet_name ?? null,
    currencyCode: row.wallet_currency_code ?? null,
    categoryId: row.category_public_id ?? null,
    dueYear: Number(row.due_year),
    dueMonth: Number(row.due_month),
    dueDate: dateOnly(row.due_date),
    expectedAmount: publicMoney(row.expected_amount),
    status: row.status,
    paidTransactionId: row.paid_transaction_public_id ?? null,
    paidAt: iso(row.paid_at),
    skippedAt: iso(row.skipped_at),
    notes: row.notes,
  };
}

async function issueSession(conn: DbConnection, user: Row) {
  const refreshToken = createRefreshToken();
  const expiresAt = DateTime.utc()
    .plus({ days: env.REFRESH_TOKEN_DAYS })
    .toJSDate();
  // Refresh-token queries include both rt.id and rt.user_id. Prefer the
  // explicit owning user ID so rt.id is never mistaken for a user ID.
  const userInternalId = user.user_id ?? user.id;
  if (userInternalId == null)
    throw new AppError(500, "SESSION_ERROR", "Could not create a session");
  await conn.execute(
    `INSERT INTO refresh_tokens (user_id, token_hash, expires_at) VALUES (?, ?, ?)`,
    [userInternalId, hashRefreshToken(refreshToken), expiresAt],
  );
  return {
    accessToken: createAccessToken(user.public_id),
    refreshToken,
    expiresIn: env.JWT_ACCESS_TTL,
  };
}

function validTimezone(value: string): boolean {
  try {
    new Intl.DateTimeFormat("en-US", { timeZone: value }).format();
    return true;
  } catch {
    return false;
  }
}

async function accountScope(
  conn: DbConnection,
  userInternalId: string,
  accountPublicId?: string,
): Promise<string[] | null> {
  if (!accountPublicId || accountPublicId === "all") return null;
  const all = await rows(
    conn,
    `SELECT id, public_id, parent_account_id FROM accounts WHERE user_id = ?`,
    [userInternalId],
  );
  const root = all.find((item) => item.public_id === accountPublicId);
  if (!root) throw new AppError(404, "ACCOUNT_NOT_FOUND", "Account not found");
  const ids = new Set<string>([String(root.id)]);
  let changed = true;
  while (changed) {
    changed = false;
    for (const item of all)
      if (
        item.parent_account_id != null &&
        ids.has(String(item.parent_account_id)) &&
        !ids.has(String(item.id))
      ) {
        ids.add(String(item.id));
        changed = true;
      }
  }
  return [...ids];
}

function financialPeriodBounds(
  year: number,
  month: number,
  financialMonthStart: number,
) {
  const start = DateTime.utc(year, month, financialMonthStart).startOf("day");
  return {
    start: start.toISODate()!,
    end: start.plus({ months: 1 }).toISODate()!,
  };
}

function financialPeriodForDate(date: DateTime, financialMonthStart: number) {
  const period =
    date.day >= financialMonthStart
      ? date
      : date.minus({ months: 1 });
  return { year: period.year, month: period.month };
}

async function generateStaticExpensesForFinancialPeriod(
  conn: DbConnection,
  userInternalId: string,
  year: number,
  month: number,
  financialMonthStart: number,
) {
  const start = DateTime.utc(year, month, financialMonthStart);
  const end = start.plus({ months: 1 });
  const calendarMonths = new Set([
    `${start.year}-${start.month}`,
    `${end.minus({ days: 1 }).year}-${end.minus({ days: 1 }).month}`,
  ]);
  for (const value of calendarMonths) {
    const [calendarYear, calendarMonth] = value.split("-").map(Number);
    await conn.query(
      "CALL sp_generate_static_expenses_for_month(?, ?, ?)",
      [userInternalId, calendarYear, calendarMonth],
    );
  }
}

async function queryMonthlySummary(
  conn: DbConnection,
  userInternalId: string,
  year: number,
  month: number,
  currency?: string,
  scope?: string[] | null,
  financialMonthStart = 1,
) {
  const bounds = financialPeriodBounds(year, month, financialMonthStart);
  const params: unknown[] = [userInternalId, bounds.start, bounds.end];
  let where = `t.user_id = ? AND t.transaction_date >= ? AND t.transaction_date < ? AND t.status = 'POSTED' AND t.deleted_at IS NULL`;
  if (currency) {
    where += " AND t.currency_code = ?";
    params.push(currency);
  }
  if (scope?.length) {
    where += ` AND t.account_id IN (${scope.map(() => "?").join(",")})`;
    params.push(...scope);
  }
  return one(
    conn,
    `SELECT t.currency_code,
    COALESCE(SUM(CASE WHEN t.transaction_type = 'MAIN_INCOME' THEN t.amount ELSE 0 END),0) AS main_income,
    COALESCE(SUM(CASE WHEN t.transaction_type = 'ADDITIONAL_INCOME' THEN t.amount ELSE 0 END),0) AS additional_income,
    COALESCE(SUM(CASE WHEN t.transaction_type IN ('MAIN_INCOME','ADDITIONAL_INCOME') THEN t.amount ELSE 0 END),0) AS total_income,
    COALESCE(SUM(CASE WHEN t.transaction_type = 'STATIC_SPENDING' THEN t.amount ELSE 0 END),0) AS static_spending,
    COALESCE(SUM(CASE WHEN t.transaction_type = 'DYNAMIC_SPENDING' THEN t.amount ELSE 0 END),0) AS dynamic_spending,
    COALESCE(SUM(CASE WHEN t.transaction_type IN ('STATIC_SPENDING','DYNAMIC_SPENDING') THEN t.amount ELSE 0 END),0) AS total_spending
    FROM transactions t WHERE ${where} GROUP BY t.currency_code`,
    params,
  );
}

async function allowanceSummary(
  conn: DbConnection,
  userInternalId: string,
  year: number,
  month: number,
  currency: string,
  scope?: string[] | null,
  today?: string,
  financialMonthStart = 1,
) {
  const plan = await one(
    conn,
    `SELECT * FROM monthly_plans WHERE user_id = ? AND plan_year = ? AND plan_month = ? AND currency_code = ? LIMIT 1`,
    [userInternalId, year, month, currency],
  );
  const bounds = financialPeriodBounds(year, month, financialMonthStart);
  const params: unknown[] = [
    userInternalId,
    bounds.start,
    bounds.end,
    currency,
  ];
  let filter = "";
  if (scope?.length) {
    filter = ` AND t.account_id IN (${scope.map(() => "?").join(",")})`;
    params.push(...scope);
  }
  const usedRow = await one(
    conn,
    `SELECT COALESCE(SUM(t.amount),0) AS used FROM transactions t WHERE t.user_id = ? AND t.transaction_date >= ? AND t.transaction_date < ? AND t.currency_code = ? AND t.transaction_type = 'DYNAMIC_SPENDING' AND t.status = 'POSTED' AND t.deleted_at IS NULL${filter}`,
    params,
  );
  const used = money(usedRow?.used ?? 0);
  const allowance = money(plan?.monthly_allowance ?? 0);
  const remaining = allowance.minus(used);
  let spentToday = ZERO;
  if (today) {
    const todayParams: unknown[] = [userInternalId, today, currency];
    let todayFilter = "";
    if (scope?.length) {
      todayFilter = ` AND t.account_id IN (${scope.map(() => "?").join(",")})`;
      todayParams.push(...scope);
    }
    const todayRow = await one(
      conn,
      `SELECT COALESCE(SUM(t.amount),0) AS used FROM transactions t WHERE t.user_id = ? AND t.transaction_date = ? AND t.currency_code = ? AND t.transaction_type = 'DYNAMIC_SPENDING' AND t.status = 'POSTED' AND t.deleted_at IS NULL${todayFilter}`,
      todayParams,
    );
    spentToday = money(todayRow?.used ?? 0);
  }
  const daily = today
    ? calculateDailyAllowance(
        remaining,
        spentToday,
        today,
        (await preferences(conn, userInternalId)).timezone,
      )
    : { dailyAllowance: ZERO, remainingToday: ZERO, remainingDays: 0 };
  return {
    currencyCode: currency,
    monthlyAllowance: allowance.toFixed(2),
    allowanceUsed: used.toFixed(2),
    allowanceRemaining: remaining.toFixed(2),
    dailyAllowance: daily.dailyAllowance.toFixed(2),
    spentToday: spentToday.toFixed(2),
    remainingToday: daily.remainingToday.toFixed(2),
    remainingDays: daily.remainingDays,
    planId: plan?.public_id ?? null,
  };
}

export function createApp() {
  const app = express();
  app.disable("x-powered-by");
  app.use(helmet());
  app.use(
    cors({
      origin: (origin, callback) => {
        if (!origin || corsOrigins.includes(origin))
          return callback(null, true);
        return callback(
          new AppError(403, "CORS_FORBIDDEN", "Origin is not allowed"),
        );
      },
    }),
  );
  const authRateLimit = rateLimit({
    windowMs: 60 * 1000,
    limit: 10,
    standardHeaders: "draft-7",
    legacyHeaders: false,
    message: {
      success: false,
      code: "AUTH_RATE_LIMITED",
      message: "Too many authentication attempts; try again shortly",
    },
  });
  app.use(express.json({ limit: "64kb" }));
  app.use(
    rateLimit({
      windowMs: 15 * 60 * 1000,
      limit: 300,
      standardHeaders: "draft-7",
      legacyHeaders: false,
    }),
  );
  app.use(requestLogger);
  app.get("/health", async (_req, res, next) => {
    try {
      await pool.query("SELECT 1");
      ok(res, { status: "ok" });
    } catch (error) {
      next(error);
    }
  });

  const api = express.Router();
  const protectedApi = express.Router();
  app.use("/api/v1", api);
  api.post("/auth/register", authRateLimit, async (req, res, next) => {
    try {
      const input = parse(registerSchema, req.body);
      const preferredCurrency = input.preferredCurrency ?? "USD";
      const userPublicId = crypto.randomUUID();
      const user = await (async () => {
        const conn = await pool.getConnection();
        try {
          await conn.beginTransaction();
          const [result] = await conn.execute(
            `INSERT INTO users (public_id, name, email, password_hash, preferred_currency) VALUES (?, ?, LOWER(?), ?, ?)`,
            [
              userPublicId,
              input.name,
              input.email,
              await hashPassword(input.password),
              preferredCurrency,
            ],
          );
          const userInternalId = String((result as any).insertId);
          await conn.query("CALL sp_initialize_user(?)", [userInternalId]);
          const created = await currentUser(conn, userPublicId);
          const session = await issueSession(conn, created);
          await conn.commit();
          return { user: publicUser(created), session };
        } catch (error) {
          await conn.rollback();
          throw error;
        } finally {
          conn.release();
        }
      })();
      return ok(res, user, 201);
    } catch (error) {
      next(error);
    }
  });

  api.post("/auth/login", authRateLimit, async (req, res, next) => {
    try {
      const input = parse(loginSchema, req.body);
      const conn = await pool.getConnection();
      try {
        const row = await one(
          conn,
          `SELECT u.*, COALESCE(up.timezone, 'UTC') AS timezone FROM users u LEFT JOIN user_preferences up ON up.user_id = u.id WHERE u.email = LOWER(?) AND u.status = 'ACTIVE' AND u.deleted_at IS NULL LIMIT 1`,
          [input.email],
        );
        if (!row || !(await verifyPassword(row.password_hash, input.password)))
          throw new AppError(
            401,
            "INVALID_CREDENTIALS",
            "Email or password is incorrect",
          );
        await conn.beginTransaction();
        await conn.execute(
          `UPDATE users SET last_login_at = UTC_TIMESTAMP() WHERE id = ?`,
          [row.id],
        );
        const session = await issueSession(conn, row);
        await conn.commit();
        return ok(res, { user: publicUser(row), session });
      } catch (error) {
        await conn.rollback().catch(() => undefined);
        throw error;
      } finally {
        conn.release();
      }
    } catch (error) {
      next(error);
    }
  });

  api.post("/auth/refresh", async (req, res, next) => {
    try {
      const input = parse(
        z.object({ refreshToken: z.string().min(20) }),
        req.body,
      );
      const conn = await pool.getConnection();
      try {
        await conn.beginTransaction();
        const token = await one(
          conn,
          `SELECT rt.*, u.public_id, u.name, u.email, u.preferred_currency, u.status, COALESCE(up.timezone, 'UTC') AS timezone
          FROM refresh_tokens rt JOIN users u ON u.id = rt.user_id LEFT JOIN user_preferences up ON up.user_id = u.id
          WHERE rt.token_hash = ? AND rt.revoked_at IS NULL AND rt.expires_at > UTC_TIMESTAMP() AND u.status = 'ACTIVE' AND u.deleted_at IS NULL LIMIT 1 FOR UPDATE`,
          [hashRefreshToken(input.refreshToken)],
        );
        if (!token)
          throw new AppError(
            401,
            "INVALID_REFRESH_TOKEN",
            "Refresh token is invalid or expired",
          );
        await conn.execute(
          `UPDATE refresh_tokens SET revoked_at = UTC_TIMESTAMP() WHERE id = ?`,
          [token.id],
        );
        const session = await issueSession(conn, token);
        await conn.commit();
        return ok(res, { user: publicUser(token), session });
      } catch (error) {
        await conn.rollback().catch(() => undefined);
        throw error;
      } finally {
        conn.release();
      }
    } catch (error) {
      next(error);
    }
  });

  api.post("/auth/logout", async (req, res, next) => {
    try {
      const token =
        typeof req.body?.refreshToken === "string"
          ? req.body.refreshToken
          : null;
      if (token)
        await pool.execute(
          `UPDATE refresh_tokens SET revoked_at = COALESCE(revoked_at, UTC_TIMESTAMP()) WHERE token_hash = ?`,
          [hashRefreshToken(token)],
        );
      return ok(res, { loggedOut: true });
    } catch (error) {
      next(error);
    }
  });

  protectedApi.use(authMiddleware(pool));
  api.use(protectedApi);

  protectedApi.get("/auth/me", async (req: AuthenticatedRequest, res, next) => {
    try {
      const user = await currentUser(pool, authOf(req).userId);
      return ok(res, publicUser(user));
    } catch (error) {
      next(error);
    }
  });

  protectedApi.patch(
    "/users/me",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const input = parse(profileSchema, req.body);
        if (input.name === undefined && input.email === undefined)
          throw new AppError(
            400,
            "VALIDATION_ERROR",
            "At least one profile field is required",
          );
        await pool.execute(
          `UPDATE users SET name = COALESCE(?, name), email = COALESCE(LOWER(?), email) WHERE id = ? AND public_id = ? AND status = 'ACTIVE' AND deleted_at IS NULL`,
          [input.name ?? null, input.email ?? null, user.userInternalId, user.userId],
        );
        return ok(res, publicUser(await currentUser(pool, user.userId)));
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.post(
    "/auth/change-password",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const input = parse(changePasswordSchema, req.body);
        const current = await one(
          pool,
          `SELECT password_hash FROM users WHERE id = ? AND public_id = ? AND status = 'ACTIVE' AND deleted_at IS NULL LIMIT 1`,
          [user.userInternalId, user.userId],
        );
        if (!current || !(await verifyPassword(current.password_hash, input.currentPassword)))
          throw new AppError(
            401,
            "INVALID_CREDENTIALS",
            "The current password is incorrect",
          );
        if (await verifyPassword(current.password_hash, input.newPassword))
          throw new AppError(
            400,
            "PASSWORD_UNCHANGED",
            "The new password must be different",
          );
        await pool.execute(
          `UPDATE users SET password_hash = ? WHERE id = ? AND public_id = ?`,
          [await hashPassword(input.newPassword), user.userInternalId, user.userId],
        );
        await pool.execute(
          `UPDATE refresh_tokens SET revoked_at = COALESCE(revoked_at, UTC_TIMESTAMP()) WHERE user_id = ?`,
          [user.userInternalId],
        );
        return ok(res, { passwordChanged: true, sessionsRevoked: true });
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.delete(
    "/users/me",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        await pool.execute(
          `UPDATE users SET status = 'DISABLED', deleted_at = COALESCE(deleted_at, UTC_TIMESTAMP()) WHERE id = ? AND public_id = ?`,
          [user.userInternalId, user.userId],
        );
        await pool.execute(
          `UPDATE refresh_tokens SET revoked_at = COALESCE(revoked_at, UTC_TIMESTAMP()) WHERE user_id = ?`,
          [user.userInternalId],
        );
        return ok(res, { deleted: true });
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.get(
    "/users/me/preferences",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const pref = await preferences(pool, user.userInternalId);
        const profile = await currentUser(pool, user.userId);
        return ok(res, {
          defaultAccountId: pref.default_account_public_id ?? null,
          defaultWalletId: pref.default_wallet_public_id ?? null,
          financialMonthStart: pref.financial_month_start,
          allowNegativeWallets: Boolean(pref.allow_negative_wallets),
          timezone: pref.timezone ?? "UTC",
          preferredCurrency: profile.preferred_currency,
        });
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.patch(
    "/users/me/preferences",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const input = parse(
          z.object({
            defaultAccountId: idSchema.nullable().optional(),
            defaultWalletId: idSchema.nullable().optional(),
            financialMonthStart: z.number().int().min(1).max(28).optional(),
            allowNegativeWallets: z.boolean().optional(),
            timezone: z.string().min(1).max(64).optional(),
            preferredCurrency: currencySchema.optional(),
          }),
          req.body,
        );
        if (input.timezone && !validTimezone(input.timezone))
          throw new AppError(
            400,
            "INVALID_TIMEZONE",
            "Timezone must be a valid IANA timezone",
          );
        const conn = await pool.getConnection();
        try {
          await conn.beginTransaction();
          const pref = await preferences(conn, user.userInternalId);
          let accountInternal: string | null | undefined;
          let walletInternal: string | null | undefined;
          if (input.defaultAccountId !== undefined)
            accountInternal = input.defaultAccountId
              ? String(
                  (
                    await getAccount(
                      conn,
                      user.userInternalId,
                      input.defaultAccountId,
                    )
                  ).id,
                )
              : null;
          if (input.defaultWalletId !== undefined)
            walletInternal = input.defaultWalletId
              ? String(
                  (
                    await getWallet(
                      conn,
                      user.userInternalId,
                      input.defaultWalletId,
                      true,
                    )
                  ).id,
                )
              : null;
          const effectiveAccountId =
            accountInternal === undefined
              ? pref.default_account_id
              : accountInternal;
          const effectiveWalletId =
            walletInternal === undefined
              ? pref.default_wallet_id
              : walletInternal;
          if (effectiveAccountId && effectiveWalletId) {
            const walletOwner = await one(
              conn,
              `SELECT account_id FROM wallets WHERE id = ? AND user_id = ? LIMIT 1`,
              [effectiveWalletId, user.userInternalId],
            );
            if (
              !walletOwner ||
              String(walletOwner.account_id) !== String(effectiveAccountId)
            )
              throw new AppError(
                400,
                "ACCOUNT_WALLET_MISMATCH",
                "Default wallet must belong to the default account",
              );
          }
          await conn.execute(
            `UPDATE user_preferences SET default_account_id = ?, default_wallet_id = ?, financial_month_start = ?, allow_negative_wallets = ?, timezone = ? WHERE user_id = ?`,
            [
              accountInternal === undefined
                ? pref.default_account_id
                : accountInternal,
              walletInternal === undefined
                ? pref.default_wallet_id
                : walletInternal,
              input.financialMonthStart ?? pref.financial_month_start,
              input.allowNegativeWallets === undefined
                ? pref.allow_negative_wallets
                : input.allowNegativeWallets
                  ? 1
                  : 0,
              input.timezone ?? pref.timezone ?? "UTC",
              user.userInternalId,
            ],
          );
          if (input.preferredCurrency)
            await conn.execute(
              `UPDATE users SET preferred_currency = ? WHERE id = ?`,
              [input.preferredCurrency, user.userInternalId],
            );
          await conn.commit();
          const updated = await preferences(conn, user.userInternalId).catch(
            () => pref,
          );
          return ok(res, {
            defaultAccountId: updated.default_account_public_id ?? null,
            defaultWalletId: updated.default_wallet_public_id ?? null,
            financialMonthStart: updated.financial_month_start,
            allowNegativeWallets: Boolean(updated.allow_negative_wallets),
            timezone: updated.timezone,
            preferredCurrency:
              input.preferredCurrency ??
              (await currentUser(pool, user.userId)).preferred_currency,
          });
        } catch (error) {
          await conn.rollback().catch(() => undefined);
          throw error;
        } finally {
          conn.release();
        }
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.get("/wallet-types", async (_req, res, next) => {
    try {
      return ok(
        res,
        (
          await rows(
            pool,
            `SELECT code, display_name AS displayName, is_system AS isSystem FROM wallet_types ORDER BY sort_order, display_name`,
          )
        ).map((item) => ({ ...item, isSystem: Boolean(item.isSystem) })),
      );
    } catch (error) {
      next(error);
    }
  });

  protectedApi.get(
    "/accounts",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const accountRows = await rows(
          pool,
          `SELECT a.*, p.public_id AS parent_public_id FROM accounts a LEFT JOIN accounts p ON p.id = a.parent_account_id WHERE a.user_id = ? ORDER BY a.parent_account_id IS NOT NULL, a.sort_order, a.name`,
          [user.userInternalId],
        );
        const walletRows = await rows(
          pool,
          `SELECT w.*, a.public_id AS account_public_id, a.name AS account_name, vb.current_balance FROM wallets w JOIN accounts a ON a.id = w.account_id LEFT JOIN v_wallet_balances vb ON vb.wallet_id = w.id WHERE w.user_id = ? ORDER BY w.account_id, w.sort_order, w.name`,
          [user.userInternalId],
        );
        return ok(
          res,
          accountRows.map((account) =>
            mapAccount(
              account,
              walletRows.filter(
                (wallet) => String(wallet.account_id) === String(account.id),
              ),
            ),
          ),
        );
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.post(
    "/accounts",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const input = parse(accountSchema, req.body);
        const publicId = crypto.randomUUID();
        let parentId: string | null = null;
        if (input.parentAccountId)
          parentId = String(
            (await getAccount(pool, user.userInternalId, input.parentAccountId))
              .id,
          );
        await pool.execute(
          `INSERT INTO accounts (public_id, user_id, parent_account_id, name, description, sort_order) VALUES (?, ?, ?, ?, ?, ?)`,
          [
            publicId,
            user.userInternalId,
            parentId,
            input.name,
            input.description ?? null,
            input.sortOrder ?? 0,
          ],
        );
        return ok(
          res,
          mapAccount(await getAccount(pool, user.userInternalId, publicId)),
          201,
        );
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.get(
    "/accounts/:accountId",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const account = await getAccount(
          pool,
          authOf(req).userInternalId,
          req.params.accountId,
        );
        const wallets = await rows(
          pool,
          `SELECT w.*, a.public_id AS account_public_id, a.name AS account_name, vb.current_balance FROM wallets w JOIN accounts a ON a.id = w.account_id LEFT JOIN v_wallet_balances vb ON vb.wallet_id = w.id WHERE w.user_id = ? AND w.account_id = ? ORDER BY w.name`,
          [authOf(req).userInternalId, account.id],
        );
        return ok(res, mapAccount(account, wallets));
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.patch(
    "/accounts/:accountId",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const input = parse(accountSchema.partial(), req.body);
        const account = await getAccount(
          pool,
          user.userInternalId,
          req.params.accountId,
          true,
        );
        let parentId: string | null | undefined;
        if (input.parentAccountId !== undefined) {
          parentId = input.parentAccountId
            ? String(
                (
                  await getAccount(
                    pool,
                    user.userInternalId,
                    input.parentAccountId,
                  )
                ).id,
              )
            : null;
          if (parentId === String(account.id))
            throw new AppError(
              400,
              "ACCOUNT_CYCLE",
              "An account cannot be its own parent",
            );
        }
        if (parentId) {
          let cursor: string | null = parentId;
          for (let i = 0; i < 50 && cursor; i++) {
            if (cursor === String(account.id))
              throw new AppError(
                400,
                "ACCOUNT_CYCLE",
                "Account hierarchy would contain a cycle",
              );
            const parent = await one(
              pool,
              `SELECT parent_account_id FROM accounts WHERE id = ? AND user_id = ?`,
              [cursor, user.userInternalId],
            );
            cursor = parent?.parent_account_id
              ? String(parent.parent_account_id)
              : null;
          }
        }
        const finalParentId =
          parentId === undefined ? account.parent_account_id : parentId;
        await pool.execute(
          `UPDATE accounts SET name = ?, description = ?, parent_account_id = ?, sort_order = ? WHERE id = ? AND user_id = ?`,
          [
            input.name ?? account.name,
            input.description === undefined
              ? account.description
              : input.description,
            finalParentId,
            input.sortOrder ?? account.sort_order,
            account.id,
            user.userInternalId,
          ],
        );
        return ok(
          res,
          mapAccount(
            await getAccount(pool, user.userInternalId, req.params.accountId),
          ),
        );
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.delete(
    "/accounts/:accountId",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const account = await getAccount(
          pool,
          user.userInternalId,
          req.params.accountId,
          true,
        );
        const child = await one(
          pool,
          `SELECT id FROM accounts WHERE user_id=? AND parent_account_id = ? AND is_active = 1 LIMIT 1`,
          [user.userInternalId, account.id],
        );
        const wallet = await one(
          pool,
          `SELECT id FROM wallets WHERE user_id=? AND account_id = ? AND is_active = 1 LIMIT 1`,
          [user.userInternalId, account.id],
        );
        if (child || wallet)
          throw new AppError(
            409,
            "ACCOUNT_NOT_EMPTY",
            "Archive child accounts and wallets before archiving this account",
          );
        await pool.execute(
          `UPDATE accounts SET is_active = 0, archived_at = UTC_TIMESTAMP() WHERE id = ? AND user_id = ?`,
          [account.id, user.userInternalId],
        );
        return ok(res, { archived: true });
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.get("/wallets", async (req: AuthenticatedRequest, res, next) => {
    try {
      const user = authOf(req);
      const account = req.query.accountId
        ? await getAccount(
            pool,
            user.userInternalId,
            String(req.query.accountId),
          )
        : null;
      const params: unknown[] = [user.userInternalId];
      const filter = account ? " AND w.account_id = ?" : "";
      if (account) params.push(account.id);
      return ok(
        res,
        await rows(
          pool,
          `SELECT w.*, a.public_id AS account_public_id, a.name AS account_name, vb.current_balance FROM wallets w JOIN accounts a ON a.id = w.account_id LEFT JOIN v_wallet_balances vb ON vb.wallet_id = w.id WHERE w.user_id = ?${filter} ORDER BY a.name, w.sort_order, w.name`,
          params,
        ).then((items) => items.map(mapWallet)),
      );
    } catch (error) {
      next(error);
    }
  });

  protectedApi.post(
    "/wallets",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const input = parse(walletSchema, req.body);
        const account = await getAccount(
          pool,
          user.userInternalId,
          input.accountId,
        );
        const amount = money(input.openingBalance, "openingBalance");
        if (
          amount.lt(0) &&
          !(await negativeWalletsAllowed(pool, user.userInternalId))
        )
          throw new AppError(
            409,
            "INSUFFICIENT_BALANCE",
            "Opening balance cannot be negative while negative wallets are disabled",
          );
        const walletId = crypto.randomUUID();
        await pool.execute(
          `INSERT INTO wallets (public_id, user_id, account_id, wallet_type_code, name, currency_code, opening_balance) VALUES (?, ?, ?, ?, ?, ?, ?)`,
          [
            walletId,
            user.userInternalId,
            account.id,
            input.walletTypeCode,
            input.name,
            input.currencyCode,
            amount.toFixed(2),
          ],
        );
        return ok(
          res,
          mapWallet(await getWallet(pool, user.userInternalId, walletId)),
          201,
        );
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.get(
    "/wallets/:walletId",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        return ok(
          res,
          mapWallet(
            (
              await rows(
                pool,
                `SELECT w.*, a.public_id AS account_public_id, a.name AS account_name, vb.current_balance FROM wallets w JOIN accounts a ON a.id = w.account_id LEFT JOIN v_wallet_balances vb ON vb.wallet_id = w.id WHERE w.user_id = ? AND w.public_id = ? LIMIT 1`,
                [authOf(req).userInternalId, req.params.walletId],
              )
            )[0] ??
              (() => {
                throw new AppError(404, "WALLET_NOT_FOUND", "Wallet not found");
              })(),
          ),
        );
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.patch(
    "/wallets/:walletId",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const current = await getWallet(
          pool,
          user.userInternalId,
          req.params.walletId,
          false,
          true,
        );
        const input = parse(walletSchema.partial(), req.body);
        let accountInternalId = String(current.account_id);
        if (input.accountId && input.accountId !== current.account_public_id) {
          const account = await getAccount(
            pool,
            user.userInternalId,
            input.accountId,
          );
          accountInternalId = String(account.id);
          const used = await one(
            pool,
            `SELECT id FROM transactions WHERE user_id=? AND wallet_id = ? LIMIT 1`,
            [user.userInternalId, current.id],
          );
          if (used)
            throw new AppError(
              409,
              "WALLET_HAS_HISTORY",
              "A wallet with history cannot move to another account",
            );
        }
        const openingBalance =
          input.openingBalance === undefined
            ? money(current.opening_balance)
            : money(input.openingBalance, "openingBalance");
        if (
          openingBalance.lt(0) &&
          !(await negativeWalletsAllowed(pool, user.userInternalId))
        )
          throw new AppError(
            409,
            "INSUFFICIENT_BALANCE",
            "Opening balance cannot be negative while negative wallets are disabled",
          );
        if (
          input.currencyCode &&
          input.currencyCode !== current.currency_code
        ) {
          const history = await one(
            pool,
            `SELECT id FROM transactions WHERE user_id=? AND wallet_id=? LIMIT 1`,
            [user.userInternalId, current.id],
          );
          const transferHistory = await one(
            pool,
            `SELECT id FROM transfers WHERE user_id=? AND (from_wallet_id=? OR to_wallet_id=?) LIMIT 1`,
            [user.userInternalId, current.id, current.id],
          );
          if (history || transferHistory)
            throw new AppError(
              409,
              "WALLET_HAS_HISTORY",
              "A wallet currency cannot change after financial history exists",
            );
        }
        await pool.execute(
          `UPDATE wallets SET account_id = ?, name = ?, wallet_type_code = ?, currency_code = ?, opening_balance = ? WHERE id = ? AND user_id = ?`,
          [
            accountInternalId,
            input.name ?? current.name,
            input.walletTypeCode ?? current.wallet_type_code,
            input.currencyCode ?? current.currency_code,
            openingBalance.toFixed(2),
            current.id,
            user.userInternalId,
          ],
        );
        return ok(
          res,
          mapWallet(
            await getWallet(pool, user.userInternalId, req.params.walletId),
          ),
        );
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.delete(
    "/wallets/:walletId",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const wallet = await getWallet(
          pool,
          user.userInternalId,
          req.params.walletId,
          false,
          true,
        );
        await pool.execute(
          `UPDATE wallets SET is_active = 0, archived_at = UTC_TIMESTAMP() WHERE id = ? AND user_id = ?`,
          [wallet.id, user.userInternalId],
        );
        return ok(res, { archived: true });
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.get(
    "/categories",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const params: unknown[] = [authOf(req).userInternalId];
        const filter = req.query.appliesTo
          ? " AND (applies_to = ? OR applies_to = 'BOTH')"
          : "";
        if (req.query.appliesTo) params.push(String(req.query.appliesTo));
        return ok(
          res,
          (
            await rows(
              pool,
              `SELECT * FROM categories WHERE user_id = ? AND is_active = 1${filter} ORDER BY sort_order, name`,
              params,
            )
          ).map(mapCategory),
        );
      } catch (error) {
        next(error);
      }
    },
  );
  protectedApi.get(
    "/categories/:categoryId",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        return ok(
          res,
          mapCategory(
            await getCategory(
              pool,
              authOf(req).userInternalId,
              req.params.categoryId,
            ),
          ),
        );
      } catch (error) {
        next(error);
      }
    },
  );
  protectedApi.post(
    "/categories",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const input = parse(categorySchema, req.body);
        const id = crypto.randomUUID();
        await pool.execute(
          `INSERT INTO categories (public_id, user_id, name, applies_to, sort_order) VALUES (?, ?, ?, ?, ?)`,
          [
            id,
            authOf(req).userInternalId,
            input.name,
            input.appliesTo ?? "SPENDING",
            input.sortOrder ?? 0,
          ] as any[],
        );
        return ok(
          res,
          mapCategory(
            (await one(
              pool,
              `SELECT * FROM categories WHERE user_id = ? AND public_id = ?`,
              [authOf(req).userInternalId, id],
            ))!,
          ),
          201,
        );
      } catch (error) {
        next(error);
      }
    },
  );
  protectedApi.patch(
    "/categories/:categoryId",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const input = parse(categorySchema.partial(), req.body);
        const category = await getCategory(
          pool,
          authOf(req).userInternalId,
          req.params.categoryId,
        );
        await pool.execute(
          `UPDATE categories SET name = COALESCE(?, name), applies_to = COALESCE(?, applies_to), sort_order = COALESCE(?, sort_order) WHERE id = ? AND user_id = ?`,
          [
            input.name ?? null,
            input.appliesTo ?? null,
            input.sortOrder ?? null,
            category.id,
            authOf(req).userInternalId,
          ],
        );
        return ok(
          res,
          mapCategory(
            await getCategory(
              pool,
              authOf(req).userInternalId,
              req.params.categoryId,
            ),
          ),
        );
      } catch (error) {
        next(error);
      }
    },
  );
  protectedApi.delete(
    "/categories/:categoryId",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const category = await getCategory(
          pool,
          authOf(req).userInternalId,
          req.params.categoryId,
        );
        await pool.execute(
          `UPDATE categories SET is_active = 0, archived_at = UTC_TIMESTAMP() WHERE id = ? AND user_id = ?`,
          [category.id, authOf(req).userInternalId],
        );
        return ok(res, { archived: true });
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.get(
    "/transactions",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const pref = await preferences(pool, user.userInternalId);
        const params: unknown[] = [user.userInternalId];
        let filter =
          "t.user_id = ? AND t.status = 'POSTED' AND t.deleted_at IS NULL";
        const requestedYear = req.query.year ? Number(req.query.year) : null;
        const requestedMonth = req.query.month ? Number(req.query.month) : null;
        if (requestedYear !== null && requestedMonth !== null) {
          const bounds = financialPeriodBounds(
            requestedYear,
            requestedMonth,
            Number(pref.financial_month_start ?? 1),
          );
          filter += " AND t.transaction_date >= ? AND t.transaction_date < ?";
          params.push(bounds.start, bounds.end);
        } else if (requestedYear !== null) {
          filter += " AND YEAR(t.transaction_date) = ?";
          params.push(requestedYear);
        } else if (requestedMonth !== null) {
          filter += " AND MONTH(t.transaction_date) = ?";
          params.push(requestedMonth);
        }
        if (req.query.type) {
          filter += " AND t.transaction_type = ?";
          params.push(String(req.query.type));
        }
        for (const [key, column] of [
          ["accountId", "a.public_id"],
          ["walletId", "w.public_id"],
          ["categoryId", "c.public_id"],
        ] as const)
          if (req.query[key]) {
            filter += ` AND ${column} = ?`;
            params.push(String(req.query[key]));
          }
        const rawLimit = req.query.limit;
        const limit = rawLimit === undefined ? 100 : Number(rawLimit);
        const rawOffset = req.query.offset;
        const rawPage = req.query.page;
        if (
          !Number.isSafeInteger(limit) ||
          limit < 1 ||
          limit > 250 ||
          (rawOffset !== undefined && rawPage !== undefined)
        )
          throw new AppError(
            400,
            "INVALID_PAGINATION",
            "limit must be an integer from 1 to 250 and offset and page cannot be combined",
          );
        let offset = 0;
        if (rawOffset !== undefined) offset = Number(rawOffset);
        if (rawPage !== undefined) {
          const page = Number(rawPage);
          if (!Number.isSafeInteger(page) || page < 1)
            throw new AppError(
              400,
              "INVALID_PAGINATION",
              "page must be a positive integer",
            );
          offset = (page - 1) * limit;
        }
        if (!Number.isSafeInteger(offset) || offset < 0)
          throw new AppError(
            400,
            "INVALID_PAGINATION",
            "offset must be a non-negative integer",
          );
        params.push(limit, offset);
        res.setHeader("X-Pagination-Limit", String(limit));
        res.setHeader("X-Pagination-Offset", String(offset));
        return ok(
          res,
          (
            await rows(
              pool,
              `SELECT t.*, w.public_id AS wallet_public_id, w.name AS wallet_name, a.public_id AS account_public_id, a.name AS account_name, c.public_id AS category_public_id, c.name AS category_name, s.public_id AS template_public_id FROM transactions t JOIN wallets w ON w.id = t.wallet_id JOIN accounts a ON a.id = t.account_id LEFT JOIN categories c ON c.id = t.category_id LEFT JOIN static_expense_templates s ON s.id = t.static_expense_template_id WHERE ${filter} ORDER BY t.transaction_date DESC, t.created_at DESC, t.id DESC LIMIT ? OFFSET ?`,
              params,
            )
          ).map(mapTransaction),
        );
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.post(
    "/transactions",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const input = parse(txSchema, req.body);
        const amount = positiveMoney(input.amount);
        const conn = await pool.getConnection();
        try {
          await conn.beginTransaction();
          const wallet = await getWallet(
            conn,
            user.userInternalId,
            input.walletId,
            true,
            true,
          );
          const category = input.categoryId
            ? await getCategory(conn, user.userInternalId, input.categoryId)
            : null;
          if (
            input.transactionType === "DYNAMIC_SPENDING" &&
            category &&
            !["SPENDING", "BOTH"].includes(category.applies_to)
          )
            throw new AppError(
              400,
              "INVALID_CATEGORY_TYPE",
              "A spending transaction requires a spending category",
            );
          if (
            input.transactionType !== "DYNAMIC_SPENDING" &&
            category &&
            !["INCOME", "BOTH"].includes(category.applies_to)
          )
            throw new AppError(
              400,
              "INVALID_CATEGORY_TYPE",
              "An income transaction requires an income category",
            );
          const txPublicId = crypto.randomUUID();
          await conn.execute(
            `INSERT INTO transactions (public_id, user_id, account_id, wallet_id, category_id, transaction_type, amount, currency_code, description, notes, transaction_date, transaction_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
            [
              txPublicId,
              user.userInternalId,
              wallet.account_id,
              wallet.id,
              category?.id ?? null,
              input.transactionType,
              amount.toFixed(2),
              wallet.currency_code,
              input.description ?? null,
              input.notes ?? null,
              input.transactionDate,
              input.transactionTime ?? null,
            ],
          );
          if (input.transactionType === "DYNAMIC_SPENDING")
            await ensureWalletNotNegative(
              conn,
              user.userInternalId,
              String(wallet.id),
            );
          await conn.commit();
          const result = await getTransaction(
            pool,
            user.userInternalId,
            txPublicId,
          );
          return ok(res, mapTransaction(result), 201);
        } catch (error) {
          await conn.rollback().catch(() => undefined);
          throw error;
        } finally {
          conn.release();
        }
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.get(
    "/transactions/:transactionId",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        return ok(
          res,
          mapTransaction(
            await getTransaction(
              pool,
              authOf(req).userInternalId,
              req.params.transactionId,
            ),
          ),
        );
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.patch(
    "/transactions/:transactionId",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const input = parse(
          z
            .object({
              ...txSchema.shape,
              transactionType: z.enum([
                "MAIN_INCOME",
                "ADDITIONAL_INCOME",
                "STATIC_SPENDING",
                "DYNAMIC_SPENDING",
              ]),
            })
            .partial(),
          req.body,
        );
        const conn = await pool.getConnection();
        try {
          await conn.beginTransaction();
          const old = await getTransaction(
            conn,
            user.userInternalId,
            req.params.transactionId,
            true,
          );
          if (old.status !== "POSTED")
            throw new AppError(
              409,
              "TRANSACTION_NOT_POSTED",
              "Only posted transactions can be edited",
            );
          if (
            old.transaction_type === "STATIC_SPENDING" &&
            input.transactionType &&
            input.transactionType !== "STATIC_SPENDING"
          )
            throw new AppError(
              400,
              "STATIC_TYPE_IMMUTABLE",
              "A paid static transaction must remain static spending",
            );
          const requestedWallet = input.walletId
            ? await getWallet(conn, user.userInternalId, input.walletId, true)
            : await getWallet(
                conn,
                user.userInternalId,
                old.wallet_public_id,
                true,
              );
          await lockWallets(conn, user.userInternalId, [
            String(old.wallet_id),
            String(requestedWallet.id),
          ]);
          const wallet = requestedWallet;
          const category =
            input.categoryId === undefined
              ? null
              : input.categoryId
                ? await getCategory(conn, user.userInternalId, input.categoryId)
                : null;
          const amount =
            input.amount === undefined
              ? money(old.amount)
              : positiveMoney(input.amount);
          const type = input.transactionType ?? old.transaction_type;
          if (type === "STATIC_SPENDING" && !old.static_expense_template_id)
            throw new AppError(
              400,
              "STATIC_TEMPLATE_REQUIRED",
              "Static spending requires a template",
            );
          if (
            category &&
            type === "DYNAMIC_SPENDING" &&
            !["SPENDING", "BOTH"].includes(category.applies_to)
          )
            throw new AppError(
              400,
              "INVALID_CATEGORY_TYPE",
              "A spending transaction requires a spending category",
            );
          if (
            category &&
            type !== "DYNAMIC_SPENDING" &&
            !["INCOME", "BOTH"].includes(category.applies_to)
          )
            throw new AppError(
              400,
              "INVALID_CATEGORY_TYPE",
              "An income transaction requires an income category",
            );
          if (
            type === "STATIC_SPENDING" &&
            String(wallet.account_id) !== String(old.account_id)
          )
            throw new AppError(
              400,
              "ACCOUNT_WALLET_MISMATCH",
              "A paid static transaction must remain in its template account",
            );
          await conn.execute(
            `UPDATE transactions SET account_id=?, wallet_id=?, category_id=?, transaction_type=?, amount=?, currency_code=?, description=?, notes=?, transaction_date=?, transaction_time=? WHERE id=? AND user_id=?`,
            [
              wallet.account_id,
              wallet.id,
              input.categoryId === undefined
                ? old.category_id
                : (category?.id ?? null),
              type,
              amount.toFixed(2),
              wallet.currency_code,
              input.description === undefined
                ? old.description
                : input.description,
              input.notes === undefined ? old.notes : input.notes,
              input.transactionDate ?? old.transaction_date,
              input.transactionTime === undefined
                ? old.transaction_time
                : input.transactionTime,
              old.id,
              user.userInternalId,
            ],
          );
          // Editing an income amount can reduce the wallet just as editing a
          // spending amount can. Validate every wallet affected by the net
          // adjustment after applying the new ledger entry.
          await ensureWalletNotNegative(
            conn,
            user.userInternalId,
            String(old.wallet_id),
          );
          if (String(wallet.id) !== String(old.wallet_id))
            await ensureWalletNotNegative(
              conn,
              user.userInternalId,
              String(wallet.id),
            );
          await conn.commit();
          return ok(
            res,
            mapTransaction(
              await getTransaction(
                pool,
                user.userInternalId,
                req.params.transactionId,
              ),
            ),
          );
        } catch (error) {
          await conn.rollback().catch(() => undefined);
          throw error;
        } finally {
          conn.release();
        }
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.delete(
    "/transactions/:transactionId",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const conn = await pool.getConnection();
        try {
          await conn.beginTransaction();
          const tx = await getTransaction(
            conn,
            user.userInternalId,
            req.params.transactionId,
            true,
          );
          if (tx.status === "VOIDED")
            throw new AppError(
              409,
              "TRANSACTION_ALREADY_VOIDED",
              "Transaction is already voided",
            );
          await lockWallets(conn, user.userInternalId, [String(tx.wallet_id)]);
          if (tx.static_expense_template_id) {
            const occurrence = await one(
              conn,
              `SELECT * FROM static_expense_occurrences WHERE paid_transaction_id = ? AND user_id = ? LIMIT 1 FOR UPDATE`,
              [tx.id, user.userInternalId],
            );
            if (occurrence)
              await conn.execute(
                `UPDATE static_expense_occurrences SET status='PENDING', paid_transaction_id=NULL, paid_at=NULL, skipped_at=NULL WHERE id=? AND user_id=?`,
                [occurrence.id, user.userInternalId],
              );
          }
          await conn.execute(
            `UPDATE transactions SET status='VOIDED', deleted_at=UTC_TIMESTAMP() WHERE id=? AND user_id=?`,
            [tx.id, user.userInternalId],
          );
          await ensureWalletNotNegative(
            conn,
            user.userInternalId,
            String(tx.wallet_id),
          );
          await conn.commit();
          return ok(res, { voided: true });
        } catch (error) {
          await conn.rollback().catch(() => undefined);
          throw error;
        } finally {
          conn.release();
        }
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.get(
    "/static-expenses",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const year = Number(req.query.year ?? DateTime.utc().year);
        const month = Number(req.query.month ?? DateTime.utc().month);
        if (
          !Number.isInteger(year) ||
          !Number.isInteger(month) ||
          month < 1 ||
          month > 12
        )
          throw new AppError(
            400,
            "INVALID_PERIOD",
            "A valid year and month are required",
          );
        const pref = await preferences(pool, user.userInternalId);
        const financialMonthStart = Number(pref.financial_month_start ?? 1);
        const bounds = financialPeriodBounds(year, month, financialMonthStart);
        await generateStaticExpensesForFinancialPeriod(
          pool,
          user.userInternalId,
          year,
          month,
          financialMonthStart,
        );
        const templates = await rows(
          pool,
          `SELECT s.*, a.public_id AS account_public_id, a.name AS account_name, w.public_id AS wallet_public_id, c.public_id AS category_public_id, c.name AS category_name FROM static_expense_templates s JOIN accounts a ON a.id=s.account_id LEFT JOIN wallets w ON w.id=s.default_wallet_id LEFT JOIN categories c ON c.id=s.category_id WHERE s.user_id=? ORDER BY s.is_active DESC, s.name`,
          [user.userInternalId],
        );
        const occurrences = await rows(
          pool,
          `SELECT o.*, s.public_id AS template_public_id, s.name, s.account_id, a.public_id AS account_public_id, a.name AS account_name, s.default_wallet_id, w.public_id AS wallet_public_id, w.name AS wallet_name, w.currency_code AS wallet_currency_code, s.category_id, c.public_id AS category_public_id, t.public_id AS paid_transaction_public_id FROM static_expense_occurrences o JOIN static_expense_templates s ON s.id=o.template_id JOIN accounts a ON a.id=s.account_id LEFT JOIN wallets w ON w.id=s.default_wallet_id LEFT JOIN categories c ON c.id=s.category_id LEFT JOIN transactions t ON t.id=o.paid_transaction_id WHERE o.user_id=? AND o.due_date >= ? AND o.due_date < ? ORDER BY o.due_date, s.name`,
          [user.userInternalId, bounds.start, bounds.end],
        );
        return ok(res, {
          year,
          month,
          templates: templates.map(mapTemplate),
          occurrences: occurrences.map(mapOccurrence),
        });
      } catch (error) {
        next(error);
      }
    },
  );
  protectedApi.post(
    "/static-expenses",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const input = parse(templateSchema, req.body);
        const amount = positiveMoney(input.defaultAmount, "defaultAmount");
        const account = await getAccount(
          pool,
          user.userInternalId,
          input.accountId,
        );
        const wallet = input.defaultWalletId
          ? await getWallet(
              pool,
              user.userInternalId,
              input.defaultWalletId,
              true,
            )
          : null;
        if (wallet && String(wallet.account_id) !== String(account.id))
          throw new AppError(
            400,
            "ACCOUNT_WALLET_MISMATCH",
            "Default wallet must belong to the selected account",
          );
        const category = input.categoryId
          ? await getCategory(pool, user.userInternalId, input.categoryId)
          : null;
        const id = crypto.randomUUID();
        await pool.execute(
          `INSERT INTO static_expense_templates (public_id,user_id,account_id,default_wallet_id,category_id,name,default_amount,due_day,start_date,end_date,notes) VALUES (?,?,?,?,?,?,?,?,?,?,?)`,
          [
            id,
            user.userInternalId,
            account.id,
            wallet?.id ?? null,
            category?.id ?? null,
            input.name,
            amount.toFixed(2),
            input.dueDay,
            input.startDate,
            input.endDate ?? null,
            input.notes ?? null,
          ],
        );
        return ok(
          res,
          mapTemplate(await getTemplate(pool, user.userInternalId, id)),
          201,
        );
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.patch(
    "/static-expenses/:templateId",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const input = parse(templateSchema.partial(), req.body);
        const current = await getTemplate(
          pool,
          user.userInternalId,
          req.params.templateId,
          true,
        );
        const account = input.accountId
          ? await getAccount(pool, user.userInternalId, input.accountId)
          : null;
        const effectiveAccountId = String(account?.id ?? current.account_id);
        const wallet = input.defaultWalletId
          ? await getWallet(
              pool,
              user.userInternalId,
              input.defaultWalletId,
              true,
            )
          : null;
        const effectiveWalletId =
          input.defaultWalletId === undefined
            ? current.default_wallet_id
            : (wallet?.id ?? null);
        if (effectiveWalletId) {
          const effectiveWallet =
            wallet ??
            (await one(
              pool,
              `SELECT account_id FROM wallets WHERE id=? AND user_id=?`,
              [effectiveWalletId, user.userInternalId],
            ));
          if (
            !effectiveWallet ||
            String(effectiveWallet.account_id) !== effectiveAccountId
          )
            throw new AppError(
              400,
              "ACCOUNT_WALLET_MISMATCH",
              "Default wallet must belong to the selected account",
            );
        }
        const category = input.categoryId
          ? await getCategory(pool, user.userInternalId, input.categoryId)
          : null;
        await pool.execute(
          `UPDATE static_expense_templates SET account_id=?, default_wallet_id=?, category_id=?, name=?, default_amount=?, due_day=?, start_date=?, end_date=?, notes=? WHERE id=? AND user_id=?`,
          [
            effectiveAccountId,
            effectiveWalletId,
            input.categoryId === undefined
              ? current.category_id
              : (category?.id ?? null),
            input.name ?? current.name,
            input.defaultAmount === undefined
              ? current.default_amount
              : positiveMoney(input.defaultAmount, "defaultAmount").toFixed(2),
            input.dueDay ?? current.due_day,
            input.startDate ?? current.start_date,
            input.endDate === undefined ? current.end_date : input.endDate,
            input.notes === undefined ? current.notes : input.notes,
            current.id,
            user.userInternalId,
          ],
        );
        return ok(
          res,
          mapTemplate(
            await getTemplate(pool, user.userInternalId, req.params.templateId),
          ),
        );
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.delete(
    "/static-expenses/:templateId",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const template = await getTemplate(
          pool,
          authOf(req).userInternalId,
          req.params.templateId,
          true,
        );
        await pool.execute(
          `UPDATE static_expense_templates SET is_active=0, archived_at=UTC_TIMESTAMP() WHERE id=? AND user_id=?`,
          [template.id, authOf(req).userInternalId],
        );
        return ok(res, { archived: true });
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.get(
    "/static-expenses/occurrences",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const year = Number(req.query.year);
        const month = Number(req.query.month);
        if (!year || !month)
          throw new AppError(
            400,
            "INVALID_PERIOD",
            "A valid year and month are required",
          );
        const pref = await preferences(pool, user.userInternalId);
        const financialMonthStart = Number(pref.financial_month_start ?? 1);
        const bounds = financialPeriodBounds(year, month, financialMonthStart);
        await generateStaticExpensesForFinancialPeriod(
          pool,
          user.userInternalId,
          year,
          month,
          financialMonthStart,
        );
        const items = await rows(
          pool,
          `SELECT o.*,s.public_id AS template_public_id,s.name,a.public_id AS account_public_id,a.name AS account_name,w.public_id AS wallet_public_id,w.name AS wallet_name,w.currency_code AS wallet_currency_code,c.public_id AS category_public_id,t.public_id AS paid_transaction_public_id FROM static_expense_occurrences o JOIN static_expense_templates s ON s.id=o.template_id JOIN accounts a ON a.id=s.account_id LEFT JOIN wallets w ON w.id=s.default_wallet_id LEFT JOIN categories c ON c.id=s.category_id LEFT JOIN transactions t ON t.id=o.paid_transaction_id WHERE o.user_id=? AND o.due_date >= ? AND o.due_date < ? ORDER BY o.due_date,s.name`,
          [user.userInternalId, bounds.start, bounds.end],
        );
        return ok(res, items.map(mapOccurrence));
      } catch (error) {
        next(error);
      }
    },
  );
  protectedApi.get(
    "/static-expenses/:templateId",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        return ok(
          res,
          mapTemplate(
            await getTemplate(
              pool,
              authOf(req).userInternalId,
              req.params.templateId,
            ),
          ),
        );
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.post(
    "/static-expenses/occurrences/generate",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const year = Number(req.body?.year);
        const month = Number(req.body?.month);
        if (!year || !month || month < 1 || month > 12)
          throw new AppError(
            400,
            "INVALID_PERIOD",
            "A valid year and month are required",
          );
        await pool.query(
          "CALL sp_generate_static_expenses_for_month(?, ?, ?)",
          [authOf(req).userInternalId, year, month],
        );
        return ok(res, { generated: true, year, month });
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.post(
    "/static-expenses/occurrences/:occurrenceId/pay",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const input = parse(
          z.object({
            walletId: idSchema.optional().nullable(),
            amount: optionalMoney.optional().nullable(),
            paidAt: z.string().datetime().optional().nullable(),
            notes: z.string().max(500).optional().nullable(),
          }),
          req.body,
        );
        const conn = await pool.getConnection();
        try {
          await conn.beginTransaction();
          const occurrence = await one(
            conn,
            `SELECT o.*,s.account_id,s.category_id,s.default_wallet_id,s.name,s.notes AS template_notes,s.public_id AS template_public_id,a.public_id AS account_public_id FROM static_expense_occurrences o JOIN static_expense_templates s ON s.id=o.template_id JOIN accounts a ON a.id=s.account_id WHERE o.user_id=? AND o.public_id=? LIMIT 1 FOR UPDATE`,
            [user.userInternalId, req.params.occurrenceId],
          );
          if (!occurrence)
            throw new AppError(
              404,
              "OCCURRENCE_NOT_FOUND",
              "Static expense occurrence not found",
            );
          if (occurrence.status !== "PENDING")
            throw new AppError(
              409,
              "OCCURRENCE_NOT_PENDING",
              "Only pending occurrences can be paid",
            );
          const wallet = await getWallet(
            conn,
            user.userInternalId,
            input.walletId ??
              (occurrence.default_wallet_id
                ? String(
                    (
                      await one(
                        conn,
                        `SELECT public_id FROM wallets WHERE user_id=? AND id=?`,
                        [user.userInternalId, occurrence.default_wallet_id],
                      )
                    )?.public_id,
                  )
                : ""),
            true,
            true,
          );
          if (String(wallet.account_id) !== String(occurrence.account_id))
            throw new AppError(
              400,
              "ACCOUNT_WALLET_MISMATCH",
              "Payment wallet must belong to the template account",
            );
          const amount =
            input.amount === undefined || input.amount === null
              ? money(occurrence.expected_amount)
              : positiveMoney(input.amount);
          const txId = crypto.randomUUID();
          await conn.execute(
            `INSERT INTO transactions (public_id,user_id,account_id,wallet_id,category_id,static_expense_template_id,transaction_type,amount,currency_code,description,notes,transaction_date) VALUES (?,?,?,?,?,?, 'STATIC_SPENDING',?,?,?,?,?)`,
            [
              txId,
              user.userInternalId,
              wallet.account_id,
              wallet.id,
              occurrence.category_id,
              occurrence.template_id,
              amount.toFixed(2),
              wallet.currency_code,
              occurrence.name,
              input.notes ??
                occurrence.notes ??
                occurrence.template_notes ??
                null,
              input.paidAt
                ? DateTime.fromISO(input.paidAt).toISODate()!
                : dateOnly(occurrence.due_date),
            ],
          );
          const inserted = await one(
            conn,
            `SELECT id FROM transactions WHERE user_id=? AND public_id=?`,
            [user.userInternalId, txId],
          );
          await ensureWalletNotNegative(
            conn,
            user.userInternalId,
            String(wallet.id),
          );
          await conn.execute(
            `UPDATE static_expense_occurrences SET status='PAID',paid_transaction_id=?,paid_at=? WHERE id=? AND user_id=?`,
            [
              inserted!.id,
              input.paidAt ? new Date(input.paidAt) : new Date(),
              occurrence.id,
              user.userInternalId,
            ],
          );
          await conn.commit();
          return ok(res, { paid: true, transactionId: txId });
        } catch (error) {
          await conn.rollback().catch(() => undefined);
          throw error;
        } finally {
          conn.release();
        }
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.post(
    "/static-expenses/occurrences/:occurrenceId/skip",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const result = await pool.execute(
          `UPDATE static_expense_occurrences SET status='SKIPPED',skipped_at=UTC_TIMESTAMP() WHERE user_id=? AND public_id=? AND status='PENDING'`,
          [user.userInternalId, req.params.occurrenceId],
        );
        if ((result[0] as any).affectedRows === 0)
          throw new AppError(
            409,
            "OCCURRENCE_NOT_PENDING",
            "Only pending occurrences can be skipped",
          );
        return ok(res, { skipped: true });
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.get(
    "/monthly-plans/current",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const pref = await preferences(pool, authOf(req).userInternalId);
        const now = DateTime.now().setZone(pref.timezone ?? "UTC");
        const period = financialPeriodForDate(
          now,
          Number(pref.financial_month_start ?? 1),
        );
        const currency = String(
          req.query.currencyCode ??
            (await currentUser(pool, authOf(req).userId)).preferred_currency,
        );
        return ok(
          res,
          await allowanceSummary(
            pool,
            authOf(req).userInternalId,
            period.year,
            period.month,
            currency,
            undefined,
            localDate(pref.timezone ?? "UTC"),
            Number(pref.financial_month_start ?? 1),
          ),
        );
      } catch (error) {
        next(error);
      }
    },
  );
  protectedApi.get(
    "/monthly-plans/:year/:month",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const year = Number(req.params.year),
          month = Number(req.params.month);
        if (!year || month < 1 || month > 12)
          throw new AppError(
            400,
            "INVALID_PERIOD",
            "A valid year and month are required",
          );
        const pref = await preferences(pool, authOf(req).userInternalId);
        const user = await currentUser(pool, authOf(req).userId);
        const currency = String(
          req.query.currencyCode ?? user.preferred_currency,
        );
        return ok(
          res,
          await allowanceSummary(
            pool,
            authOf(req).userInternalId,
            year,
            month,
            currency,
            undefined,
            localDate(pref.timezone ?? "UTC"),
            Number(pref.financial_month_start ?? 1),
          ),
        );
      } catch (error) {
        next(error);
      }
    },
  );
  protectedApi.post(
    "/monthly-plans",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const input = parse(planSchema, req.body);
        const amount = money(input.monthlyAllowance, "monthlyAllowance");
        const id = crypto.randomUUID();
        await pool.execute(
          `INSERT INTO monthly_plans(public_id,user_id,plan_year,plan_month,currency_code,monthly_allowance,notes) VALUES(?,?,?,?,?,?,?) ON DUPLICATE KEY UPDATE monthly_allowance=VALUES(monthly_allowance),notes=VALUES(notes)`,
          [
            id,
            user.userInternalId,
            input.planYear,
            input.planMonth,
            input.currencyCode,
            amount.toFixed(2),
            input.notes ?? null,
          ],
        );
        const pref = await preferences(pool, user.userInternalId);
        return ok(
          res,
          await allowanceSummary(
            pool,
            user.userInternalId,
            input.planYear,
            input.planMonth,
            input.currencyCode,
            undefined,
            localDate(pref.timezone ?? "UTC"),
            Number(pref.financial_month_start ?? 1),
          ),
          201,
        );
      } catch (error) {
        next(error);
      }
    },
  );
  protectedApi.patch(
    "/monthly-plans/:planId",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const input = parse(planSchema.partial(), req.body);
        const user = authOf(req);
        const current = await one(
          pool,
          `SELECT * FROM monthly_plans WHERE user_id=? AND public_id=? LIMIT 1`,
          [user.userInternalId, req.params.planId],
        );
        if (!current)
          throw new AppError(
            404,
            "MONTHLY_PLAN_NOT_FOUND",
            "Monthly plan not found",
          );
        await pool.execute(
          `UPDATE monthly_plans SET plan_year=?,plan_month=?,currency_code=?,monthly_allowance=?,notes=? WHERE id=? AND user_id=?`,
          [
            input.planYear ?? current.plan_year,
            input.planMonth ?? current.plan_month,
            input.currencyCode ?? current.currency_code,
            input.monthlyAllowance === undefined
              ? current.monthly_allowance
              : money(input.monthlyAllowance, "monthlyAllowance").toFixed(2),
            input.notes === undefined ? current.notes : input.notes,
            current.id,
            user.userInternalId,
          ],
        );
        const pref = await preferences(pool, user.userInternalId);
        return ok(
          res,
          await allowanceSummary(
            pool,
            user.userInternalId,
            Number(input.planYear ?? current.plan_year),
            Number(input.planMonth ?? current.plan_month),
            String(input.currencyCode ?? current.currency_code),
            undefined,
            localDate(pref.timezone ?? "UTC"),
            Number(pref.financial_month_start ?? 1),
          ),
        );
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.get(
    "/transfers",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const pref = await preferences(pool, user.userInternalId);
        const params: unknown[] = [user.userInternalId];
        let filter =
          "tr.user_id=? AND tr.status='COMPLETED' AND tr.deleted_at IS NULL";
        if (req.query.year && req.query.month) {
          const bounds = financialPeriodBounds(
            Number(req.query.year),
            Number(req.query.month),
            Number(pref.financial_month_start ?? 1),
          );
          filter += " AND tr.transfer_date >= ? AND tr.transfer_date < ?";
          params.push(bounds.start, bounds.end);
        } else if (req.query.year) {
          filter += " AND YEAR(tr.transfer_date)=?";
          params.push(Number(req.query.year));
        } else if (req.query.month) {
          filter += " AND MONTH(tr.transfer_date)=?";
          params.push(Number(req.query.month));
        }
        const items = await rows(
          pool,
          `SELECT tr.*,fw.public_id AS from_wallet_public_id,fw.name AS from_wallet_name,tw.public_id AS to_wallet_public_id,tw.name AS to_wallet_name FROM transfers tr JOIN wallets fw ON fw.id=tr.from_wallet_id JOIN wallets tw ON tw.id=tr.to_wallet_id WHERE ${filter} ORDER BY tr.transfer_date DESC,tr.created_at DESC LIMIT 250`,
          params,
        );
        return ok(res, items.map(mapTransfer));
      } catch (error) {
        next(error);
      }
    },
  );
  protectedApi.get(
    "/transfers/:transferId",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const item = await one(
          pool,
          `SELECT tr.*,fw.public_id AS from_wallet_public_id,fw.name AS from_wallet_name,tw.public_id AS to_wallet_public_id,tw.name AS to_wallet_name FROM transfers tr JOIN wallets fw ON fw.id=tr.from_wallet_id JOIN wallets tw ON tw.id=tr.to_wallet_id WHERE tr.user_id=? AND tr.public_id=? AND tr.status='COMPLETED' AND tr.deleted_at IS NULL LIMIT 1`,
          [authOf(req).userInternalId, req.params.transferId],
        );
        if (!item)
          throw new AppError(404, "TRANSFER_NOT_FOUND", "Transfer not found");
        return ok(res, mapTransfer(item));
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.post(
    "/transfers",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const input = parse(transferSchema, req.body);
        const amount = positiveMoney(input.amount);
        if (input.fromWalletId === input.toWalletId)
          throw new AppError(
            400,
            "SAME_WALLET",
            "Source and destination wallets must be different",
          );
        const conn = await pool.getConnection();
        try {
          await conn.beginTransaction();
          const source = await getWallet(
            conn,
            user.userInternalId,
            input.fromWalletId,
            true,
          );
          const target = await getWallet(
            conn,
            user.userInternalId,
            input.toWalletId,
            true,
          );
          await lockWallets(conn, user.userInternalId, [
            String(source.id),
            String(target.id),
          ]);
          if (source.currency_code !== target.currency_code)
            throw new AppError(
              400,
              "CROSS_CURRENCY_TRANSFER",
              "Transfers require wallets with the same currency",
            );
          const transferId = crypto.randomUUID();
          await conn.execute(
            `INSERT INTO transfers(public_id,user_id,from_wallet_id,to_wallet_id,amount,currency_code,notes,transfer_date,transfer_time) VALUES(?,?,?,?,?,?,?,?,?)`,
            [
              transferId,
              user.userInternalId,
              source.id,
              target.id,
              amount.toFixed(2),
              source.currency_code,
              input.notes ?? null,
              input.transferDate,
              input.transferTime ?? null,
            ],
          );
          await ensureWalletNotNegative(
            conn,
            user.userInternalId,
            String(source.id),
          );
          await conn.commit();
          return ok(
            res,
            {
              id: transferId,
              transferred: true,
              fromWalletId: source.public_id,
              toWalletId: target.public_id,
              amount: amount.toFixed(2),
              currencyCode: source.currency_code,
            },
            201,
          );
        } catch (error) {
          await conn.rollback().catch(() => undefined);
          throw error;
        } finally {
          conn.release();
        }
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.delete(
    "/transfers/:transferId",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const conn = await pool.getConnection();
        try {
          await conn.beginTransaction();
          const candidate = await one(
            conn,
            `SELECT * FROM transfers WHERE user_id=? AND public_id=? AND status='COMPLETED' AND deleted_at IS NULL LIMIT 1`,
            [user.userInternalId, req.params.transferId],
          );
          if (!candidate)
            throw new AppError(404, "TRANSFER_NOT_FOUND", "Transfer not found");
          await lockWallets(conn, user.userInternalId, [
            String(candidate.from_wallet_id),
            String(candidate.to_wallet_id),
          ]);
          const transfer = await one(
            conn,
            `SELECT * FROM transfers WHERE user_id=? AND public_id=? AND status='COMPLETED' AND deleted_at IS NULL LIMIT 1 FOR UPDATE`,
            [user.userInternalId, req.params.transferId],
          );
          if (!transfer)
            throw new AppError(404, "TRANSFER_NOT_FOUND", "Transfer not found");
          await conn.execute(
            `UPDATE transfers SET status='VOIDED',deleted_at=UTC_TIMESTAMP() WHERE id=? AND user_id=?`,
            [transfer.id, user.userInternalId],
          );
          await ensureWalletNotNegative(
            conn,
            user.userInternalId,
            String(transfer.to_wallet_id),
          );
          await conn.commit();
          return ok(res, { voided: true });
        } catch (error) {
          await conn.rollback().catch(() => undefined);
          throw error;
        } finally {
          conn.release();
        }
      } catch (error) {
        next(error);
      }
    },
  );

  protectedApi.get(
    "/dashboard",
    async (req: AuthenticatedRequest, res, next) => {
      try {
        const user = authOf(req);
        const year = Number(req.query.year);
        const month = Number(req.query.month);
        if (
          !Number.isInteger(year) ||
          !Number.isInteger(month) ||
          month < 1 ||
          month > 12
        )
          throw new AppError(
            400,
            "INVALID_PERIOD",
            "A valid year and month are required",
          );
        const pref = await preferences(pool, user.userInternalId);
        const scope = await accountScope(
          pool,
          user.userInternalId,
          req.query.accountId ? String(req.query.accountId) : undefined,
        );
        const currency = req.query.currencyCode
          ? String(req.query.currencyCode).toUpperCase()
          : undefined;
        const params: unknown[] = [user.userInternalId];
        let walletFilter = "w.user_id=? AND w.is_active=1";
        if (currency) {
          walletFilter += " AND w.currency_code=?";
          params.push(currency);
        }
        if (scope?.length) {
          walletFilter += ` AND w.account_id IN (${scope.map(() => "?").join(",")})`;
          params.push(...scope);
        }
        const balanceRows = await rows(
          pool,
          `SELECT vb.*,a.public_id AS account_public_id,a.name AS account_name FROM v_wallet_balances vb JOIN wallets w ON w.id=vb.wallet_id JOIN accounts a ON a.id=vb.account_id WHERE ${walletFilter} ORDER BY a.name,vb.wallet_name`,
          params,
        );
        const currencies = [
          ...new Set(balanceRows.map((item) => String(item.currency_code))),
        ];
        if (currency && !currencies.includes(currency))
          currencies.push(currency);
        const summaryByCurrency = [] as Row[];
        const allowanceByCurrency = [] as Row[];
        const today = localDate(pref.timezone ?? "UTC");
        for (const code of currencies) {
          const summary = await queryMonthlySummary(
            pool,
            user.userInternalId,
            year,
            month,
            code,
            scope,
            Number(pref.financial_month_start ?? 1),
          );
          const spending = summary
            ? {
                mainIncome: publicMoney(summary.main_income),
                additionalIncome: publicMoney(summary.additional_income),
                totalIncome: publicMoney(summary.total_income),
                staticSpending: publicMoney(summary.static_spending),
                dynamicSpending: publicMoney(summary.dynamic_spending),
                totalSpending: publicMoney(summary.total_spending),
                remainingMoney: money(summary.total_income)
                  .minus(money(summary.total_spending))
                  .toFixed(2),
              }
            : {
                mainIncome: "0.00",
                additionalIncome: "0.00",
                totalIncome: "0.00",
                staticSpending: "0.00",
                dynamicSpending: "0.00",
                totalSpending: "0.00",
                remainingMoney: "0.00",
              };
          summaryByCurrency.push({ currencyCode: code, ...spending });
          allowanceByCurrency.push(
            await allowanceSummary(
              pool,
              user.userInternalId,
              year,
              month,
              code,
              scope,
              financialPeriodForDate(
                DateTime.fromISO(today),
                Number(pref.financial_month_start ?? 1),
              ).year === year &&
              financialPeriodForDate(
                DateTime.fromISO(today),
                Number(pref.financial_month_start ?? 1),
              ).month === month
                ? today
                : undefined,
              Number(pref.financial_month_start ?? 1),
            ),
          );
        }
        const dashboardBounds = financialPeriodBounds(
          year,
          month,
          Number(pref.financial_month_start ?? 1),
        );
        await generateStaticExpensesForFinancialPeriod(
          pool,
          user.userInternalId,
          year,
          month,
          Number(pref.financial_month_start ?? 1),
        );
        const occurrenceParams: unknown[] = [
          user.userInternalId,
          dashboardBounds.start,
          dashboardBounds.end,
        ];
        let occurrenceFilter =
          "o.user_id=? AND o.due_date >= ? AND o.due_date < ?";
        if (scope?.length) {
          occurrenceFilter += ` AND s.account_id IN (${scope.map(() => "?").join(",")})`;
          occurrenceParams.push(...scope);
        }
        if (currency) {
          occurrenceFilter +=
            " AND (w.currency_code=? OR w.currency_code IS NULL)";
          occurrenceParams.push(currency);
        }
        const staticRows = await rows(
          pool,
          `SELECT o.*,s.public_id AS template_public_id,s.name,a.public_id AS account_public_id,a.name AS account_name,w.public_id AS wallet_public_id,w.name AS wallet_name,w.currency_code AS wallet_currency_code,c.public_id AS category_public_id,t.public_id AS paid_transaction_public_id FROM static_expense_occurrences o JOIN static_expense_templates s ON s.id=o.template_id JOIN accounts a ON a.id=s.account_id LEFT JOIN wallets w ON w.id=s.default_wallet_id LEFT JOIN categories c ON c.id=s.category_id LEFT JOIN transactions t ON t.id=o.paid_transaction_id WHERE ${occurrenceFilter} ORDER BY o.due_date,s.name`,
          occurrenceParams,
        );
        const recentBounds = financialPeriodBounds(
          year,
          month,
          Number(pref.financial_month_start ?? 1),
        );
        const recentParams: unknown[] = [
          user.userInternalId,
          recentBounds.start,
          recentBounds.end,
        ];
        let recentFilter =
          "t.user_id=? AND t.transaction_date >= ? AND t.transaction_date < ? AND t.status='POSTED' AND t.deleted_at IS NULL";
        if (scope?.length) {
          recentFilter += ` AND t.account_id IN (${scope.map(() => "?").join(",")})`;
          recentParams.push(...scope);
        }
        if (currency) {
          recentFilter += " AND t.currency_code=?";
          recentParams.push(currency);
        }
        const tx = await rows(
          pool,
          `SELECT t.*,w.public_id AS wallet_public_id,w.name AS wallet_name,a.public_id AS account_public_id,a.name AS account_name,c.public_id AS category_public_id,c.name AS category_name,s.public_id AS template_public_id FROM transactions t JOIN wallets w ON w.id=t.wallet_id JOIN accounts a ON a.id=t.account_id LEFT JOIN categories c ON c.id=t.category_id LEFT JOIN static_expense_templates s ON s.id=t.static_expense_template_id WHERE ${recentFilter} ORDER BY t.transaction_date DESC,t.created_at DESC LIMIT 20`,
          recentParams,
        );
        return ok(res, {
          user: publicUser(await currentUser(pool, user.userId)),
          period: {
            year,
            month,
            timezone: pref.timezone ?? "UTC",
            accountId: req.query.accountId ?? "all",
            currencyCode: currency ?? null,
          },
          balances: balanceRows.map((item) => ({
            currencyCode: item.currency_code,
            accountId: item.account_public_id,
            accountName: item.account_name,
            walletId: item.wallet_public_id,
            walletName: item.wallet_name,
            walletTypeCode: item.wallet_type_code,
            currentBalance: publicMoney(item.current_balance),
          })),
          summaryByCurrency,
          allowanceByCurrency,
          staticExpenses: staticRows.map(mapOccurrence),
          recentTransactions: tx.map(mapTransaction),
        });
      } catch (error) {
        next(error);
      }
    },
  );

  return app;
}

export const app = createApp();
app.use(notFound);
app.use(errorHandler);
