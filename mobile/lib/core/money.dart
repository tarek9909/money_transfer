import 'package:decimal/decimal.dart';

String moneyValue(Object? value, {String currency = 'USD'}) {
  final amount = Decimal.tryParse(value?.toString() ?? '0') ?? Decimal.zero;
  final negative = amount < Decimal.zero;
  final absolute = negative ? Decimal.zero - amount : amount;
  final fixed = absolute.toStringAsFixed(2);
  final parts = fixed.split('.');
  final digits = parts.first;
  final grouped = digits.replaceAllMapped(
    RegExp(r'(?<=\d)(?=(\d{3})+$)'),
    (_) => ',',
  );
  return '${negative ? '-' : ''}$currency $grouped.${parts[1]}';
}

String signedMoney(Object? value, {String currency = 'USD'}) {
  final amount = Decimal.tryParse(value?.toString() ?? '0') ?? Decimal.zero;
  return '${amount >= Decimal.zero ? '+' : ''}${moneyValue(amount, currency: currency)}';
}

Decimal parseMoney(Object? value) =>
    Decimal.tryParse(value?.toString() ?? '0') ?? Decimal.zero;
