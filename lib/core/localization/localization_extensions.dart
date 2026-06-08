import 'package:flutter/widgets.dart';
import 'package:personal_wallet/l10n/app_localizations.dart';

extension LocalizationContextX on BuildContext {
  AppLocalizations get tr => AppLocalizations.of(this)!;
}
