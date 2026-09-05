import 'package:drift/drift.dart';

import '../database/app_database.dart';

/// A site being composed, before it has a database id.
class SiteDraft {
  const SiteDraft({
    required this.siteNo,
    this.amps = Amps.none,
    this.water = false,
    this.sewer = false,
    this.maxLengthFt,
    this.approach,
    this.shade,
    this.level,
    this.cellBars,
    this.cellCarrier,
    this.notes,
  });

  final String siteNo;
  final Amps amps;
  final bool water;
  final bool sewer;
  final int? maxLengthFt;
  final Approach? approach;
  final Shade? shade;
  final Level? level;
  final int? cellBars;
  final String? cellCarrier;
  final String? notes;
}

class SiteRepository {
  SiteRepository(this._db, {AppJournalRepository? journal})
      : _journalOverride = journal; // ignore: prefer_initializing_formals

  final AppDatabase _db;
  final AppJournalRepository? _journalOverride;
  late final AppJournalRepository _journal =
      _journalOverride ?? _db.journal();

  /// A campground's sites, by site number.
  Stream<List<Site>> watchForCampground(int campgroundId) {
    final query = _db.select(_db.sites)
      ..where((s) => s.campgroundId.equals(campgroundId))
      ..orderBy([(s) => OrderingTerm.asc(s.siteNo)]);
    return query.watch();
  }

  Stream<Site?> watchOne(int id) {
    final query = _db.select(_db.sites)..where((s) => s.id.equals(id));
    return query.watchSingleOrNull();
  }

  Future<int> create(int campgroundId, SiteDraft d) {
    return _db.into(_db.sites).insert(_companion(campgroundId, d));
  }

  Future<void> update(int id, SiteDraft d) async {
    final site = await (_db.select(_db.sites)..where((s) => s.id.equals(id)))
        .getSingle();
    await (_db.update(_db.sites)..where((s) => s.id.equals(id)))
        .write(_companion(site.campgroundId, d));
  }

  /// How many visits a delete would take with it.
  Future<int> visitCount(int id) async {
    final countExp = _db.visits.id.count();
    final query = _db.selectOnly(_db.visits)
      ..addColumns([countExp])
      ..where(_db.visits.siteId.equals(id));
    return (await query.getSingle()).read(countExp)!;
  }

  /// Visits cascade with the site; their journal entries are deleted
  /// explicitly.
  Future<void> delete(int id) async {
    final entryId = _db.visits.journalEntryId;
    final query = _db.selectOnly(_db.visits)
      ..addColumns([entryId])
      ..where(_db.visits.siteId.equals(id) & entryId.isNotNull());
    final entryIds =
        (await query.get()).map((r) => r.read(entryId)!).toList();
    await (_db.delete(_db.sites)..where((s) => s.id.equals(id))).go();
    if (entryIds.isNotEmpty) await _journal.deleteEntries(entryIds);
  }

  SitesCompanion _companion(int campgroundId, SiteDraft d) =>
      SitesCompanion.insert(
        campgroundId: campgroundId,
        siteNo: d.siteNo,
        amps: d.amps,
        water: Value(d.water),
        sewer: Value(d.sewer),
        maxLengthFt: Value(d.maxLengthFt),
        approach: Value(d.approach),
        shade: Value(d.shade),
        level: Value(d.level),
        cellBars: Value(d.cellBars),
        cellCarrier: Value(d.cellCarrier),
        notes: Value(d.notes),
      );
}
