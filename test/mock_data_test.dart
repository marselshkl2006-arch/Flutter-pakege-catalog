import 'package:crates_catalog/data/mock_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('has at least 20 crates', () {
    expect(MockData.crates.length, greaterThanOrEqualTo(20));
  });

  test('contains the required real crates', () {
    const required = [
      'serde', 'tokio', 'reqwest', 'clap', 'anyhow', 'thiserror', 'rayon', 'serde_json', 'hyper',
      'axum', 'tracing', 'log', 'rand', 'regex', 'chrono', 'uuid', 'url', 'base64', 'futures',
      'once_cell', 'parking_lot', 'itertools',
    ];
    final names = MockData.crates.map((c) => c.name).toSet();
    expect(names.containsAll(required), isTrue, reason: 'missing: ${required.toSet().difference(names)}');
  });

  test('all fields are filled', () {
    for (final c in MockData.crates) {
      expect(c.name, isNotEmpty);
      expect(c.version, isNotEmpty, reason: c.name);
      expect(c.description, isNotNull, reason: c.name);
      expect(c.description, isNotEmpty, reason: c.name);
      expect(c.downloads, greaterThan(0), reason: c.name);
      expect(c.repository, isNotEmpty, reason: c.name);
      expect(c.documentation, isNotEmpty, reason: c.name);
      expect(c.homepage, isNotEmpty, reason: c.name);
      expect(c.dependencies, isNotEmpty, reason: c.name);
      expect(c.owners, isNotEmpty, reason: c.name);
    }
  });

  test('names are unique and every owner is known', () {
    expect(MockData.crates.map((c) => c.name).toSet().length, MockData.crates.length);
    final logins = MockData.owners.map((o) => o.login).toSet();
    for (final c in MockData.crates) {
      expect(logins.containsAll(c.owners), isTrue, reason: c.name);
    }
  });
}
