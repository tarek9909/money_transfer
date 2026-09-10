import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/money.dart';
import '../../core/models.dart';
import '../../core/providers.dart';

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
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Activity'),
            Text(
              '${_monthName(month.month)} ${month.year}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => shiftMonth(-1),
            icon: const Icon(Icons.chevron_left_rounded),
            tooltip: 'Previous month',
          ),
          IconButton(
            onPressed: () => shiftMonth(1),
            icon: const Icon(Icons.chevron_right_rounded),
            tooltip: 'Next month',
          ),
          IconButton(
            onPressed: () => context.push('/transfers'),
            icon: const Icon(Icons.swap_horiz_rounded),
            tooltip: 'Transfer history',
          ),
          PopupMenuButton<String?>(
            onSelected: (value) => setState(() => type = value),
            icon: const Icon(Icons.filter_list_rounded),
            itemBuilder: (_) => const [
              PopupMenuItem(value: null, child: Text('All activity')),
              PopupMenuItem(
                value: 'DYNAMIC_SPENDING',
                child: Text('Dynamic spending'),
              ),
              PopupMenuItem(
                value: 'STATIC_SPENDING',
                child: Text('Recurring spending'),
              ),
              PopupMenuItem(value: 'MAIN_INCOME', child: Text('Main income')),
              PopupMenuItem(
                value: 'ADDITIONAL_INCOME',
                child: Text('Additional income'),
              ),
            ],
          ),
        ],
      ),
      body: history.when(
        data: (history) => history.items.isEmpty
            ? _empty(context)
            : RefreshIndicator(
                onRefresh: () async =>
                    ref.invalidate(pagedTransactionsProvider(query)),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 112),
                  itemCount:
                      history.items.length +
                      (history.isLoadingMore || history.loadMoreError != null
                          ? 1
                          : 0),
                  itemBuilder: (context, index) {
                    if (index >= history.items.length) {
                      if (history.loadMoreError != null) {
                        return TextButton(
                          onPressed: () => ref
                              .read(pagedTransactionsProvider(query).notifier)
                              .loadMore(),
                          child: const Text('Could not load more — retry'),
                        );
                      }
                      return const Padding(
                        padding: EdgeInsets.all(18),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: _row(context, history.items[index]),
                    );
                  },
                ),
              ),
        error: (error, _) =>
            Center(child: Text('Could not load history: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _row(BuildContext context, TransactionItem item) {
    final income = item.transactionType.contains('INCOME');
    final color = income ? Colors.green : Colors.red;
    final detail = [
      item.transactionDate,
      item.walletName ?? item.currencyCode,
    ].where((value) => value.isNotEmpty).join(' • ');
    return Dismissible(
      key: ValueKey(item.id),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      confirmDismiss: (_) => _confirmVoid(context, item),
      child: Card(
        child: ListTile(
          onTap: () => context.push(
            '/add?type=${item.transactionType}&transactionId=${item.id}',
          ),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .11),
              shape: BoxShape.circle,
            ),
            child: Icon(
              income ? Icons.south_west_rounded : Icons.north_east_rounded,
              color: color,
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
        ),
      ),
    );
  }

  Widget _empty(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_graph_rounded, size: 32),
          ),
          const SizedBox(height: 18),
          Text('A clean slate', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          const Text(
            'No activity recorded for this month yet.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () => context.push('/add?type=DYNAMIC_SPENDING'),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add activity'),
          ),
        ],
      ),
    ),
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Void transaction?'),
        content: const Text(
          'This will reverse the transaction and update the wallet balance.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Void'),
          ),
        ],
      ),
    );
    return confirmed == true ? _void(item) : false;
  }
}
