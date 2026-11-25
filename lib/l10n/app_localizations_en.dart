// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Crates Catalog';

  @override
  String get searchHint => 'Search crates...';

  @override
  String get noResults => 'Nothing found';

  @override
  String get detailsTitle => 'Crate Details';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';
}
