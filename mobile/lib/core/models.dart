import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

/// Money crosses the API as a two-decimal string and stays a Decimal in Dart.
/// This converter also accepts a numeric value so old cached responses can be
/// read without reintroducing floating-point arithmetic into the app.
class DecimalConverter extends JsonConverter<Decimal, Object?> {
  const DecimalConverter();

  @override
  Decimal fromJson(Object? json) {
    if (json is String || json is num) return Decimal.parse(json.toString());
    throw FormatException('Expected a decimal string, got $json');
  }

  @override
  Object toJson(Decimal object) => object.toStringAsFixed(2);
}

@freezed
abstract class Session with _$Session {
  const factory Session({
    required String accessToken,
    required String refreshToken,
    required String expiresIn,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    required String preferredCurrency,
    required String timezone,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
abstract class Wallet with _$Wallet {
  const factory Wallet({
    required String id,
    required String accountId,
    String? accountName,
    required String name,
    required String walletTypeCode,
    required String currencyCode,
    @DecimalConverter() required Decimal openingBalance,
    @DecimalConverter() required Decimal currentBalance,
    required bool isActive,
  }) = _Wallet;

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);
}

@freezed
abstract class Account with _$Account {
  const factory Account({
    required String id,
    required String name,
    String? description,
    String? parentAccountId,
    required bool isActive,
    @Default(<Wallet>[]) List<Wallet> wallets,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}

@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    required String appliesTo,
    required bool isActive,
    required int sortOrder,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}

@freezed
abstract class TransactionItem with _$TransactionItem {
  const factory TransactionItem({
    required String id,
    required String transactionType,
    @DecimalConverter() required Decimal amount,
    required String currencyCode,
    required String accountId,
    String? accountName,
    required String walletId,
    String? walletName,
    String? categoryId,
    String? categoryName,
    String? staticExpenseTemplateId,
    String? description,
    String? notes,
    required String transactionDate,
    String? transactionTime,
    required String status,
    String? createdAt,
  }) = _TransactionItem;

  factory TransactionItem.fromJson(Map<String, dynamic> json) =>
      _$TransactionItemFromJson(json);
}

@freezed
abstract class StaticExpenseTemplate with _$StaticExpenseTemplate {
  const factory StaticExpenseTemplate({
    required String id,
    required String name,
    @JsonKey(name: 'amount') @DecimalConverter() required Decimal amount,
    required String accountId,
    required String accountName,
    String? defaultWalletId,
    String? categoryId,
    String? categoryName,
    required int dueDay,
    required String startDate,
    String? endDate,
    String? notes,
    required bool isActive,
  }) = _StaticExpenseTemplate;

  factory StaticExpenseTemplate.fromJson(Map<String, dynamic> json) =>
      _$StaticExpenseTemplateFromJson(json);
}

@freezed
abstract class StaticExpenseOccurrence with _$StaticExpenseOccurrence {
  const factory StaticExpenseOccurrence({
    required String id,
    required String templateId,
    required String name,
    required String accountId,
    String? accountName,
    String? walletId,
    String? walletName,
    String? currencyCode,
    String? categoryId,
    required int dueYear,
    required int dueMonth,
    required String dueDate,
    @DecimalConverter() required Decimal expectedAmount,
    required String status,
    String? paidTransactionId,
    String? paidAt,
    String? skippedAt,
    String? notes,
  }) = _StaticExpenseOccurrence;

  factory StaticExpenseOccurrence.fromJson(Map<String, dynamic> json) =>
      _$StaticExpenseOccurrenceFromJson(json);
}

@freezed
abstract class StaticExpenseCollection with _$StaticExpenseCollection {
  const factory StaticExpenseCollection({
    required int year,
    required int month,
    required List<StaticExpenseTemplate> templates,
    required List<StaticExpenseOccurrence> occurrences,
  }) = _StaticExpenseCollection;

  factory StaticExpenseCollection.fromJson(Map<String, dynamic> json) =>
      _$StaticExpenseCollectionFromJson(json);
}

@freezed
abstract class DashboardBalance with _$DashboardBalance {
  const factory DashboardBalance({
    required String currencyCode,
    required String accountId,
    required String accountName,
    required String walletId,
    required String walletName,
    required String walletTypeCode,
    @DecimalConverter() required Decimal currentBalance,
  }) = _DashboardBalance;

  factory DashboardBalance.fromJson(Map<String, dynamic> json) =>
      _$DashboardBalanceFromJson(json);
}

@freezed
abstract class DashboardSummary with _$DashboardSummary {
  const factory DashboardSummary({
    required String currencyCode,
    @DecimalConverter() required Decimal mainIncome,
    @DecimalConverter() required Decimal additionalIncome,
    @DecimalConverter() required Decimal totalIncome,
    @DecimalConverter() required Decimal staticSpending,
    @DecimalConverter() required Decimal dynamicSpending,
    @DecimalConverter() required Decimal totalSpending,
    @DecimalConverter() required Decimal remainingMoney,
  }) = _DashboardSummary;

  factory DashboardSummary.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryFromJson(json);
}

@freezed
abstract class AllowanceSummary with _$AllowanceSummary {
  const factory AllowanceSummary({
    required String currencyCode,
    @DecimalConverter() required Decimal monthlyAllowance,
    @DecimalConverter() required Decimal allowanceUsed,
    @DecimalConverter() required Decimal allowanceRemaining,
    @DecimalConverter() required Decimal dailyAllowance,
    @DecimalConverter() required Decimal spentToday,
    @DecimalConverter() required Decimal remainingToday,
    required int remainingDays,
    String? planId,
  }) = _AllowanceSummary;

  factory AllowanceSummary.fromJson(Map<String, dynamic> json) =>
      _$AllowanceSummaryFromJson(json);
}

@freezed
abstract class DashboardPeriod with _$DashboardPeriod {
  const factory DashboardPeriod({
    required int year,
    required int month,
    required String timezone,
    required String accountId,
    String? currencyCode,
  }) = _DashboardPeriod;

  factory DashboardPeriod.fromJson(Map<String, dynamic> json) =>
      _$DashboardPeriodFromJson(json);
}

@freezed
abstract class Dashboard with _$Dashboard {
  const factory Dashboard({
    required User user,
    required DashboardPeriod period,
    required List<DashboardBalance> balances,
    required List<DashboardSummary> summaryByCurrency,
    required List<AllowanceSummary> allowanceByCurrency,
    required List<StaticExpenseOccurrence> staticExpenses,
    required List<TransactionItem> recentTransactions,
  }) = _Dashboard;

  factory Dashboard.fromJson(Map<String, dynamic> json) =>
      _$DashboardFromJson(json);
}

@freezed
abstract class Transfer with _$Transfer {
  const factory Transfer({
    required String id,
    required String fromWalletId,
    required String fromWalletName,
    required String toWalletId,
    required String toWalletName,
    @DecimalConverter() required Decimal amount,
    required String currencyCode,
    String? notes,
    required String transferDate,
    required String status,
  }) = _Transfer;

  factory Transfer.fromJson(Map<String, dynamic> json) =>
      _$TransferFromJson(json);
}

@freezed
abstract class TransactionRequest with _$TransactionRequest {
  const factory TransactionRequest({
    required String transactionType,
    @DecimalConverter() required Decimal amount,
    required String walletId,
    String? categoryId,
    String? description,
    String? notes,
    required String transactionDate,
    String? transactionTime,
  }) = _TransactionRequest;

  factory TransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$TransactionRequestFromJson(json);
}

@freezed
abstract class OccurrencePaymentRequest with _$OccurrencePaymentRequest {
  const factory OccurrencePaymentRequest({
    String? walletId,
    @DecimalConverter() Decimal? amount,
    String? paidAt,
    String? notes,
  }) = _OccurrencePaymentRequest;

  factory OccurrencePaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$OccurrencePaymentRequestFromJson(json);
}

/// The API intentionally keeps the historical transaction-list payload as an
/// array for compatibility. This client-side value adds the paging state that
/// an infinite-scroll controller needs without weakening item typing.
class TransactionPage {
  const TransactionPage({
    required this.items,
    required this.limit,
    required this.offset,
  });

  final List<TransactionItem> items;
  final int limit;
  final int offset;

  bool get hasMore => items.length == limit;
  int get nextOffset => offset + items.length;
}
