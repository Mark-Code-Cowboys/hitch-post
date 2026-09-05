import 'dart:math';

import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';
import 'package:stream_transform/stream_transform.dart';

import '../database/app_database.dart';

/// What hangs off a campground — shown before a delete so the user
/// knows what goes with it.
class CampgroundDependents {
  const CampgroundDependents({required this.sites, required this.visits});

  final int sites;
  final int visits;
}

/// A campground being composed, before it has a database id.
class CampgroundDraft {
  const CampgroundDraft({
    required this.name,
    required this.kind,
    this.state,
    this.notes,
    this.rating,
    this.wouldReturn = true,
    this.lat,
    this.lon,
  });

  final String name;
  final CampgroundKind kind;
  final String? state;
  final String? notes;
  final int? rating;
  final bool wouldReturn;
  final double? lat;
  final double? lon;
}

class CampgroundRepository {
  CampgroundRepository(this._db,
      {AppJournalRepository? journal, LifetimeTally? tally})
      // ignore: prefer_initializing_formals
      : _journalOverride = journal,
        _tally = tally; // ignore: prefer_initializing_formals

  final AppDatabase _db;
  final AppJournalRepository? _journalOverride;
  final LifetimeTally? _tally;
  late final AppJournalRepository _journal =
      _journalOverride ?? _db.journal();

  /// All campgrounds A-Z; the home screen re-sorts per its mode.
  Stream<List<Campground>> watchAll() {
    final query = _db.select(_db.campgrounds)
      ..orderBy([(c) => OrderingTerm.asc(c.name.lower())]);
    return query.watch();
  }

  /// One-shot list for the importers (matching by name).
  Future<List<Campground>> getAll() => _db.select(_db.campgrounds).get();

  Stream<Campground?> watchOne(int id) {
    final query = _db.select(_db.campgrounds)..where((c) => c.id.equals(id));
    return query.watchSingleOrNull();
  }

  /// Campgrounds in the ledger — feeds `FreeLimit(5, 'campgrounds')`.
  Future<int> count() async {
    final countExp = _db.campgrounds.id.count();
    final query = _db.selectOnly(_db.campgrounds)..addColumns([countExp]);
    return (await query.getSingle()).read(countExp)!;
  }

  Future<int> create(CampgroundDraft d) async {
    final id = await _db.into(_db.campgrounds).insert(_companion(d));
    await _tally?.recordCreated(liveCount: await count());
    return id;
  }

  /// Campgrounds ever created on this device: the tally, but never
  /// below the live row count (pre-tally installs, backup restores).
  Future<int> lifetimeCreated() async {
    final live = await count();
    final tallied = await _tally?.value() ?? 0;
    return max(live, tallied);
  }

  /// Live [lifetimeCreated], ticking on creates and on row changes.
  Stream<int> watchLifetimeCreated() {
    final live = watchAll().map((rows) => rows.length);
    final tallied = _tally?.watch() ?? Stream.value(0);
    return live.combineLatest(tallied, (int a, int b) => max(a, b));
  }

  /// Sets (or clears, with nulls) the campground's map pin. Opt-in
  /// only: nothing else ever writes these columns.
  Future<void> setLocation(int id, {double? lat, double? lon}) {
    return (_db.update(_db.campgrounds)..where((c) => c.id.equals(id)))
        .write(CampgroundsCompanion(lat: Value(lat), lon: Value(lon)));
  }

  /// Rewrites the campground's fields — except the map pin, which only
  /// [setLocation] touches, so no edit path can silently clear it.
  Future<void> update(int id, CampgroundDraft d) {
    return (_db.update(_db.campgrounds)..where((c) => c.id.equals(id)))
        .write(_companion(d).copyWith(
            lat: const Value.absent(), lon: const Value.absent()));
  }

  /// How many sites and visits a delete would take with it.
  Future<CampgroundDependents> dependentCounts(int id) async {
    final siteCount = _db.sites.id.count();
    final sitesQuery = _db.selectOnly(_db.sites)
      ..addColumns([siteCount])
      ..where(_db.sites.campgroundId.equals(id));
    final visitCount = _db.visits.id.count();
    final visitsQuery = _db.selectOnly(_db.visits).join([
      innerJoin(_db.sites, _db.sites.id.equalsExp(_db.visits.siteId),
          useColumns: false),
    ])
      ..addColumns([visitCount])
      ..where(_db.sites.campgroundId.equals(id));
    return CampgroundDependents(
      sites: (await sitesQuery.getSingle()).read(siteCount)!,
      visits: (await visitsQuery.getSingle()).read(visitCount)!,
    );
  }

  /// Sites and visits cascade with the campground; the visits' journal
  /// entries (and photo files) are deleted explicitly since the FK
  /// points domain -> entry.
  Future<void> delete(int id) async {
    final entryId = _db.visits.journalEntryId;
    final query = _db.selectOnly(_db.visits).join([
      innerJoin(_db.sites, _db.sites.id.equalsExp(_db.visits.siteId),
          useColumns: false),
    ])
      ..addColumns([entryId])
      ..where(_db.sites.campgroundId.equals(id) & entryId.isNotNull());
    final entryIds =
        (await query.get()).map((r) => r.read(entryId)!).toList();
    await (_db.delete(_db.campgrounds)..where((c) => c.id.equals(id))).go();
    if (entryIds.isNotEmpty) await _journal.deleteEntries(entryIds);
  }

  CampgroundsCompanion _companion(CampgroundDraft d) =>
      CampgroundsCompanion.insert(
        name: d.name,
        kind: d.kind,
        state: Value(d.state),
        notes: Value(d.notes),
        rating: Value(d.rating),
        wouldReturn: Value(d.wouldReturn),
        lat: Value(d.lat),
        lon: Value(d.lon),
      );
}
