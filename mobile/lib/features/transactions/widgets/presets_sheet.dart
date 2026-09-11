import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/item_preset.dart';
import '../../../core/providers.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import 'preset_grid_card.dart';

class PresetsSheet extends ConsumerStatefulWidget {
  const PresetsSheet({
    this.onSelect,
    this.initialType = 'DYNAMIC_SPENDING',
    super.key,
  });

  final void Function(ItemPreset preset)? onSelect;
  final String initialType;

  static Future<void> show(
    BuildContext context, {
    void Function(ItemPreset preset)? onSelect,
    String initialType = 'DYNAMIC_SPENDING',
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PresetsSheet(
        onSelect: onSelect,
        initialType: initialType,
      ),
    );
  }

  @override
  ConsumerState<PresetsSheet> createState() => _PresetsSheetState();
}

class _PresetsSheetState extends ConsumerState<PresetsSheet> {
  bool isCreating = false;
  bool isGridView = true;
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  late String selectedType;
  String selectedIcon = '🏷️';

  static const availableIcons = [
    '☕', '🍔', '🛒', '⛽', '🚇', '💊', '🎬', '🏋️', '📚', '✂️', '✈️', '🎁', '💰', '💼', '🏷️'
  ];

  @override
  void initState() {
    super.initState();
    selectedType = widget.initialType;
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final presets = ref.watch(presetsProvider);
    final isIncome = selectedType.contains('INCOME');
    final accentColor = isIncome ? AppColors.emerald : AppColors.crimson;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: AppShadows.floating,
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.cardSurfaceAlt,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        alignment: Alignment.center,
                        child: const Text('⚡', style: TextStyle(fontSize: 20)),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isCreating ? 'New Quick Preset' : 'Quick Item Presets',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.midnight,
                            ),
                          ),
                          Text(
                            isCreating
                                ? 'Save item name & price for 1-tap entry'
                                : 'Tap any item to enter price immediately',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isCreating && presets.isNotEmpty)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isGridView = !isGridView;
                            });
                          },
                          icon: Icon(
                            isGridView
                                ? Icons.view_agenda_outlined
                                : Icons.grid_view_rounded,
                            color: AppColors.textSecondary,
                            size: 22,
                          ),
                          tooltip: isGridView ? 'List View' : 'Grid View',
                        ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isCreating = !isCreating;
                          });
                        },
                        icon: Icon(
                          isCreating
                              ? Icons.close_rounded
                              : Icons.add_circle_outline_rounded,
                          color: isCreating
                              ? AppColors.textSecondary
                              : AppColors.emerald,
                          size: 26,
                        ),
                        tooltip: isCreating ? 'Cancel' : 'Create Preset',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (isCreating) ...[
                // Creation Form
                _buildCreateForm(context, accentColor),
              ] else ...[
                // Presets List
                if (presets.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'No presets saved yet. Tap + to add one!',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  )
                else if (isGridView)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.25,
                    ),
                    itemCount: presets.length,
                    itemBuilder: (context, index) {
                      final preset = presets[index];
                      return PresetGridCard(
                        preset: preset,
                        layout: PresetCardLayout.detailed,
                        onTap: () {
                          if (widget.onSelect != null) {
                            Navigator.of(context).pop();
                            widget.onSelect!(preset);
                          }
                        },
                        onDelete: () => _deletePreset(preset),
                      );
                    },
                  )
                else
                  ...presets.map((preset) => _buildPresetTile(context, preset)),

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        ref.read(presetsProvider.notifier).resetDefaults();
                        AppToast.info(context, 'Reset to default presets');
                      },
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: Text(
                        'Restore Defaults',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.midnight,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      onPressed: () => setState(() => isCreating = true),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: Text(
                        'New Preset',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateForm(BuildContext context, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Type selector
          Row(
            children: [
              _typeChoice('Spending', 'DYNAMIC_SPENDING', AppColors.crimson),
              const SizedBox(width: 8),
              _typeChoice('Income', 'MAIN_INCOME', AppColors.emerald),
            ],
          ),
          const SizedBox(height: 14),

          // Icon picker strip
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: availableIcons.map((ic) {
                final isSel = selectedIcon == ic;
                return GestureDetector(
                  onTap: () => setState(() => selectedIcon = ic),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSel ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSel ? AppColors.midnight : AppColors.borderSubtle,
                        width: isSel ? 2 : 1,
                      ),
                    ),
                    child: Text(ic, style: const TextStyle(fontSize: 18)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Item Name',
              hintText: 'e.g. Morning Coffee, Protein Bar, Gas',
              prefixIcon: Icon(Icons.label_outline_rounded),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Default Price / Amount',
              hintText: '0.00',
              prefixIcon: Icon(Icons.attach_money_rounded),
            ),
          ),
          const SizedBox(height: 16),

          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.midnight,
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: _saveNewPreset,
            child: Text(
              'Save Preset',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeChoice(String label, String type, Color color) {
    final isSelected = selectedType == type;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => selectedType = type),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.12) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : AppColors.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? color : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPresetTile(BuildContext context, ItemPreset preset) {
    final isIncome = preset.type.contains('INCOME');
    final color = isIncome ? AppColors.emerald : AppColors.crimson;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (widget.onSelect != null) {
              Navigator.of(context).pop();
              widget.onSelect!(preset);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    preset.icon ?? (isIncome ? '💰' : '🏷️'),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        preset.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.midnight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isIncome ? 'Income' : 'Spending',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: color,
                              ),
                            ),
                          ),
                          if (preset.categoryName != null) ...[
                            const SizedBox(width: 6),
                            Text(
                              preset.categoryName!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${preset.amount.toStringAsFixed(2)}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    size: 20,
                    color: AppColors.textTertiary,
                  ),
                  onPressed: () => _deletePreset(preset),
                  tooltip: 'Delete preset',
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deletePreset(ItemPreset preset) async {
    final confirmed = await AppConfirmationSheet.show(
      context: context,
      title: 'Delete Preset?',
      message: 'Are you sure you want to delete preset "${preset.title}"?',
      confirmLabel: 'Delete',
      icon: Icons.delete_outline_rounded,
      confirmColor: AppColors.crimson,
    );
    if (!confirmed) return;
    ref.read(presetsProvider.notifier).deletePreset(preset.id);
    if (mounted) {
      AppToast.success(context, 'Preset "${preset.title}" deleted');
    }
  }

  void _saveNewPreset() {
    final title = titleController.text.trim();
    final amt = Decimal.tryParse(amountController.text.trim());

    if (title.isEmpty) {
      AppToast.error(context, 'Please enter an item name');
      return;
    }
    if (amt == null || amt <= Decimal.zero) {
      AppToast.error(context, 'Please enter a valid price');
      return;
    }

    final preset = ItemPreset(
      id: 'preset_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      amount: amt,
      type: selectedType,
      icon: selectedIcon,
    );

    ref.read(presetsProvider.notifier).savePreset(preset);
    setState(() {
      isCreating = false;
      titleController.clear();
      amountController.clear();
    });

    AppToast.success(context, 'Preset "$title" saved');
  }
}
