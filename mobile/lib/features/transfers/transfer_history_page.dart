import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/money.dart';
import '../../core/providers.dart';

class TransferHistoryPage extends ConsumerWidget {
  const TransferHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(selectedPeriodProvider);
    final query = MonthQuery(period.year, period.month);
    final state = ref.watch(transfersProvider(query));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer history'),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(transfersProvider(query)),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: state.when(
        data: (items) => items.isEmpty
            ? const Center(child: Text('No transfers for this period.'))
            : RefreshIndicator(
                onRefresh: () async => ref.invalidate(transfersProvider(query)),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 112),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.swap_horiz_rounded),
                        title: Text(
                          '${item.fromWalletName} → ${item.toWalletName}',
                        ),
                        subtitle: Text(
                          '${item.transferDate}${item.notes == null ? '' : ' · ${item.notes}'}',
                        ),
                        contentPadding: const EdgeInsets.only(
                          left: 16,
                          right: 4,
                        ),
                        horizontalTitleGap: 12,
                        isThreeLine: false,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              moneyValue(
                                item.amount,
                                currency: item.currencyCode,
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) async {
                                if (value != 'void') return;
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    title: const Text('Void transfer?'),
                                    content: const Text(
                                      'This reverses the transfer between the two wallets.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext, false),
                                        child: const Text('Cancel'),
                                      ),
                                      FilledButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext, true),
                                        child: const Text('Void'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirmed != true) return;
                                try {
                                  await ref
                                      .read(apiClientProvider)
                                      .voidTransfer(item.id);
                                  ref.invalidate(transfersProvider(query));
                                  ref.invalidate(accountsProvider);
                                  ref.invalidate(walletsProvider);
                                  ref.invalidate(dashboardProvider);
                                } catch (error) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(error.toString())),
                                    );
                                  }
                                }
                              },
                              itemBuilder: (_) => const [
                                PopupMenuItem(
                                  value: 'void',
                                  child: Text('Void transfer'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
        error: (error, _) =>
            Center(child: Text('Could not load transfers: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
