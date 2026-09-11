import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/models.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../core/widgets/amount_display.dart';
import '../../core/widgets/app_bottom_sheet.dart';
import '../../core/widgets/luxury_card.dart';

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});
  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

String _monthName(int month) => const [
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
][month];

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  String? type;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_loadWhenNearEnd);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_loadWhenNearEnd)
      ..dispose();
    super.dispose();
  }

  void shiftMonth(int amount) {
    final month = ref.read(selectedPeriodProvider);
    ref.read(selectedPeriodProvider.notifier).state = DateTime(
      month.year,
      month.month + amount,
    );
  }

  void _loadWhenNearEnd() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter < 500) {
      final month = ref.read(selectedPeriodProvider);
      ref
          .read(
            pagedTransactionsProvider(
              HistoryQuery(month.year, month.month, type),
            ).notifier,
          )
          .loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final month = ref.watch(selectedPeriodProvider);
    final query = HistoryQuery(month.year, month.month, type);
    final history = ref.watch(pagedTransactionsProvider(query));

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: _header(context, month),
            ),
            _filterChips(),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.midnight,
                onRefresh: () async {
                  ref.invalidate(pagedTransactionsProvider(query));
                  ref.invalidate(accountsProvider);
                  ref.invalidate(walletsProvider);
                },
                child: history.when(
                  data: (historyData) => historyData.items.isEmpty
                      ? _empty(context)
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 150),
                          itemCount:
                              historyData.items.length +
                              (historyData.isLoadingMore ||
                                      historyData.loadMoreError != null
                                  ? 1
                                  : 0),
                          itemBuilder: (context, index) {
                            if (index >= historyData.items.length) {
                              if (historyData.loadMoreError != null) {
                                return Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Center(
                                    child: TextButton.icon(
                                      onPressed: () => ref
                                          .read(
                                            pagedTransactionsProvider(query).notifier,
                                          )
                                          .loadMore(),
                                      icon: const Icon(Icons.refresh_rounded, size: 16),
                                      label: const Text('Could not load more — retry'),
                                    ),
                                  ),
                                );
                              }
                              return const Padding(
                                padding: EdgeInsets.all(18),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.midnight,
                                  ),
                                ),
                              );
                            }
                            return _row(context, historyData.items[index]);
                          },
                        ),
                  error: (error, _) => ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    children: [
                      const SizedBox(height: 60),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline_rounded,
                                size: 36, color: AppColors.crimson),
                            const SizedBox(height: 12),
                            Text(
                              'Could not load history',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
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
                          ],
                        ),
                      ),
                    ],
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.midnight,
                      strokeWidth: 2.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context, DateTime month) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity Ledger',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.midnight,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              '${_monthName(month.month)} ${month.year}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.emerald,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => shiftMonth(-1),
                    icon: const Icon(Icons.chevron_left_rounded, size: 20),
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Previous month',
                  ),
                  IconButton(
                    onPressed: () => shiftMonth(1),
                    icon: const Icon(Icons.chevron_right_rounded, size: 20),
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Next month',
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => context.push('/transfers'),
              icon: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.swap_horiz_rounded,
                  color: AppColors.indigo,
                  size: 20,
                ),
              ),
              tooltip: 'Transfers',
            ),
          ],
        ),
      ],
    );
  }

  Widget _filterChips() {
    final filters = [
      (label: 'All Activity', value: null),
      (label: 'Spending', value: 'DYNAMIC_SPENDING'),
      (label: 'Recurring', value: 'STATIC_SPENDING'),
      (label: 'Main Income', value: 'MAIN_INCOME'),
      (label: 'Extra Income', value: 'ADDITIONAL_INCOME'),
    ];

    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = filters[index];
          final isSelected = type == item.value;
          return ChoiceChip(
            label: Text(item.label),
            selected: isSelected,
            onSelected: (_) => setState(() => type = item.value),
          );
        },
      ),
    );
  }

  Widget _row(BuildContext context, TransactionItem item) {
    final income = item.transactionType.contains('INCOME');
    final color = income ? AppColors.emerald : AppColors.crimson;
    final detail = [
      item.transactionDate,
      item.walletName ?? item.currencyCode,
    ].where((value) => value.isNotEmpty).join(' • ');

    final iconData = income
        ? (item.transactionType == 'MAIN_INCOME'
            ? Icons.account_balance_outlined
            : Icons.south_west_rounded)
        : (item.transactionType == 'STATIC_SPENDING'
            ? Icons.event_repeat_rounded
            : Icons.shopping_bag_outlined);

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.crimson,
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 22),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22),
            SizedBox(width: 6),
            Text(
              'Void',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (_) => _confirmVoid(context, item),
      child: LuxuryCard(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        onTap: () => context.push(
          '/add?type=${item.transactionType}&transactionId=${item.id}',
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(iconData, color: color, size: 20),
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
                  const SizedBox(height: 3),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _empty(BuildContext context) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.fromLTRB(32, 48, 32, 100),
    children: [
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.cardSurfaceAlt,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 32,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'No transactions recorded',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.midnight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Keep track of your cash flows by recording your first transaction.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => context.push('/add?type=DYNAMIC_SPENDING'),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Add transaction'),
            ),
          ],
        ),
      ),
    ],
  );

  Future<bool> _void(TransactionItem item) async {
    try {
      await ref.read(apiClientProvider).voidTransaction(item.id);
      final month = ref.read(selectedPeriodProvider);
      final query = HistoryQuery(month.year, month.month, type);
      ref.invalidate(transactionsProvider(query));
      ref.invalidate(pagedTransactionsProvider(query));
      ref.invalidate(accountsProvider);
      ref.invalidate(walletsProvider);
      ref.invalidate(dashboardProvider);
      return true;
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
      return false;
    }
  }

  Future<bool> _confirmVoid(BuildContext context, TransactionItem item) async {
    final confirmed = await AppConfirmationSheet.show(
      context: context,
      title: 'Void Transaction?',
      message:
          'This will permanently reverse the transaction and restore the original wallet balance.',
      confirmLabel: 'Void',
      confirmColor: AppColors.crimson,
      icon: Icons.delete_outline_rounded,
    );
    return confirmed ? _void(item) : false;
  }
}
