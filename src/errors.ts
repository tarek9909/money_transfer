export class AppError extends Error {
  constructor(
    public readonly statusCode: number,
    public readonly code: string,
    message: string,
    public readonly details?: unknown,
  ) {
    super(message);
    this.name = 'AppError';
  }
}

export function publicError(error: unknown): AppError {
  if (error instanceof AppError) return error;
  if (error instanceof Error && /must be a valid decimal|must be greater than zero/.test(error.message)) return new AppError(400, 'VALIDATION_ERROR', error.message);
  const mysqlError = error as { code?: string; errno?: number };
  if (mysqlError.code === 'ER_DUP_ENTRY') return new AppError(409, 'CONFLICT', 'The resource already exists');
  if (mysqlError.code === 'ER_NO_REFERENCED_ROW_2') return new AppError(400, 'INVALID_REFERENCE', 'A referenced resource does not exist');
  return new AppError(500, 'INTERNAL_ERROR', 'An unexpected error occurred');
}
