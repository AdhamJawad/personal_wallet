import 'package:flutter/material.dart';

extension AppTextStyles on BuildContext {
  TextTheme get _textTheme => Theme.of(this).textTheme;

  TextStyle get titleLarge => _textTheme.headlineSmall!;
  TextStyle get titleMedium => _textTheme.titleLarge!;
  TextStyle get bodyLarge => _textTheme.bodyLarge!;
}
