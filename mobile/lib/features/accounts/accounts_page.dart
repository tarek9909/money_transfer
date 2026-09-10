import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/money.dart';
import '../../core/providers.dart';

class AccountsPage extends ConsumerWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Accounts'),
            Text(
              'Your money, organized beautifully',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _accountDialog(context, ref),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: accounts.when(
        data: (items) => items.isEmpty
            ? _empty(context, ref)
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 112),
                children: items
                    .map(
                      (raw) => _account(
                        context,
                        ref,
                        Map<String, dynamic>.from(raw as Map),
                      ),
                    )
                    .toList(),
              ),
        error: (error, _) =>
            Center(child: Text('Could not load accounts: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _empty(BuildContext context, WidgetRef ref) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.account_balance_wallet_rounded, size: 34),
          ),
          const SizedBox(height: 18),
          Text(
            'Start with one account',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 7),
          const Text(
            'Add cash, bank, or digital wallets to see your full picture.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () => _accountDialog(context, ref),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add account'),
          ),
        ],
      ),
    ),
  );

  Widget _account(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> item,
  ) {
    final wallets = List<dynamic>.from(item['wallets'] ?? const []);
    return Card(
      child: ExpansionTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.account_balance_rounded),
        ),
        title: Text(item['name'].toString()),
        subtitle: Text(
          '${wallets.length} wallet${wallets.length == 1 ? '' : 's'}',
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'edit') {
              await _editAccountDialog(context, ref, item);
              return;
            }
            if (value == 'archive') {
              try {
                await ref
                    .read(apiClientProvider)
                    .archiveAccount(item['id'] as String);
                ref.invalidate(accountsProvider);
              } catch (error) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(error.toString())));
                }
              }
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit account')),
            PopupMenuItem(value: 'archive', child: Text('Archive account')),
          ],
        ),
        children: [
          ...wallets.map((raw) {
            final wallet = Map<String, dynamic>.from(raw as Map);
            return ListTile(
              leading: const Icon(Icons.account_balance_wallet_outlined),
              title: Text(wallet['name'].toString()),
              subtitle: Text(
                '${wallet['walletTypeCode']} · ${wallet['currencyCode']}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    moneyValue(
                      wallet['currentBalance'],
                      currency: wallet['currencyCode'].toString(),
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        await _editWalletDialog(context, ref, wallet);
                        return;
                      }
                      if (value != 'archive') return;
                      try {
                        await ref
                            .read(apiClientProvider)
                            .archiveWallet(wallet['id'] as String);
                        ref.invalidate(accountsProvider);
                        ref.invalidate(walletsProvider);
                      } catch (error) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.toString())),
                          );
                        }
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('Edit wallet')),
                      PopupMenuItem(
                        value: 'archive',
                        child: Text('Archive wallet'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _walletDialog(context, ref, item),
              icon: const Icon(Icons.add),
              label: const Text('Add wallet'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editAccountDialog(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> account,
  ) async {
    final controller = TextEditingController(text: account['name'].toString());
    var saving = false;
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: const Text('Edit account'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Name'),
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
                      if (controller.text.trim().isEmpty) return;
                      setState(() => saving = true);
                      try {
                        await ref.read(apiClientProvider).updateAccount(
                          account['id'] as String,
                          {'name': controller.text.trim()},
                        );
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
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (saved == true) ref.invalidate(accountsProvider);
  }

  Future<void> _editWalletDialog(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> wallet,
  ) async {
    final name = TextEditingController(text: wallet['name'].toString());
    final opening = TextEditingController(
      text: wallet['openingBalance']?.toString() ?? '0.00',
    );
    var saving = false;
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: const Text('Edit wallet'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: opening,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Opening balance'),
              ),
            ],
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
                      setState(() => saving = true);
                      try {
                        await ref
                            .read(apiClientProvider)
                            .updateWallet(wallet['id'] as String, {
                              'name': name.text.trim(),
                              'openingBalance': opening.text.trim(),
                            });
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
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
    name.dispose();
    opening.dispose();
    if (saved == true) {
      ref.invalidate(accountsProvider);
      ref.invalidate(walletsProvider);
    }
  }

  Future<void> _accountDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final existing = await ref.read(accountsProvider.future);
    String? parentId;
    var saving = false;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('New account'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              if (existing.isNotEmpty) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  initialValue: parentId,
                  decoration: const InputDecoration(
                    labelText: 'Parent account (optional)',
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Top-level account'),
                    ),
                    ...existing.map((raw) {
                      final item = Map<String, dynamic>.from(raw as Map);
                      return DropdownMenuItem<String?>(
                        value: item['id'] as String,
                        child: Text(item['name'].toString()),
                      );
                    }),
                  ],
                  onChanged: (value) => setState(() => parentId = value),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: saving
                  ? null
                  : () async {
                      if (controller.text.trim().isEmpty) return;
                      setState(() => saving = true);
                      try {
                        await ref.read(apiClientProvider).createAccount({
                          'name': controller.text.trim(),
                          'parentAccountId': parentId,
                        });
                        if (context.mounted) Navigator.pop(context, true);
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
                  : const Text('Create'),
            ),
          ],
        ),
      ),
    );
    if (result == true) ref.invalidate(accountsProvider);
    controller.dispose();
  }

  Future<void> _walletDialog(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> account,
  ) async {
    final name = TextEditingController(text: 'Cash');
    final opening = TextEditingController(text: '0.00');
    final pref = await ref.read(preferencesProvider.future);
    String currency = pref['preferredCurrency']?.toString() ?? 'USD';
    String walletType = 'CASH';
    var saving = false;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('New wallet'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: opening,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Opening balance'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: walletType,
                decoration: const InputDecoration(labelText: 'Wallet type'),
                items: const [
                  DropdownMenuItem(value: 'CASH', child: Text('Cash')),
                  DropdownMenuItem(value: 'WHISH', child: Text('Whish')),
                  DropdownMenuItem(value: 'OTHER', child: Text('Other')),
                ],
                onChanged: (value) =>
                    setState(() => walletType = value ?? 'CASH'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: currency,
                decoration: const InputDecoration(labelText: 'Currency'),
                items: const [
                  DropdownMenuItem(value: 'USD', child: Text('USD')),
                  DropdownMenuItem(value: 'LBP', child: Text('LBP')),
                ],
                onChanged: (value) => setState(() => currency = value ?? 'USD'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: saving
                  ? null
                  : () async {
                      if (name.text.trim().isEmpty) return;
                      setState(() => saving = true);
                      try {
                        await ref.read(apiClientProvider).createWallet({
                          'accountId': account['id'],
                          'name': name.text.trim(),
                          'walletTypeCode': walletType,
                          'currencyCode': currency,
                          'openingBalance': opening.text,
                        });
                        if (context.mounted) Navigator.pop(context, true);
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
                  : const Text('Create'),
            ),
          ],
        ),
      ),
    );
    if (result == true) {
      ref.invalidate(accountsProvider);
      ref.invalidate(walletsProvider);
    }
    name.dispose();
    opening.dispose();
  }
}
