import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';

import '../../data/database/app_database.dart';

/// The whole log as a JSON-encodable map (format 1). Pure data — photo
/// files are referenced by store name; the backup archive carries their
/// bytes separately.
Future<Map<String, Object?>> buildExportData(
  AppDatabase db, {
  required int lifetimeCampgrounds,
  DateTime? now,
}) async {
  final campgrounds = await (db.select(db.campgrounds)
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .get();
  final sites =
      await (db.select(db.sites)..orderBy([(t) => OrderingTerm.asc(t.id)]))
          .get();
  final visits =
      await (db.select(db.visits)..orderBy([(t) => OrderingTerm.asc(t.id)]))
          .get();
  final rigs =
      await (db.select(db.rigs)..orderBy([(t) => OrderingTerm.asc(t.id)]))
          .get();
  return {
    'app': 'HitchPost',
    'format': 1,
    'exportedAt': (now ?? DateTime.now()).toIso8601String(),
    // Carried so a restore never resets the free tier (raiseTo).
    'lifetimeCampgrounds': lifetimeCampgrounds,
    'campgrounds': [
      for (final c in campgrounds)
        {
          'id': c.id,
          'name': c.name,
          'kind': c.kind.name,
          'state': c.state,
          'notes': c.notes,
          'rating': c.rating,
          'wouldReturn': c.wouldReturn,
          'lat': c.lat,
          'lon': c.lon,
          'createdAt': c.createdAt.toIso8601String(),
        },
    ],
    'sites': [
      for (final s in sites)
        {
          'id': s.id,
          'campgroundId': s.campgroundId,
          'siteNo': s.siteNo,
          'amps': s.amps.name,
          'water': s.water,
          'sewer': s.sewer,
          'maxLengthFt': s.maxLengthFt,
          'approach': s.approach?.name,
          'shade': s.shade?.name,
          'level': s.level?.name,
          'cellBars': s.cellBars,
          'cellCarrier': s.cellCarrier,
          'notes': s.notes,
        },
    ],
    'visits': [
      for (final v in visits)
        {
          'id': v.id,
          'siteId': v.siteId,
          'arrive': v.arrive.toIso8601String(),
          'depart': v.depart.toIso8601String(),
          'costTotalCents': v.costTotalCents,
          'journalEntryId': v.journalEntryId,
        },
    ],
    'rigs': [
      for (final r in rigs)
        {
          'id': r.id,
          'name': r.name,
          'kind': r.kind.name,
          'lengthFt': r.lengthFt,
          'gvwrLbs': r.gvwrLbs,
          'ballSizeIn': r.ballSizeIn,
          'hitchDropIn': r.hitchDropIn,
          'wdBarSetting': r.wdBarSetting,
          'tirePsiFront': r.tirePsiFront,
          'tirePsiRear': r.tirePsiRear,
          'brakeGain': r.brakeGain,
          'bearingServiceDate': r.bearingServiceDate?.toIso8601String(),
          'tireDate': r.tireDate?.toIso8601String(),
          'journalEntryId': r.journalEntryId,
        },
    ],
    ...await db.journal().dumpJournalTables(),
  };
}

/// Replaces the entire log with the contents of an export. Runs in one
/// transaction; ids are preserved.
///
/// Returns the backup's lifetime-campgrounds figure so the caller can
/// `raiseTo` the tally (never lowered).
Future<int> restoreFromExportData(
    AppDatabase db, Map<String, Object?> data) async {
  if (data['app'] != 'HitchPost' || data['format'] != 1) {
    throw const InvalidBackupException('Unrecognized export format');
  }
  final campgrounds = data['campgrounds'];
  final sites = data['sites'];
  final visits = data['visits'];
  final rigs = data['rigs'];
  if (campgrounds is! List ||
      sites is! List ||
      visits is! List ||
      rigs is! List) {
    throw const InvalidBackupException('Malformed export tables');
  }

  await db.transaction(() async {
    await db.delete(db.rigs).go();
    await db.delete(db.campgrounds).go(); // sites+visits cascade
    await db.delete(db.appJournalEntries).go();

    await db.journal().restoreJournalTables(data);

    for (final row in campgrounds.cast<Map<String, dynamic>>()) {
      await db.into(db.campgrounds).insert(CampgroundsCompanion(
            id: Value(row['id'] as int),
            name: Value(row['name'] as String),
            kind: Value(
                CampgroundKind.values.byName(row['kind'] as String)),
            state: Value(row['state'] as String?),
            notes: Value(row['notes'] as String?),
            rating: Value(row['rating'] as int?),
            wouldReturn: Value(row['wouldReturn'] as bool),
            lat: Value((row['lat'] as num?)?.toDouble()),
            lon: Value((row['lon'] as num?)?.toDouble()),
            createdAt: Value(DateTime.parse(row['createdAt'] as String)),
          ));
    }
    for (final row in sites.cast<Map<String, dynamic>>()) {
      await db.into(db.sites).insert(SitesCompanion(
            id: Value(row['id'] as int),
            campgroundId: Value(row['campgroundId'] as int),
            siteNo: Value(row['siteNo'] as String),
            amps: Value(Amps.values.byName(row['amps'] as String)),
            water: Value(row['water'] as bool),
            sewer: Value(row['sewer'] as bool),
            maxLengthFt: Value(row['maxLengthFt'] as int?),
            approach: Value(switch (row['approach'] as String?) {
              null => null,
              final name => Approach.values.byName(name),
            }),
            shade: Value(switch (row['shade'] as String?) {
              null => null,
              final name => Shade.values.byName(name),
            }),
            level: Value(switch (row['level'] as String?) {
              null => null,
              final name => Level.values.byName(name),
            }),
            cellBars: Value(row['cellBars'] as int?),
            cellCarrier: Value(row['cellCarrier'] as String?),
            notes: Value(row['notes'] as String?),
          ));
    }
    for (final row in visits.cast<Map<String, dynamic>>()) {
      await db.into(db.visits).insert(VisitsCompanion(
            id: Value(row['id'] as int),
            siteId: Value(row['siteId'] as int),
            arrive: Value(DateTime.parse(row['arrive'] as String)),
            depart: Value(DateTime.parse(row['depart'] as String)),
            costTotalCents: Value(row['costTotalCents'] as int?),
            journalEntryId: Value(row['journalEntryId'] as int?),
          ));
    }
    for (final row in rigs.cast<Map<String, dynamic>>()) {
      await db.into(db.rigs).insert(RigsCompanion(
            id: Value(row['id'] as int),
            name: Value(row['name'] as String),
            kind: Value(RigKind.values.byName(row['kind'] as String)),
            lengthFt: Value(row['lengthFt'] as int?),
            gvwrLbs: Value(row['gvwrLbs'] as int?),
            ballSizeIn: Value(row['ballSizeIn'] as String?),
            hitchDropIn: Value(row['hitchDropIn'] as int?),
            wdBarSetting: Value(row['wdBarSetting'] as String?),
            tirePsiFront: Value(row['tirePsiFront'] as int?),
            tirePsiRear: Value(row['tirePsiRear'] as int?),
            brakeGain: Value(row['brakeGain'] as int?),
            bearingServiceDate: Value(switch (
                row['bearingServiceDate'] as String?) {
              null => null,
              final iso => DateTime.parse(iso),
            }),
            tireDate: Value(switch (row['tireDate'] as String?) {
              null => null,
              final iso => DateTime.parse(iso),
            }),
            journalEntryId: Value(row['journalEntryId'] as int?),
          ));
    }
  });
  return (data['lifetimeCampgrounds'] as num?)?.toInt() ??
      campgrounds.length;
}
