import 'package:flutter_test/flutter_test.dart';
import 'package:hitch_post/data/database/app_database.dart';
import 'package:hitch_post/features/trends/trends_math.dart';

Visit visit(int id,
        {required DateTime arrive, required DateTime depart, int? cost}) =>
    Visit(
        id: id,
        siteId: 1,
        arrive: arrive,
        depart: depart,
        costTotalCents: cost,
        journalEntryId: null);

void main() {
  test('nightsOf: each night belongs to the date it starts', () {
    final nights =
        nightsOf(visit(1,
                arrive: DateTime(2026, 6, 12), depart: DateTime(2026, 6, 15)))
            .toList();
    expect(nights,
        [DateTime(2026, 6, 12), DateTime(2026, 6, 13), DateTime(2026, 6, 14)]);
    expect(
        nightsOf(visit(2,
            arrive: DateTime(2026, 6, 12), depart: DateTime(2026, 6, 12))),
        isEmpty);
  });

  test('nightsByYear splits a New Year straddle and dedupes overlaps', () {
    final byYear = nightsByYear([
      visit(1,
          arrive: DateTime(2025, 12, 30), depart: DateTime(2026, 1, 2)),
      // Overlaps the first visit's last night; must not double-count.
      visit(2, arrive: DateTime(2026, 1, 1), depart: DateTime(2026, 1, 3)),
    ]);
    expect(byYear, {2025: 2, 2026: 2});
  });

  test('nightsInMonth clips to the window', () {
    final camped = nightsInMonth(
        [
          visit(1,
              arrive: DateTime(2026, 5, 30), depart: DateTime(2026, 6, 2)),
        ],
        2026,
        6);
    expect(camped, {DateTime(2026, 6, 1)});
  });

  test('avgCostPerNightCents skips costless visits, null when none', () {
    expect(
        avgCostPerNightCents([
          visit(1,
              arrive: DateTime(2026, 6, 1),
              depart: DateTime(2026, 6, 4),
              cost: 9000), // 3 nights
          visit(2,
              arrive: DateTime(2026, 7, 1),
              depart: DateTime(2026, 7, 2)), // no cost: excluded
        ]),
        3000);
    expect(
        avgCostPerNightCents(
            [visit(1, arrive: DateTime(2026, 6, 1), depart: DateTime(2026, 6, 2))]),
        isNull);
  });

  test('statesRecorded normalizes and drops nulls', () {
    Campground cg(int id, String? state) => Campground(
        id: id,
        name: 'C$id',
        kind: CampgroundKind.other,
        state: state,
        notes: null,
        rating: null,
        wouldReturn: true,
        lat: null,
        lon: null,
        createdAt: DateTime(2026));
    expect(statesRecorded([cg(1, 'mi'), cg(2, 'MI'), cg(3, null)]), {'MI'});
  });
}
