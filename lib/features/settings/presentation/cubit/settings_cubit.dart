import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsState {
  final ThemeMode themeMode;
  final Locale locale;

  const SettingsState({required this.themeMode, required this.locale});

  SettingsState copyWith({ThemeMode? themeMode, Locale? locale}) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState(themeMode: ThemeMode.system, locale: Locale('ru')));

  void toggleTheme() {
    final newMode = state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(state.copyWith(themeMode: newMode));
  }

  void toggleLanguage() {
    final newLocale = state.locale.languageCode == 'ru' ? const Locale('en') : const Locale('ru');
    emit(state.copyWith(locale: newLocale));
  }
}
