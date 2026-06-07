import 'package:flutter/material.dart';

String formatDashboardTimestamp(BuildContext context, DateTime value) {
  final MaterialLocalizations localizations = MaterialLocalizations.of(context);
  final DateTime localValue = value.toLocal();
  final String date = localizations.formatCompactDate(localValue);
  final String time = localizations.formatTimeOfDay(
    TimeOfDay.fromDateTime(localValue),
  );
  return '$date • $time';
}
