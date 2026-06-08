import 'package:flutter/widgets.dart';

import '../../../../core/localization/localization_extensions.dart';

String? amountValidator(BuildContext context, String? value) {
  if (value == null || value.trim().isEmpty) {
    return context.tr.amountRequired;
  }

  final num? parsedValue = num.tryParse(value.trim());
  if (parsedValue == null || parsedValue <= 0) {
    return context.tr.enterValidAmount;
  }

  return null;
}
