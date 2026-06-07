import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/providers/app_preferences_provider.dart';
import '../core/theme/app_theme.dart';
import 'router/app_router.dart';

class PersonalWalletApp extends ConsumerWidget {
  const PersonalWalletApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final preferences = ref.watch(appPreferencesProvider);

    return MaterialApp.router(
      title: 'Personal Wallet',
      debugShowCheckedModeBanner: false,
      themeMode: preferences.themeMode,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      locale: preferences.locale,
      supportedLocales: const <Locale>[Locale('en'), Locale('ar')],
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
