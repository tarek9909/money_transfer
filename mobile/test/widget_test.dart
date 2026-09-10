import 'package:flutter_test/flutter_test.dart';
import 'package:decimal/decimal.dart';
import 'package:personal_money_tracker/core/api_client.dart';
import 'package:personal_money_tracker/core/money.dart';
import 'package:personal_money_tracker/core/models.dart';

void main() {
  test('formats money using decimal input', () {
    expect(moneyValue('12.30', currency: 'USD'), contains('12.30'));
  });

  test('formats large balances without converting through double', () {
    expect(moneyValue('30000000.10', currency: 'LBP'), 'LBP 30,000,000.10');
  });

  test('preserves negative allowance values', () {
    expect(moneyValue('-50.00', currency: 'USD'), '-USD 50.00');
  });

  test('generated models keep camelCase and decimal string contracts', () {
    final request = TransactionRequest(
      transactionType: 'DYNAMIC_SPENDING',
      amount: Decimal.parse('12.3'),
      walletId: 'b130e64c-7c85-4089-a292-628fdfd4e68e',
      transactionDate: '2026-09-10',
    );

    expect(request.toJson(), {
      'transactionType': 'DYNAMIC_SPENDING',
      'amount': '12.30',
      'walletId': 'b130e64c-7c85-4089-a292-628fdfd4e68e',
      'categoryId': null,
      'description': null,
      'notes': null,
      'transactionDate': '2026-09-10',
      'transactionTime': null,
    });
    expect(
      TransactionRequest.fromJson(request.toJson()).amount,
      Decimal.parse('12.30'),
    );
  });

  test('maps financial API codes to typed UI exceptions', () {
    expect(
      ApiException.fromResponse({
        'message': 'Not enough money',
        'code': 'INSUFFICIENT_BALANCE',
      }),
      isA<InsufficientBalanceException>(),
    );
    expect(
      ApiException.fromResponse({
        'message': 'Wallets differ',
        'code': 'ACCOUNT_WALLET_MISMATCH',
      }),
      isA<AccountWalletMismatchException>(),
    );
  });
}
