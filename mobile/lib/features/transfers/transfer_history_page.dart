import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/money.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../core/widgets/luxury_card.dart';

class TransferHistoryPage extends ConsumerWidget {
  const TransferHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(selectedPeriodProvider);
    final query = MonthQuery(period.year, period.month);
    final state = ref.watch(transfersProvider(query));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transfer History',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(transfersProvider(query)),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: state.when(
        data: (items) => items.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.indigoSoft,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.swap_horiz_rounded,
                          color: AppColors.indigo,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'No transfers for this period',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.midnight,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Funds moved between your accounts will be tracked here.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : RefreshIndicator(
                color: AppColors.midnight,
                onRefresh: () async => ref.invalidate(transfersProvider(query)),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return LuxuryCard(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.indigoSoft,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.swap_horiz_rounded,
                              color: AppColors.indigo,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${item.fromWalletName} → ${item.toWalletName}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.midnight,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${item.transferDate}${item.notes == null ? '' : ' · ${item.notes}'}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            moneyValue(
                              item.amount,
                              currency: item.currencyCode,
                            ),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.midnight,
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert_rounded,
                              color: AppColors.textTertiary,
                              size: 20,
                            ),
                            onSelected: (value) async {
                              if (value != 'void') return;
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (dialogContext) => AlertDialog(
                                  title: const Text('Void Transfer?'),
                                  content: const Text(
                                    'This will reverse the transfer between both wallets.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext, false),
                                      child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                      style: FilledButton.styleFrom(
                                        backgroundColor: AppColors.crimson,
                                      ),
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
                    );
                  },
                ),
              ),
        error: (error, _) => Center(
          child: Text(
            'Could not load transfers: $error',
            style: GoogleFonts.plusJakartaSans(color: AppColors.crimson),
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.midnight),
        ),
      ),
    );
  }
}
