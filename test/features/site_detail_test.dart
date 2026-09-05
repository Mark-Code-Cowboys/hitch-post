import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hitch_post/data/database/app_database.dart';
import 'package:hitch_post/data/repositories/campground_repository.dart';
import 'package:hitch_post/data/repositories/site_repository.dart';
import 'package:hitch_post/data/repositories/visit_repository.dart';
import 'package:hitch_post/features/sites/site_detail_screen.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late int siteId;

  setUp(() async {
    db = makeTestDb();
    final campgroundId =
        await CampgroundRepository(db).create(campgroundDraft());
    siteId = await SiteRepository(db).create(
        campgroundId,
        const SiteDraft(
          siteNo: '42',
          amps: Amps.a50,
          water: true,
          sewer: false,
          maxLengthFt: 35,
          approach: Approach.backIn,
          shade: Shade.partial,
          level: Level.workable,
          cellBars: 3,
          cellCarrier: 'VZW',
        ));
  });

  tearDown(() => db.close());

  testWidgets('the rebooking grid answers everything in one look',
      (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
        testApp(db: db, home: SiteDetailScreen(siteId: siteId)));
    await tester.pumpAndSettle();

    expect(find.text('Site 42'), findsOneWidget);
    expect(find.text('50A'), findsOneWidget);
    expect(find.text('35 ft'), findsOneWidget);
    expect(find.text('Back-in'), findsOneWidget);
    expect(find.text('Partial shade'), findsOneWidget);
    expect(find.text('Workable'), findsOneWidget);
    expect(find.text('3 bars VZW'), findsOneWidget);
    expect(find.textContaining('No visits logged'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('logging a visit lands it on the site with its story',
      (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
        testApp(db: db, home: SiteDetailScreen(siteId: siteId)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log a visit'));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(TextField, 'Total cost'), '135.00');
    await tester.enterText(
        find.widgetWithText(TextField, 'Notes for next time'),
        'Utilities are mid-site; bring the long sewer hose.');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.textContaining(r'$135.00'), findsOneWidget);
    expect(find.textContaining('long sewer hose'), findsOneWidget);

    final visits = await tester.runAsync(
        () => VisitRepository(db).watchForSite(siteId).first);
    expect(visits!.single.notes, contains('long sewer hose'));
    expect(visits.single.visit.costTotalCents, 13500);
    await disposeApp(tester);
  });
}
