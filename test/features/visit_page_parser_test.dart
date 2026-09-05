import 'package:cc_core/cc_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hitch_post/features/scan_import/visit_page_parser.dart';

void main() {
  test('transcribes a full notebook page', () {
    final draft = parseVisitPage(const [
      // Shouted header, tallest, top third.
      OcrLine('BIG PINES RV PARK', left: 0, top: 0, height: 40),
      OcrLine('Gaylord MI', left: 0, top: 60, height: 20),
      OcrLine('Site 42', left: 0, top: 90, height: 20),
      OcrLine('6/12/2026 - 6/15/2026', left: 0, top: 120, height: 20),
      OcrLine('Total \$96.00', left: 0, top: 150, height: 20),
      OcrLine('Pull thru was tight, good shade', left: 0, top: 180, height: 20),
    ])!;
    expect(draft.campground, 'Big Pines Rv Park');
    expect(draft.state, 'MI');
    expect(draft.siteNo, '42');
    expect(draft.arrive, DateTime(2026, 6, 12));
    expect(draft.depart, DateTime(2026, 6, 15));
    expect(draft.costTotalCents, 9600);
    expect(draft.notes, contains('Pull thru was tight'));
  });

  test('missing fields stay null — never guessed', () {
    final draft = parseVisitPage(const [
      OcrLine('Riverbend Campground', left: 0, top: 0, height: 30),
    ])!;
    expect(draft.campground, 'Riverbend Campground');
    expect(draft.state, isNull);
    expect(draft.siteNo, isNull);
    expect(draft.arrive, isNull);
    expect(draft.costTotalCents, isNull);
  });

  test('a random word pair never reads as a state', () {
    final draft = parseVisitPage(const [
      // "RV" is uppercase 2 letters but not a postal code.
      OcrLine('Sunset RV Resort', left: 0, top: 0, height: 30),
    ])!;
    expect(draft.state, isNull);
  });

  test('null when the photo had no text', () {
    expect(parseVisitPage(const []), isNull);
  });
}
