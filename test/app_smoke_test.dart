import 'package:crates_catalog/app/app.dart';
import 'package:crates_catalog/data/crates_repository.dart';
import 'package:crates_catalog/data/mock_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('list -> detail -> back works with mock data', (tester) async {
    final source = MockCratesSource(latency: Duration.zero);
    final repo = CratesRepository(api: source, mock: source, useMocks: () => true);

    await tester.pumpWidget(CratesCatalogApp(repository: repo));
    await tester.pumpAndSettle();

    const item = 'serde  1.0.228';
    expect(find.text(item), findsOneWidget);

    await tester.tap(find.text(item));
    await tester.pumpAndSettle();
    expect(find.textContaining('1.0.228'), findsWidgets);
    expect(find.byType(BackButton), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text(item), findsOneWidget);
  });
}
