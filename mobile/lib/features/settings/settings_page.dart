import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../core/widgets/luxury_card.dart';
import '../../core/widgets/status_badge.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).valueOrNull;
    final pref = ref.watch(preferencesProvider);
    final fullName = user?['name']?.toString() ?? 'Account';
    final email = user?['email']?.toString() ?? '';
    final initials = fullName.trim().isNotEmpty
        ? fullName
            .trim()
            .split(' ')
            .where((e) => e.isNotEmpty)
            .take(2)
            .map((e) => e[0].toUpperCase())
            .join()
        : 'U';

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.midnight,
          onRefresh: () async {
            ref.invalidate(authProvider);
            ref.invalidate(preferencesProvider);
            ref.invalidate(accountsProvider);
            ref.invalidate(walletsProvider);
            ref.invalidate(categoriesProvider);
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 150),
            children: [
            Text(
              'Settings',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.midnight,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Customize your account and app preferences',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),

            // Profile Header Card
            TitaniumCard(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.mint.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.mint, width: 1.5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initials,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.mint,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          email,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white.withValues(alpha: 0.65),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(
                    label: user?['preferredCurrency']?.toString() ?? 'USD',
                    variant: BadgeVariant.income,
                    compact: true,
                  ),
                ],
              ),
            ),

            pref.when(
              data: (data) => _preferences(context, ref, data),
              error: (e, _) => Text(
                'Preferences unavailable: $e',
                style: GoogleFonts.plusJakartaSans(color: AppColors.crimson),
              ),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(color: AppColors.midnight),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Navigation & Management Section
            LuxuryCard(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.amberSoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.event_repeat_rounded,
                          color: AppColors.amber, size: 20),
                    ),
                    title: Text(
                      'Recurring Expenses',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      'Manage monthly recurring bills & templates',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: AppColors.textTertiary),
                    onTap: () => context.push('/static-expenses'),
                  ),
                  const Divider(height: 1, indent: 60),
                  ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.mintSoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.tune_rounded,
                          color: AppColors.emerald, size: 20),
                    ),
                    title: Text(
                      'Spending & Income Categories',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      'Customize category tags and taxonomies',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: AppColors.textTertiary),
                    onTap: () => _manageCategories(context, ref),
                  ),
                  const Divider(height: 1, indent: 60),
                  ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.indigoSoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.shield_outlined,
                          color: AppColors.indigo, size: 20),
                    ),
                    title: Text(
                      'Security & Storage',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      'Encrypted key storage enabled',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12),
                    ),
                    trailing: const StatusBadge(
                      label: 'Active',
                      variant: BadgeVariant.income,
                      compact: true,
                    ),
                  ),
                  const Divider(height: 1, indent: 60),
                  ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.cardSurfaceAlt,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.dns_outlined,
                          color: AppColors.midnight, size: 20),
                    ),
                    title: Text(
                      'Backend Server',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      ref.watch(apiClientProvider).currentBaseUrl,
                      style: GoogleFonts.plusJakartaSans(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: AppColors.textTertiary),
                    onTap: () => _serverConfigDialog(context, ref),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Logout Button
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.crimson,
                side: const BorderSide(color: AppColors.crimsonSoft, width: 1.5),
                backgroundColor: Colors.white,
              ),
              onPressed: () => ref.read(authProvider.notifier).logout(),
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: Text(
                'Log Out',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
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

    return LuxuryCard(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Preferred Currency',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              currency,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.emerald,
                fontWeight: FontWeight.w700,
              ),
            ),
            trailing: const Icon(Icons.chevron_right_rounded,
                color: AppColors.textTertiary),
            onTap: () => _currencyDialog(context, ref, data),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            title: Text(
              'Default Account',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            trailing: DropdownButton<String?>(
              underline: const SizedBox(),
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
              ],
              onChanged: (value) async {
                await ref.read(apiClientProvider).updatePreferences({
                  'defaultAccountId': value,
                });
                ref.invalidate(preferencesProvider);
              },
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            title: Text(
              'Default Wallet',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            trailing: DropdownButton<String?>(
              underline: const SizedBox(),
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
                    child: Text('${item['name']} (${item['currencyCode']})'),
                  );
                }),
              ],
              onChanged: (value) async {
                await ref.read(apiClientProvider).updatePreferences({
                  'defaultWalletId': value,
                });
                ref.invalidate(preferencesProvider);
              },
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            title: Text(
              'Financial Month Starts On',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              'Used for monthly tracking periods',
              style: GoogleFonts.plusJakartaSans(fontSize: 12),
            ),
            trailing: DropdownButton<int>(
              underline: const SizedBox(),
              value:
                  int.tryParse(data['financialMonthStart']?.toString() ?? '') ??
                  1,
              items: [
                for (var day = 1; day <= 28; day++)
                  DropdownMenuItem(value: day, child: Text('Day $day')),
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
          const Divider(height: 1, indent: 16, endIndent: 16),
          SwitchListTile(
            title: Text(
              'Allow Negative Balances',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              'Permit transactions when wallet funds are insufficient',
              style: GoogleFonts.plusJakartaSans(fontSize: 12),
            ),
            activeTrackColor: AppColors.emerald,
            activeThumbColor: Colors.white,
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
        title: const Text('Preferred Currency'),
        content: DropdownButtonFormField<String>(
          initialValue: value,
          items: const [
            DropdownMenuItem(value: 'USD', child: Text('USD - United States Dollar')),
            DropdownMenuItem(value: 'EUR', child: Text('EUR - Euro')),
            DropdownMenuItem(value: 'GBP', child: Text('GBP - British Pound')),
            DropdownMenuItem(value: 'LBP', child: Text('LBP - Lebanese Pound')),
            DropdownMenuItem(value: 'AED', child: Text('AED - UAE Dirham')),
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Categories'),
              DropdownButton<String>(
                underline: const SizedBox(),
                value: filter,
                items: const [
                  DropdownMenuItem(value: 'ALL', child: Text('All')),
                  DropdownMenuItem(value: 'SPENDING', child: Text('Spending')),
                  DropdownMenuItem(value: 'INCOME', child: Text('Income')),
                ],
                onChanged: (value) => setState(() => filter = value ?? 'ALL'),
              ),
            ],
          ),
          content: SizedBox(
            width: 360,
            height: 380,
            child: ListView(
              shrinkWrap: true,
              children: categories
                  .where((item) {
                    final type = item['appliesTo'];
                    return filter == 'ALL' || type == filter || type == 'BOTH';
                  })
                  .map((item) {
                    final isInc = item['appliesTo'] == 'INCOME';
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isInc ? AppColors.mintSoft : AppColors.crimsonSoft,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              isInc ? Icons.trending_up_rounded : Icons.shopping_bag_outlined,
                              color: isInc ? AppColors.emerald : AppColors.crimson,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'].toString(),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  item['appliesTo'].toString(),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18),
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
                                        title: const Text('Edit Category'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: name,
                                              decoration: const InputDecoration(labelText: 'Name'),
                                            ),
                                            const SizedBox(height: 12),
                                            DropdownButtonFormField<String>(
                                              initialValue: appliesTo,
                                              decoration: const InputDecoration(labelText: 'Applies to'),
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
                            icon: const Icon(Icons.archive_outlined, size: 18),
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
                    title: const Text('New Category'),
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
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('Add Category'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _serverConfigDialog(BuildContext context, WidgetRef ref) async {
    final client = ref.read(apiClientProvider);
    final controller = TextEditingController(text: client.currentBaseUrl);
    String? testResult;
    bool isTesting = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(
            'Backend Server',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Specify the API endpoint address for the Personal Money Tracker backend.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'API Base URL',
                    hintText: 'https://moneytrackerrrrrrrrrrrr.duckdns.org/api/v1',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Quick Presets:',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.cloud_done_rounded, size: 16),
                      label: const Text('Cloud (Online)'),
                      onPressed: () => setDialogState(
                        () => controller.text =
                            'https://moneytrackerrrrrrrrrrrr.duckdns.org/api/v1',
                      ),
                    ),
                    ActionChip(
                      label: const Text('Wi-Fi (192.168.10.127)'),
                      onPressed: () => setDialogState(
                        () => controller.text = 'http://192.168.10.127:4050/api/v1',
                      ),
                    ),
                    ActionChip(
                      label: const Text('ADB Reverse (127.0.0.1)'),
                      onPressed: () => setDialogState(
                        () => controller.text = 'http://127.0.0.1:4050/api/v1',
                      ),
                    ),
                    ActionChip(
                      label: const Text('Emulator (10.0.2.2)'),
                      onPressed: () => setDialogState(
                        () => controller.text = 'http://10.0.2.2:4050/api/v1',
                      ),
                    ),
                  ],
                ),
                if (testResult != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: testResult!.contains('Success')
                          ? AppColors.mintSoft
                          : AppColors.crimsonSoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      testResult!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: testResult!.contains('Success')
                            ? AppColors.emerald
                            : AppColors.crimson,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: isTesting
                      ? null
                      : () async {
                          setDialogState(() {
                            isTesting = true;
                            testResult = null;
                          });
                          final ok = await client.testConnection(controller.text.trim());
                          setDialogState(() {
                            isTesting = false;
                            testResult = ok
                                ? '✓ Successfully connected to backend!'
                                : '✗ Cannot reach server at this address';
                          });
                        },
                  icon: isTesting
                      ? const SizedBox.square(
                          dimension: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.network_check_rounded, size: 16),
                  label: const Text('Test Connection'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final newUrl = controller.text.trim();
                if (newUrl.isNotEmpty) {
                  await client.saveBaseUrl(newUrl);
                  ref.invalidate(apiClientProvider);
                  ref.invalidate(dashboardProvider);
                  ref.invalidate(accountsProvider);
                  ref.invalidate(walletsProvider);
                }
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              child: const Text('Save & Connect'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
  }
}
