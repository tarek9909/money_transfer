import { Decimal } from 'decimal.js';
import { describe, expect, it } from 'vitest';
import { calculateDailyAllowance, ledgerEffect, money } from '../src/financial.js';

describe('financial rules', () => {
  it('keeps allowance remaining negative while flooring future allowance', () => {
    const result = calculateDailyAllowance(new Decimal(-50), new Decimal(0), '2026-09-10', 'Asia/Beirut');
    expect(result.dailyAllowance.toFixed(2)).toBe('0.00');
    expect(result.remainingDays).toBe(21);
  });

  it('includes the current day in remaining days', () => {
    const result = calculateDailyAllowance(new Decimal(300), new Decimal(13), '2026-09-10', 'UTC');
    expect(result.dailyAllowance.toFixed(2)).toBe('14.90');
    expect(result.remainingToday.toFixed(2)).toBe('1.90');
  });

  it('uses signed effects without floating-point arithmetic', () => {
    expect(ledgerEffect('MAIN_INCOME', new Decimal('0.10')).plus(ledgerEffect('DYNAMIC_SPENDING', new Decimal('0.20'))).toFixed(2)).toBe('-0.10');
  });

  it('rejects fractions beyond the database precision', () => {
    expect(() => money('10.001')).toThrow();
    expect(money('30000000.10').toFixed(2)).toBe('30000000.10');
  });
});
