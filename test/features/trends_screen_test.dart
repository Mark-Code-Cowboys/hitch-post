import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hitch_post/data/repositories/campground_repository.dart';
import 'package:hitch_post/data/repositories/site_repository.dart';
import 'package:hitch_post/data/repositories/visit_repository.dart';
import 'package:hitch_post/features/trends/trends_screen.dart';

import '../helpers.dart';

void main() {
  testWidgets('free users get the pitch — and the ungated restore',
      (tester) async {
    final db = makeTestDb();
    await tester.pumpWidget(testApp(db: db, home: const TrendsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('The long arc of the road.'), findsOneWidget);
    expect(find.text('Restore a backup'), findsOneWidget);
    expect(find.text('The states map'), findsNothing);

    await disposeApp(tester);
    await db.close();
  });

  testWidgets('Pro sees the map, the calendar, and the export buttons',
      (tester) async {
    tester.view.physicalSize = const Size(800, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final db = makeTestDb();
    final campgrounds = CampgroundRepository(db);
    final pinesId = await campgrounds.create(
        campgroundDraft(name: 'Big Pines', state: 'MI'));
    final siteId =
        await SiteRepository(db).create(pinesId, siteDraft(siteNo: '42'));
    await VisitRepository(db).create(
        siteId,
        visitDraft(
            arrive: DateTime(2026, 6, 12),
            depart: DateTime(2026, 6, 15),
            costTotalCents: 9600));

    await tester.pumpWidget(testApp(
      db: db,
      entitlements: FakeEntitlementService(unlimited: true),
      home: const TrendsScreen(),
    ));
    await tester.pumpAndSettle();

    expect(find.text('The states map'), findsOneWidget);
    expect(find.text('The camped calendar'), findsOneWidget);
    expect(find.text('1 campground'), findsOneWidget);
    expect(find.text('1 visit'), findsOneWidget);
    expect(find.text('3 nights'), findsOneWidget);
    expect(find.text('1 state'), findsOneWidget);
    expect(
        find.text(r'$32.00 average, over the visits with a recorded cost.'),
        findsOneWidget);
    expect(find.text('Share visits as CSV'), findsOneWidget);
    expect(find.text('Back up the whole log'), findsOneWidget);
    expect(find.text('Restore a backup'), findsOneWidget);

    await disposeApp(tester);
    await db.close();
  });
}
