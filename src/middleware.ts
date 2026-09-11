import type { NextFunction, Response } from 'express';
import type { Pool } from 'mysql2/promise';
import pino from 'pino';
import { pinoHttp } from 'pino-http';
import { verifyAccessToken } from './auth.js';
import { publicError, AppError } from './errors.js';
import type { AuthenticatedRequest } from './types.js';

export const logger = pino({
  level: process.env.LOG_LEVEL ?? 'info',
  redact: ['req.headers.authorization', 'req.body.password', 'req.body.refreshToken', 'req.body.refresh_token'],
});

export const requestLogger = pinoHttp({ logger });

export function authMiddleware(pool: Pool) {
  return async (req: AuthenticatedRequest, _res: Response, next: NextFunction) => {
    try {
      const header = req.header('authorization');
      if (!header?.startsWith('Bearer ')) throw new AppError(401, 'UNAUTHORIZED', 'Authentication is required');
      const { sub } = verifyAccessToken(header.slice(7));
      const [rows] = await pool.execute(
        `SELECT id, public_id, name, email, preferred_currency, status
         FROM users WHERE public_id = ? AND status = 'ACTIVE' AND deleted_at IS NULL LIMIT 1`,
        [sub],
      ) as any;
      if (!rows[0]) throw new AppError(401, 'UNAUTHORIZED', 'Authentication is required');
      req.auth = { userId: rows[0].public_id, userInternalId: String(rows[0].id) };
      next();
    } catch (error) {
      if (error instanceof AppError) {
        return next(error);
      }
      if (error instanceof Error && (error.name === 'JsonWebTokenError' || error.name === 'TokenExpiredError' || error.message.includes('token') || error.message.includes('jwt'))) {
        return next(new AppError(401, 'UNAUTHORIZED', 'Invalid or expired authentication token'));
      }
      return next(error);
    }
  };
}

export function errorHandler(error: unknown, req: AuthenticatedRequest, res: Response, _next: NextFunction) {
  const normalized = publicError(error);
  if (normalized.statusCode >= 500) req.log?.error({ err: error, userId: req.auth?.userId }, normalized.message);
  const isDev = process.env.NODE_ENV === 'development';
  res.status(normalized.statusCode).json({
    success: false,
    message: isDev && error instanceof Error ? error.message : normalized.message,
    code: normalized.code,
    ...(normalized.details ? { details: normalized.details } : (isDev && error instanceof Error ? { stack: error.stack } : {})),
  });
}

export function notFound(_req: AuthenticatedRequest, res: Response) {
  res.status(404).json({ success: false, message: 'Route not found', code: 'NOT_FOUND' });
}
