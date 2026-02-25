import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'constants.dart';

class DarkwoodTheme {
  DarkwoodTheme._();

  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    fontFamily: DarkwoodConstants.fontFamily,
    scaffoldBackgroundColor: DarkwoodColors.background,
    colorScheme: const ColorScheme.light(
      primary: DarkwoodColors.accent,
      onPrimary: DarkwoodColors.black,
      secondary: DarkwoodColors.paleAccent,
      onSecondary: DarkwoodColors.black,
      surface: DarkwoodColors.surface,
      onSurface: DarkwoodColors.textPrimary,
      error: DarkwoodColors.error,
      onError: DarkwoodColors.background,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: DarkwoodColors.background,
      foregroundColor: DarkwoodColors.black,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark),
      titleTextStyle: TextStyle(
        fontFamily: DarkwoodConstants.fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: DarkwoodColors.black,
        letterSpacing: 1.2,
      ),
    ),
    textTheme: const TextTheme(
      // Causten has sTypoLineGap=200 (20% extra line box) and a cap height
      // of 65% em vs ~72% for system fonts — so glyphs look ~10% smaller.
      // Pinning `height` on every style kills the lineGap and makes sizes
      // feel on-par with SF Pro / Roboto at the same pt value.
      displayLarge: TextStyle(
        fontFamily: DarkwoodConstants.fontFamily,
        fontSize: 52,
        fontWeight: FontWeight.w800,
        color: DarkwoodColors.black,
        letterSpacing: -0.5,
        height: 0.8,
      ),
      displayMedium: TextStyle(
        fontFamily: DarkwoodConstants.fontFamily,
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: DarkwoodColors.black,
        height: 0.8,
      ),
      headlineLarge: TextStyle(
        fontFamily: DarkwoodConstants.fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: DarkwoodColors.black,
        height: 0.9,
      ),
      headlineMedium: TextStyle(
        fontFamily: DarkwoodConstants.fontFamily,
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: DarkwoodColors.black,
        height: 0.9,
      ),
      titleLarge: TextStyle(
        fontFamily: DarkwoodConstants.fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: DarkwoodColors.black,
        height: 0.9,
      ),
      titleMedium: TextStyle(
        fontFamily: DarkwoodConstants.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: DarkwoodColors.black,
        height: 0.9,
      ),
      bodyLarge: TextStyle(
        fontFamily: DarkwoodConstants.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: DarkwoodColors.textPrimary,
        height: 1.2,
      ),
      bodyMedium: TextStyle(
        fontFamily: DarkwoodConstants.fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: DarkwoodColors.textSecondary,
        height: 1.2,
      ),
      bodySmall: TextStyle(
        fontFamily: DarkwoodConstants.fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: DarkwoodColors.textMuted,
        height: 1.1,
      ),
      labelLarge: TextStyle(
        fontFamily: DarkwoodConstants.fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: DarkwoodColors.black,
        letterSpacing: 0.8,
        height: 0.8,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DarkwoodColors.accent,
        foregroundColor: DarkwoodColors.black,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DarkwoodConstants.radiusLG)),
        textStyle: const TextStyle(fontFamily: DarkwoodConstants.fontFamily, fontSize: 19, fontWeight: FontWeight.w700, letterSpacing: 0.5),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: DarkwoodColors.black,
        foregroundColor: DarkwoodColors.accent,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DarkwoodConstants.radiusLG)),
        textStyle: const TextStyle(fontFamily: DarkwoodConstants.fontFamily, fontSize: 19, fontWeight: FontWeight.w700, letterSpacing: 0.5),
      ),
    ),
    dividerTheme: const DividerThemeData(color: DarkwoodColors.divider, thickness: 1),
  );
}
