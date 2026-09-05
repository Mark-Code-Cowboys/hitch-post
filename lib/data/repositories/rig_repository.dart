import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';
import 'package:stream_transform/stream_transform.dart';

import '../database/app_database.dart';

/// A rig joined with its journal entry (notes and photos).
class RigWithStory {
  const RigWithStory(this.rig, {this.entry, this.photos = const []});

  final Rig rig;
  final JournalEntry? entry;
  final List<JournalPhoto> photos;

  String? get notes => entry?.notes;
}

/// A rig being composed. Notes/photos land in the journal tables.
class RigDraft {
  const RigDraft({
    required this.name,
    required this.kind,
    this.lengthFt,
    this.gvwrLbs,
    this.ballSizeIn,
    this.hitchDropIn,
    this.wdBarSetting,
    this.tirePsiFront,
    this.tirePsiRear,
    this.brakeGain,
    this.bearingServiceDate,
    this.tireDate,
    this.notes,
    this.photos = const [],
  });

  final String name;
  final RigKind kind;
  final int? lengthFt;
  final int? gvwrLbs;
  final String? ballSizeIn;
  final int? hitchDropIn;
  final String? wdBarSetting;
  final int? tirePsiFront;
  final int? tirePsiRear;
  final int? brakeGain;
  final DateTime? bearingServiceDate;
  final DateTime? tireDate;
  final String? notes;
  final List<JournalPhotoDraft> photos;

  bool get hasStory => notes != null || photos.isNotEmpty;
}

class RigRepository {
  RigRepository(this._db, {AppJournalRepository? journal})
      : _journalOverride = journal; // ignore: prefer_initializing_formals

  final AppDatabase _db;
  final AppJournalRepository? _journalOverride;
  late final AppJournalRepository _journal =
      _journalOverride ?? _db.journal();

  /// All rigs, A-Z, each with its story.
  Stream<List<RigWithStory>> watchAll() {
    final query = _db.select(_db.rigs)
      ..orderBy([(r) => OrderingTerm.asc(r.name.lower())]);
    final entries = _db.select(_db.appJournalEntries).watch();
    final photos = (_db.select(_db.appJournalPhotos)
          ..orderBy([(p) => OrderingTerm.asc(p.id)]))
        .watch();
    return query
        .watch()
        .combineLatest(entries, (List<Rig> r, List<JournalEntry> e) => (r, e))
        .combineLatest(photos, (pair, List<JournalPhoto> p) {
      final (rigRows, entryRows) = pair;
      final byId = {for (final e in entryRows) e.id: e};
      return [
        for (final rig in rigRows)
          RigWithStory(
            rig,
            entry: byId[rig.journalEntryId],
            photos: [
              for (final photo in p)
                if (photo.entryId == rig.journalEntryId) photo,
            ],
          ),
      ];
    });
  }

  Stream<RigWithStory?> watchOne(int id) =>
      watchAll().map((rigs) => rigs.where((r) => r.rig.id == id).firstOrNull);

  /// Rigs in the garage — feeds `FreeLimit(1, 'rigs')`.
  Future<int> count() async {
    final countExp = _db.rigs.id.count();
    final query = _db.selectOnly(_db.rigs)..addColumns([countExp]);
    return (await query.getSingle()).read(countExp)!;
  }

  /// Creates the rig (and its journal entry when there's a story)
  /// atomically; returns the rig id.
  Future<int> create(RigDraft d) {
    return _db.transaction(() async {
      int? entryId;
      if (d.hasStory) {
        entryId = await _journal.createEntry(
            JournalEntryDraft(notes: d.notes, photos: d.photos));
      }
      return _db.into(_db.rigs).insert(_companion(d, entryId));
    });
  }

  /// Rewrites the rig's fields and its notes. Photos are managed
  /// separately via the entry.
  Future<void> update(int id, RigDraft d) {
    return _db.transaction(() async {
      final rig =
          await (_db.select(_db.rigs)..where((r) => r.id.equals(id)))
              .getSingle();
      var entryId = rig.journalEntryId;
      if (entryId == null && d.notes != null) {
        entryId =
            await _journal.createEntry(JournalEntryDraft(notes: d.notes));
      } else if (entryId != null) {
        await _journal.updateEntry(entryId, notes: d.notes);
      }
      await (_db.update(_db.rigs)..where((r) => r.id.equals(id)))
          .write(_companion(d, entryId));
    });
  }

  /// Deletes the rig and its journal entry (photo files included).
  Future<void> delete(int id) async {
    final rig = await (_db.select(_db.rigs)..where((r) => r.id.equals(id)))
        .getSingleOrNull();
    await (_db.delete(_db.rigs)..where((r) => r.id.equals(id))).go();
    final entryId = rig?.journalEntryId;
    if (entryId != null) await _journal.deleteEntries([entryId]);
  }

  RigsCompanion _companion(RigDraft d, int? entryId) => RigsCompanion.insert(
        name: d.name,
        kind: d.kind,
        lengthFt: Value(d.lengthFt),
        gvwrLbs: Value(d.gvwrLbs),
        ballSizeIn: Value(d.ballSizeIn),
        hitchDropIn: Value(d.hitchDropIn),
        wdBarSetting: Value(d.wdBarSetting),
        tirePsiFront: Value(d.tirePsiFront),
        tirePsiRear: Value(d.tirePsiRear),
        brakeGain: Value(d.brakeGain),
        bearingServiceDate: Value(d.bearingServiceDate),
        tireDate: Value(d.tireDate),
        journalEntryId: Value(entryId),
      );
}
