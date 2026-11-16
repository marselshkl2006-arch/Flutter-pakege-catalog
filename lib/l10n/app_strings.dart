import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AppStrings {
  AppStrings(this._values);

  final Map<String, String> _values;

  static const List<Locale> supportedLocales = [Locale('ru'), Locale('en')];
  static const LocalizationsDelegate<AppStrings> delegate = _AppStringsDelegate();

  static AppStrings of(BuildContext context) => Localizations.of<AppStrings>(context, AppStrings)!;

  String _t(String key) => _values[key] ?? key;

  String get appTitle => _t('app_title');
  String get searchHint => _t('search_hint');
  String get loading => _t('loading');
  String get errorTitle => _t('error_title');
  String get errorRetry => _t('error_retry');
  String get emptyList => _t('empty_list');
  String get back => _t('back');
  String get dependencies => _t('dependencies');
  String get noDependencies => _t('no_dependencies');
  String get owner => _t('owner');
  String get downloads => _t('downloads');
  String get version => _t('version');
  String get versions => _t('versions');
  String get repository => _t('repository');
  String get documentation => _t('documentation');
  String get descriptionMissing => _t('description_missing');
  String get login => _t('login');
  String get userName => _t('user_name');
  String get themeToggle => _t('theme_toggle');
  String get languageToggle => _t('language_toggle');
  String get dataSourceMock => _t('data_source_mock');
  String get dataSourceNetwork => _t('data_source_network');
  
  // НОВЫЕ СТРОКИ ДЛЯ ИЗБРАННОГО
  String get favorites => _t('favorites');
  String get favoritesEmpty => _t('favorites_empty');
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) => const ['ru', 'en'].contains(locale.languageCode);

  @override
  Future<AppStrings> load(Locale locale) async {
    final code = isSupported(locale) ? locale.languageCode : 'en';
    final raw = await rootBundle.loadString('assets/l10n/app_$code.arb');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return AppStrings({
      for (final e in json.entries)
        if (!e.key.startsWith('@')) e.key: e.value as String,
    });
  }

  @override
  bool shouldReload(_AppStringsDelegate old) => false;
}
