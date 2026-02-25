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
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
          ),
          titleTextStyle: TextStyle(
            fontFamily: DarkwoodConstants.fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: DarkwoodColors.black,
            letterSpacing: 1.2,
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: DarkwoodConstants.fontFamily,
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: DarkwoodColors.black,
            letterSpacing: -0.5,
          ),
          displayMedium: TextStyle(
            fontFamily: DarkwoodConstants.fontFamily,
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: DarkwoodColors.black,
          ),
          headlineLarge: TextStyle(
            fontFamily: DarkwoodConstants.fontFamily,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: DarkwoodColors.black,
          ),
          headlineMedium: TextStyle(
            fontFamily: DarkwoodConstants.fontFamily,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: DarkwoodColors.black,
          ),
          titleLarge: TextStyle(
            fontFamily: DarkwoodConstants.fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: DarkwoodColors.black,
          ),
          titleMedium: TextStyle(
            fontFamily: DarkwoodConstants.fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: DarkwoodColors.black,
          ),
          bodyLarge: TextStyle(
            fontFamily: DarkwoodConstants.fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: DarkwoodColors.textPrimary,
          ),
          bodyMedium: TextStyle(
            fontFamily: DarkwoodConstants.fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: DarkwoodColors.textSecondary,
          ),
          bodySmall: TextStyle(
            fontFamily: DarkwoodConstants.fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: DarkwoodColors.textMuted,
          ),
          labelLarge: TextStyle(
            fontFamily: DarkwoodConstants.fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: DarkwoodColors.black,
            letterSpacing: 0.8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: DarkwoodColors.accent,
            foregroundColor: DarkwoodColors.black,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DarkwoodConstants.radiusLG),
            ),
            textStyle: const TextStyle(
              fontFamily: DarkwoodConstants.fontFamily,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: DarkwoodColors.divider,
          thickness: 1,
        ),
      );
}
