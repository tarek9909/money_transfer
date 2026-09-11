import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/money.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../core/widgets/app_bottom_sheet.dart';
import '../../core/widgets/luxury_card.dart';
import '../../core/widgets/status_badge.dart';

class AccountsPage extends ConsumerWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);
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
                        'Accounts & Wallets',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.midnight,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'Manage your financial repositories',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => _openAddAccountDialog(context),
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.midnight,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.midnight.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
                    ),
                    tooltip: 'Add Account',
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.midnight,
                onRefresh: () async {
                  ref.invalidate(accountsProvider);
                  ref.invalidate(walletsProvider);
                },
                child: accounts.when(
                  skipLoadingOnReload: true,
                  skipLoadingOnRefresh: true,
                  data: (items) => items.isEmpty
                      ? _empty(context)
                      : ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 150),
                          children: [
                            _netWorthBanner(items),
                            const SizedBox(height: 12),
                            ...items.map(
                              (raw) => _account(
                                context,
                                ref,
                                Map<String, dynamic>.from(raw as Map),
                              ),
                            ),
                          ],
                        ),
                  error: (error, _) => ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    children: [
                      const SizedBox(height: 60),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: AppColors.crimson,
                              size: 36,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Could not load accounts: $error',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.midnight,
                      strokeWidth: 2.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _netWorthBanner(List<dynamic> accounts) {
    final currencyTotals = <String, Decimal>{};
    int totalWallets = 0;

    for (final rawAcc in accounts) {
      final acc = rawAcc as Map;
      final wallets = List<dynamic>.from(acc['wallets'] ?? const []);
      totalWallets += wallets.length;
      for (final rawW in wallets) {
        final w = rawW as Map;
        final curr = w['currencyCode']?.toString() ?? 'USD';
        final bal = Decimal.tryParse(w['currentBalance']?.toString() ?? '0') ?? Decimal.zero;
        currencyTotals[curr] = (currencyTotals[curr] ?? Decimal.zero) + bal;
      }
    }

    return TitaniumCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AGGREGATED NET WORTH',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              StatusBadge(
                label: '$totalWallets wallets',
                variant: BadgeVariant.income,
                compact: true,
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (currencyTotals.isEmpty)
            Text(
              'No active funds',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            )
          else
            ...currencyTotals.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  moneyValue(e.value, currency: e.key),
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _empty(BuildContext context) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.fromLTRB(32, 48, 32, 100),
    children: [
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: const BoxDecoration(
                color: AppColors.mintSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_balance_wallet_rounded,
                color: AppColors.emerald,
                size: 36,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Create your first account',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.midnight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Add cash, bank accounts, or digital wallets to track balances accurately.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => _openAddAccountDialog(context),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Add Account'),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    ],
  );

  Widget _account(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> item,
  ) {
    final wallets = List<dynamic>.from(item['wallets'] ?? const []);
    return LuxuryCard(
      padding: EdgeInsets.zero,
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.fromLTRB(16, 6, 12, 6),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.indigoSoft,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.account_balance_rounded,
            color: AppColors.indigo,
            size: 22,
          ),
        ),
        title: Text(
          item['name'].toString(),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.midnight,
          ),
        ),
        subtitle: Text(
          '${wallets.length} wallet${wallets.length == 1 ? '' : 's'}',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded, color: AppColors.textTertiary),
          onSelected: (value) async {
            if (value == 'edit') {
              await _openEditAccountDialog(context, item);
              return;
            }
            if (value == 'archive') {
              final confirmed = await AppConfirmationSheet.show(
                context: context,
                title: 'Archive Account?',
                message:
                    'Are you sure you want to archive "${item['name']}"? All associated wallets will also be archived.',
                confirmLabel: 'Archive',
                icon: Icons.archive_outlined,
                confirmColor: AppColors.amber,
              );
              if (!confirmed) return;
              try {
                await ref
                    .read(apiClientProvider)
                    .archiveAccount(item['id'] as String);
                ref.invalidate(accountsProvider);
                ref.invalidate(walletsProvider);
                if (context.mounted) {
                  AppToast.success(
                    context,
                    'Account "${item['name']}" archived',
                  );
                }
              } catch (error) {
                if (context.mounted) {
                  AppToast.error(context, error.toString());
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
          const Divider(height: 1, indent: 16, endIndent: 16),
          ...wallets.map((raw) {
            final wallet = Map<String, dynamic>.from(raw as Map);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.borderSubtle, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.cardSurfaceAlt,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: AppColors.midnight,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wallet['name'].toString(),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.midnight,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${wallet['walletTypeCode']} · ',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            StatusBadge(
                              label: wallet['currencyCode'].toString(),
                              compact: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    moneyValue(
                      wallet['currentBalance'],
                      currency: wallet['currencyCode'].toString(),
                    ),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.midnight,
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_horiz_rounded,
                        color: AppColors.textTertiary, size: 18),
                    onSelected: (value) async {
                      if (value == 'edit') {
                        await _openEditWalletDialog(context, wallet);
                        return;
                      }
                      if (value != 'archive') return;
                      final confirmed = await AppConfirmationSheet.show(
                        context: context,
                        title: 'Archive Wallet?',
                        message:
                            'Are you sure you want to archive "${wallet['name']}"?',
                        confirmLabel: 'Archive',
                        icon: Icons.archive_outlined,
                        confirmColor: AppColors.amber,
                      );
                      if (!confirmed) return;
                      try {
                        await ref
                            .read(apiClientProvider)
                            .archiveWallet(wallet['id'] as String);
                        ref.invalidate(accountsProvider);
                        ref.invalidate(walletsProvider);
                        if (context.mounted) {
                          AppToast.success(
                            context,
                            'Wallet "${wallet['name']}" archived',
                          );
                        }
                      } catch (error) {
                        if (context.mounted) {
                          AppToast.error(context, error.toString());
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _openAddWalletDialog(context, item),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Add wallet'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openAddAccountDialog(BuildContext context) async {
    final res = await showAppBottomSheet<bool>(
      context: context,
      builder: (_) => const _AddAccountDialog(),
    );
    if (res == true && context.mounted) {
      AppToast.success(context, 'Account created successfully');
    }
  }

  Future<void> _openEditAccountDialog(
    BuildContext context,
    Map<String, dynamic> account,
  ) async {
    final res = await showAppBottomSheet<bool>(
      context: context,
      builder: (_) => _EditAccountDialog(account: account),
    );
    if (res == true && context.mounted) {
      AppToast.success(context, 'Account updated successfully');
    }
  }

  Future<void> _openAddWalletDialog(
    BuildContext context,
    Map<String, dynamic> account,
  ) async {
    final res = await showAppBottomSheet<bool>(
      context: context,
      builder: (_) => _AddWalletDialog(account: account),
    );
    if (res == true && context.mounted) {
      AppToast.success(context, 'Wallet created successfully');
    }
  }

  Future<void> _openEditWalletDialog(
    BuildContext context,
    Map<String, dynamic> wallet,
  ) async {
    final res = await showAppBottomSheet<bool>(
      context: context,
      builder: (_) => _EditWalletDialog(wallet: wallet),
    );
    if (res == true && context.mounted) {
      AppToast.success(context, 'Wallet updated successfully');
    }
  }
}

class _AddAccountDialog extends ConsumerStatefulWidget {
  const _AddAccountDialog();

  @override
  ConsumerState<_AddAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends ConsumerState<_AddAccountDialog> {
  late final TextEditingController _controller;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await ref.read(apiClientProvider).createAccount({'name': name});
      ref.invalidate(accountsProvider);
      ref.invalidate(walletsProvider);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: 'New Account',
      subtitle: 'Group multiple currency wallets under an institution.',
      icon: Icons.account_balance_rounded,
      iconColor: AppColors.indigo,
      iconBackground: AppColors.indigoSoft,
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
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
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  'Create Account',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                  ),
                ),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Account Name',
              hintText: 'e.g. Chase Bank, Main Cash, Revolut',
            ),
            onSubmitted: (_) => _saving ? null : _submit(),
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(
              _error!,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.crimson,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EditAccountDialog extends ConsumerStatefulWidget {
  const _EditAccountDialog({required this.account});
  final Map<String, dynamic> account;

  @override
  ConsumerState<_EditAccountDialog> createState() => _EditAccountDialogState();
}

class _EditAccountDialogState extends ConsumerState<_EditAccountDialog> {
  late final TextEditingController _controller;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.account['name']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await ref.read(apiClientProvider).updateAccount(
        widget.account['id'] as String,
        {'name': name},
      );
      ref.invalidate(accountsProvider);
      ref.invalidate(walletsProvider);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: 'Edit Account',
      subtitle: 'Update the account name across linked wallets.',
      icon: Icons.edit_rounded,
      iconColor: AppColors.indigo,
      iconBackground: AppColors.indigoSoft,
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
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
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  'Save Changes',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                  ),
                ),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Account Name'),
            onSubmitted: (_) => _saving ? null : _submit(),
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(
              _error!,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.crimson,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AddWalletDialog extends ConsumerStatefulWidget {
  const _AddWalletDialog({required this.account});
  final Map<String, dynamic> account;

  @override
  ConsumerState<_AddWalletDialog> createState() => _AddWalletDialogState();
}

class _AddWalletDialogState extends ConsumerState<_AddWalletDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _currencyController;
  late final TextEditingController _balanceController;
  String _type = 'CHECKING';
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _currencyController = TextEditingController(text: 'USD');
    _balanceController = TextEditingController(text: '0.00');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currencyController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final currency = _currencyController.text.trim().toUpperCase();
    if (name.isEmpty) {
      setState(() => _error = 'Wallet name is required');
      return;
    }
    if (currency.length != 3) {
      setState(() => _error = 'Currency code must be 3 letters (e.g. USD, EUR, LBP)');
      return;
    }

    final initial = Decimal.tryParse(_balanceController.text.trim()) ?? Decimal.zero;

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await ref.read(apiClientProvider).createWallet({
        'accountId': widget.account['id'],
        'name': name,
        'walletTypeCode': _type,
        'currencyCode': currency,
        'openingBalance': initial.toString(),
      });
      ref.invalidate(accountsProvider);
      ref.invalidate(walletsProvider);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: 'Add Wallet',
      subtitle: 'Account: ${widget.account['name']}',
      icon: Icons.account_balance_wallet_rounded,
      iconColor: AppColors.emerald,
      iconBackground: AppColors.mintSoft,
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
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
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  'Add Wallet',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                  ),
                ),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _nameController,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Wallet Name',
              hintText: 'e.g. Daily Spending, Savings',
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: _type,
            decoration: const InputDecoration(labelText: 'Type'),
            items: const [
              DropdownMenuItem(value: 'CASH', child: Text('Cash')),
              DropdownMenuItem(value: 'CHECKING', child: Text('Checking')),
              DropdownMenuItem(value: 'SAVINGS', child: Text('Savings')),
              DropdownMenuItem(value: 'CREDIT_CARD', child: Text('Credit Card')),
              DropdownMenuItem(value: 'DIGITAL', child: Text('Digital')),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _type = value);
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _currencyController,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: 'Currency Code',
              hintText: 'USD, EUR, LBP',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _balanceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Initial Balance',
              prefixText: '\$ ',
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(
              _error!,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.crimson,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EditWalletDialog extends ConsumerStatefulWidget {
  const _EditWalletDialog({required this.wallet});
  final Map<String, dynamic> wallet;

  @override
  ConsumerState<_EditWalletDialog> createState() => _EditWalletDialogState();
}

class _EditWalletDialogState extends ConsumerState<_EditWalletDialog> {
  late final TextEditingController _nameController;
  late String _type;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.wallet['name']?.toString() ?? '',
    );
    _type = widget.wallet['walletTypeCode']?.toString() ?? 'CHECKING';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await ref.read(apiClientProvider).updateWallet(
        widget.wallet['id'] as String,
        {
          'name': name,
          'walletTypeCode': _type,
        },
      );
      ref.invalidate(accountsProvider);
      ref.invalidate(walletsProvider);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: 'Edit Wallet',
      subtitle: 'Change wallet name or classification type.',
      icon: Icons.edit_rounded,
      iconColor: AppColors.emerald,
      iconBackground: AppColors.mintSoft,
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
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
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  'Save Changes',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                  ),
                ),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _nameController,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Wallet Name'),
            onSubmitted: (_) => _saving ? null : _submit(),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: _type,
            decoration: const InputDecoration(labelText: 'Type'),
            items: const [
              DropdownMenuItem(value: 'CASH', child: Text('Cash')),
              DropdownMenuItem(value: 'CHECKING', child: Text('Checking')),
              DropdownMenuItem(value: 'SAVINGS', child: Text('Savings')),
              DropdownMenuItem(value: 'CREDIT_CARD', child: Text('Credit Card')),
              DropdownMenuItem(value: 'DIGITAL', child: Text('Digital')),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _type = value);
            },
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(
              _error!,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.crimson,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
