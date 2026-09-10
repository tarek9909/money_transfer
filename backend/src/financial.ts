import { Decimal } from 'decimal.js';
import { DateTime } from 'luxon';

export const ZERO = new Decimal(0);

export function money(value: unknown, field = 'amount'): Decimal {
  try {
    const parsed = new Decimal(String(value));
    if (!parsed.isFinite() || parsed.decimalPlaces() > 2) throw new Error('invalid');
    return parsed.toDecimalPlaces(2);
  } catch {
    throw new Error(`${field} must be a valid decimal with at most two fraction digits`);
  }
}

export function positiveMoney(value: unknown, field = 'amount'): Decimal {
  const parsed = money(value, field);
  if (!parsed.gt(0)) throw new Error(`${field} must be greater than zero`);
  return parsed;
}

export function ledgerEffect(type: string, amount: Decimal): Decimal {
  return type === 'MAIN_INCOME' || type === 'ADDITIONAL_INCOME' ? amount : amount.neg();
}

export function calculateDailyAllowance(
  allowanceRemaining: Decimal,
  todaySpending: Decimal,
  isoDate: string,
  timezone: string,
): { dailyAllowance: Decimal; remainingToday: Decimal; remainingDays: number } {
  const date = DateTime.fromISO(isoDate, { zone: timezone });
  const remainingDays = Math.max((date.daysInMonth ?? 30) - date.day + 1, 1);
  // `allowanceRemaining` already includes today's spending. Restore the
  // start-of-day balance before calculating today's pace, then subtract the
  // spend exactly once for the amount still available today.
  const allowanceRemainingAtStartOfDay = allowanceRemaining.plus(todaySpending);
  const dailyAllowance = Decimal.max(
    allowanceRemainingAtStartOfDay,
    ZERO,
  ).div(remainingDays).toDecimalPlaces(2);
  return {
    dailyAllowance,
    remainingToday: dailyAllowance.minus(todaySpending).toDecimalPlaces(2),
    remainingDays,
  };
}

export function localDate(timezone: string): string {
  return DateTime.now().setZone(timezone).toISODate()!;
}

export function dateIsValid(value: string): boolean {
  const parsed = DateTime.fromISO(value, { zone: 'UTC' });
  return parsed.isValid && parsed.toISODate() === value;
}
