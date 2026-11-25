// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Каталог крейтов';

  @override
  String get searchHint => 'Поиск крейтов...';

  @override
  String get noResults => 'Ничего не найдено';

  @override
  String get detailsTitle => 'Детали крейта';

  @override
  String get theme => 'Тема';

  @override
  String get language => 'Язык';
}
