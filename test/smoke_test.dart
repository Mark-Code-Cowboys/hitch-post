import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hitch_post/app.dart';

void main() {
  testWidgets('scaffold boots and the free-tier gate fires at the cap',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: HitchPostApp()));

    expect(find.text('Hitch Post'), findsOneWidget);
    expect(find.textContaining('scaffold is alive'), findsOneWidget);

    for (var i = 0; i < 5; i++) {
      await tester.tap(find.text('Add entry'));
      await tester.pump();
    }
    expect(find.text('5 of 5 free entries used'), findsOneWidget);

    // The sixth add hits the gate and opens the paywall stub.
    await tester.tap(find.text('Add entry'));
    await tester.pumpAndSettle();
    expect(find.text('Hitch Post Pro'), findsOneWidget);
  });
}
