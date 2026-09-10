import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/models.dart';
import '../../core/providers.dart';

class AddEntryPage extends ConsumerStatefulWidget {
  const AddEntryPage({required this.type, this.transactionId, super.key});
  final String type;
  final String? transactionId;
  @override
  ConsumerState<AddEntryPage> createState() => _AddEntryPageState();
}

class _AddEntryPageState extends ConsumerState<AddEntryPage> {
  final amount = TextEditingController();
  final description = TextEditingController();
  final notes = TextEditingController();
  String? walletId;
  String? categoryId;
  DateTime date = DateTime.now();
  bool saving = false;
  Map<String, dynamic>? existing;

  @override
  void initState() {
    super.initState();
    if (widget.transactionId != null) Future.microtask(_load);
  }

  Future<void> _load() async {
    try {
      final item = await ref
          .read(apiClientProvider)
          .transaction(widget.transactionId!);
      if (!mounted) return;
      setState(() {
        existing = item;
        amount.text = item['amount'].toString();
        description.text = item['description']?.toString() ?? '';
        notes.text = item['notes']?.toString() ?? '';
        walletId = item['walletId']?.toString();
        categoryId = item['categoryId']?.toString();
        date = DateTime.tryParse(item['transactionDate'].toString()) ?? date;
      });
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  void dispose() {
    amount.dispose();
    description.dispose();
    notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallets = ref.watch(walletsProvider);
    final categories = ref.watch(
      widget.type.contains('SPENDING')
          ? categoriesProvider
          : incomeCategoriesProvider,
    );
    final isEdit = existing != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit transaction' : titleFor(widget.type)),
      ),
      body: wallets.when(
        data: (walletItems) => categories.when(
          data: (categoryItems) => _form(
            context,
            List<dynamic>.from(walletItems),
            List<dynamic>.from(categoryItems),
            isEdit,
          ),
          error: (error, _) =>
              Center(child: Text('Categories unavailable: $error')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
        error: (error, _) => Center(child: Text('Wallets unavailable: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _form(
    BuildContext context,
    List<dynamic> wallets,
    List<dynamic> categories,
    bool isEdit,
  ) {
    final preferredWallet = ref
        .watch(preferencesProvider)
        .valueOrNull?['defaultWalletId']
        ?.toString();
    final walletIds = wallets
        .map((raw) => (raw as Map)['id'].toString())
        .toSet();
    walletId ??= walletIds.contains(preferredWallet)
        ? preferredWallet
        : wallets.isNotEmpty
        ? (wallets.first as Map)['id'] as String
        : null;
    final walletItems = [...wallets];
    if (walletId != null && !walletIds.contains(walletId)) {
      walletItems.add({
        'id': walletId,
        'name': 'Archived wallet',
        'currencyCode': '',
      });
    }
    final categoryIds = categories
        .map((raw) => (raw as Map)['id'].toString())
        .toSet();
    final categoryItems = [...categories];
    if (categoryId != null && !categoryIds.contains(categoryId)) {
      categoryItems.add({'id': categoryId, 'name': 'Archived category'});
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: amount,
            autofocus: !isEdit,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Amount'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: walletId,
            decoration: const InputDecoration(labelText: 'Wallet'),
            items: walletItems.map((raw) {
              final item = Map<String, dynamic>.from(raw as Map);
              return DropdownMenuItem(
                value: item['id'] as String,
                child: Text('${item['name']} · ${item['currencyCode']}'),
              );
            }).toList(),
            onChanged: (value) => setState(() => walletId = value),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String?>(
            initialValue: categoryId,
            decoration: const InputDecoration(labelText: 'Category (optional)'),
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('No category'),
              ),
              ...categoryItems.map((raw) {
                final item = Map<String, dynamic>.from(raw as Map);
                return DropdownMenuItem<String?>(
                  value: item['id'] as String,
                  child: Text(item['name'].toString()),
                );
              }),
            ],
            onChanged: (value) => setState(() => categoryId = value),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Date'),
            subtitle: Text(formatDate(date)),
            trailing: const Icon(Icons.calendar_today),
            onTap: _pickDate,
          ),
          TextField(
            controller: description,
            decoration: const InputDecoration(
              labelText: 'Description (optional)',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: notes,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Notes (optional)'),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: saving ? null : () => _save(isEdit),
            child: saving
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(isEdit ? 'Save changes' : 'Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2200),
      initialDate: date,
    );
    if (picked != null) setState(() => date = picked);
  }

  Future<void> _save(bool isEdit) async {
    if (amount.text.trim().isEmpty || walletId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Amount and wallet are required')),
      );
      return;
    }
    final parsedAmount = Decimal.tryParse(amount.text.trim());
    if (parsedAmount == null || parsedAmount <= Decimal.zero) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid positive amount')),
      );
      return;
    }
    setState(() => saving = true);
    final request = TransactionRequest(
      transactionType: existing?['transactionType']?.toString() ?? widget.type,
      amount: parsedAmount,
      walletId: walletId!,
      categoryId: categoryId,
      description: description.text.trim().isEmpty
          ? null
          : description.text.trim(),
      notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
      transactionDate: formatDate(date),
    );
    try {
      if (isEdit) {
        await ref
            .read(apiClientProvider)
            .updateTransaction(widget.transactionId!, request);
      } else {
        await ref.read(apiClientProvider).createTransaction(request);
      }
      ref.invalidate(accountsProvider);
      ref.invalidate(walletsProvider);
      ref.invalidate(preferencesProvider);
      ref.invalidate(dashboardProvider);
      ref.invalidate(transactionsProvider);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Saved')));
        context.pop();
      }
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }
}

String titleFor(String type) => switch (type) {
  'MAIN_INCOME' => 'Main income',
  'ADDITIONAL_INCOME' => 'Additional income',
  _ => 'Dynamic spending',
};
String formatDate(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
