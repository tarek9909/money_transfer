import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/money.dart';
import '../../core/models.dart';
import '../../core/providers.dart';

class StaticExpensesPage extends ConsumerStatefulWidget {
  const StaticExpensesPage({super.key});
  @override
  ConsumerState<StaticExpensesPage> createState() => _StaticExpensesPageState();
}

class _StaticExpensesPageState extends ConsumerState<StaticExpensesPage> {
  final Set<String> _processing = <String>{};

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
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recurring expenses'),
            Text(
              '${_staticMonthName(month.month)} ${month.year}',
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
            onPressed: () => _newTemplate(context),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: state.when(
        data: (data) {
          final occurrences = data.occurrences;
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: 'Occurrences'),
                    Tab(text: 'Templates'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _occurrenceList(context, occurrences, query),
                      _templateList(context, data.templates, query),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, _) =>
            Center(child: Text('Could not load static spending: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _occurrenceList(
    BuildContext context,
    List<StaticExpenseOccurrence> occurrences,
    MonthQuery query,
  ) => occurrences.isEmpty
      ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No recurring expenses for this month.'),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => _newTemplate(context),
                icon: const Icon(Icons.add),
                label: const Text('Create template'),
              ),
            ],
          ),
        )
      : RefreshIndicator(
          onRefresh: () async => ref.invalidate(staticExpensesProvider(query)),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 112),
            children: occurrences
                .map((item) => _occurrence(context, item, query))
                .toList(),
          ),
        );

  Widget _templateList(
    BuildContext context,
    List<StaticExpenseTemplate> templates,
    MonthQuery query,
  ) => templates.isEmpty
      ? Center(
          child: FilledButton.icon(
            onPressed: () => _newTemplate(context),
            icon: const Icon(Icons.add),
            label: const Text('Create template'),
          ),
        )
      : ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 112),
          children: templates
              .map(
                (item) => Card(
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text(
                      '${moneyValue(item.amount)} · ${item.accountName} · due ${item.dueDay}',
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'edit') {
                          await _editTemplate(context, item, query);
                        } else if (value == 'archive') {
                          try {
                            await ref
                                .read(apiClientProvider)
                                .archiveTemplate(item.id);
                            ref.invalidate(staticExpensesProvider(query));
                          } catch (error) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error.toString())),
                              );
                            }
                          }
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit template'),
                        ),
                        PopupMenuItem(
                          value: 'archive',
                          child: Text('Archive template'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        );

  Widget _occurrence(
    BuildContext context,
    StaticExpenseOccurrence item,
    MonthQuery query,
  ) {
    final status = item.status;
    final statusColor = status == 'PAID'
        ? Colors.green
        : status == 'SKIPPED'
        ? Colors.grey
        : Theme.of(context).colorScheme.tertiary;
    return Card(
      child: ListTile(
        title: Text(item.name),
        subtitle: Text(
          '${item.dueDate} · ${item.accountName ?? item.accountId}',
        ),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            status == 'PAID'
                ? Icons.check_rounded
                : status == 'SKIPPED'
                ? Icons.skip_next_rounded
                : Icons.schedule_rounded,
            color: statusColor,
          ),
        ),
        trailing: status == 'PENDING'
            ? _processing.contains(item.id)
                  ? const SizedBox.square(
                      dimension: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Wrap(
                      spacing: 4,
                      children: [
                        Text(
                          item.currencyCode == null
                              ? item.expectedAmount.toStringAsFixed(2)
                              : moneyValue(
                                  item.expectedAmount,
                                  currency: item.currencyCode!,
                                ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) => value == 'pay'
                              ? _pay(item, query)
                              : _skip(item, query),
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: 'pay',
                              child: Text('Mark paid'),
                            ),
                            PopupMenuItem(value: 'skip', child: Text('Skip')),
                          ],
                        ),
                      ],
                    )
            : Text(status),
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
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => StatefulBuilder(
            builder: (dialogContext, setState) => AlertDialog(
              title: const Text('Choose payment wallet'),
              content: DropdownButtonFormField<String>(
                initialValue: selected,
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
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: selected == null
                      ? null
                      : () => Navigator.pop(dialogContext, true),
                  child: const Text('Continue'),
                ),
              ],
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
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Expense marked paid')));
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      _processing.remove(item.id);
      if (mounted) setState(() {});
    }
  }

  Future<void> _skip(StaticExpenseOccurrence item, MonthQuery query) async {
    if (!_processing.add(item.id)) return;
    setState(() {});
    try {
      await ref.read(apiClientProvider).skipOccurrence(item.id);
      ref.invalidate(staticExpensesProvider(query));
      ref.invalidate(dashboardProvider);
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
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
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) {
          return AlertDialog(
            title: Text(
              existing == null
                  ? 'New recurring expense'
                  : 'Edit recurring expense',
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: name,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: amount,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(labelText: 'Amount'),
                  ),
                  TextField(
                    controller: due,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Due day (1-31)',
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Start date'),
                    subtitle: Text(_templateDate(startDate)),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: dialogContext,
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
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: dialogContext,
                        firstDate: startDate,
                        lastDate: DateTime(2200),
                        initialDate: endDate ?? startDate,
                      );
                      if (picked != null) setState(() => endDate = picked);
                    },
                    trailing: endDate == null
                        ? null
                        : IconButton(
                            onPressed: () => setState(() => endDate = null),
                            icon: const Icon(Icons.clear),
                          ),
                  ),
                  DropdownButtonFormField<String>(
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
                  DropdownButtonFormField<String>(
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
                      labelText: 'Default wallet',
                    ),
                  ),
                  DropdownButtonFormField<String?>(
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
                      if (categoryId != null &&
                          !categories.any(
                            (raw) => (raw as Map)['id'] == categoryId,
                          ))
                        DropdownMenuItem<String?>(
                          value: categoryId,
                          enabled: false,
                          child: const Text('Archived category'),
                        ),
                    ],
                    onChanged: (value) => setState(() => categoryId = value),
                    decoration: const InputDecoration(labelText: 'Category'),
                  ),
                  TextField(
                    controller: notes,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: saving ? null : () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: saving
                    ? null
                    : () async {
                        if (accountId == null || name.text.trim().isEmpty)
                          return;
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
                          if (dialogContext.mounted)
                            Navigator.pop(dialogContext, true);
                        } catch (error) {
                          setState(() => saving = false);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.toString())),
                            );
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
