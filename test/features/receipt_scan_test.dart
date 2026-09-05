import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hitch_post/data/repositories/campground_repository.dart';
import 'package:hitch_post/data/repositories/site_repository.dart';
import 'package:hitch_post/features/scan_import/scan_import_providers.dart';
import 'package:hitch_post/features/visits/visit_composer_screen.dart';

import '../helpers.dart';

void main() {
  testWidgets('receipt scan fills cost and dates after the user confirms',
      (tester) async {
    final db = makeTestDb();
    final campgroundId =
        await CampgroundRepository(db).create(campgroundDraft());
    final siteId = await SiteRepository(db).create(campgroundId, siteDraft());

    await tester.pumpWidget(testApp(
      db: db,
      entitlements: FakeEntitlementService(unlimited: true),
      home: VisitComposerScreen(siteId: siteId),
      overrides: [
        documentScanServiceProvider
            .overrideWithValue(FakeDocumentScanService(['receipt.jpg'])),
        textRecognitionServiceProvider.overrideWithValue(
          FakeTextRecognitionService(linesByPath: {
            'receipt.jpg': const [
              OcrLine('Check in 6/12/2026', left: 0, top: 0, height: 20),
              OcrLine('Check out 6/15/2026', left: 0, top: 30, height: 20),
              OcrLine('Total \$84.00', left: 0, top: 60, height: 20),
            ],
          }),
        ),
      ],
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Scan receipt'));
    await tester.pumpAndSettle();

    // The confirm dialog shows the reading verbatim.
    expect(find.text('Receipt says'), findsOneWidget);
    expect(find.text(r'Total: $84.00'), findsOneWidget);
    expect(find.textContaining('Jun 12'), findsOneWidget);

    await tester.tap(find.text('Use these'));
    await tester.pumpAndSettle();

    expect(
        tester
            .widget<TextField>(find.widgetWithText(TextField, 'Total cost'))
            .controller
            ?.text,
        '84.00');
    expect(find.text('Jun 12, 2026'), findsOneWidget);
    expect(find.text('Jun 15, 2026'), findsOneWidget);

    await disposeApp(tester);
    await db.close();
  });

  testWidgets('backing out of the confirm dialog changes nothing',
      (tester) async {
    final db = makeTestDb();
    final campgroundId =
        await CampgroundRepository(db).create(campgroundDraft());
    final siteId = await SiteRepository(db).create(campgroundId, siteDraft());

    await tester.pumpWidget(testApp(
      db: db,
      entitlements: FakeEntitlementService(unlimited: true),
      home: VisitComposerScreen(siteId: siteId),
      overrides: [
        documentScanServiceProvider
            .overrideWithValue(FakeDocumentScanService(['receipt.jpg'])),
        textRecognitionServiceProvider.overrideWithValue(
          FakeTextRecognitionService(fallback: const [
            OcrLine('Total \$84.00', left: 0, top: 0, height: 20),
          ]),
        ),
      ],
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Scan receipt'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(
        tester
            .widget<TextField>(find.widgetWithText(TextField, 'Total cost'))
            .controller
            ?.text,
        isEmpty);

    await disposeApp(tester);
    await db.close();
  });
}
