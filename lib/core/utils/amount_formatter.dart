import 'package:intl/intl.dart';

final class AmountFormatter {
  AmountFormatter._();

  static final NumberFormat _currencyFormatter = NumberFormat.decimalPattern();
  static final NumberFormat _minorCurrencyFormatter = NumberFormat('#,##0.##');
  static const int _defaultFractionDigits = 2;

  static String format(String amount) {
    final num parsedAmount = num.tryParse(amount) ?? 0;
    return _currencyFormatter.format(parsedAmount);
  }

  static String formatMinor(
    int amountMinor, {
    int fractionDigits = _defaultFractionDigits,
  }) {
    final num parsedAmount = amountMinor / _minorMultiplier(fractionDigits);
    return _minorCurrencyFormatter.format(parsedAmount);
  }

  static int parseToMinor(
    String amount, {
    int fractionDigits = _defaultFractionDigits,
  }) {
    final String normalized = amount.replaceAll(',', '').trim();
    final num parsedAmount = num.tryParse(normalized) ?? 0;
    return (parsedAmount * _minorMultiplier(fractionDigits)).round();
  }

  static num majorFromMinor(
    int amountMinor, {
    int fractionDigits = _defaultFractionDigits,
  }) {
    return amountMinor / _minorMultiplier(fractionDigits);
  }

  static int _minorMultiplier(int fractionDigits) {
    return switch (fractionDigits) {
      0 => 1,
      1 => 10,
      2 => 100,
      3 => 1000,
      _ => 100,
    };
  }
}
