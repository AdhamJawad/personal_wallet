import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class AppPreferencesState {
  const AppPreferencesState({
    this.locale = const Locale('en'),
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
  AppPreferencesController() : super(const AppPreferencesState());

  void setLanguageCode(String languageCode) {
    state = state.copyWith(locale: Locale(languageCode));
  }

  void setThemeMode(ThemeMode themeMode) {
    state = state.copyWith(themeMode: themeMode);
  }
}

final appPreferencesProvider =
    StateNotifierProvider<AppPreferencesController, AppPreferencesState>(
      (Ref ref) => AppPreferencesController(),
    );
