import 'package:cc_core/cc_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hitch_post/app.dart';
import 'package:hitch_post/data/database/app_database.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = makeTestDb());
  tearDown(() => db.close());

  testWidgets(
      'first run leads with the positioning line, the promise, and the fork',
      (tester) async {
    final store = InMemoryKeyValueStore();
    await tester
        .pumpWidget(testApp(db: db, kvStore: store, home: const AppRoot()));
    await tester.pumpAndSettle();

    expect(find.text("Every site you'd book again, in one book."),
        findsOneWidget);
    expect(find.textContaining('Not a booking app.'), findsOneWidget);
    expect(find.text(kPrivacyBoilerplate), findsOneWidget);
    expect(find.text('Import my old log'), findsOneWidget);
    expect(find.text('Add my first campground'), findsOneWidget);

    await tester.ensureVisible(find.text('Just look around'));
    await tester.tap(find.text('Just look around'));
    await tester.pumpAndSettle();

    // Swapped to the shell, and the flag persisted.
    expect(find.text('Hitch Post'), findsOneWidget);
    expect(await FirstRunFlag(store).seen(), isTrue);
    await disposeApp(tester);
  });

  testWidgets('returning users go straight to the shell', (tester) async {
    final store = InMemoryKeyValueStore();
    await FirstRunFlag(store).markSeen();
    await tester
        .pumpWidget(testApp(db: db, kvStore: store, home: const AppRoot()));
    await tester.pumpAndSettle();

    expect(find.text('Hitch Post'), findsOneWidget);
    expect(find.text('Import my old log'), findsNothing);
    await disposeApp(tester);
  });
}
