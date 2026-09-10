-- Strengthen terminal-field invariants for existing installations.
-- The migration runner understands DELIMITER blocks; mysql clients can run
-- this file directly as well.
DROP TRIGGER IF EXISTS trg_static_occurrences_bu;

DELIMITER $$
CREATE TRIGGER trg_static_occurrences_bu
BEFORE UPDATE ON static_expense_occurrences
FOR EACH ROW
BEGIN
    DECLARE v_paid_tx_user BIGINT UNSIGNED;
    DECLARE v_paid_tx_type VARCHAR(40);

    IF NEW.status = 'PAID' AND NEW.paid_transaction_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Paid occurrence requires paid_transaction_id';
    END IF;

    IF NEW.status = 'PAID' AND NEW.paid_at IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Paid occurrence requires paid_at';
    END IF;

    IF NEW.status = 'PAID' AND NEW.skipped_at IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Paid occurrence cannot have skipped_at';
    END IF;

    IF NEW.status = 'SKIPPED' AND NEW.skipped_at IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Skipped occurrence requires skipped_at';
    END IF;

    IF NEW.status = 'SKIPPED'
       AND (NEW.paid_transaction_id IS NOT NULL OR NEW.paid_at IS NOT NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Skipped occurrence cannot have payment fields';
    END IF;

    IF NEW.status = 'PENDING'
       AND (NEW.paid_transaction_id IS NOT NULL
            OR NEW.paid_at IS NOT NULL
            OR NEW.skipped_at IS NOT NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pending occurrence cannot have terminal fields';
    END IF;

    IF NEW.status <> 'PAID' AND NEW.paid_transaction_id IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Only PAID occurrences may reference a paid transaction';
    END IF;

    IF NEW.paid_transaction_id IS NOT NULL THEN
        SELECT user_id, transaction_type
        INTO v_paid_tx_user, v_paid_tx_type
        FROM transactions
        WHERE id = NEW.paid_transaction_id
        LIMIT 1;

        IF v_paid_tx_user IS NULL
           OR v_paid_tx_user <> NEW.user_id
           OR v_paid_tx_type <> 'STATIC_SPENDING' THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Paid transaction must be a STATIC_SPENDING transaction owned by the same user';
        END IF;

        IF EXISTS (
            SELECT 1 FROM transactions
            WHERE id = NEW.paid_transaction_id
              AND (status <> 'POSTED' OR deleted_at IS NOT NULL
                   OR static_expense_template_id <> NEW.template_id)
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Paid transaction must be posted and belong to this template';
        END IF;
    END IF;
END$$
DELIMITER ;
