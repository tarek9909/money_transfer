-- Applied after the reviewed initial schema in backend/DB.SQL.
-- Keep this migration immutable; add a new numbered migration for later changes.
ALTER TABLE user_preferences
    ADD COLUMN timezone VARCHAR(64) NOT NULL DEFAULT 'UTC' AFTER financial_month_start;

ALTER TABLE monthly_plans
    ADD COLUMN currency_code CHAR(3) NOT NULL DEFAULT 'USD' AFTER plan_month;

ALTER TABLE monthly_plans
    DROP INDEX uq_monthly_plans_user_period,
    ADD UNIQUE KEY uq_monthly_plans_user_period_currency
        (user_id, plan_year, plan_month, currency_code);

INSERT INTO app_meta (meta_key, meta_value)
VALUES ('schema_hardening', 'currency-aware-plans-timezone-paid-occurrence-invariants')
ON DUPLICATE KEY UPDATE meta_value = VALUES(meta_value);
