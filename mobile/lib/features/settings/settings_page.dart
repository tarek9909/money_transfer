import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).valueOrNull;
    final pref = ref.watch(preferencesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Settings'),
            Text(
              'Make Money Tracker feel like yours',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff0b1724), Color(0xff173d3a)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xffa9efd0).withValues(alpha: .18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Color(0xffa9efd0),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?['name']?.toString() ?? 'Account',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        user?['email']?.toString() ?? '',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .68),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pref.when(
            data: (data) => _preferences(context, ref, data),
            error: (e, _) => Text('Preferences unavailable: $e'),
            loading: () => const LinearProgressIndicator(),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.autorenew_rounded),
                  title: const Text('Static spending'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/static-expenses'),
                ),
                ListTile(
                  leading: const Icon(Icons.tune_rounded),
                  title: const Text('Categories'),
                  subtitle: const Text('Manage spending categories'),
                  onTap: () => _manageCategories(context, ref),
                ),
                ListTile(
                  leading: const Icon(Icons.shield_outlined),
                  title: const Text('Security'),
                  subtitle: const Text(
                    'Access tokens are kept in secure storage',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => ref.read(authProvider.notifier).logout(),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Log out'),
          ),
        ],
      ),
    );
  }

  Widget _preferences(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> data,
  ) {
    final user = ref.watch(authProvider).valueOrNull;
    final currency =
        data['preferredCurrency']?.toString() ??
        user?['preferredCurrency']?.toString() ??
        'USD';
    final accounts = ref.watch(accountsProvider).valueOrNull ?? const [];
    final wallets = ref.watch(walletsProvider).valueOrNull ?? const [];
    final selectedAccount = data['defaultAccountId']?.toString();
    final selectedWallet = data['defaultWalletId']?.toString();
    final accountIds = accounts
        .map((raw) => (raw as Map)['id'].toString())
        .toSet();
    final walletIds = wallets
        .map((raw) => (raw as Map)['id'].toString())
        .toSet();
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('Preferred currency'),
            subtitle: Text(currency),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _currencyDialog(context, ref, data),
          ),
          ListTile(
            title: const Text('Timezone'),
            subtitle: Text(data['timezone']?.toString() ?? 'UTC'),
          ),
          ListTile(
            title: const Text('Default account'),
            trailing: DropdownButton<String?>(
              value: accountIds.contains(selectedAccount)
                  ? selectedAccount
                  : null,
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('None'),
                ),
                ...accounts.map((raw) {
                  final item = Map<String, dynamic>.from(raw as Map);
                  return DropdownMenuItem<String?>(
                    value: item['id'] as String,
                    child: Text(item['name'].toString()),
                  );
                }),
                if (selectedAccount != null &&
                    !accountIds.contains(selectedAccount))
                  DropdownMenuItem<String?>(
                    value: selectedAccount,
                    enabled: false,
                    child: const Text('Archived account'),
                  ),
              ],
              onChanged: (value) async {
                await ref.read(apiClientProvider).updatePreferences({
                  'defaultAccountId': value,
                });
                ref.invalidate(preferencesProvider);
              },
            ),
          ),
          ListTile(
            title: const Text('Default wallet'),
            trailing: DropdownButton<String?>(
              value: walletIds.contains(selectedWallet) ? selectedWallet : null,
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('None'),
                ),
                ...wallets.map((raw) {
                  final item = Map<String, dynamic>.from(raw as Map);
                  return DropdownMenuItem<String?>(
                    value: item['id'] as String,
                    child: Text('${item['name']} · ${item['currencyCode']}'),
                  );
                }),
                if (selectedWallet != null &&
                    !walletIds.contains(selectedWallet))
                  DropdownMenuItem<String?>(
                    value: selectedWallet,
                    enabled: false,
                    child: const Text('Archived wallet'),
                  ),
              ],
              onChanged: (value) async {
                await ref.read(apiClientProvider).updatePreferences({
                  'defaultWalletId': value,
                });
                ref.invalidate(preferencesProvider);
              },
            ),
          ),
          ListTile(
            title: const Text('Financial month starts on'),
            subtitle: const Text('Used for dashboard and activity periods'),
            trailing: DropdownButton<int>(
              value:
                  int.tryParse(data['financialMonthStart']?.toString() ?? '') ??
                  1,
              items: [
                for (var day = 1; day <= 28; day++)
                  DropdownMenuItem(value: day, child: Text('$day')),
              ],
              onChanged: (value) async {
                if (value == null) return;
                try {
                  await ref.read(apiClientProvider).updatePreferences({
                    'financialMonthStart': value,
                  });
                  ref.invalidate(preferencesProvider);
                } catch (error) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(error.toString())));
                  }
                }
              },
            ),
          ),
          SwitchListTile(
            title: const Text('Allow negative wallet balances'),
            value: data['allowNegativeWallets'] == true,
            onChanged: (value) async {
              await ref.read(apiClientProvider).updatePreferences({
                'allowNegativeWallets': value,
              });
              ref.invalidate(preferencesProvider);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _currencyDialog(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> data,
  ) async {
    String value = data['preferredCurrency']?.toString() ?? 'USD';
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Preferred currency'),
        content: DropdownButtonFormField<String>(
          initialValue: value,
          items: const [
            DropdownMenuItem(value: 'USD', child: Text('USD')),
            DropdownMenuItem(value: 'LBP', child: Text('LBP')),
            DropdownMenuItem(value: 'EUR', child: Text('EUR')),
          ],
          onChanged: (next) => value = next ?? value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, value),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) {
      await ref.read(apiClientProvider).updatePreferences({
        'preferredCurrency': result,
      });
      ref.invalidate(preferencesProvider);
    }
  }

  Future<void> _manageCategories(BuildContext context, WidgetRef ref) async {
    final spending = await ref.read(categoriesProvider.future);
    final income = await ref.read(incomeCategoriesProvider.future);
    final byId = <String, Map<String, dynamic>>{};
    for (final raw in [...spending, ...income]) {
      final item = Map<String, dynamic>.from(raw as Map);
      byId[item['id'] as String] = item;
    }
    final categories = byId.values.toList();
    if (!context.mounted) return;
    var filter = 'ALL';
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: DropdownButton<String>(
            value: filter,
            items: const [
              DropdownMenuItem(value: 'ALL', child: Text('All categories')),
              DropdownMenuItem(
                value: 'SPENDING',
                child: Text('Spending categories'),
              ),
              DropdownMenuItem(
                value: 'INCOME',
                child: Text('Income categories'),
              ),
            ],
            onChanged: (value) => setState(() => filter = value ?? 'ALL'),
          ),
          content: SizedBox(
            width: 360,
            child: ListView(
              shrinkWrap: true,
              children: categories
                  .where((item) {
                    final type = item['appliesTo'];
                    return filter == 'ALL' || type == filter || type == 'BOTH';
                  })
                  .map((item) {
                    return ListTile(
                      title: Text(item['name'].toString()),
                      subtitle: Text(item['appliesTo'].toString()),
                      trailing: Wrap(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () async {
                              final name = TextEditingController(
                                text: item['name'].toString(),
                              );
                              var appliesTo = item['appliesTo'].toString();
                              final edited = await showDialog<bool>(
                                context: dialogContext,
                                builder: (editContext) => StatefulBuilder(
                                  builder: (editContext, editState) =>
                                      AlertDialog(
                                        title: const Text('Edit category'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(controller: name),
                                            DropdownButtonFormField<String>(
                                              initialValue: appliesTo,
                                              items: const [
                                                DropdownMenuItem(
                                                  value: 'SPENDING',
                                                  child: Text('Spending'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'INCOME',
                                                  child: Text('Income'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'BOTH',
                                                  child: Text('Both'),
                                                ),
                                              ],
                                              onChanged: (value) => editState(
                                                () => appliesTo =
                                                    value ?? appliesTo,
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(editContext),
                                            child: const Text('Cancel'),
                                          ),
                                          FilledButton(
                                            onPressed: () => Navigator.pop(
                                              editContext,
                                              true,
                                            ),
                                            child: const Text('Save'),
                                          ),
                                        ],
                                      ),
                                ),
                              );
                              if (edited == true &&
                                  name.text.trim().isNotEmpty) {
                                try {
                                  final updated = await ref
                                      .read(apiClientProvider)
                                      .updateCategory(item['id'] as String, {
                                        'name': name.text.trim(),
                                        'appliesTo': appliesTo,
                                      });
                                  setState(() {
                                    final index = categories.indexOf(item);
                                    categories[index] = updated;
                                  });
                                  ref.invalidate(categoriesProvider);
                                  ref.invalidate(incomeCategoriesProvider);
                                } catch (error) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(error.toString())),
                                    );
                                  }
                                }
                              }
                              name.dispose();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.archive_outlined),
                            onPressed: () async {
                              try {
                                await ref
                                    .read(apiClientProvider)
                                    .archiveCategory(item['id'] as String);
                                setState(() => categories.remove(item));
                                ref.invalidate(categoriesProvider);
                                ref.invalidate(incomeCategoriesProvider);
                              } catch (error) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error.toString())),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  })
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
            FilledButton.icon(
              onPressed: () async {
                final controller = TextEditingController();
                final created = await showDialog<bool>(
                  context: dialogContext,
                  builder: (context) => AlertDialog(
                    title: const Text('New category'),
                    content: TextField(
                      controller: controller,
                      autofocus: true,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Create'),
                      ),
                    ],
                  ),
                );
                if (created == true && controller.text.trim().isNotEmpty) {
                  try {
                    final category = await ref
                        .read(apiClientProvider)
                        .createCategory({
                          'name': controller.text.trim(),
                          'appliesTo': filter == 'INCOME'
                              ? 'INCOME'
                              : 'SPENDING',
                        });
                    setState(() => categories.add(category));
                    ref.invalidate(categoriesProvider);
                    ref.invalidate(incomeCategoriesProvider);
                  } catch (error) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(error.toString())));
                    }
                  }
                }
                controller.dispose();
              },
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
