import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../shared/domain/enums/currency.dart';

@immutable
class AppPreferencesState {
  const AppPreferencesState({
    this.locale = const Locale('ar'),
    this.themeMode = ThemeMode.dark,
    this.defaultCurrencyCode = 'USD',
    this.dateFormatPattern = 'DD/MM/YYYY',
  });

  final Locale locale;
  final ThemeMode themeMode;
  final String defaultCurrencyCode;
  final String dateFormatPattern;

  AppPreferencesState copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    String? defaultCurrencyCode,
    String? dateFormatPattern,
  }) {
    return AppPreferencesState(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      defaultCurrencyCode: defaultCurrencyCode ?? this.defaultCurrencyCode,
      dateFormatPattern: dateFormatPattern ?? this.dateFormatPattern,
    );
  }

  Currency get defaultCurrency {
    return switch (defaultCurrencyCode.toUpperCase()) {
      'SYP' => Currency.syp,
      _ => Currency.usd,
    };
  }

  Currency get secondaryCurrency {
    return defaultCurrency == Currency.usd ? Currency.syp : Currency.usd;
  }
}

class AppPreferencesController extends StateNotifier<AppPreferencesState> {
  AppPreferencesController() : super(const AppPreferencesState()) {
    _restoreAppearancePreferences();
    _restoreFinancialPreferences();
  }

  Future<void> _restoreAppearancePreferences() async {
    if (!Hive.isBoxOpen(AppConstants.preferencesBox)) {
      return;
    }

    final Box<String> box = Hive.box<String>(AppConstants.preferencesBox);
    final String? storedLanguageCode = box.get(
      AppConstants.localePreferenceKey,
    );
    final String? storedThemeMode = box.get(
      AppConstants.themeModePreferenceKey,
    );

    state = state.copyWith(
      locale: storedLanguageCode?.isNotEmpty == true
          ? Locale(storedLanguageCode!)
          : state.locale,
      themeMode: _themeModeFromValue(storedThemeMode) ?? state.themeMode,
    );
  }

  void setLanguageCode(String languageCode) {
    state = state.copyWith(locale: Locale(languageCode));

    if (Hive.isBoxOpen(AppConstants.preferencesBox)) {
      Hive.box<String>(
        AppConstants.preferencesBox,
      ).put(AppConstants.localePreferenceKey, languageCode);
    }
  }

  Future<void> _restoreFinancialPreferences() async {
    if (!Hive.isBoxOpen(AppConstants.preferencesBox)) {
      return;
    }

    final Box<String> box = Hive.box<String>(AppConstants.preferencesBox);
    final String? storedCurrencyCode = box.get(
      AppConstants.defaultCurrencyPreferenceKey,
    );
    final String? storedDateFormat = box.get(
      AppConstants.dateFormatPreferenceKey,
    );

    state = state.copyWith(
      defaultCurrencyCode: storedCurrencyCode?.isNotEmpty == true
          ? storedCurrencyCode
          : state.defaultCurrencyCode,
      dateFormatPattern: storedDateFormat?.isNotEmpty == true
          ? storedDateFormat
          : state.dateFormatPattern,
    );
  }

  void setThemeMode(ThemeMode themeMode) {
    state = state.copyWith(themeMode: themeMode);

    if (Hive.isBoxOpen(AppConstants.preferencesBox)) {
      Hive.box<String>(
        AppConstants.preferencesBox,
      ).put(AppConstants.themeModePreferenceKey, themeMode.name);
    }
  }

  void setDefaultCurrencyCode(String currencyCode) {
    state = state.copyWith(defaultCurrencyCode: currencyCode);

    if (Hive.isBoxOpen(AppConstants.preferencesBox)) {
      Hive.box<String>(
        AppConstants.preferencesBox,
      ).put(AppConstants.defaultCurrencyPreferenceKey, currencyCode);
    }
  }

  void setDateFormatPattern(String pattern) {
    state = state.copyWith(dateFormatPattern: pattern);

    if (Hive.isBoxOpen(AppConstants.preferencesBox)) {
      Hive.box<String>(
        AppConstants.preferencesBox,
      ).put(AppConstants.dateFormatPreferenceKey, pattern);
    }
  }
}

ThemeMode? _themeModeFromValue(String? value) {
  return switch (value) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    'system' => ThemeMode.dark,
    _ => null,
  };
}

final appPreferencesProvider =
    StateNotifierProvider<AppPreferencesController, AppPreferencesState>(
      (Ref ref) => AppPreferencesController(),
    );
