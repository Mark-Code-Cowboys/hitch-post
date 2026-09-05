import 'package:flutter_test/flutter_test.dart';

import 'package:hitch_post/data/database/app_database.dart';
import 'package:hitch_post/data/repositories/rig_repository.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = makeTestDb());
  tearDown(() => db.close());

  testWidgets('empty rig tab pitches writing the rig down once',
      (tester) async {
    await tester.pumpWidget(testApp(db: db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rig'));
    await tester.pumpAndSettle();

    expect(find.text('Write the rig down once.'), findsOneWidget);
    expect(find.text('Add rig'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('rig card groups Setup / Pressures / Service dates',
      (tester) async {
    await RigRepository(db).create(const RigDraft(
      name: 'Grey Wolf 26DBH',
      kind: RigKind.travelTrailer,
      lengthFt: 30,
      ballSizeIn: '2-5/16',
      hitchDropIn: 3,
      wdBarSetting: 'Chain link 5',
      tirePsiFront: 65,
      tirePsiRear: 65,
      brakeGain: 6,
      notes: 'Sways above 65 mph unloaded.',
    ));

    await tester.pumpWidget(testApp(db: db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rig'));
    await tester.pumpAndSettle();

    expect(find.text('Grey Wolf 26DBH'), findsOneWidget);
    expect(find.text('Setup'), findsOneWidget);
    expect(find.text('Pressures'), findsOneWidget);
    expect(find.text('2-5/16'), findsOneWidget);
    expect(find.text('Chain link 5'), findsOneWidget);
    expect(find.text('65 psi'), findsNWidgets(2));
    expect(find.textContaining('Sways above 65'), findsOneWidget);
    // No service dates recorded -> the section stays hidden.
    expect(find.text('Service dates'), findsNothing);
    await disposeApp(tester);
  });
}
