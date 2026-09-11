import request from 'supertest';
import { describe, expect, it } from 'vitest';
import { app } from '../src/app.js';

describe('API conventions', () => {
  it('returns the standard envelope for unknown routes', async () => {
    const response = await request(app).get('/not-a-route');
    expect(response.status).toBe(404);
    expect(response.body).toMatchObject({ success: false, code: 'NOT_FOUND' });
  });

  it('rejects protected resources without an access token', async () => {
    const response = await request(app).get('/api/v1/accounts');
    expect(response.status).toBe(401);
    expect(response.body).toMatchObject({ success: false, code: 'UNAUTHORIZED' });
  });

  it('validates auth input before touching the database', async () => {
    const response = await request(app).post('/api/v1/auth/register').send({ email: 'not-an-email' });
    expect(response.status).toBe(400);
    expect(response.body).toMatchObject({ success: false, code: 'VALIDATION_ERROR' });
  });
});
