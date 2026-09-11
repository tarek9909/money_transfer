import 'package:decimal/decimal.dart';

class ItemPreset {
  final String id;
  final String title;
  final Decimal amount;
  final String type; // 'DYNAMIC_SPENDING', 'MAIN_INCOME', 'ADDITIONAL_INCOME'
  final String? categoryName;
  final String? categoryId;
  final String? icon;

  const ItemPreset({
    required this.id,
    required this.title,
    required this.amount,
    this.type = 'DYNAMIC_SPENDING',
    this.categoryName,
    this.categoryId,
    this.icon,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'amount': amount.toString(),
    'type': type,
    if (categoryName != null) 'categoryName': categoryName,
    if (categoryId != null) 'categoryId': categoryId,
    if (icon != null) 'icon': icon,
  };

  factory ItemPreset.fromJson(Map<String, dynamic> json) => ItemPreset(
    id: json['id'] as String,
    title: json['title'] as String,
    amount: Decimal.tryParse(json['amount']?.toString() ?? '0') ?? Decimal.zero,
    type: json['type'] as String? ?? 'DYNAMIC_SPENDING',
    categoryName: json['categoryName'] as String?,
    categoryId: json['categoryId'] as String?,
    icon: json['icon'] as String?,
  );

  ItemPreset copyWith({
    String? id,
    String? title,
    Decimal? amount,
    String? type,
    String? categoryName,
    String? categoryId,
    String? icon,
  }) => ItemPreset(
    id: id ?? this.id,
    title: title ?? this.title,
    amount: amount ?? this.amount,
    type: type ?? this.type,
    categoryName: categoryName ?? this.categoryName,
    categoryId: categoryId ?? this.categoryId,
    icon: icon ?? this.icon,
  );
}

final defaultItemPresets = <ItemPreset>[
  ItemPreset(
    id: 'default_coffee',
    title: 'Coffee',
    amount: Decimal.parse('4.50'),
    type: 'DYNAMIC_SPENDING',
    icon: '☕',
    categoryName: 'Food & Dining',
  ),
  ItemPreset(
    id: 'default_lunch',
    title: 'Lunch',
    amount: Decimal.parse('15.00'),
    type: 'DYNAMIC_SPENDING',
    icon: '🍔',
    categoryName: 'Food & Dining',
  ),
  ItemPreset(
    id: 'default_groceries',
    title: 'Groceries',
    amount: Decimal.parse('50.00'),
    type: 'DYNAMIC_SPENDING',
    icon: '🛒',
    categoryName: 'Groceries',
  ),
  ItemPreset(
    id: 'default_gas',
    title: 'Gas / Fuel',
    amount: Decimal.parse('40.00'),
    type: 'DYNAMIC_SPENDING',
    icon: '⛽',
    categoryName: 'Transportation',
  ),
  ItemPreset(
    id: 'default_transit',
    title: 'Subway / Bus',
    amount: Decimal.parse('3.00'),
    type: 'DYNAMIC_SPENDING',
    icon: '🚇',
    categoryName: 'Transportation',
  ),
  ItemPreset(
    id: 'default_salary',
    title: 'Salary Deposit',
    amount: Decimal.parse('3000.00'),
    type: 'MAIN_INCOME',
    icon: '💰',
    categoryName: 'Salary',
  ),
];
