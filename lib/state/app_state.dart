import 'safe_notifier.dart';

/// Global UI settings. Kept in memory only (nothing is saved to disk in v1).
class AppState extends SafeNotifier {
  AppState({bool isDarkTheme = false, String language = 'ru', bool useMocks = true})
      : _isDarkTheme = isDarkTheme,
        _language = language,
        _useMocks = useMocks;

  static const List<String> supportedLanguages = ['ru', 'en'];

  bool _isDarkTheme;
  String _language;
  bool _useMocks;

  bool get isDarkTheme => _isDarkTheme;

  /// "ru" or "en".
  String get language => _language;

  /// true = hand-written MockData, false = real crates.io API.
  bool get useMocks => _useMocks;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  void setLanguage(String language) {
    assert(supportedLanguages.contains(language), 'Unsupported language: $language');
    _language = language;
    notifyListeners();
  }

  void toggleDataSource() {
    _useMocks = !_useMocks;
    notifyListeners();
  }
}
