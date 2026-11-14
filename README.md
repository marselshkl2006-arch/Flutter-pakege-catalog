# Flutter Crates Catalog

Кроссплатформенное приложение «Каталог крейтов» на Flutter/Dart. Данные о пакетах предоставляет открытый API crates.io.

## Реализовано
- **Архитектура:** Слоистая (Model, Data, State, UI).
- **Сеть:** Пакет `http`, обязательный заголовок `User-Agent`, обработка ошибок (404, 429, таймауты).
- **Состояние:** Паттерн State Holder на базе `ChangeNotifier` (без сторонних библиотек).
- **Навигация:** Типизированные маршруты (`sealed class`), анимации переходов (`PageRouteBuilder`).
- **Локализация:** RU/EN через ARB-файлы (`intl`).
- **Функционал:** Список с поиском и пагинацией, экран деталей, экраны зависимостей и владельцев.
- **Данные:** Работа только с реальным API (моки удалены из production-кода).

## Требования
- Flutter SDK (3.29+)
- Dart SDK (входит в Flutter)

## Запуск
```bash
# Получить зависимости
flutter pub get

# Запуск на Linux (Desktop)
flutter run -d linux

# Запуск на Web (Chrome)
flutter run -d chrome

# Запуск на Android (Эмулятор)
flutter run -d emulator-5554
Тестирование и анализ
bash
flutter analyze
flutter test
python3 tools/check_strings.py
Структура проекта
lib/ — исходный код (model, data, state, navigation, ui, theme, l10n).

docs/lab-1/ — отчеты по лабораторным работам.

tools/ — вспомогательные скрипты.

Примечание
На платформе Web (браузер) реальные запросы к crates.io могут блокироваться политикой CORS. На Desktop и Android сеть работает штатно.
