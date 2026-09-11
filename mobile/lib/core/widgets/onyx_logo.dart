import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

/// Modern luxury brand mark for ONYX Personal Finance.
class OnyxLogo extends StatelessWidget {
  const OnyxLogo({
    super.key,
    this.size = 52,
    this.showText = false,
    this.subtitle,
  });

  final double size;
  final bool showText;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.midnight,
        borderRadius: BorderRadius.circular(size * 0.32),
        border: Border.all(
          color: AppColors.emerald.withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.emerald.withValues(alpha: 0.20),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.midnight.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.30),
        child: Image.asset(
          'assets/images/logo.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            decoration: const BoxDecoration(
              gradient: AppGradients.luxuryDark,
            ),
            child: Icon(
              Icons.diamond_outlined,
              color: AppColors.mint,
              size: size * 0.52,
            ),
          ),
        ),
      ),
    );

    if (!showText) return iconWidget;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        iconWidget,
        SizedBox(width: size * 0.26),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ONYX',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: size * 0.42,
                    fontWeight: FontWeight.w900,
                    color: AppColors.midnight,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.mint,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            Text(
              subtitle ?? 'Wealth Intelligence',
              style: GoogleFonts.plusJakartaSans(
                fontSize: (size * 0.22).clamp(10.0, 13.0),
                color: AppColors.emerald,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
