import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  Future<T?> push<T>(Widget page) => Navigator.of(this).push<T>(
        MaterialPageRoute<T>(builder: (_) => page),
      );

  Future<T?> pushReplacement<T>(Widget page) =>
      Navigator.of(this).pushReplacement<T, dynamic>(
        MaterialPageRoute<T>(builder: (_) => page),
      );

  void pop<T>([T? result]) => Navigator.of(this).pop<T>(result);

  void popUntilFirst() =>
      Navigator.of(this).popUntil((route) => route.isFirst);

  bool get canPop => Navigator.of(this).canPop();
}

extension TextThemeExtension on BuildContext {
  TextTheme get _tt => Theme.of(this).textTheme;

  TextStyle? get displayLarge  => _tt.displayLarge;
  TextStyle? get displayMedium => _tt.displayMedium;
  TextStyle? get displaySmall  => _tt.displaySmall;

  TextStyle? get headlineLarge  => _tt.headlineLarge;
  TextStyle? get headlineMedium => _tt.headlineMedium;
  TextStyle? get headlineSmall  => _tt.headlineSmall;

  TextStyle? get titleLarge  => _tt.titleLarge;
  TextStyle? get titleMedium => _tt.titleMedium;
  TextStyle? get titleSmall  => _tt.titleSmall;

  TextStyle? get bodyLarge  => _tt.bodyLarge;
  TextStyle? get bodyMedium => _tt.bodyMedium;
  TextStyle? get bodySmall  => _tt.bodySmall;

  TextStyle? get labelLarge  => _tt.labelLarge;
  TextStyle? get labelMedium => _tt.labelMedium;
  TextStyle? get labelSmall  => _tt.labelSmall;
}
