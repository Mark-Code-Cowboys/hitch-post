import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';

import 'app_database.dart';

/// Demo log for screenshots and store listing shots:
/// `flutter run --dart-define=DEMO_SEED=true`
///
/// Exactly 8 campgrounds across 6 states, 2 rigs, and 20 visits, with
/// the kind of notes the app exists for. Several campgrounds carry map
/// pins for the pin-map shot. No-op unless the log is empty, so a real
/// log is never polluted.
Future<void> seedDemoData(AppDatabase db) async {
  final existing = await db.select(db.campgrounds).get();
  if (existing.isNotEmpty) return;

  Future<int> campground(
    String name,
    String state, {
    required CampgroundKind kind,
    int? rating,
    bool wouldReturn = true,
    String? notes,
    double? lat,
    double? lon,
  }) =>
      db.into(db.campgrounds).insert(CampgroundsCompanion.insert(
            name: name,
            kind: kind,
            state: Value(state),
            rating: Value(rating),
            wouldReturn: Value(wouldReturn),
            notes: Value(notes),
            lat: Value(lat),
            lon: Value(lon),
          ));

  Future<int> site(
    int campgroundId,
    String siteNo, {
    Amps amps = Amps.a30,
    bool water = true,
    bool sewer = false,
    int? maxLengthFt,
    Approach? approach,
    Shade? shade,
    Level? level,
    int? cellBars,
    String? cellCarrier,
    String? notes,
  }) =>
      db.into(db.sites).insert(SitesCompanion.insert(
            campgroundId: campgroundId,
            siteNo: siteNo,
            amps: amps,
            water: Value(water),
            sewer: Value(sewer),
            maxLengthFt: Value(maxLengthFt),
            approach: Value(approach),
            shade: Value(shade),
            level: Value(level),
            cellBars: Value(cellBars),
            cellCarrier: Value(cellCarrier),
            notes: Value(notes),
          ));

  final journal = db.journal();
  Future<int> visit(
    int siteId,
    DateTime arrive,
    DateTime depart, {
    int? costCents,
    int? rating,
    String? story,
  }) async {
    int? entryId;
    if (story != null || rating != null) {
      entryId = await journal
          .createEntry(JournalEntryDraft(notes: story, rating: rating));
    }
    return db.into(db.visits).insert(VisitsCompanion.insert(
          siteId: siteId,
          arrive: arrive,
          depart: depart,
          costTotalCents: Value(costCents),
          journalEntryId: Value(entryId),
        ));
  }

  // --- Michigan (home turf) ---
  final pines = await campground('Big Pines RV Park', 'MI',
      kind: CampgroundKind.private, rating: 5,
      notes: 'The June tradition. Book by February.',
      lat: 44.76, lon: -85.62);
  final ludington = await campground('Ludington State Park', 'MI',
      kind: CampgroundKind.statePark, rating: 5,
      lat: 44.03, lon: -86.50);
  final thumb = await campground('Thumb Shores Campground', 'MI',
      kind: CampgroundKind.public, rating: 3,
      wouldReturn: false,
      notes: 'Trainline runs right behind the loop. Once was enough.');

  // --- The Smokies trip ---
  final smoky = await campground('Cades Cove Campground', 'TN',
      kind: CampgroundKind.nationalPark, rating: 5,
      lat: 35.61, lon: -83.77);

  // --- The big west loop ---
  final custer = await campground('Custer State Park', 'SD',
      kind: CampgroundKind.statePark, rating: 5,
      notes: 'Bison on the road in, twice.',
      lat: 43.76, lon: -103.42);
  final tetonView = await campground('Teton View Boondock', 'WY',
      kind: CampgroundKind.boondock, rating: 4,
      notes: 'No hookups, best sunrise of the trip. Fill water in Jackson.',
      lat: 43.65, lon: -110.71);
  final yellowstoneKoa = await campground('Yellowstone Gateway RV', 'MT',
      kind: CampgroundKind.private, rating: 3,
      lat: 45.03, lon: -110.70);

  // --- Snowbird run ---
  final marina = await campground('Gulf Breeze COE', 'FL',
      kind: CampgroundKind.coe, rating: 4,
      notes: 'COE value as always. Gate closes 8pm sharp.');

  // --- Sites (the rebooking grid) ---
  final pines42 = await site(pines, '42',
      amps: Amps.a50, sewer: true, maxLengthFt: 35,
      approach: Approach.pullThru, shade: Shade.partial, level: Level.yes,
      cellBars: 3, cellCarrier: 'VZW',
      notes: 'The one by the creek. Ask for it by number.');
  final pines17 = await site(pines, '17',
      approach: Approach.backIn, shade: Shade.full, level: Level.workable,
      cellBars: 2, cellCarrier: 'VZW',
      notes: 'Tight turn at the pump house — swing wide.');
  final ludingtonCedar = await site(ludington, 'Cedar 211',
      amps: Amps.a30, maxLengthFt: 30, approach: Approach.backIn,
      shade: Shade.full, level: Level.yes, cellBars: 1, cellCarrier: 'VZW');
  final thumb8 = await site(thumb, '8',
      amps: Amps.a30, level: Level.no, cellBars: 4, cellCarrier: 'ATT');
  final smokyB12 = await site(smoky, 'B12',
      amps: Amps.none, water: false, maxLengthFt: 30,
      approach: Approach.backIn, shade: Shade.full, level: Level.workable,
      cellBars: 0, notes: 'Generator hours 8-11 and 4-8. Bear box.');
  final custer14 = await site(custer, '14',
      amps: Amps.a30, approach: Approach.pullThru, shade: Shade.partial,
      level: Level.yes, cellBars: 2, cellCarrier: 'VZW');
  final teton = await site(tetonView, '—',
      amps: Amps.none, water: false, level: Level.workable, cellBars: 1,
      cellCarrier: 'VZW', notes: 'Arrive before Friday noon for a spot.');
  final gateway7 = await site(yellowstoneKoa, '7',
      amps: Amps.a50, sewer: true, approach: Approach.backIn,
      shade: Shade.none, level: Level.yes, cellBars: 3, cellCarrier: 'ATT');
  final gulf33 = await site(marina, '33',
      amps: Amps.a50, sewer: true, maxLengthFt: 40,
      approach: Approach.backIn, shade: Shade.partial, level: Level.yes,
      cellBars: 4, cellCarrier: 'VZW');

  // --- 20 visits, 2023 → 2026 ---
  // Big Pines: every June, plus fall color (6 visits).
  await visit(pines42, DateTime(2023, 6, 9), DateTime(2023, 6, 12),
      costCents: 16500, rating: 5,
      story: 'First stay in 42. The creek does the white noise for you.');
  await visit(pines42, DateTime(2023, 10, 6), DateTime(2023, 10, 9),
      costCents: 14100);
  await visit(pines42, DateTime(2024, 6, 14), DateTime(2024, 6, 17),
      costCents: 17400, rating: 5);
  await visit(pines17, DateTime(2024, 10, 4), DateTime(2024, 10, 7),
      costCents: 14700, rating: 3,
      story: 'Full shade means wet leaves on everything by morning.');
  await visit(pines42, DateTime(2025, 6, 13), DateTime(2025, 6, 16),
      costCents: 18000, rating: 5,
      story: 'Third June running. The neighbors from Ohio were back too.');
  await visit(pines42, DateTime(2026, 6, 12), DateTime(2026, 6, 15),
      costCents: 19200, rating: 5);

  // Ludington: the anniversary trip (3 visits).
  await visit(ludingtonCedar, DateTime(2023, 8, 18), DateTime(2023, 8, 21),
      costCents: 9900, rating: 5,
      story: 'Walked the lighthouse both nights. Cedar loop is the one.');
  await visit(ludingtonCedar, DateTime(2024, 8, 16), DateTime(2024, 8, 19),
      costCents: 10500, rating: 5);
  await visit(ludingtonCedar, DateTime(2025, 8, 15), DateTime(2025, 8, 18),
      costCents: 11100, rating: 4,
      story: 'One bar of signal and zero regrets.');

  // The one mistake (1 visit).
  await visit(thumb8, DateTime(2024, 5, 24), DateTime(2024, 5, 27),
      costCents: 10200, rating: 2,
      story: '2am freight, both nights. Site 8 tilts toward the tracks, '
          'which is somehow worse.');

  // Smokies (2 visits).
  await visit(smokyB12, DateTime(2024, 4, 12), DateTime(2024, 4, 16),
      costCents: 11000, rating: 5,
      story: 'No hookups, no signal, saw a bear from the picnic table. '
          'Perfect.');
  await visit(smokyB12, DateTime(2026, 4, 10), DateTime(2026, 4, 14),
      costCents: 12000, rating: 5);

  // The big west loop, summer 2025 (4 visits).
  await visit(custer14, DateTime(2025, 7, 2), DateTime(2025, 7, 6),
      costCents: 13200, rating: 5,
      story: 'The wildlife loop at dawn beats any zoo. Book 14 again.');
  await visit(teton, DateTime(2025, 7, 8), DateTime(2025, 7, 11),
      rating: 4,
      story: 'Free, level enough, and the Tetons out the door. Tanks were '
          'the limit.');
  await visit(gateway7, DateTime(2025, 7, 11), DateTime(2025, 7, 15),
      costCents: 26000, rating: 3,
      story: 'Paid resort prices to dump tanks and do laundry. Worth it '
          'exactly once per trip.');
  await visit(custer14, DateTime(2025, 7, 17), DateTime(2025, 7, 19),
      costCents: 6600);

  // Snowbird runs (4 visits).
  await visit(gulf33, DateTime(2024, 1, 15), DateTime(2024, 1, 22),
      costCents: 18200, rating: 4,
      story: 'A week for the price of two nights up north.');
  await visit(gulf33, DateTime(2025, 1, 13), DateTime(2025, 1, 20),
      costCents: 19600, rating: 4);
  await visit(gulf33, DateTime(2026, 1, 12), DateTime(2026, 1, 19),
      costCents: 21000, rating: 5,
      story: 'Site 33 three Januaries running. The gate hours keep the '
          'loop quiet.');
  await visit(ludingtonCedar, DateTime(2026, 8, 14), DateTime(2026, 8, 17),
      costCents: 11700);

  // --- The garage: the rig that was, and the rig that is ---
  final oldRigStory = await journal.createEntry(const JournalEntryDraft(
      notes: 'The starter rig. Sold spring 2025 — taught us everything on '
          'this list.'));
  await db.into(db.rigs).insert(RigsCompanion.insert(
        name: 'The Popup',
        kind: RigKind.travelTrailer,
        lengthFt: const Value(16),
        gvwrLbs: const Value(2900),
        ballSizeIn: const Value('2'),
        journalEntryId: Value(oldRigStory),
      ));
  final arkStory = await journal.createEntry(const JournalEntryDraft(
      notes: 'WD bars on setting 4 since the Custer grades. Re-torque '
          'after the first 50 miles, every time.'));
  await db.into(db.rigs).insert(RigsCompanion.insert(
        name: 'The Ark',
        kind: RigKind.travelTrailer,
        lengthFt: const Value(28),
        gvwrLbs: const Value(7600),
        ballSizeIn: const Value('2 5/16'),
        hitchDropIn: const Value(3),
        wdBarSetting: const Value('4'),
        tirePsiFront: const Value(65),
        tirePsiRear: const Value(65),
        brakeGain: const Value(6),
        bearingServiceDate: Value(DateTime(2026, 4, 2)),
        tireDate: Value(DateTime(2024, 3, 15)),
        journalEntryId: Value(arkStory),
      ));
}
