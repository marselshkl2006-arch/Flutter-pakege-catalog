import 'package:crates_catalog/data/mock_data.dart';
import 'package:crates_catalog/ui/list/list_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ListState withMocks() => ListState()..crates = MockData.crates;

  test('blank query keeps everything', () {
    final s = withMocks()..query = '   ';
    expect(s.filtered.length, MockData.crates.length);
  });

  test('filters by name, case-insensitively', () {
    final s = withMocks()..query = 'SERDE';
    expect(s.filtered.map((c) => c.name).toSet(), {'serde', 'serde_json'});
  });

  test('filters by description', () {
    final s = withMocks()..query = 'work-stealing';
    expect(s.filtered.map((c) => c.name), ['rayon']);
  });

  test('no match gives an empty list', () {
    final s = withMocks()..query = 'definitely-not-a-crate';
    expect(s.filtered, isEmpty);
  });
}
