// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Session _$SessionFromJson(Map<String, dynamic> json) => _Session(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  expiresIn: json['expiresIn'] as String,
);

Map<String, dynamic> _$SessionToJson(_Session instance) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'expiresIn': instance.expiresIn,
};

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  preferredCurrency: json['preferredCurrency'] as String,
  timezone: json['timezone'] as String,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'preferredCurrency': instance.preferredCurrency,
  'timezone': instance.timezone,
};

_Wallet _$WalletFromJson(Map<String, dynamic> json) => _Wallet(
  id: json['id'] as String,
  accountId: json['accountId'] as String,
  accountName: json['accountName'] as String?,
  name: json['name'] as String,
  walletTypeCode: json['walletTypeCode'] as String,
  currencyCode: json['currencyCode'] as String,
  openingBalance: const DecimalConverter().fromJson(json['openingBalance']),
  currentBalance: const DecimalConverter().fromJson(json['currentBalance']),
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$WalletToJson(_Wallet instance) => <String, dynamic>{
  'id': instance.id,
  'accountId': instance.accountId,
  'accountName': instance.accountName,
  'name': instance.name,
  'walletTypeCode': instance.walletTypeCode,
  'currencyCode': instance.currencyCode,
  'openingBalance': const DecimalConverter().toJson(instance.openingBalance),
  'currentBalance': const DecimalConverter().toJson(instance.currentBalance),
  'isActive': instance.isActive,
};

_Account _$AccountFromJson(Map<String, dynamic> json) => _Account(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  parentAccountId: json['parentAccountId'] as String?,
  isActive: json['isActive'] as bool,
  wallets:
      (json['wallets'] as List<dynamic>?)
          ?.map((e) => Wallet.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Wallet>[],
);

Map<String, dynamic> _$AccountToJson(_Account instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'parentAccountId': instance.parentAccountId,
  'isActive': instance.isActive,
  'wallets': instance.wallets,
};

_Category _$CategoryFromJson(Map<String, dynamic> json) => _Category(
  id: json['id'] as String,
  name: json['name'] as String,
  appliesTo: json['appliesTo'] as String,
  isActive: json['isActive'] as bool,
  sortOrder: (json['sortOrder'] as num).toInt(),
);

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'appliesTo': instance.appliesTo,
  'isActive': instance.isActive,
  'sortOrder': instance.sortOrder,
};

_TransactionItem _$TransactionItemFromJson(Map<String, dynamic> json) =>
    _TransactionItem(
      id: json['id'] as String,
      transactionType: json['transactionType'] as String,
      amount: const DecimalConverter().fromJson(json['amount']),
      currencyCode: json['currencyCode'] as String,
      accountId: json['accountId'] as String,
      accountName: json['accountName'] as String?,
      walletId: json['walletId'] as String,
      walletName: json['walletName'] as String?,
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      staticExpenseTemplateId: json['staticExpenseTemplateId'] as String?,
      description: json['description'] as String?,
      notes: json['notes'] as String?,
      transactionDate: json['transactionDate'] as String,
      transactionTime: json['transactionTime'] as String?,
      status: json['status'] as String,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$TransactionItemToJson(_TransactionItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transactionType': instance.transactionType,
      'amount': const DecimalConverter().toJson(instance.amount),
      'currencyCode': instance.currencyCode,
      'accountId': instance.accountId,
      'accountName': instance.accountName,
      'walletId': instance.walletId,
      'walletName': instance.walletName,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'staticExpenseTemplateId': instance.staticExpenseTemplateId,
      'description': instance.description,
      'notes': instance.notes,
      'transactionDate': instance.transactionDate,
      'transactionTime': instance.transactionTime,
      'status': instance.status,
      'createdAt': instance.createdAt,
    };

_StaticExpenseTemplate _$StaticExpenseTemplateFromJson(
  Map<String, dynamic> json,
) => _StaticExpenseTemplate(
  id: json['id'] as String,
  name: json['name'] as String,
  amount: const DecimalConverter().fromJson(json['amount']),
  accountId: json['accountId'] as String,
  accountName: json['accountName'] as String,
  defaultWalletId: json['defaultWalletId'] as String?,
  categoryId: json['categoryId'] as String?,
  categoryName: json['categoryName'] as String?,
  dueDay: (json['dueDay'] as num).toInt(),
  startDate: json['startDate'] as String,
  endDate: json['endDate'] as String?,
  notes: json['notes'] as String?,
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$StaticExpenseTemplateToJson(
  _StaticExpenseTemplate instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'amount': const DecimalConverter().toJson(instance.amount),
  'accountId': instance.accountId,
  'accountName': instance.accountName,
  'defaultWalletId': instance.defaultWalletId,
  'categoryId': instance.categoryId,
  'categoryName': instance.categoryName,
  'dueDay': instance.dueDay,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'notes': instance.notes,
  'isActive': instance.isActive,
};

_StaticExpenseOccurrence _$StaticExpenseOccurrenceFromJson(
  Map<String, dynamic> json,
) => _StaticExpenseOccurrence(
  id: json['id'] as String,
  templateId: json['templateId'] as String,
  name: json['name'] as String,
  accountId: json['accountId'] as String,
  accountName: json['accountName'] as String?,
  walletId: json['walletId'] as String?,
  walletName: json['walletName'] as String?,
  currencyCode: json['currencyCode'] as String?,
  categoryId: json['categoryId'] as String?,
  dueYear: (json['dueYear'] as num).toInt(),
  dueMonth: (json['dueMonth'] as num).toInt(),
  dueDate: json['dueDate'] as String,
  expectedAmount: const DecimalConverter().fromJson(json['expectedAmount']),
  status: json['status'] as String,
  paidTransactionId: json['paidTransactionId'] as String?,
  paidAt: json['paidAt'] as String?,
  skippedAt: json['skippedAt'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$StaticExpenseOccurrenceToJson(
  _StaticExpenseOccurrence instance,
) => <String, dynamic>{
  'id': instance.id,
  'templateId': instance.templateId,
  'name': instance.name,
  'accountId': instance.accountId,
  'accountName': instance.accountName,
  'walletId': instance.walletId,
  'walletName': instance.walletName,
  'currencyCode': instance.currencyCode,
  'categoryId': instance.categoryId,
  'dueYear': instance.dueYear,
  'dueMonth': instance.dueMonth,
  'dueDate': instance.dueDate,
  'expectedAmount': const DecimalConverter().toJson(instance.expectedAmount),
  'status': instance.status,
  'paidTransactionId': instance.paidTransactionId,
  'paidAt': instance.paidAt,
  'skippedAt': instance.skippedAt,
  'notes': instance.notes,
};

_StaticExpenseCollection _$StaticExpenseCollectionFromJson(
  Map<String, dynamic> json,
) => _StaticExpenseCollection(
  year: (json['year'] as num).toInt(),
  month: (json['month'] as num).toInt(),
  templates: (json['templates'] as List<dynamic>)
      .map((e) => StaticExpenseTemplate.fromJson(e as Map<String, dynamic>))
      .toList(),
  occurrences: (json['occurrences'] as List<dynamic>)
      .map((e) => StaticExpenseOccurrence.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StaticExpenseCollectionToJson(
  _StaticExpenseCollection instance,
) => <String, dynamic>{
  'year': instance.year,
  'month': instance.month,
  'templates': instance.templates,
  'occurrences': instance.occurrences,
};

_DashboardBalance _$DashboardBalanceFromJson(Map<String, dynamic> json) =>
    _DashboardBalance(
      currencyCode: json['currencyCode'] as String,
      accountId: json['accountId'] as String,
      accountName: json['accountName'] as String,
      walletId: json['walletId'] as String,
      walletName: json['walletName'] as String,
      walletTypeCode: json['walletTypeCode'] as String,
      currentBalance: const DecimalConverter().fromJson(json['currentBalance']),
    );

Map<String, dynamic> _$DashboardBalanceToJson(
  _DashboardBalance instance,
) => <String, dynamic>{
  'currencyCode': instance.currencyCode,
  'accountId': instance.accountId,
  'accountName': instance.accountName,
  'walletId': instance.walletId,
  'walletName': instance.walletName,
  'walletTypeCode': instance.walletTypeCode,
  'currentBalance': const DecimalConverter().toJson(instance.currentBalance),
};

_DashboardSummary _$DashboardSummaryFromJson(
  Map<String, dynamic> json,
) => _DashboardSummary(
  currencyCode: json['currencyCode'] as String,
  mainIncome: const DecimalConverter().fromJson(json['mainIncome']),
  additionalIncome: const DecimalConverter().fromJson(json['additionalIncome']),
  totalIncome: const DecimalConverter().fromJson(json['totalIncome']),
  staticSpending: const DecimalConverter().fromJson(json['staticSpending']),
  dynamicSpending: const DecimalConverter().fromJson(json['dynamicSpending']),
  totalSpending: const DecimalConverter().fromJson(json['totalSpending']),
  remainingMoney: const DecimalConverter().fromJson(json['remainingMoney']),
);

Map<String, dynamic> _$DashboardSummaryToJson(
  _DashboardSummary instance,
) => <String, dynamic>{
  'currencyCode': instance.currencyCode,
  'mainIncome': const DecimalConverter().toJson(instance.mainIncome),
  'additionalIncome': const DecimalConverter().toJson(
    instance.additionalIncome,
  ),
  'totalIncome': const DecimalConverter().toJson(instance.totalIncome),
  'staticSpending': const DecimalConverter().toJson(instance.staticSpending),
  'dynamicSpending': const DecimalConverter().toJson(instance.dynamicSpending),
  'totalSpending': const DecimalConverter().toJson(instance.totalSpending),
  'remainingMoney': const DecimalConverter().toJson(instance.remainingMoney),
};

_AllowanceSummary _$AllowanceSummaryFromJson(Map<String, dynamic> json) =>
    _AllowanceSummary(
      currencyCode: json['currencyCode'] as String,
      monthlyAllowance: const DecimalConverter().fromJson(
        json['monthlyAllowance'],
      ),
      allowanceUsed: const DecimalConverter().fromJson(json['allowanceUsed']),
      allowanceRemaining: const DecimalConverter().fromJson(
        json['allowanceRemaining'],
      ),
      dailyAllowance: const DecimalConverter().fromJson(json['dailyAllowance']),
      spentToday: const DecimalConverter().fromJson(json['spentToday']),
      remainingToday: const DecimalConverter().fromJson(json['remainingToday']),
      remainingDays: (json['remainingDays'] as num).toInt(),
      planId: json['planId'] as String?,
    );

Map<String, dynamic> _$AllowanceSummaryToJson(
  _AllowanceSummary instance,
) => <String, dynamic>{
  'currencyCode': instance.currencyCode,
  'monthlyAllowance': const DecimalConverter().toJson(
    instance.monthlyAllowance,
  ),
  'allowanceUsed': const DecimalConverter().toJson(instance.allowanceUsed),
  'allowanceRemaining': const DecimalConverter().toJson(
    instance.allowanceRemaining,
  ),
  'dailyAllowance': const DecimalConverter().toJson(instance.dailyAllowance),
  'spentToday': const DecimalConverter().toJson(instance.spentToday),
  'remainingToday': const DecimalConverter().toJson(instance.remainingToday),
  'remainingDays': instance.remainingDays,
  'planId': instance.planId,
};

_DashboardPeriod _$DashboardPeriodFromJson(Map<String, dynamic> json) =>
    _DashboardPeriod(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      timezone: json['timezone'] as String,
      accountId: json['accountId'] as String,
      currencyCode: json['currencyCode'] as String?,
    );

Map<String, dynamic> _$DashboardPeriodToJson(_DashboardPeriod instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'timezone': instance.timezone,
      'accountId': instance.accountId,
      'currencyCode': instance.currencyCode,
    };

_Dashboard _$DashboardFromJson(Map<String, dynamic> json) => _Dashboard(
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  period: DashboardPeriod.fromJson(json['period'] as Map<String, dynamic>),
  balances: (json['balances'] as List<dynamic>)
      .map((e) => DashboardBalance.fromJson(e as Map<String, dynamic>))
      .toList(),
  summaryByCurrency: (json['summaryByCurrency'] as List<dynamic>)
      .map((e) => DashboardSummary.fromJson(e as Map<String, dynamic>))
      .toList(),
  allowanceByCurrency: (json['allowanceByCurrency'] as List<dynamic>)
      .map((e) => AllowanceSummary.fromJson(e as Map<String, dynamic>))
      .toList(),
  staticExpenses: (json['staticExpenses'] as List<dynamic>)
      .map((e) => StaticExpenseOccurrence.fromJson(e as Map<String, dynamic>))
      .toList(),
  recentTransactions: (json['recentTransactions'] as List<dynamic>)
      .map((e) => TransactionItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DashboardToJson(_Dashboard instance) =>
    <String, dynamic>{
      'user': instance.user,
      'period': instance.period,
      'balances': instance.balances,
      'summaryByCurrency': instance.summaryByCurrency,
      'allowanceByCurrency': instance.allowanceByCurrency,
      'staticExpenses': instance.staticExpenses,
      'recentTransactions': instance.recentTransactions,
    };

_Transfer _$TransferFromJson(Map<String, dynamic> json) => _Transfer(
  id: json['id'] as String,
  fromWalletId: json['fromWalletId'] as String,
  fromWalletName: json['fromWalletName'] as String,
  toWalletId: json['toWalletId'] as String,
  toWalletName: json['toWalletName'] as String,
  amount: const DecimalConverter().fromJson(json['amount']),
  currencyCode: json['currencyCode'] as String,
  notes: json['notes'] as String?,
  transferDate: json['transferDate'] as String,
  status: json['status'] as String,
);

Map<String, dynamic> _$TransferToJson(_Transfer instance) => <String, dynamic>{
  'id': instance.id,
  'fromWalletId': instance.fromWalletId,
  'fromWalletName': instance.fromWalletName,
  'toWalletId': instance.toWalletId,
  'toWalletName': instance.toWalletName,
  'amount': const DecimalConverter().toJson(instance.amount),
  'currencyCode': instance.currencyCode,
  'notes': instance.notes,
  'transferDate': instance.transferDate,
  'status': instance.status,
};

_TransactionRequest _$TransactionRequestFromJson(Map<String, dynamic> json) =>
    _TransactionRequest(
      transactionType: json['transactionType'] as String,
      amount: const DecimalConverter().fromJson(json['amount']),
      walletId: json['walletId'] as String,
      categoryId: json['categoryId'] as String?,
      description: json['description'] as String?,
      notes: json['notes'] as String?,
      transactionDate: json['transactionDate'] as String,
      transactionTime: json['transactionTime'] as String?,
    );

Map<String, dynamic> _$TransactionRequestToJson(_TransactionRequest instance) =>
    <String, dynamic>{
      'transactionType': instance.transactionType,
      'amount': const DecimalConverter().toJson(instance.amount),
      'walletId': instance.walletId,
      'categoryId': instance.categoryId,
      'description': instance.description,
      'notes': instance.notes,
      'transactionDate': instance.transactionDate,
      'transactionTime': instance.transactionTime,
    };

_OccurrencePaymentRequest _$OccurrencePaymentRequestFromJson(
  Map<String, dynamic> json,
) => _OccurrencePaymentRequest(
  walletId: json['walletId'] as String?,
  amount: const DecimalConverter().fromJson(json['amount']),
  paidAt: json['paidAt'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$OccurrencePaymentRequestToJson(
  _OccurrencePaymentRequest instance,
) => <String, dynamic>{
  'walletId': instance.walletId,
  'amount': _$JsonConverterToJson<Object?, Decimal>(
    instance.amount,
    const DecimalConverter().toJson,
  ),
  'paidAt': instance.paidAt,
  'notes': instance.notes,
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
