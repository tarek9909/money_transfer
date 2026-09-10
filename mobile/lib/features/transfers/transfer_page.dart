import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers.dart';

class TransferPage extends ConsumerStatefulWidget {
  const TransferPage({super.key});
  @override
  ConsumerState<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends ConsumerState<TransferPage> {
  final amount = TextEditingController();
  final notes = TextEditingController();
  String? from;
  String? to;
  DateTime transferDate = DateTime.now();
  bool saving = false;
  @override
  void dispose() {
    amount.dispose();
    notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallets = ref.watch(walletsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer money'),
        actions: [
          IconButton(
            onPressed: () => context.push('/transfers'),
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Transfer history',
          ),
        ],
      ),
      body: wallets.when(
        data: (items) {
          final list = List<dynamic>.from(items);
          from ??= list.isNotEmpty ? (list.first as Map)['id'] as String : null;
          final source = list.cast<Map>().where((item) => item['id'] == from);
          final currency = source.isEmpty ? null : source.first['currencyCode'];
          final destinations = list.where((raw) {
            final item = Map<String, dynamic>.from(raw as Map);
            return item['id'] != from &&
                (currency == null || item['currencyCode'] == currency);
          }).toList();
          if (to == null ||
              !destinations.any((item) => (item as Map)['id'] == to)) {
            to = destinations.isEmpty
                ? null
                : (destinations.first as Map)['id'] as String;
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                controller: amount,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
              const SizedBox(height: 12),
              _dropdown(
                'From wallet',
                from,
                list,
                (value) => setState(() => from = value),
              ),
              const SizedBox(height: 12),
              _dropdown(
                'To wallet',
                to,
                destinations,
                (value) => setState(() => to = value),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Transfer date'),
                subtitle: Text(_formatDate(transferDate)),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: _pickDate,
              ),
              TextField(
                controller: notes,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                ),
              ),
              if (destinations.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Add another wallet in the same currency to transfer funds.',
                  ),
                ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: saving ? null : _save,
                child: saving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Transfer'),
              ),
            ],
          );
        },
        error: (error, _) => Center(child: Text('Wallets unavailable: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _dropdown(
    String label,
    String? value,
    List<dynamic> items,
    ValueChanged<String?> onChanged,
  ) => DropdownButtonFormField<String>(
    initialValue: value,
    decoration: InputDecoration(labelText: label),
    items: items.map((raw) {
      final item = Map<String, dynamic>.from(raw as Map);
      return DropdownMenuItem(
        value: item['id'] as String,
        child: Text('${item['name']} · ${item['currencyCode']}'),
      );
    }).toList(),
    onChanged: onChanged,
  );
  Future<void> _save() async {
    if (from == null || to == null || amount.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose two wallets and enter an amount')),
      );
      return;
    }
    setState(() => saving = true);
    try {
      await ref.read(apiClientProvider).createTransfer({
        'fromWalletId': from,
        'toWalletId': to,
        'amount': amount.text.trim(),
        'transferDate': _formatDate(transferDate),
        'notes': notes.text.trim().isEmpty ? null : notes.text.trim(),
      });
      ref.invalidate(accountsProvider);
      ref.invalidate(walletsProvider);
      ref.invalidate(dashboardProvider);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Transfer completed')));
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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2200),
      initialDate: transferDate,
    );
    if (picked != null) setState(() => transferDate = picked);
  }
}

String _formatDate(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
