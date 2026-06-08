import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/app_constants.dart';

@immutable
class AppPreferencesState {
  const AppPreferencesState({
    this.locale = const Locale('ar'),
    this.themeMode = ThemeMode.system,
  });

  final Locale locale;
  final ThemeMode themeMode;

  AppPreferencesState copyWith({
    Locale? locale,
    ThemeMode? themeMode,
  }) {
    return AppPreferencesState(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class AppPreferencesController extends StateNotifier<AppPreferencesState> {
  AppPreferencesController() : super(const AppPreferencesState()) {
    _restoreLocale();
  }

  Future<void> _restoreLocale() async {
    if (!Hive.isBoxOpen(AppConstants.preferencesBox)) {
      return;
    }

    final String? storedLanguageCode = Hive.box<String>(
      AppConstants.preferencesBox,
    ).get(AppConstants.localePreferenceKey);

    if (storedLanguageCode == null || storedLanguageCode.isEmpty) {
      return;
    }

    state = state.copyWith(locale: Locale(storedLanguageCode));
  }

  void setLanguageCode(String languageCode) {
    state = state.copyWith(locale: Locale(languageCode));

    if (Hive.isBoxOpen(AppConstants.preferencesBox)) {
      Hive.box<String>(
        AppConstants.preferencesBox,
      ).put(AppConstants.localePreferenceKey, languageCode);
    }
  }

  void setThemeMode(ThemeMode themeMode) {
    state = state.copyWith(themeMode: themeMode);
  }
}

final appPreferencesProvider =
    StateNotifierProvider<AppPreferencesController, AppPreferencesState>(
      (Ref ref) => AppPreferencesController(),
    );
