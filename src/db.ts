import mysql, { Pool, PoolConnection } from 'mysql2/promise';
import { env } from './config.js';

export const pool = mysql.createPool({
  host: env.DATABASE_HOST,
  port: env.DATABASE_PORT,
  database: env.DATABASE_NAME,
  user: env.DATABASE_USER,
  password: env.DATABASE_PASSWORD,
  connectionLimit: env.DATABASE_CONNECTION_LIMIT,
  waitForConnections: true,
  decimalNumbers: false,
  namedPlaceholders: false,
  timezone: 'Z',
  enableKeepAlive: true,
  keepAliveInitialDelay: 10000,
});

export async function withTransaction<T>(fn: (connection: PoolConnection) => Promise<T>): Promise<T> {
  const connection = await pool.getConnection();
  try {
    await connection.beginTransaction();
    const result = await fn(connection);
    await connection.commit();
    return result;
  } catch (error) {
    await connection.rollback();
    throw error;
  } finally {
    connection.release();
  }
}

export type DbConnection = Pool | PoolConnection;
