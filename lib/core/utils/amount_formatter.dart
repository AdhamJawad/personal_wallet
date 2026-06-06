import 'package:intl/intl.dart';

final class AmountFormatter {
  AmountFormatter._();

  static final NumberFormat _currencyFormatter = NumberFormat.decimalPattern();

  static String format(String amount) {
    final num parsedAmount = num.tryParse(amount) ?? 0;
    return _currencyFormatter.format(parsedAmount);
  }
}
