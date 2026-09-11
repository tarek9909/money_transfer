import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../money.dart';
import '../theme.dart';

class AmountDisplay extends StatelessWidget {
  const AmountDisplay({
    required this.amount,
    super.key,
    this.currency = 'USD',
    this.isMasked = false,
    this.fontSize = 28,
    this.color,
    this.isSigned = false,
    this.isIncome,
  });

  final Object? amount;
  final String currency;
  final bool isMasked;
  final double fontSize;
  final Color? color;
  final bool isSigned;
  final bool? isIncome;

  @override
  Widget build(BuildContext context) {
    if (isMasked) {
      return Text(
        '••••••',
        style: GoogleFonts.plusJakartaSans(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          color: color ?? AppColors.midnight,
          letterSpacing: 2.0,
        ),
      );
    }

    final formatted = isSigned
        ? signedMoney(amount, currency: currency)
        : moneyValue(amount, currency: currency);

    final displayColor = color ??
        (isIncome == true
            ? AppColors.emerald
            : (isIncome == false ? AppColors.crimson : AppColors.midnight));

    return Text(
      formatted,
      style: GoogleFonts.plusJakartaSans(
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        color: displayColor,
        letterSpacing: -0.8,
      ),
    );
  }
}
