import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/money.dart';
import '../../core/models.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../core/widgets/app_bottom_sheet.dart';
import '../../core/widgets/luxury_card.dart';
import '../../core/widgets/status_badge.dart';

class StaticExpensesPage extends ConsumerStatefulWidget {
  const StaticExpensesPage({super.key});
  @override
  ConsumerState<StaticExpensesPage> createState() => _StaticExpensesPageState();
}

class _StaticExpensesPageState extends ConsumerState<StaticExpensesPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final Set<String> _processing = <String>{};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void shiftMonth(int amount) {
    final current = ref.read(selectedPeriodProvider);
    ref.read(selectedPeriodProvider.notifier).state = DateTime(
      current.year,
      current.month + amount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final month = ref.watch(selectedPeriodProvider);
    final query = MonthQuery(month.year, month.month);
    final state = ref.watch(staticExpensesProvider(query));

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recurring Bills',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.midnight,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        '${_staticMonthName(month.month)} ${month.year}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.amber,
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
                        onPressed: () => _newTemplate(context),
                        icon: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.midnight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.add_rounded,
                              color: Colors.white, size: 20),
                        ),
                        tooltip: 'Add Template',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: state.when(
                data: (data) {
                  final occurrences = data.occurrences;
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.cardSurfaceAlt,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: AppShadows.card,
                          ),
                          labelColor: AppColors.midnight,
                          unselectedLabelColor: AppColors.textSecondary,
                          labelStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                          tabs: const [
                            Tab(text: 'Occurrences'),
                            Tab(text: 'Templates'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _occurrenceList(context, occurrences, query),
                            _templateList(context, data.templates, query),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                error: (error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline_rounded,
                            color: AppColors.crimson, size: 36),
                        const SizedBox(height: 12),
                        Text(
                          'Could not load recurring commitments: $error',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                loading: () => const Center(
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
    );
  }

  Widget _occurrenceList(
    BuildContext context,
    List<StaticExpenseOccurrence> occurrences,
    MonthQuery query,
  ) {
    if (occurrences.isEmpty) {
      return RefreshIndicator(
        color: AppColors.midnight,
        onRefresh: () async => ref.invalidate(staticExpensesProvider(query)),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(32, 60, 32, 100),
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.amberSoft,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.event_repeat_rounded,
                      color: AppColors.amber,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'No recurring bills this month',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.midnight,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Create templates for rent, subscriptions, or fixed monthly commitments.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () => _newTemplate(context),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Create Template'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Summary calculations
    var totalCommitted = Decimal.zero;
    var totalPaid = Decimal.zero;
    for (final occ in occurrences) {
      totalCommitted += occ.expectedAmount;
      if (occ.status == 'PAID') {
        totalPaid += occ.expectedAmount;
      }
    }

    return RefreshIndicator(
      color: AppColors.midnight,
      onRefresh: () async => ref.invalidate(staticExpensesProvider(query)),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 64),
        children: [
          TitaniumCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'MONTHLY COMMITMENTS',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    StatusBadge(
                      label: '${occurrences.where((o) => o.status == 'PAID').length}/${occurrences.length} Paid',
                      variant: BadgeVariant.warning,
                      compact: true,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Expected',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          moneyValue(totalCommitted),
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Paid So Far',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          moneyValue(totalPaid),
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.mint,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          ...occurrences.map((item) => _occurrence(context, item, query)),
        ],
      ),
    );
  }

  Widget _occurrence(
    BuildContext context,
    StaticExpenseOccurrence item,
    MonthQuery query,
  ) {
    final status = item.status;
    final isPaid = status == 'PAID';
    final isSkipped = status == 'SKIPPED';
    final isPending = status == 'PENDING';

    final (statusLabel, statusVariant) = isPaid
        ? ('Paid', BadgeVariant.income)
        : isSkipped
        ? ('Skipped', BadgeVariant.neutral)
        : ('Pending', BadgeVariant.warning);

    final amountStr = item.currencyCode == null
        ? item.expectedAmount.toStringAsFixed(2)
        : moneyValue(item.expectedAmount, currency: item.currencyCode!);

    return LuxuryCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isPaid
                  ? AppColors.mintSoft
                  : (isSkipped ? AppColors.cardSurfaceAlt : AppColors.amberSoft),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isPaid
                  ? Icons.check_circle_rounded
                  : (isSkipped
                      ? Icons.skip_next_rounded
                      : Icons.schedule_rounded),
              color: isPaid
                  ? AppColors.emerald
                  : (isSkipped ? AppColors.textTertiary : AppColors.amber),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.midnight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    StatusBadge(
                      label: statusLabel,
                      variant: statusVariant,
                      compact: true,
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'Due: ${item.dueDate} · ${item.accountName ?? item.accountId}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (isPending) ...[
            if (_processing.contains(item.id))
              const SizedBox.square(
                dimension: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    amountStr,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.midnight,
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert_rounded,
                        color: AppColors.textTertiary, size: 20),
                    onSelected: (value) async {
                      await Future<void>.delayed(const Duration(milliseconds: 120));
                      if (!mounted) return;
                      if (value == 'pay') {
                        await _pay(item, query);
                      } else {
                        await _skip(item, query);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'pay', child: Text('Mark Paid')),
                      PopupMenuItem(value: 'skip', child: Text('Skip')),
                    ],
                  ),
                ],
              ),
          ] else
            Text(
              amountStr,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isPaid ? AppColors.emerald : AppColors.textTertiary,
                decoration: isSkipped ? TextDecoration.lineThrough : null,
              ),
            ),
        ],
      ),
    );
  }

  Widget _templateList(
    BuildContext context,
    List<StaticExpenseTemplate> templates,
    MonthQuery query,
  ) {
    if (templates.isEmpty) {
      return RefreshIndicator(
        color: AppColors.midnight,
        onRefresh: () async => ref.invalidate(staticExpensesProvider(query)),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(32, 80, 32, 100),
          children: [
            Center(
              child: FilledButton.icon(
                onPressed: () => _newTemplate(context),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Create Template'),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.midnight,
      onRefresh: () async => ref.invalidate(staticExpensesProvider(query)),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 64),
        children: templates
            .map(
              (item) => LuxuryCard(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.amberSoft,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.event_repeat_rounded,
                        color: AppColors.amber,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.midnight,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${item.accountName} · Due day ${item.dueDay}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            moneyValue(item.amount),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.amber,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: AppColors.textTertiary,
                      ),
                      onSelected: (value) async {
                        await Future<void>.delayed(const Duration(milliseconds: 120));
                        if (!mounted) return;
                        if (value == 'edit') {
                          await _editTemplate(context, item, query);
                          return;
                        }
                        if (value == 'archive') {
                          final confirmed = await AppConfirmationSheet.show(
                            context: context,
                            title: 'Archive Template?',
                            message:
                                'Are you sure you want to archive "${item.name}"? Future recurring bill occurrences will not be generated.',
                            confirmLabel: 'Archive',
                            icon: Icons.archive_outlined,
                            confirmColor: AppColors.amber,
                          );
                          if (!confirmed) return;
                          try {
                            await ref
                                .read(apiClientProvider)
                                .archiveTemplate(item.id);
                            ref.invalidate(staticExpensesProvider(query));
                            if (mounted) {
                              AppToast.success(
                                context,
                                'Template "${item.name}" archived',
                              );
                            }
                          } catch (error) {
                            if (mounted) {
                              AppToast.error(context, error.toString());
                            }
                          }
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit template')),
                        PopupMenuItem(
                          value: 'archive',
                          child: Text('Archive template'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> _pay(StaticExpenseOccurrence item, MonthQuery query) async {
    if (!_processing.add(item.id)) return;
    setState(() {});
    try {
      String? paymentWalletId = item.walletId;
      if (item.walletId == null) {
        final allWallets = await ref.read(walletsProvider.future);
        final wallets = allWallets.where((raw) {
          final wallet = Map<String, dynamic>.from(raw as Map);
          return wallet['accountId'] == item.accountId &&
              (item.currencyCode == null ||
                  wallet['currencyCode'] == item.currencyCode);
        }).toList();
        String? selected;
        if (!mounted) return;
        final confirmed = await showAppBottomSheet<bool>(
          context: context,
          builder: (sheetContext) => StatefulBuilder(
            builder: (sheetContext, setState) => AppBottomSheet(
              title: 'Choose Payment Wallet',
              subtitle: 'Select the wallet to deduct this bill payment from.',
              icon: Icons.account_balance_wallet_rounded,
              iconColor: AppColors.emerald,
              iconBackground: AppColors.mintSoft,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.midnight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: selected == null
                      ? null
                      : () => Navigator.pop(sheetContext, true),
                  child: Text(
                    'Confirm Payment',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: selected,
                    decoration: const InputDecoration(labelText: 'Wallet'),
                    items: wallets.map((raw) {
                      final wallet = Map<String, dynamic>.from(raw as Map);
                      return DropdownMenuItem<String>(
                        value: wallet['id'] as String,
                        child: Text(
                          '${wallet['name']} · ${wallet['currencyCode']}',
                        ),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => selected = value),
                  ),
                ],
              ),
            ),
          ),
        );
        if (confirmed != true || selected == null) return;
        paymentWalletId = selected;
      }
      await ref
          .read(apiClientProvider)
          .payOccurrence(
            item.id,
            OccurrencePaymentRequest(walletId: paymentWalletId),
          );
      ref.invalidate(staticExpensesProvider(query));
      ref.invalidate(accountsProvider);
      ref.invalidate(walletsProvider);
      ref.invalidate(dashboardProvider);
      if (mounted) {
        AppToast.success(context, 'Marked "${item.name}" as paid');
      }
    } catch (error) {
      if (mounted) {
        AppToast.error(context, error.toString());
      }
    } finally {
      _processing.remove(item.id);
      if (mounted) setState(() {});
    }
  }

  Future<void> _skip(StaticExpenseOccurrence item, MonthQuery query) async {
    final confirmed = await AppConfirmationSheet.show(
      context: context,
      title: 'Skip Expense?',
      message:
          'Are you sure you want to skip "${item.name}" for this month? It will be marked as skipped without deducting funds.',
      confirmLabel: 'Skip',
      icon: Icons.skip_next_rounded,
      confirmColor: AppColors.amber,
    );
    if (!confirmed) return;

    if (!_processing.add(item.id)) return;
    setState(() {});
    try {
      await ref.read(apiClientProvider).skipOccurrence(item.id);
      ref.invalidate(staticExpensesProvider(query));
      ref.invalidate(dashboardProvider);
      if (mounted) {
        AppToast.success(context, 'Skipped "${item.name}" for this month');
      }
    } catch (error) {
      if (mounted) {
        AppToast.error(context, error.toString());
      }
    } finally {
      _processing.remove(item.id);
      if (mounted) setState(() {});
    }
  }

  Future<void> _newTemplate(BuildContext context) async {
    await _templateDialog(context);
  }

  Future<void> _editTemplate(
    BuildContext context,
    StaticExpenseTemplate item,
    MonthQuery query,
  ) async {
    await _templateDialog(context, existing: item, query: query);
  }

  Future<void> _templateDialog(
    BuildContext context, {
    StaticExpenseTemplate? existing,
    MonthQuery? query,
  }) async {
    final name = TextEditingController(text: existing?.name ?? '');
    final amount = TextEditingController(
      text: existing?.amount.toStringAsFixed(2) ?? '',
    );
    final due = TextEditingController(text: '${existing?.dueDay ?? 1}');
    final notes = TextEditingController(text: existing?.notes ?? '');
    final accounts = await ref.read(accountsProvider.future);
    final wallets = await ref.read(walletsProvider.future);
    final categories = await ref.read(categoriesProvider.future);
    String? accountId = accounts.isNotEmpty
        ? existing?.accountId ?? (accounts.first as Map)['id'] as String
        : null;
    String? walletId = existing?.defaultWalletId;
    if (walletId == null ||
        !wallets.any((raw) => (raw as Map)['id'] == walletId)) {
      for (final raw in wallets) {
        final wallet = Map<String, dynamic>.from(raw as Map);
        if (wallet['accountId'] == accountId) {
          walletId = wallet['id'] as String;
          break;
        }
      }
    }
    String? categoryId = existing?.categoryId;
    DateTime startDate =
        DateTime.tryParse(existing?.startDate ?? '') ?? DateTime.now();
    DateTime? endDate = existing?.endDate == null
        ? null
        : DateTime.tryParse(existing!.endDate!);
    var saving = false;
    final result = await showAppBottomSheet<bool>(
      context: context,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setState) {
          return AppBottomSheet(
            title: existing == null
                ? 'New Recurring Expense'
                : 'Edit Recurring Expense',
            subtitle: 'Configure automated monthly bill schedules.',
            icon: Icons.repeat_rounded,
            iconColor: AppColors.amber,
            iconBackground: AppColors.amber.withValues(alpha: 0.12),
            actions: [
              TextButton(
                onPressed: saving ? null : () => Navigator.pop(sheetContext),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.midnight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: saving
                    ? null
                    : () async {
                        if (accountId == null || name.text.trim().isEmpty) return;
                        setState(() => saving = true);
                        try {
                          final data = <String, dynamic>{
                            'accountId': accountId,
                            'defaultWalletId': walletId,
                            'categoryId': categoryId,
                            'name': name.text.trim(),
                            'defaultAmount': amount.text.trim(),
                            'dueDay': int.tryParse(due.text) ?? 1,
                            'startDate': _templateDate(startDate),
                            'endDate': endDate == null
                                ? null
                                : _templateDate(endDate!),
                            'notes': notes.text.trim().isEmpty
                                ? null
                                : notes.text.trim(),
                          };
                          if (existing == null) {
                            await ref
                                .read(apiClientProvider)
                                .createTemplate(data);
                          } else {
                            await ref
                                .read(apiClientProvider)
                                .updateTemplate(existing.id, data);
                          }
                          if (sheetContext.mounted) {
                            Navigator.pop(sheetContext, true);
                          }
                        } catch (error) {
                          setState(() => saving = false);
                          if (context.mounted) {
                            AppToast.error(context, error.toString());
                          }
                        }
                      },
                child: saving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(existing == null ? 'Create' : 'Save'),
              ),
            ],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amount,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Amount'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: due,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Due day of month (1-31)',
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Start date'),
                  subtitle: Text(_templateDate(startDate)),
                  trailing: const Icon(Icons.calendar_today_outlined, size: 18),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: sheetContext,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2200),
                      initialDate: startDate,
                    );
                    if (picked != null) setState(() => startDate = picked);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('End date (optional)'),
                  subtitle: Text(
                    endDate == null ? 'No end date' : _templateDate(endDate!),
                  ),
                  trailing: endDate == null
                      ? const Icon(Icons.calendar_today_outlined, size: 18)
                      : IconButton(
                          onPressed: () => setState(() => endDate = null),
                          icon: const Icon(Icons.clear, size: 18),
                        ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: sheetContext,
                      firstDate: startDate,
                      lastDate: DateTime(2200),
                      initialDate: endDate ?? startDate,
                    );
                    if (picked != null) setState(() => endDate = picked);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: accountId,
                  items: accounts.map((raw) {
                    final item = Map<String, dynamic>.from(raw as Map);
                    return DropdownMenuItem(
                      value: item['id'] as String,
                      child: Text(item['name'].toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      accountId = value;
                      walletId = null;
                      for (final raw in wallets) {
                        final wallet = Map<String, dynamic>.from(raw as Map);
                        if (wallet['accountId'] == accountId) {
                          walletId = wallet['id'] as String;
                          break;
                        }
                      }
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Account'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: walletId,
                  items: wallets
                      .where((raw) {
                        final wallet = Map<String, dynamic>.from(raw as Map);
                        return wallet['accountId'] == accountId;
                      })
                      .map((raw) {
                        final item = Map<String, dynamic>.from(raw as Map);
                        return DropdownMenuItem(
                          value: item['id'] as String,
                          child: Text(item['name'].toString()),
                        );
                      })
                      .toList(),
                  onChanged: (value) => setState(() => walletId = value),
                  decoration: const InputDecoration(
                    labelText: 'Default Wallet',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  isExpanded: true,
                  initialValue: categoryId,
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('No category'),
                    ),
                    ...categories.map((raw) {
                      final item = Map<String, dynamic>.from(raw as Map);
                      return DropdownMenuItem<String?>(
                        value: item['id'] as String,
                        child: Text(item['name'].toString()),
                      );
                    }),
                  ],
                  onChanged: (value) => setState(() => categoryId = value),
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notes,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
    if (result == true) {
      final period = ref.read(selectedPeriodProvider);
      ref.invalidate(
        staticExpensesProvider(query ?? MonthQuery(period.year, period.month)),
      );
      ref.invalidate(dashboardProvider);
      if (context.mounted) {
        AppToast.success(
          context,
          existing == null
              ? 'Template created successfully'
              : 'Template updated successfully',
        );
      }
    }
    name.dispose();
    amount.dispose();
    due.dispose();
    notes.dispose();
  }
}

String _templateDate(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

String _staticMonthName(int month) => const [
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
