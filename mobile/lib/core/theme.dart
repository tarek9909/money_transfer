import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppColors {
  // Midnight & Obsidian foundation
  static const Color midnight = Color(0xFF090E17);
  static const Color obsidian = Color(0xFF0F172A);
  static const Color slateDark = Color(0xFF1E293B);
  static const Color slateMedium = Color(0xFF334155);

  // Luxury Accents
  static const Color emerald = Color(0xFF059669);
  static const Color emeraldLight = Color(0xFF10B981);
  static const Color mint = Color(0xFF00D589);
  static const Color mintSoft = Color(0xFFE6F9F0);
  static const Color mintContainer = Color(0xFFD1FAE5);

  // Secondary Accents
  static const Color indigo = Color(0xFF4F46E5);
  static const Color indigoLight = Color(0xFF6366F1);
  static const Color indigoSoft = Color(0xFFEEF2FF);

  static const Color amber = Color(0xFFD97706);
  static const Color amberLight = Color(0xFFF59E0B);
  static const Color amberSoft = Color(0xFFFEF3C7);

  static const Color crimson = Color(0xFFE11D48);
  static const Color crimsonLight = Color(0xFFF43F5E);
  static const Color crimsonSoft = Color(0xFFFFE4E6);

  // Surfaces & Backgrounds
  static const Color background = Color(0xFFF8FAFC);
  static const Color cardSurface = Colors.white;
  static const Color cardSurfaceAlt = Color(0xFFF1F5F9);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderSubtle = Color(0xFFF1F5F9);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
}

abstract final class AppGradients {
  static const LinearGradient luxuryDark = LinearGradient(
    colors: [Color(0xFF090E1A), Color(0xFF11232B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient titanium = LinearGradient(
    colors: [Color(0xFF182232), Color(0xFF0C1322)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emerald = LinearGradient(
    colors: [Color(0xFF059669), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient indigo = LinearGradient(
    colors: [Color(0xFF4338CA), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient crimson = LinearGradient(
    colors: [Color(0xFFBE123C), Color(0xFFF43F5E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGlow = LinearGradient(
    colors: [Color(0x1400D589), Color(0x00000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

abstract final class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0A0F172A),
      blurRadius: 18,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x050F172A),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> floating = [
    BoxShadow(
      color: Color(0x1A090E17),
      blurRadius: 28,
      offset: Offset(0, 10),
    ),
    BoxShadow(
      color: Color(0x0A090E17),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  static List<BoxShadow> glow(Color color, {double opacity = 0.22, double blur = 18}) => [
    BoxShadow(
      color: color.withValues(alpha: opacity),
      blurRadius: blur,
      offset: const Offset(0, 6),
    ),
  ];
}

ThemeData appTheme() {
  final baseTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
  );

  final textTheme = GoogleFonts.plusJakartaSansTextTheme(baseTheme.textTheme).copyWith(
    headlineLarge: GoogleFonts.plusJakartaSans(
      color: AppColors.midnight,
      fontSize: 32,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.2,
      height: 1.2,
    ),
    headlineMedium: GoogleFonts.plusJakartaSans(
      color: AppColors.midnight,
      fontSize: 26,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.8,
      height: 1.25,
    ),
    titleLarge: GoogleFonts.plusJakartaSans(
      color: AppColors.midnight,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.4,
    ),
    titleMedium: GoogleFonts.plusJakartaSans(
      color: AppColors.midnight,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2,
    ),
    titleSmall: GoogleFonts.plusJakartaSans(
      color: AppColors.textSecondary,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: GoogleFonts.plusJakartaSans(
      color: AppColors.textPrimary,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      height: 1.45,
    ),
    bodyMedium: GoogleFonts.plusJakartaSans(
      color: AppColors.textSecondary,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.4,
    ),
    bodySmall: GoogleFonts.plusJakartaSans(
      color: AppColors.textTertiary,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
    ),
    labelLarge: GoogleFonts.plusJakartaSans(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
    ),
    labelSmall: GoogleFonts.plusJakartaSans(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.8,
    ),
  );

  final scheme = ColorScheme.light(
    primary: AppColors.midnight,
    onPrimary: Colors.white,
    primaryContainer: AppColors.mintContainer,
    onPrimaryContainer: const Color(0xFF064E3B),
    secondary: AppColors.emerald,
    onSecondary: Colors.white,
    secondaryContainer: AppColors.mintSoft,
    onSecondaryContainer: const Color(0xFF065F46),
    tertiary: AppColors.indigo,
    onTertiary: Colors.white,
    tertiaryContainer: AppColors.indigoSoft,
    error: AppColors.crimson,
    onError: Colors.white,
    errorContainer: AppColors.crimsonSoft,
    surface: AppColors.cardSurface,
    onSurface: AppColors.textPrimary,
    surfaceContainerHighest: AppColors.cardSurfaceAlt,
    outline: AppColors.border,
    outlineVariant: AppColors.borderSubtle,
  );

  return baseTheme.copyWith(
    colorScheme: scheme,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.midnight,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w800,
      ),
      iconTheme: const IconThemeData(color: AppColors.midnight, size: 22),
    ),
    cardTheme: CardThemeData(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.cardSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.midnight, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.crimson, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.crimson, width: 1.8),
      ),
      labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
      floatingLabelStyle: const TextStyle(color: AppColors.midnight, fontWeight: FontWeight.w600),
      prefixIconColor: AppColors.textSecondary,
      suffixIconColor: AppColors.textSecondary,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColors.midnight,
        foregroundColor: Colors.white,
        elevation: 0,
        textStyle: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: const BorderSide(color: AppColors.border, width: 1.2),
        foregroundColor: AppColors.midnight,
        textStyle: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.emerald,
        textStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      selectedColor: AppColors.midnight,
      secondarySelectedColor: AppColors.midnight,
      side: const BorderSide(color: AppColors.border, width: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      labelStyle: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      secondaryLabelStyle: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      space: 22,
      thickness: 1,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
      titleTextStyle: GoogleFonts.plusJakartaSans(
        color: AppColors.midnight,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      dragHandleColor: AppColors.border,
      dragHandleSize: Size(44, 4),
    ),
  );
}
