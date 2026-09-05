import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hitch_post/data/database/app_database.dart';
import 'package:hitch_post/data/repositories/campground_repository.dart';
import 'package:hitch_post/features/home/home_screen.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = makeTestDb());
  tearDown(() => db.close());

  testWidgets('empty log shows the positioning line and Add campground',
      (tester) async {
    await tester.pumpWidget(testApp(db: db));
    await tester.pumpAndSettle();

    expect(find.text('Your campground spreadsheet, on your phone.'),
        findsOneWidget);
    expect(find.text('Add campground'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('seeded log shows cards, chips, and the gate counter',
      (tester) async {
    final repo = CampgroundRepository(db);
    await repo.create(campgroundDraft(name: 'Pine Flats', rating: 4));
    await repo.create(campgroundDraft(
        name: 'Mirror Lake COE',
        kind: CampgroundKind.coe,
        state: 'WI',
        wouldReturn: false));

    await tester.pumpWidget(testApp(db: db));
    await tester.pumpAndSettle();

    expect(find.text('2 of 5 free campgrounds used'), findsOneWidget);
    expect(find.text('Pine Flats'), findsOneWidget);
    expect(find.text('State park · MI'), findsOneWidget);
    expect(find.text('COE · WI'), findsOneWidget);
    expect(find.text('Would return'), findsOneWidget);
    expect(find.text("Wouldn't return"), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('search filters by name and exact state', (tester) async {
    final repo = CampgroundRepository(db);
    await repo.create(campgroundDraft(name: 'Pine Flats', state: 'MI'));
    await repo.create(campgroundDraft(name: 'Mirror Lake', state: 'WI'));

    await tester.pumpWidget(testApp(db: db));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'wi');
    await tester.pumpAndSettle();
    expect(find.text('Mirror Lake'), findsOneWidget);
    expect(find.text('Pine Flats'), findsNothing);

    await tester.enterText(find.byType(TextField), 'pine');
    await tester.pumpAndSettle();
    expect(find.text('Pine Flats'), findsOneWidget);
    expect(find.text('Mirror Lake'), findsNothing);
    await disposeApp(tester);
  });

  test('rating sort puts the best first, unrated last', () {
    Campground c(String name, int? rating, DateTime created) => Campground(
          id: name.hashCode,
          name: name,
          kind: CampgroundKind.public,
          wouldReturn: true,
          createdAt: created,
          rating: rating,
        );
    final sorted = filterAndSort(
      [
        c('Unrated', null, DateTime(2026)),
        c('Best', 5, DateTime(2024)),
        c('Fine', 3, DateTime(2025)),
      ],
      '',
      CampgroundSort.rating,
    );
    expect(sorted.map((x) => x.name), ['Best', 'Fine', 'Unrated']);
  });
}
