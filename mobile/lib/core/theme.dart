import 'package:flutter/material.dart';

ThemeData appTheme() {
  const midnight = Color(0xff0b1724);
  const mint = Color(0xffa9efd0);
  const evergreen = Color(0xff287b62);
  const pearl = Color(0xfff5f7f4);
  final scheme =
      ColorScheme.fromSeed(
        seedColor: evergreen,
        brightness: Brightness.light,
      ).copyWith(
        primary: midnight,
        onPrimary: Colors.white,
        primaryContainer: mint,
        onPrimaryContainer: midnight,
        secondary: evergreen,
        onSecondary: Colors.white,
        secondaryContainer: const Color(0xffe0f5ea),
        onSecondaryContainer: const Color(0xff123b2d),
        tertiary: const Color(0xffc49349),
        error: const Color(0xffbd4c50),
        surface: Colors.white,
        onSurface: const Color(0xff162331),
        surfaceContainerHighest: const Color(0xffe9efeb),
        outline: const Color(0xffc8d4ce),
      );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: pearl,
    fontFamily: 'Avenir Next',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: midnight,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        color: midnight,
        fontSize: 23,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: midnight,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.1,
      ),
      headlineMedium: TextStyle(
        color: midnight,
        fontSize: 27,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
      ),
      titleLarge: TextStyle(
        color: midnight,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleMedium: TextStyle(
        color: midnight,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(
        color: Color(0xff425466),
        fontSize: 15,
        height: 1.35,
      ),
      bodyMedium: TextStyle(
        color: Color(0xff65747f),
        fontSize: 14,
        height: 1.3,
      ),
      labelLarge: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.1),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(color: evergreen, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(color: Color(0xffbd4c50)),
      ),
      labelStyle: const TextStyle(color: Color(0xff71808a)),
      floatingLabelStyle: const TextStyle(color: evergreen),
    ),
    cardTheme: const CardThemeData(
      margin: EdgeInsets.only(bottom: 12),
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Color(0x160b1724),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 74,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      indicatorColor: mint,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 11,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
          color: states.contains(WidgetState.selected)
              ? midnight
              : const Color(0xff71808a),
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          size: 22,
          color: states.contains(WidgetState.selected)
              ? midnight
              : const Color(0xff71808a),
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: midnight,
      foregroundColor: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        backgroundColor: midnight,
        foregroundColor: Colors.white,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        side: const BorderSide(color: Color(0xffc8d4ce)),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      selectedColor: mint,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 3),
      iconColor: evergreen,
      titleTextStyle: TextStyle(
        color: midnight,
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
      subtitleTextStyle: TextStyle(color: Color(0xff71808a), fontSize: 13),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xffe5ebe7),
      space: 20,
      thickness: 1,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: pearl,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      titleTextStyle: const TextStyle(
        color: midnight,
        fontSize: 21,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
