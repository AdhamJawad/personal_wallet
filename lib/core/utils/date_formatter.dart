import 'package:intl/intl.dart';

final class DateFormatter {
  DateFormatter._();

  static final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('dd MMM yyyy, hh:mm a');

  static String short(DateTime value) => _dateFormat.format(value.toLocal());

  static String full(DateTime value) => _dateTimeFormat.format(value.toLocal());
}
