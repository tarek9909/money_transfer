import fs from 'node:fs/promises';
import path from 'node:path';
import mysql from 'mysql2/promise';
import { env } from '../src/config.js';

const connection = await mysql.createConnection({ host: env.DATABASE_HOST, port: env.DATABASE_PORT, database: env.DATABASE_NAME, user: env.DATABASE_USER, password: env.DATABASE_PASSWORD, multipleStatements: false });
await connection.execute(`CREATE TABLE IF NOT EXISTS schema_migrations (version VARCHAR(100) PRIMARY KEY, applied_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP)`);

async function hasColumn(table: string, column: string) {
  const [rows] = await connection.execute(`SELECT 1 FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name=? AND column_name=?`, [table, column]);
  return (rows as any[]).length > 0;
}
async function hasIndex(table: string, index: string) {
  const [rows] = await connection.execute(`SELECT 1 FROM information_schema.statistics WHERE table_schema=DATABASE() AND table_name=? AND index_name=?`, [table, index]);
  return (rows as any[]).length > 0;
}

async function executeSqlFile(sql: string) {
  if (!/\bDELIMITER\b/i.test(sql)) {
    for (const statement of sql.split(/;\s*(?:\r?\n|$)/).map((value) => value.trim()).filter(Boolean)) await connection.query(statement);
    return;
  }

  let delimiter = ';';
  let buffer = '';
  for (const line of sql.split(/\r?\n/)) {
    const delimiterMatch = line.trim().match(/^DELIMITER\s+(\S+)$/i);
    if (delimiterMatch) {
      delimiter = delimiterMatch[1];
      continue;
    }
    buffer += `${line}\n`;
    if (buffer.trimEnd().endsWith(delimiter)) {
      const statement = buffer.trimEnd().slice(0, -delimiter.length).trim();
      if (statement) await connection.query(statement);
      buffer = '';
    }
  }
  if (buffer.trim()) await connection.query(buffer.trim());
}

const migrationDir = path.resolve(process.cwd(), 'migrations');
const files = (await fs.readdir(migrationDir)).filter((file) => /^\d+_.*\.sql$/.test(file)).sort();
for (const file of files) {
  const version = file.replace(/\.sql$/, '');
  const [applied] = await connection.execute(`SELECT version FROM schema_migrations WHERE version=?`, [version]);
  if ((applied as any[]).length) continue;
  if (version === '002_schema_hardening') {
    if (!(await hasColumn('user_preferences', 'timezone'))) await connection.execute(`ALTER TABLE user_preferences ADD COLUMN timezone VARCHAR(64) NOT NULL DEFAULT 'UTC' AFTER financial_month_start`);
    if (!(await hasColumn('monthly_plans', 'currency_code'))) await connection.execute(`ALTER TABLE monthly_plans ADD COLUMN currency_code CHAR(3) NOT NULL DEFAULT 'USD' AFTER plan_month`);
    if (await hasIndex('monthly_plans', 'uq_monthly_plans_user_period')) await connection.execute(`ALTER TABLE monthly_plans DROP INDEX uq_monthly_plans_user_period`);
    if (!(await hasIndex('monthly_plans', 'uq_monthly_plans_user_period_currency'))) await connection.execute(`ALTER TABLE monthly_plans ADD UNIQUE KEY uq_monthly_plans_user_period_currency (user_id, plan_year, plan_month, currency_code)`);
    await connection.execute(`INSERT INTO app_meta (meta_key, meta_value) VALUES ('schema_hardening','currency-aware-plans-timezone-paid-occurrence-invariants') ON DUPLICATE KEY UPDATE meta_value=VALUES(meta_value)`);
  } else {
    const sql = await fs.readFile(path.join(migrationDir, file), 'utf8');
    await executeSqlFile(sql);
  }
  await connection.execute(`INSERT INTO schema_migrations(version) VALUES(?)`, [version]);
  console.log(`Applied ${version}`);
}
await connection.end();
