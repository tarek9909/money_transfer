import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/item_preset.dart';
import '../../core/models.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../core/widgets/luxury_card.dart';
import 'widgets/presets_sheet.dart';

class AddEntryPage extends ConsumerStatefulWidget {
  const AddEntryPage({
    required this.type,
    this.transactionId,
    this.initialAmount,
    this.initialDescription,
    super.key,
  });
  final String type;
  final String? transactionId;
  final String? initialAmount;
  final String? initialDescription;
  @override
  ConsumerState<AddEntryPage> createState() => _AddEntryPageState();
}

class _AddEntryPageState extends ConsumerState<AddEntryPage> {
  final amount = TextEditingController();
  final description = TextEditingController();
  final notes = TextEditingController();
  late String currentType;
  String? walletId;
  String? categoryId;
  DateTime date = DateTime.now();
  bool saving = false;
  Map<String, dynamic>? existing;

  @override
  void initState() {
    super.initState();
    currentType = widget.type;
    if (widget.initialAmount != null && widget.initialAmount!.isNotEmpty) {
      amount.text = widget.initialAmount!;
    }
    if (widget.initialDescription != null &&
        widget.initialDescription!.isNotEmpty) {
      description.text = widget.initialDescription!;
    }
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
        currentType = item['transactionType']?.toString() ?? widget.type;
        date = DateTime.tryParse(item['transactionDate'].toString()) ?? date;
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
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
    final isIncome = currentType.contains('INCOME');
    final categories = ref.watch(
      isIncome ? incomeCategoriesProvider : categoriesProvider,
    );
    final isEdit = existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Transaction' : 'Record Transaction',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: wallets.when(
        data: (walletItems) => categories.when(
          data: (categoryItems) => _form(
            context,
            List<dynamic>.from(walletItems),
            List<dynamic>.from(categoryItems),
            isEdit,
          ),
          error: (error, _) => Center(
            child: Text(
              'Categories unavailable: $error',
              style: GoogleFonts.plusJakartaSans(color: AppColors.crimson),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.midnight),
          ),
        ),
        error: (error, _) => Center(
          child: Text(
            'Wallets unavailable: $error',
            style: GoogleFonts.plusJakartaSans(color: AppColors.crimson),
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.midnight),
        ),
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

    final isIncome = currentType.contains('INCOME');
    final accentColor = isIncome ? AppColors.emerald : AppColors.crimson;

    return RefreshIndicator(
      color: AppColors.midnight,
      onRefresh: () async {
        ref.invalidate(walletsProvider);
        ref.invalidate(categoriesProvider);
        ref.invalidate(accountsProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Type selector
          if (!isEdit) ...[
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.cardSurfaceAlt,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  _typeTab(
                    label: 'Spending',
                    type: 'DYNAMIC_SPENDING',
                    icon: Icons.shopping_bag_outlined,
                    color: AppColors.crimson,
                  ),
                  _typeTab(
                    label: 'Main Income',
                    type: 'MAIN_INCOME',
                    icon: Icons.account_balance_outlined,
                    color: AppColors.emerald,
                  ),
                  _typeTab(
                    label: 'Extra Income',
                    type: 'ADDITIONAL_INCOME',
                    icon: Icons.add_card_outlined,
                    color: const Color(0xFF0D9488),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Quick Presets Bar
          if (!isEdit) _quickPresetsBar(context, categoryItems),

          // Amount Card Hero
          LuxuryCard(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            borderColor: accentColor.withValues(alpha: 0.2),
            child: Column(
              children: [
                Text(
                  'AMOUNT',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: amount,
                  autofocus: !isEdit,
                  textAlign: TextAlign.center,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: accentColor,
                    letterSpacing: -1.0,
                  ),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      color: AppColors.textTertiary,
                    ),
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: [
                    _presetChip(10, accentColor),
                    _presetChip(25, accentColor),
                    _presetChip(50, accentColor),
                    _presetChip(100, accentColor),
                    if (amount.text.isNotEmpty && amount.text != '0.00')
                      ActionChip(
                        label: Text(
                          'Clear',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        backgroundColor: AppColors.background,
                        side: const BorderSide(color: AppColors.borderSubtle),
                        onPressed: () => setState(() => amount.clear()),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Form fields card
          LuxuryCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: walletId,
                  decoration: const InputDecoration(
                    labelText: 'Wallet',
                    prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                  ),
                  items: walletItems.map((raw) {
                    final item = Map<String, dynamic>.from(raw as Map);
                    return DropdownMenuItem(
                      value: item['id'] as String,
                      child: Text('${item['name']} (${item['currencyCode']})'),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => walletId = value),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String?>(
                  initialValue: categoryId,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Uncategorized'),
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
                const SizedBox(height: 14),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              formatDate(date),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.midnight,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Change',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.emerald,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: description,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: notes,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    prefixIcon: Icon(Icons.edit_note_rounded),
                  ),
                ),
                if (!isEdit) ...[
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.midnight,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _saveCurrentAsPreset,
                    icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                    label: Text(
                      'Save as Quick Preset',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Submit CTA
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.midnight,
              minimumSize: const Size.fromHeight(56),
              elevation: 4,
              shadowColor: AppColors.midnight.withValues(alpha: 0.3),
            ),
            onPressed: saving ? null : () => _save(isEdit),
            child: saving
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    isEdit ? 'Save Changes' : 'Record Transaction',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
          const SizedBox(height: 36),
        ],
      ),
    ),
  );
}

  Widget _presetChip(int amountToAdd, Color color) {
    return ActionChip(
      label: Text(
        '+$amountToAdd',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
      backgroundColor: color.withValues(alpha: 0.08),
      side: BorderSide(color: color.withValues(alpha: 0.2)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: () {
        final cur = Decimal.tryParse(amount.text.trim()) ?? Decimal.zero;
        final next = cur + Decimal.fromInt(amountToAdd);
        setState(() {
          amount.text = next.toStringAsFixed(2);
        });
      },
    );
  }

  Widget _quickPresetsBar(BuildContext context, List<dynamic> categories) {
    final presets = ref.watch(presetsProvider);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('⚡', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    'QUICK ITEM PRESETS',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => PresetsSheet.show(
                  context,
                  initialType: currentType,
                  onSelect: (preset) => _applyPreset(preset, categories),
                ),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.tune_rounded, size: 14, color: AppColors.emerald),
                      const SizedBox(width: 4),
                      Text(
                        'Manage',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.emerald,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...presets.map((p) => _itemPresetChip(p, categories)),
                ActionChip(
                  avatar: const Icon(Icons.add_rounded, size: 16, color: AppColors.midnight),
                  label: Text(
                    'New Preset',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.midnight,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onPressed: () => PresetsSheet.show(
                    context,
                    initialType: currentType,
                    onSelect: (preset) => _applyPreset(preset, categories),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemPresetChip(ItemPreset preset, List<dynamic> categories) {
    final isIncome = preset.type.contains('INCOME');
    final color = isIncome ? AppColors.emerald : AppColors.crimson;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        avatar: Text(
          preset.icon ?? (isIncome ? '💰' : '🏷️'),
          style: const TextStyle(fontSize: 14),
        ),
        label: Text(
          '${preset.title} · \$${preset.amount.toStringAsFixed(2)}',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.midnight,
          ),
        ),
        backgroundColor: Colors.white,
        side: BorderSide(color: color.withValues(alpha: 0.3)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onPressed: () => _applyPreset(preset, categories),
      ),
    );
  }

  void _applyPreset(ItemPreset preset, List<dynamic> categories) {
    if (!mounted) return;
    setState(() {
      amount.text = preset.amount.toStringAsFixed(2);
      description.text = preset.title;
      currentType = preset.type;
      if (preset.categoryId != null) {
        final match = categories.any((c) => (c as Map)['id'] == preset.categoryId);
        if (match) categoryId = preset.categoryId;
      } else if (preset.categoryName != null) {
        final match = categories.cast<Map<dynamic, dynamic>>().where(
          (c) => c['name'].toString().toLowerCase().contains(preset.categoryName!.toLowerCase()),
        ).firstOrNull;
        if (match != null) categoryId = match['id'].toString();
      }
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Applied "${preset.title}" (\$${preset.amount.toStringAsFixed(2)})'),
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  void _saveCurrentAsPreset() {
    if (!mounted) return;
    final title = description.text.trim();
    final amt = Decimal.tryParse(amount.text.trim());
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a description or item name to save as preset')),
      );
      return;
    }
    if (amt == null || amt <= Decimal.zero) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid amount to save as preset')),
      );
      return;
    }

    final preset = ItemPreset(
      id: 'preset_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      amount: amt,
      type: currentType,
      categoryId: categoryId,
      icon: currentType.contains('INCOME') ? '💰' : '🏷️',
    );
    ref.read(presetsProvider.notifier).savePreset(preset);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Preset "$title" (\$${amt.toStringAsFixed(2)}) saved!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _typeTab({
    required String label,
    required String type,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = currentType == type;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() {
          currentType = type;
          categoryId = null; // reset category on type change
        }),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected ? AppShadows.card : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? color : AppColors.textTertiary,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? AppColors.midnight : AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
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
      transactionType: currentType,
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
        ).showSnackBar(const SnackBar(content: Text('Saved successfully')));
        context.pop();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }
}

String titleFor(String type) => switch (type) {
  'MAIN_INCOME' => 'Main Income',
  'ADDITIONAL_INCOME' => 'Additional Income',
  _ => 'Dynamic Spending',
};

String formatDate(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
