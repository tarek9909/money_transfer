import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/money.dart';
import '../../core/models.dart';
import '../../core/providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String? selectedCurrency;

  @override
  void initState() {
    super.initState();
    Future.microtask(_restoreSelections);
  }

  Future<void> _restoreSelections() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    if (!mounted) return;
    final storedMonth = prefs.getString('selected_month')?.split('-');
    if (storedMonth?.length == 2) {
      final year = int.tryParse(storedMonth![0]);
      final month = int.tryParse(storedMonth[1]);
      if (year != null && month != null) {
        ref.read(selectedPeriodProvider.notifier).state = DateTime(year, month);
      }
    }
    final storedAccount = prefs.getString('selected_account');
    final preference = await ref.read(preferencesProvider.future);
    if (!mounted) return;
    ref.read(selectedAccountProvider.notifier).state =
        storedAccount ?? preference['defaultAccountId']?.toString();
  }

  void shift(int amount) {
    final current = ref.read(selectedPeriodProvider);
    final month = DateTime(current.year, current.month + amount);
    ref.read(selectedPeriodProvider.notifier).state = month;
    ref
        .read(sharedPreferencesProvider.future)
        .then(
          (prefs) =>
              prefs.setString('selected_month', '${month.year}-${month.month}'),
        );
  }

  @override
  Widget build(BuildContext context) {
    final month = ref.watch(selectedPeriodProvider);
    final accountId = ref.watch(selectedAccountProvider);
    final accounts = ref.watch(accountsProvider);
    final user = ref.watch(authProvider).valueOrNull;
    final name = user?['name']?.toString().split(' ').first ?? 'there';
    final query = DashboardQuery(month.year, month.month, accountId);
    final dashboard = ref.watch(dashboardProvider(query));
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good ${_greeting()}, $name'),
            Text(
              'Your financial snapshot',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(dashboardProvider(query)),
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dashboardProvider(query));
          await ref.read(dashboardProvider(query).future);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 112),
          children: [
            _monthSelector(context),
            const SizedBox(height: 12),
            accounts.when(
              data: (items) => DropdownButtonFormField<String?>(
                initialValue: accountId,
                decoration: const InputDecoration(
                  labelText: 'Account view',
                  prefixIcon: Icon(Icons.layers_outlined),
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('All accounts'),
                  ),
                  ...items.map(
                    (item) => DropdownMenuItem<String?>(
                      value: (item as Map)['id'] as String,
                      child: Text(item['name'] as String),
                    ),
                  ),
                ],
                onChanged: (value) {
                  ref.read(selectedAccountProvider.notifier).state = value;
                  ref
                      .read(sharedPreferencesProvider.future)
                      .then(
                        (prefs) => value == null
                            ? prefs.remove('selected_account')
                            : prefs.setString('selected_account', value),
                      );
                },
              ),
              error: (error, _) => Text('Accounts unavailable: $error'),
              loading: () => const LinearProgressIndicator(),
            ),
            const SizedBox(height: 16),
            dashboard.when(
              data: (data) => _content(context, data),
              error: (error, _) => _error(context, error, query),
              loading: () => const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _monthSelector(BuildContext context) {
    final month = ref.watch(selectedPeriodProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => shift(-1),
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          Column(
            children: [
              Text(
                'VIEWING',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.2,
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${monthName(month.month)} ${month.year}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          IconButton(
            onPressed: () => shift(1),
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context, Dashboard data) {
    final summaries = data.summaryByCurrency;
    final currencies = summaries.map((item) => item.currencyCode).toList();
    final activeCurrency = currencies.contains(selectedCurrency)
        ? selectedCurrency!
        : currencies.firstOrNull;
    final summary = activeCurrency == null
        ? null
        : summaries.firstWhere((item) => item.currencyCode == activeCurrency);
    final allowance = summary == null
        ? null
        : data.allowanceByCurrency
              .where((item) => item.currencyCode == summary.currencyCode)
              .firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _balanceCard(context, data.balances),
        if (currencies.length > 1)
          DefaultTabController(
            length: currencies.length,
            initialIndex: currencies
                .indexOf(activeCurrency ?? currencies.first)
                .clamp(0, currencies.length - 1)
                .toInt(),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                isScrollable: true,
                tabs: currencies
                    .map((currency) => Tab(text: currency))
                    .toList(),
                onTap: (index) =>
                    setState(() => selectedCurrency = currencies[index]),
              ),
            ),
          ),
        if (summary != null) _summary(context, summary, allowance),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Make a move',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Keep your ledger current in a tap.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 13),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.shopping_bag_outlined, size: 18),
                      label: const Text('Spending'),
                      onPressed: () =>
                          context.push('/add?type=DYNAMIC_SPENDING'),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.trending_up_rounded, size: 18),
                      label: const Text('Income'),
                      onPressed: () => context.push('/add?type=MAIN_INCOME'),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.autorenew_rounded, size: 18),
                      label: const Text('Recurring'),
                      onPressed: () => context.push('/static-expenses'),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.swap_horiz_rounded, size: 18),
                      label: const Text('Transfer'),
                      onPressed: () => context.push('/transfer'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (data.recentTransactions.isNotEmpty)
          _recent(context, data.recentTransactions),
      ],
    );
  }

  Widget _balanceCard(BuildContext context, List<DashboardBalance> balances) {
    final grouped = <String, Decimal>{};
    for (final item in balances) {
      final currency = item.currencyCode;
      grouped[currency] =
          (grouped[currency] ?? Decimal.zero) + item.currentBalance;
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff0b1724), Color(0xff173d3a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x260b1724),
            blurRadius: 20,
            offset: Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL AVAILABLE',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .67),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              Icon(
                Icons.visibility_outlined,
                color: Colors.white.withValues(alpha: .7),
                size: 19,
              ),
            ],
          ),
          const SizedBox(height: 9),
          if (grouped.isEmpty)
            const Text(
              'No active wallets',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            )
          else
            ...grouped.entries.map(
              (entry) => Text(
                moneyValue(entry.value, currency: entry.key),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 29,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.6,
                ),
              ),
            ),
          if (balances.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(color: Colors.white24),
            ...balances.map(
              (item) => Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item.walletName} (${item.walletTypeCode})',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .82),
                      ),
                    ),
                    Text(
                      moneyValue(
                        item.currentBalance,
                        currency: item.currencyCode,
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xffa9efd0),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Across your active wallets',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .7),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summary(
    BuildContext context,
    DashboardSummary item,
    AllowanceSummary? allowance,
  ) {
    final currency = item.currencyCode;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    currency,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Monthly picture',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 10),
            _metric(
              'Total income',
              moneyValue(item.totalIncome, currency: currency),
              Colors.green,
            ),
            _metric(
              'Static spending',
              moneyValue(item.staticSpending, currency: currency),
              Colors.orange,
            ),
            _metric(
              'Dynamic spending',
              moneyValue(item.dynamicSpending, currency: currency),
              Colors.red,
            ),
            const Divider(),
            _metric(
              'Remaining money',
              moneyValue(item.remainingMoney, currency: currency),
              Theme.of(context).colorScheme.primary,
              big: true,
            ),
            if (allowance != null) _allowance(context, allowance, currency),
          ],
        ),
      ),
    );
  }

  Widget _allowance(
    BuildContext context,
    AllowanceSummary item,
    String currency,
  ) => Column(
    children: [
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Monthly allowance',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          TextButton.icon(
            onPressed: () => _editAllowance(context, currency, item),
            icon: const Icon(Icons.edit_outlined, size: 17),
            label: const Text('Edit'),
          ),
        ],
      ),
      _metric(
        'Used',
        moneyValue(item.allowanceUsed, currency: currency),
        Colors.orange,
      ),
      _metric(
        'Remaining',
        moneyValue(item.allowanceRemaining, currency: currency),
        item.allowanceRemaining < Decimal.zero ? Colors.red : Colors.green,
      ),
      _metric(
        'Daily pace',
        moneyValue(item.dailyAllowance, currency: currency),
        Theme.of(context).colorScheme.primary,
      ),
      _metric(
        'Spent today',
        moneyValue(item.spentToday, currency: currency),
        Colors.red,
      ),
      _metric(
        'Today left',
        moneyValue(item.remainingToday, currency: currency),
        Theme.of(context).colorScheme.primary,
      ),
    ],
  );

  Future<void> _editAllowance(
    BuildContext context,
    String currency,
    AllowanceSummary current,
  ) async {
    final controller = TextEditingController(
      text: current.monthlyAllowance.toStringAsFixed(2),
    );
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('$currency monthly allowance'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Amount'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result == true) {
      try {
        await ref.read(apiClientProvider).updatePlan({
          'planYear': ref.read(selectedPeriodProvider).year,
          'planMonth': ref.read(selectedPeriodProvider).month,
          'currencyCode': currency,
          'monthlyAllowance': controller.text.trim(),
        });
        ref.invalidate(dashboardProvider);
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        }
      }
    }
    controller.dispose();
  }

  Widget _metric(String title, String value, Color color, {bool big = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: big ? 20 : 15,
              ),
            ),
          ],
        ),
      );

  Widget _recent(BuildContext context, List<TransactionItem> items) => Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent activity',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () => context.go('/transactions'),
                child: const Text('See all'),
              ),
            ],
          ),
        ),
        ...items.take(5).map((item) {
          final income = item.transactionType.contains('INCOME');
          final color = income ? Colors.green : Colors.red;
          final detail = [
            item.transactionDate,
            item.walletName ?? item.currencyCode,
          ].where((value) => value.isNotEmpty).join(' • ');
          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .11),
                shape: BoxShape.circle,
              ),
              child: Icon(
                income ? Icons.south_west_rounded : Icons.north_east_rounded,
                color: color,
                size: 20,
              ),
            ),
            title: Text(
              item.description?.isNotEmpty == true
                  ? item.description!
                  : item.transactionType,
            ),
            subtitle: Text(detail),
            trailing: Text(
              signedMoney(
                income ? item.amount : '-${item.amount}',
                currency: item.currencyCode,
              ),
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          );
        }),
      ],
    ),
  );

  Widget _error(BuildContext context, Object error, DashboardQuery query) =>
      Card(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              Icon(
                Icons.cloud_off_rounded,
                size: 40,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 8),
              Text(
                'Could not load your dashboard',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(error.toString(), textAlign: TextAlign.center),
              TextButton(
                onPressed: () => ref.invalidate(dashboardProvider(query)),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
}

String _greeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'morning';
  if (hour < 18) return 'afternoon';
  return 'evening';
}

String monthName(int value) => const [
  '',
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
][value];
