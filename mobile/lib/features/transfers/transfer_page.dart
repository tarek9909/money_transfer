import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../core/widgets/luxury_card.dart';

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
        title: Text(
          'Transfer Funds',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
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

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Visual Route Card
                TitaniumCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.north_east_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'FROM WALLET',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white.withValues(alpha: 0.6),
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                Text(
                                  _walletName(from, list),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            const SizedBox(width: 17),
                            Container(
                              width: 2,
                              height: 20,
                              color: AppColors.mint.withValues(alpha: 0.5),
                            ),
                            const SizedBox(width: 16),
                            const Icon(
                              Icons.arrow_downward_rounded,
                              color: AppColors.mint,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.mint.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.south_west_rounded,
                              color: AppColors.mint,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TO DESTINATION',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white.withValues(alpha: 0.6),
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                Text(
                                  _walletName(to, destinations),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Amount input Hero
                LuxuryCard(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                  child: Column(
                    children: [
                      Text(
                        'TRANSFER AMOUNT',
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
                        textAlign: TextAlign.center,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: AppColors.indigo,
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
                      if (currency != null)
                        Text(
                          currency,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        alignment: WrapAlignment.center,
                        children: [
                          _presetChip(10),
                          _presetChip(25),
                          _presetChip(50),
                          _presetChip(100),
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
                const SizedBox(height: 14),

                // Selection Form
                LuxuryCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _dropdown(
                        'Source Wallet (From)',
                        from,
                        list,
                        (value) => setState(() => from = value),
                      ),
                      const SizedBox(height: 14),
                      _dropdown(
                        'Destination Wallet (To)',
                        to,
                        destinations,
                        (value) => setState(() => to = value),
                      ),
                      if (destinations.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Add another wallet with the same currency to enable transfers.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.crimson,
                            ),
                          ),
                        ),
                      const SizedBox(height: 14),
                      InkWell(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
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
                                    size: 18,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _formatDate(transferDate),
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
                        controller: notes,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Notes (optional)',
                          prefixIcon: Icon(Icons.edit_note_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.midnight,
                    minimumSize: const Size.fromHeight(56),
                    elevation: 4,
                  ),
                  onPressed: saving || destinations.isEmpty ? null : _save,
                  child: saving
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Execute Transfer',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
                const SizedBox(height: 36),
              ],
            ),
          );
        },
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

  String _walletName(String? id, List<dynamic> list) {
    if (id == null) return 'Select wallet';
    for (final raw in list) {
      final item = Map<String, dynamic>.from(raw as Map);
      if (item['id'] == id) {
        return '${item['name']} (${item['currencyCode']})';
      }
    }
    return 'Wallet';
  }

  Widget _dropdown(
    String label,
    String? value,
    List<dynamic> items,
    ValueChanged<String?> onChanged,
  ) =>
      DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
        ),
        items: items.map((raw) {
          final item = Map<String, dynamic>.from(raw as Map);
          return DropdownMenuItem(
            value: item['id'] as String,
            child: Text('${item['name']} (${item['currencyCode']})'),
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
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
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

  Widget _presetChip(int amountToAdd) {
    return ActionChip(
      label: Text(
        '+$amountToAdd',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.indigo,
        ),
      ),
      backgroundColor: AppColors.indigoSoft,
      side: BorderSide(color: AppColors.indigo.withValues(alpha: 0.2)),
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
}

String _formatDate(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
