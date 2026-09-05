import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hitch_post/data/database/app_database.dart';
import 'package:hitch_post/data/repositories/campground_repository.dart';
import 'package:hitch_post/data/repositories/rig_repository.dart';

import '../helpers.dart';

/// Restore that actually finds a purchase, for the restore-path test.
class _RestoringFake extends FakeEntitlementService {
  @override
  Future<void> restorePurchases() => buyUnlimited();
}

void main() {
  late AppDatabase db;

  setUp(() => db = makeTestDb());
  tearDown(() => db.close());

  Future<void> seedCampgrounds(int n) async {
    final repo = CampgroundRepository(db);
    for (var i = 0; i < n; i++) {
      await repo.create(campgroundDraft(name: 'Camp $i'));
    }
  }

  testWidgets('at the cap, Add campground opens the paywall',
      (tester) async {
    await seedCampgrounds(5);

    await tester.pumpWidget(testApp(db: db));
    await tester.pumpAndSettle();
    expect(find.text('5 of 5 free campgrounds used'), findsOneWidget);

    await tester.tap(find.text('Add campground'));
    await tester.pumpAndSettle();

    expect(find.text('Hitch Post Pro'), findsOneWidget);
    expect(find.text('Unlimited campgrounds and rigs'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Campground name'),
        findsNothing);

    await tester.ensureVisible(find.text('Maybe later'));
    await tester.tap(find.text('Maybe later'));
    await tester.pumpAndSettle();
    expect(find.text('Hitch Post Pro'), findsNothing);
    await disposeApp(tester);
  });

  testWidgets('under the cap, Add campground goes straight through',
      (tester) async {
    await seedCampgrounds(4);

    await tester.pumpWidget(testApp(db: db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add campground'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextFormField, 'Campground name'),
        findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('the second rig is gated; the first is free',
      (tester) async {
    await tester.pumpWidget(testApp(db: db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rig'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add rig'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextFormField, 'Rig name'), findsOneWidget);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Rig name'), 'Trailer');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add rig'));
    await tester.pumpAndSettle();
    expect(find.text('Hitch Post Pro'), findsOneWidget);
    await disposeApp(tester);
  });

  test('trading up the rig stays free: delete frees the slot', () async {
    final rigs = RigRepository(db);
    final id = await rigs
        .create(const RigDraft(name: 'Old', kind: RigKind.travelTrailer));
    expect(await rigs.count(), 1);
    await rigs.delete(id);
    expect(await rigs.count(), 0); // capacity gate, not lifetime
  });

  test('deleting a campground never refunds a free-tier slot', () async {
    final tally = LifetimeTally(InMemoryKeyValueStore(),
        key: 'campgrounds_created_lifetime');
    addTearDown(tally.dispose);
    final repo = CampgroundRepository(db, tally: tally);
    final ids = <int>[];
    for (var i = 0; i < 5; i++) {
      ids.add(await repo.create(campgroundDraft(name: 'Camp $i')));
    }
    await repo.delete(ids.first);
    expect(await repo.count(), 4);
    expect(await repo.lifetimeCreated(), 5); // the slot stays spent
  });

  testWidgets('buying monthly Pro mid-gate continues into the composer',
      (tester) async {
    await seedCampgrounds(5);

    await tester.pumpWidget(testApp(db: db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add campground'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text(r'Go Pro · $12.99 / month'));
    await tester.tap(find.text(r'Go Pro · $12.99 / month'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextFormField, 'Campground name'),
        findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('restore purchase unlocks from the sheet', (tester) async {
    await seedCampgrounds(5);

    await tester
        .pumpWidget(testApp(db: db, entitlements: _RestoringFake()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add campground'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Restore purchase'));
    await tester.tap(find.text('Restore purchase'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextFormField, 'Campground name'),
        findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('Pro owners see no counter and no gates', (tester) async {
    await seedCampgrounds(6);

    await tester.pumpWidget(testApp(
        db: db, entitlements: FakeEntitlementService(unlimited: true)));
    await tester.pumpAndSettle();

    expect(find.textContaining('free campgrounds used'), findsNothing);
    await tester.tap(find.text('Add campground'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextFormField, 'Campground name'),
        findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('Settings offers the upgrade path to the same sheet',
      (tester) async {
    await tester.pumpWidget(testApp(db: db));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hitch Post Pro'));
    await tester.pumpAndSettle();

    expect(find.text(r'Or yours forever · $6.99'), findsOneWidget);
    await disposeApp(tester);
  });
}
