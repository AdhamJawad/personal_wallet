import 'package:intl/intl.dart';

final class DateFormatter {
  DateFormatter._();

  static String _datePattern = 'dd/MM/yyyy';
  static String _locale = 'ar';
  static DateFormat _dateFormat = DateFormat(_datePattern, _locale);
  static DateFormat _dateTimeFormat = DateFormat(
    '$_datePattern, hh:mm a',
    _locale,
  );

  static void configure({
    required String dateFormatPattern,
    required String locale,
  }) {
    final String resolvedPattern = _resolvePattern(dateFormatPattern);
    if (_datePattern == resolvedPattern && _locale == locale) {
      return;
    }

    _datePattern = resolvedPattern;
    _locale = locale;
    _dateFormat = DateFormat(_datePattern, _locale);
    _dateTimeFormat = DateFormat('$_datePattern, hh:mm a', _locale);
  }

  static String short(DateTime value) => _dateFormat.format(value.toLocal());

  static String full(DateTime value) => _dateTimeFormat.format(value.toLocal());

  static String _resolvePattern(String value) {
    return switch (value.toUpperCase()) {
      'MM/DD/YYYY' => 'MM/dd/yyyy',
      _ => 'dd/MM/yyyy',
    };
  }
}
