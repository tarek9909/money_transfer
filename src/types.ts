import type { Request } from 'express';

export interface AuthContext {
  userId: string;
  userInternalId: string;
}

export interface AuthenticatedRequest extends Request<Record<string, string>> {
  auth?: AuthContext;
}

export interface UserRow {
  id: string;
  public_id: string;
  name: string;
  email: string;
  preferred_currency: string;
  status: string;
  timezone?: string;
}
