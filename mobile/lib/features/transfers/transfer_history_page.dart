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
      body: RefreshIndicator(
        color: AppColors.midnight,
        onRefresh: () async {
          ref.invalidate(transfersProvider(query));
          ref.invalidate(walletsProvider);
          ref.invalidate(accountsProvider);
        },
        child: state.when(
          data: (items) {
            if (items.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(32),
                children: [
                  const SizedBox(height: 60),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: const BoxDecoration(
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
                          'Funds moved between your accounts will be tracked here.\nPull down to refresh anytime.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return LuxuryCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.indigoSoft,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.swap_horiz_rounded,
                          color: AppColors.indigo,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.notes?.isNotEmpty == true
                                  ? item.notes!
                                  : 'Transfer',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.midnight,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${item.fromWalletName} → ${item.toWalletName}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.transferDate,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        moneyValue(item.amount, currency: item.currencyCode),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.indigo,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          error: (error, _) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(32),
            children: [
              const SizedBox(height: 60),
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        size: 48, color: AppColors.crimson),
                    const SizedBox(height: 16),
                    Text(
                      'Could not load transfers',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.midnight,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$error\n\nPull down to retry',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.midnight),
          ),
        ),
      ),
    );
  }
}
