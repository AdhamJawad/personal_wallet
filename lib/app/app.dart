import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_wallet/l10n/app_localizations.dart';

import '../core/localization/localization_extensions.dart';
import '../core/utils/date_formatter.dart';
import '../features/auth/presentation/widgets/app_security_gate.dart';
import 'presentation/providers/app_preferences_provider.dart';
import '../core/theme/app_theme.dart';
import 'router/app_router.dart';

class PersonalWalletApp extends ConsumerWidget {
  const PersonalWalletApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final preferences = ref.watch(appPreferencesProvider);

    DateFormatter.configure(
      dateFormatPattern: preferences.dateFormatPattern,
      locale: preferences.locale.languageCode,
    );

    return MaterialApp.router(
      onGenerateTitle: (BuildContext context) => context.tr.appName,
      debugShowCheckedModeBanner: false,
      themeMode: preferences.themeMode,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      locale: preferences.locale,
      supportedLocales: const <Locale>[Locale('en'), Locale('ar')],
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (BuildContext context, Widget? child) {
        if (child == null) {
          return const SizedBox.shrink();
        }
        return AppSecurityGate(child: child);
      },
      routerConfig: router,
    );
  }
}
