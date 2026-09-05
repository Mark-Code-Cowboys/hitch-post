import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hitch_post/features/scan_import/scan_import_providers.dart';

import '../helpers.dart';

void main() {
  testWidgets('the converter: empty state -> scan pages -> review -> '
      'campground and visit filed', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final db = makeTestDb();
    await tester.pumpWidget(testApp(
      db: db,
      entitlements: FakeEntitlementService(unlimited: true),
      overrides: [
        documentScanServiceProvider
            .overrideWithValue(FakeDocumentScanService(['page1.jpg'])),
        textRecognitionServiceProvider.overrideWithValue(
          FakeTextRecognitionService(linesByPath: {
            'page1.jpg': const [
              OcrLine('BIG PINES RV PARK', left: 0, top: 0, height: 40),
              OcrLine('Site 42', left: 0, top: 90, height: 20),
              OcrLine('6/12/2026 - 6/15/2026', left: 0, top: 120, height: 20),
              OcrLine('Total \$96.00', left: 0, top: 150, height: 20),
            ],
          }),
        ),
      ],
    ));
    await tester.pumpAndSettle();

    // The converter is surfaced on the empty state.
    await tester.tap(find.text('Import your old log'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Scan notebook pages'));
    await tester.pumpAndSettle();

    // Review screen shows the transcription verbatim.
    expect(find.text('Scanned pages'), findsOneWidget);
    expect(find.text('Big Pines Rv Park'), findsOneWidget);
    expect(find.textContaining('Site 42'), findsOneWidget);

    await tester.tap(find.text('Add 1 visit'));
    await tester.pumpAndSettle();

    // Filed: the campground is on the home list now.
    expect(find.text('Big Pines Rv Park'), findsOneWidget);

    // Drain the report snackbar before teardown.
    await tester.pump(const Duration(seconds: 5));
    await disposeApp(tester);
    await db.close();
  });
}
