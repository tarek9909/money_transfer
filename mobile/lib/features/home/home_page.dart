import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/money.dart';
import '../../core/models.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../core/widgets/amount_display.dart';
import '../../core/widgets/luxury_card.dart';
import '../../core/widgets/status_badge.dart';
import '../transactions/widgets/presets_sheet.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String? selectedCurrency;
  bool isBalanceHidden = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_restoreSelections);
  }

  Future<void> _restoreSelections() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    if (!mounted) return;
    final storedMonth = prefs.getString('selected_month')?.split('-');
    if (storedMonth != null && storedMonth.length == 2) {
      final year = int.tryParse(storedMonth[0]);
      final month = int.tryParse(storedMonth[1]);
      if (year != null && month != null) {
        ref.read(selectedPeriodProvider.notifier).state = DateTime(year, month);
      }
    }
    final storedAccount = prefs.getString('selected_account');
    try {
      final preference = await ref.read(preferencesProvider.future);
      if (!mounted) return;
      ref.read(selectedAccountProvider.notifier).state =
          storedAccount ?? preference['defaultAccountId']?.toString();
    } catch (_) {}
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
    final fullName = user?['name']?.toString() ?? '';
    final firstName = fullName.trim().isNotEmpty
        ? fullName.trim().split(' ').first
        : 'there';
    final initials = fullName.trim().isNotEmpty
        ? fullName
            .trim()
            .split(' ')
            .where((e) => e.isNotEmpty)
            .take(2)
            .map((e) => e[0].toUpperCase())
            .join()
        : 'U';

    final query = DashboardQuery(month.year, month.month, accountId);
    final dashboard = ref.watch(dashboardProvider(query));

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.midnight,
          onRefresh: () async {
            ref.invalidate(dashboardProvider(query));
            await ref.read(dashboardProvider(query).future);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 150),
            children: [
              _topHeader(context, firstName, initials, query),
              const SizedBox(height: 14),
              _monthAndAccountSelector(context, month, accountId, accounts),
              const SizedBox(height: 16),
              dashboard.when(
                skipLoadingOnReload: true,
                skipLoadingOnRefresh: true,
                data: (data) => _content(context, data),
                error: (error, _) => _error(context, error, query),
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 80),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.midnight,
                      strokeWidth: 2.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topHeader(
    BuildContext context,
    String firstName,
    String initials,
    DashboardQuery query,
  ) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: AppGradients.luxuryDark,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.midnight.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.mint,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good ${_greeting()}, $firstName',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.midnight,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Personal Money Tracker',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => ref.invalidate(dashboardProvider(query)),
          icon: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.refresh_rounded,
              color: AppColors.midnight,
              size: 20,
            ),
          ),
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _monthAndAccountSelector(
    BuildContext context,
    DateTime month,
    String? accountId,
    AsyncValue<List<dynamic>> accounts,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => shift(-1),
                icon: const Icon(Icons.chevron_left_rounded, size: 22),
                visualDensity: VisualDensity.compact,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 14,
                    color: AppColors.emerald,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${monthName(month.month)} ${month.year}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.midnight,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => shift(1),
                icon: const Icon(Icons.chevron_right_rounded, size: 22),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const Divider(height: 12),
          accounts.when(
            skipLoadingOnReload: true,
            skipLoadingOnRefresh: true,
            data: (items) => DropdownButtonHideUnderline(
              child: DropdownButton<String?>(
                value: accountId,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.midnight,
                ),
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.layers_outlined,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'All accounts (${items.length})',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...items.map(
                    (item) => DropdownMenuItem<String?>(
                      value: (item as Map)['id'] as String,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.account_balance_outlined,
                            size: 16,
                            color: AppColors.emerald,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item['name'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                onChanged: (value) {
                  ref.read(selectedAccountProvider.notifier).state = value;
                  ref.read(sharedPreferencesProvider.future).then(
                    (prefs) => value == null
                        ? prefs.remove('selected_account')
                        : prefs.setString('selected_account', value),
                  );
                },
              ),
            ),
            error: (error, _) => Text(
              'Accounts unavailable: $error',
              style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.crimson),
            ),
            loading: () => const LinearProgressIndicator(minHeight: 2),
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
        _heroBalanceCard(context, data.balances),
        if (currencies.length > 1) ...[
          Container(
            height: 38,
            margin: const EdgeInsets.only(bottom: 14),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: currencies.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final curr = currencies[index];
                final isSelected = curr == activeCurrency;
                return ChoiceChip(
                  label: Text(curr),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => selectedCurrency = curr);
                  },
                );
              },
            ),
          ),
        ],
        if (summary != null) _financialSummary(context, summary, allowance),
        _quickActionsSection(context),
        _quickPresetsHomeSection(context),
        if (data.recentTransactions.isNotEmpty)
          _recentActivity(context, data.recentTransactions),
      ],
    );
  }

  Widget _heroBalanceCard(BuildContext context, List<DashboardBalance> balances) {
    final grouped = <String, Decimal>{};
    for (final item in balances) {
      final currency = item.currencyCode;
      grouped[currency] =
          (grouped[currency] ?? Decimal.zero) + item.currentBalance;
    }

    return TitaniumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.mint,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'TOTAL LIQUIDITY',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => setState(() => isBalanceHidden = !isBalanceHidden),
                icon: Icon(
                  isBalanceHidden
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: Colors.white.withValues(alpha: 0.75),
                  size: 20,
                ),
                tooltip: isBalanceHidden ? 'Show balance' : 'Hide balance',
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (grouped.isEmpty)
            Text(
              'No active wallets',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            )
          else
            ...grouped.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: AmountDisplay(
                  amount: entry.value,
                  currency: entry.key,
                  isMasked: isBalanceHidden,
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
          const SizedBox(height: 14),
          if (balances.isNotEmpty) ...[
            Container(
              height: 1,
              color: Colors.white.withValues(alpha: 0.12),
            ),
            const SizedBox(height: 12),
            ...balances.take(4).map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 14,
                          color: AppColors.mint,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          item.walletName,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      isBalanceHidden
                          ? '••••••'
                          : moneyValue(item.currentBalance, currency: item.currencyCode),
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (balances.length > 4)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  '+${balances.length - 4} more wallets',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _financialSummary(
    BuildContext context,
    DashboardSummary item,
    AllowanceSummary? allowance,
  ) {
    final currency = item.currencyCode;
    final income = item.totalIncome;
    final totalSpent = item.staticSpending + item.dynamicSpending;

    double spendingRatio = 0.0;
    if (income > Decimal.zero) {
      final ratioDec = (totalSpent / income).toDecimal(scaleOnInfinitePrecision: 4);
      spendingRatio = (ratioDec.toDouble()).clamp(0.0, 1.0);
    }

    return LuxuryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.midnight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      currency,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.mint,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Monthly Performance',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.midnight,
                    ),
                  ),
                ],
              ),
              StatusBadge(
                label: item.remainingMoney >= Decimal.zero ? 'Surplus' : 'Deficit',
                variant: item.remainingMoney >= Decimal.zero
                    ? BadgeVariant.income
                    : BadgeVariant.expense,
                compact: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Remaining Money Highlight
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Net Remaining',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    AmountDisplay(
                      amount: item.remainingMoney,
                      currency: currency,
                      fontSize: 22,
                      isMasked: isBalanceHidden,
                      color: item.remainingMoney >= Decimal.zero
                          ? AppColors.emerald
                          : AppColors.crimson,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (item.remainingMoney >= Decimal.zero
                            ? AppColors.emerald
                            : AppColors.crimson)
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.remainingMoney >= Decimal.zero
                        ? Icons.trending_up_rounded
                        : Icons.trending_down_rounded,
                    color: item.remainingMoney >= Decimal.zero
                        ? AppColors.emerald
                        : AppColors.crimson,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Cash flow breakdown metrics
          _metricRow(
            icon: Icons.south_west_rounded,
            title: 'Total Inflow',
            amount: moneyValue(item.totalIncome, currency: currency),
            color: AppColors.emerald,
            bgColor: AppColors.mintSoft,
          ),
          const SizedBox(height: 8),
          _metricRow(
            icon: Icons.event_repeat_rounded,
            title: 'Static Recurring',
            amount: moneyValue(item.staticSpending, currency: currency),
            color: AppColors.amber,
            bgColor: AppColors.amberSoft,
          ),
          const SizedBox(height: 8),
          _metricRow(
            icon: Icons.shopping_bag_outlined,
            title: 'Dynamic Spending',
            amount: moneyValue(item.dynamicSpending, currency: currency),
            color: AppColors.crimson,
            bgColor: AppColors.crimsonSoft,
          ),
          const SizedBox(height: 14),
          // Progress bar of spending vs income
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Budget Used',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${(spendingRatio * 100).toStringAsFixed(0)}%',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: spendingRatio > 0.85
                          ? AppColors.crimson
                          : AppColors.midnight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: spendingRatio,
                  minHeight: 6,
                  backgroundColor: AppColors.cardSurfaceAlt,
                  color: spendingRatio > 0.85
                      ? AppColors.crimson
                      : AppColors.emerald,
                ),
              ),
            ],
          ),
          if (allowance != null) ...[
            const Divider(height: 24),
            _allowanceSection(context, allowance, currency),
          ],
        ],
      ),
    );
  }

  Widget _metricRow({
    required IconData icon,
    required String title,
    required String amount,
    required Color color,
    required Color bgColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: Text(
            isBalanceHidden ? '••••••' : amount,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _allowanceSection(
    BuildContext context,
    AllowanceSummary item,
    String currency,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(
                    Icons.speed_rounded,
                    size: 17,
                    color: AppColors.indigo,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Spending Allowance',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.midnight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            TextButton.icon(
              onPressed: () => _editAllowance(context, currency, item),
              icon: const Icon(Icons.edit_outlined, size: 14),
              label: const Text('Edit Cap'),
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _allowanceMetricCard(
                title: 'Remaining',
                amount: moneyValue(item.allowanceRemaining, currency: currency),
                isPositive: item.allowanceRemaining >= Decimal.zero,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _allowanceMetricCard(
                title: 'Daily Pace',
                amount: moneyValue(item.dailyAllowance, currency: currency),
                isPositive: true,
                badge: 'Planned',
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _allowanceMetricCard(
                title: 'Left Today',
                amount: moneyValue(item.remainingToday, currency: currency),
                isPositive: item.remainingToday >= Decimal.zero,
                badge: item.remainingToday >= Decimal.zero ? 'Safe' : 'Over',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _allowanceMetricCard({
    required String title,
    required String amount,
    required bool isPositive,
    String? badge,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              if (badge != null) ...[
                const SizedBox(width: 3),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                  decoration: BoxDecoration(
                    color: (isPositive ? AppColors.emerald : AppColors.crimson)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    badge,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      color:
                          isPositive ? AppColors.emerald : AppColors.crimson,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              isBalanceHidden ? '••••' : amount,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: isPositive ? AppColors.midnight : AppColors.crimson,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActionsSection(BuildContext context) {
    return LuxuryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Moves',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.midnight,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _actionIconButton(
                context,
                icon: Icons.shopping_bag_outlined,
                label: 'Expense',
                color: AppColors.crimson,
                bgColor: AppColors.crimsonSoft,
                onTap: () => context.push('/add?type=DYNAMIC_SPENDING'),
              ),
              _actionIconButton(
                context,
                icon: Icons.trending_up_rounded,
                label: 'Income',
                color: AppColors.emerald,
                bgColor: AppColors.mintSoft,
                onTap: () => context.push('/add?type=MAIN_INCOME'),
              ),
              _actionIconButton(
                context,
                icon: Icons.swap_horiz_rounded,
                label: 'Transfer',
                color: AppColors.indigo,
                bgColor: AppColors.indigoSoft,
                onTap: () => context.push('/transfer'),
              ),
              _actionIconButton(
                context,
                icon: Icons.event_repeat_rounded,
                label: 'Bills',
                color: AppColors.amber,
                bgColor: AppColors.amberSoft,
                onTap: () => context.push('/static-expenses'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickPresetsHomeSection(BuildContext context) {
    final presets = ref.watch(presetsProvider);
    if (presets.isEmpty) return const SizedBox.shrink();

    return LuxuryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.amberSoft,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('⚡', style: TextStyle(fontSize: 12)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Instant Presets',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.midnight,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => PresetsSheet.show(context),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.tune_rounded, size: 14, color: AppColors.emerald),
                      const SizedBox(width: 4),
                      Text(
                        'Manage',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.emerald,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: presets.map((preset) {
                final isIncome = preset.type.contains('INCOME');
                final color = isIncome ? AppColors.emerald : AppColors.crimson;
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () {
                      final encodedDesc = Uri.encodeComponent(preset.title);
                      final encodedAmt = preset.amount.toStringAsFixed(2);
                      context.push(
                        '/add?type=${preset.type}&amount=$encodedAmt&description=$encodedDesc',
                      );
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: color.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Text(
                            preset.icon ?? (isIncome ? '💰' : '🏷️'),
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                preset.title,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.midnight,
                                ),
                              ),
                              Text(
                                '\$${preset.amount.toStringAsFixed(2)}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionIconButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withValues(alpha: 0.15), width: 1),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.midnight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recentActivity(BuildContext context, List<TransactionItem> items) {
    return LuxuryCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.midnight,
                ),
              ),
              TextButton(
                onPressed: () => context.go('/transactions'),
                child: const Text('See all'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...items.take(5).map((item) {
            final income = item.transactionType.contains('INCOME');
            final color = income ? AppColors.emerald : AppColors.crimson;
            final detail = [
              item.transactionDate,
              item.walletName ?? item.currencyCode,
            ].where((value) => value.isNotEmpty).join(' • ');

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: InkWell(
                onTap: () => context.push(
                  '/add?type=${item.transactionType}&transactionId=${item.id}',
                ),
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        income
                            ? Icons.south_west_rounded
                            : Icons.north_east_rounded,
                        color: color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.description?.isNotEmpty == true
                                ? item.description!
                                : item.transactionType.replaceAll('_', ' '),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.midnight,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            detail,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AmountDisplay(
                      amount: income ? item.amount : '-${item.amount}',
                      currency: item.currencyCode,
                      fontSize: 14,
                      isSigned: true,
                      isIncome: income,
                      isMasked: isBalanceHidden,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _error(BuildContext context, Object error, DashboardQuery query) =>
      LuxuryCard(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.crimsonSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_off_rounded,
                  color: AppColors.crimson,
                  size: 26,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Could not load your dashboard',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.midnight,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => ref.invalidate(dashboardProvider(query)),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
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
        title: Text('$currency Monthly Cap'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set the target dynamic spending limit for this month.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Monthly allowance ($currency)',
                prefixIcon: const Icon(Icons.speed_rounded),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Save Cap'),
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
