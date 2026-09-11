import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:decimal/decimal.dart';
import 'package:personal_money_tracker/core/api_client.dart';
import 'package:personal_money_tracker/core/item_preset.dart';
import 'package:personal_money_tracker/core/money.dart';
import 'package:personal_money_tracker/core/models.dart';
import 'package:personal_money_tracker/core/providers.dart';
import 'package:personal_money_tracker/features/accounts/accounts_page.dart';
import 'package:personal_money_tracker/features/auth/login_page.dart';
import 'package:personal_money_tracker/features/auth/register_page.dart';
import 'package:personal_money_tracker/core/widgets/floating_nav_dock.dart';
import 'package:personal_money_tracker/features/transactions/widgets/preset_grid_card.dart';

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

  test('ItemPreset correctly serializes and deserializes', () {
    final preset = ItemPreset(
      id: 'test_coffee',
      title: 'Latte',
      amount: Decimal.parse('4.75'),
      type: 'DYNAMIC_SPENDING',
      icon: '☕',
      categoryName: 'Food & Dining',
    );

    final json = preset.toJson();
    expect(json['title'], 'Latte');
    expect(json['amount'], '4.75');
    expect(json['type'], 'DYNAMIC_SPENDING');
    expect(json['icon'], '☕');

    final restored = ItemPreset.fromJson(json);
    expect(restored.id, 'test_coffee');
    expect(restored.title, 'Latte');
    expect(restored.amount, Decimal.parse('4.75'));
    expect(restored.type, 'DYNAMIC_SPENDING');
    expect(restored.icon, '☕');
    expect(restored.categoryName, 'Food & Dining');
  });

  test('defaultItemPresets contains common items with valid decimal prices', () {
    expect(defaultItemPresets.isNotEmpty, isTrue);
    for (final preset in defaultItemPresets) {
      expect(preset.id, isNotEmpty);
      expect(preset.title, isNotEmpty);
      expect(preset.amount > Decimal.zero, isTrue);
    }
  });

  testWidgets('AccountsPage dialog flow - open, enter text, and cancel', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          accountsProvider.overrideWith((ref) => Future.value([])),
        ],
        child: const MaterialApp(
          home: AccountsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap Add Account in empty state
    final addBtn = find.text('Add Account');
    expect(addBtn, findsOneWidget);
    await tester.tap(addBtn);
    await tester.pumpAndSettle();

    // Verify dialog opened
    expect(find.text('New Account'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);

    // Enter account name
    await tester.enterText(find.byType(TextField), 'Revolut Personal');
    await tester.pumpAndSettle();
    expect(find.text('Revolut Personal'), findsOneWidget);

    // Cancel dialog
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('New Account'), findsNothing);

    // Open via top AppBar button
    final topAddBtn = find.byTooltip('Add Account');
    expect(topAddBtn, findsOneWidget);
    await tester.tap(topAddBtn);
    await tester.pumpAndSettle();

    expect(find.text('New Account'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
  });

  testWidgets('AccountsPage with accounts and wallets renders properly', (tester) async {
    final mockAccounts = [
      {
        'id': 'acc-1',
        'name': 'Main Bank',
        'wallets': [
          {
            'id': 'w-1',
            'name': 'Checking Account',
            'walletTypeCode': 'CHECKING',
            'currencyCode': 'USD',
            'currentBalance': '2500.50',
          },
          {
            'id': 'w-2',
            'name': 'Emergency Cash',
            'walletTypeCode': 'CASH',
            'currencyCode': 'USD',
            'currentBalance': '400.00',
          },
        ],
      },
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          accountsProvider.overrideWith((ref) => Future.value(mockAccounts)),
        ],
        child: const MaterialApp(
          home: AccountsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify net worth banner and account name
    expect(find.text('AGGREGATED NET WORTH'), findsOneWidget);
    expect(find.text('Main Bank'), findsOneWidget);
    expect(find.text('2 wallets'), findsNWidgets(2));
    expect(find.text('Checking Account'), findsOneWidget);
    expect(find.text('Emergency Cash'), findsOneWidget);
  });

  testWidgets('LoginPage renders without error or overflow', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(FakeAuthController.new),
        ],
        child: const MaterialApp(
          home: LoginPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('ONYX'), findsOneWidget);
    expect(find.text('AES-256 Encrypted Local Tokens'), findsOneWidget);
  });

  testWidgets('RegisterPage renders without error or overflow', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(FakeAuthController.new),
        ],
        child: const MaterialApp(
          home: RegisterPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Create Account'), findsOneWidget);
  });

  testWidgets('FloatingNavDock renders all nav items without missing Material or overflow', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              const SizedBox.expand(),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: FloatingNavDock(
                  selectedIndex: 0,
                  onDestinationSelected: (_) {},
                  onAddPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('Accounts'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('FloatingNavDock renders cleanly on narrow screen (320px width)', (tester) async {
    tester.view.physicalSize = const Size(640, 1136);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              const SizedBox.expand(),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: FloatingNavDock(
                  selectedIndex: 1,
                  onDestinationSelected: (_) {},
                  onAddPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('Accounts'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('PresetGridCard renders in compact and detailed grid modes with tap and delete handlers', (tester) async {
    final preset = ItemPreset(
      id: 'test_coffee',
      title: 'Morning Coffee',
      amount: Decimal.parse('4.75'),
      type: 'DYNAMIC_SPENDING',
      icon: '☕',
      categoryName: 'Food & Dining',
    );

    bool tapped = false;
    bool deleted = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              PresetGridCard(
                preset: preset,
                layout: PresetCardLayout.compact,
                onTap: () => tapped = true,
              ),
              PresetGridCard(
                preset: preset,
                layout: PresetCardLayout.detailed,
                onTap: () => tapped = true,
                onDelete: () => deleted = true,
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Morning Coffee'), findsNWidgets(2));
    expect(find.text('\$4.75'), findsNWidgets(2));
    expect(find.text('Food & Dining'), findsOneWidget);

    // Tap compact card
    await tester.tap(find.text('Morning Coffee').first);
    expect(tapped, isTrue);

    // Tap delete icon in detailed card
    final deleteIcon = find.byIcon(Icons.delete_outline_rounded);
    expect(deleteIcon, findsOneWidget);
    await tester.tap(deleteIcon);
    expect(deleted, isTrue);
  });
}

class FakeAuthController extends AuthController {
  @override
  Future<Map<String, dynamic>?> build() async => null;
}
