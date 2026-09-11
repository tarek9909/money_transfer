import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

enum BadgeVariant {
  income,
  expense,
  transfer,
  warning,
  neutral,
  accent,
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.label,
    super.key,
    this.variant = BadgeVariant.neutral,
    this.icon,
    this.compact = false,
  });

  final String label;
  final BadgeVariant variant;
  final IconData? icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (variant) {
      BadgeVariant.income => (AppColors.mintSoft, AppColors.emerald),
      BadgeVariant.expense => (AppColors.crimsonSoft, AppColors.crimson),
      BadgeVariant.transfer => (AppColors.indigoSoft, AppColors.indigo),
      BadgeVariant.warning => (AppColors.amberSoft, AppColors.amber),
      BadgeVariant.accent => (AppColors.midnight, Colors.white),
      BadgeVariant.neutral => (AppColors.cardSurfaceAlt, AppColors.textSecondary),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(compact ? 8 : 10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: compact ? 12 : 14, color: fg),
            SizedBox(width: compact ? 3 : 5),
          ],
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: fg,
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
