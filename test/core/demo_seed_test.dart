import 'package:flutter_test/flutter_test.dart';

import 'package:hitch_post/data/database/seed.dart';

import '../helpers.dart';

void main() {
  test('DEMO_SEED plants exactly 8 campgrounds, 2 rigs, 20 visits',
      () async {
    final db = makeTestDb();
    addTearDown(db.close);

    await seedDemoData(db);

    final campgrounds = await db.select(db.campgrounds).get();
    final visits = await db.select(db.visits).get();
    final rigs = await db.select(db.rigs).get();
    expect(campgrounds, hasLength(8));
    expect(visits, hasLength(20));
    expect(rigs, hasLength(2));
    expect(campgrounds.map((c) => c.state).toSet(),
        {'MI', 'TN', 'SD', 'WY', 'MT', 'FL'});

    // Several pins for the map shot — but never all: pins are opt-in
    // and the demo should look it.
    final pinned = campgrounds.where((c) => c.lat != null).length;
    expect(pinned, inInclusiveRange(4, 7));

    // Notes are the point — a healthy share of visits carry a story.
    final entries = await db.select(db.appJournalEntries).get();
    expect(entries.where((e) => e.notes != null).length,
        greaterThanOrEqualTo(12));
    expect(visits.where((v) => v.journalEntryId != null).length,
        greaterThanOrEqualTo(12));

    // Both rigs carry garage notes.
    expect(rigs.where((r) => r.journalEntryId != null), hasLength(2));
  });

  test('seeding is a no-op on a log with data', () async {
    final db = makeTestDb();
    addTearDown(db.close);

    await seedDemoData(db);
    await seedDemoData(db);

    expect(await db.select(db.campgrounds).get(), hasLength(8));
    expect(await db.select(db.visits).get(), hasLength(20));
  });
}
