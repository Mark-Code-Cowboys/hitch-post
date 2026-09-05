import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';
import 'package:stream_transform/stream_transform.dart';

import '../database/app_database.dart';

/// A visit joined with its journal entry (the stay's story, rating,
/// photos, tags). Visits without any of those have no entry.
class VisitWithStory {
  const VisitWithStory(this.visit,
      {this.entry, this.photos = const [], this.tags = const []});

  final Visit visit;
  final JournalEntry? entry;
  final List<JournalPhoto> photos;
  final List<JournalTag> tags;

  String? get notes => entry?.notes;
  int? get rating => entry?.rating;

  /// Nights stayed; a same-day stop counts as zero.
  int get nights => visit.depart.difference(visit.arrive).inDays;
}

/// A visit being composed. Story fields land in the journal tables.
class VisitDraft {
  const VisitDraft({
    required this.arrive,
    required this.depart,
    this.costTotalCents,
    this.rating,
    this.notes,
    this.photos = const [],
    this.tags = const [],
  });

  final DateTime arrive;
  final DateTime depart;
  final int? costTotalCents;
  final int? rating;
  final String? notes;
  final List<JournalPhotoDraft> photos;
  final List<String> tags;

  bool get hasStory =>
      notes != null || rating != null || photos.isNotEmpty || tags.isNotEmpty;
}

class VisitRepository {
  VisitRepository(this._db, {AppJournalRepository? journal})
      : _journalOverride = journal; // ignore: prefer_initializing_formals

  final AppDatabase _db;
  final AppJournalRepository? _journalOverride;
  late final AppJournalRepository _journal =
      _journalOverride ?? _db.journal();

  /// Every visit in the log, raw — the trends math and exporters work
  /// across the whole book.
  Stream<List<Visit>> watchAllRaw() => _db.select(_db.visits).watch();

  /// A site's visits, newest arrival first, each with its story.
  Stream<List<VisitWithStory>> watchForSite(int siteId) {
    final query = _db.select(_db.visits)
      ..where((v) => v.siteId.equals(siteId))
      ..orderBy([
        (v) => OrderingTerm.desc(v.arrive),
        (v) => OrderingTerm.desc(v.id),
      ]);
    return _withStories(query.watch());
  }

  Stream<VisitWithStory?> watchOne(int visitId) {
    final query = _db.select(_db.visits)..where((v) => v.id.equals(visitId));
    return _withStories(query.watch().map((rows) => rows.take(1).toList()))
        .map((list) => list.isEmpty ? null : list.single);
  }

  /// Every visit, oldest arrival first — trends aggregates.
  Stream<List<Visit>> watchAll() {
    final query = _db.select(_db.visits)
      ..orderBy([(v) => OrderingTerm.asc(v.arrive)]);
    return query.watch();
  }

  Stream<List<VisitWithStory>> _withStories(Stream<List<Visit>> visits) {
    final entries = _db.select(_db.appJournalEntries).watch();
    final photos = (_db.select(_db.appJournalPhotos)
          ..orderBy([(p) => OrderingTerm.asc(p.id)]))
        .watch();
    final tags = (_db.select(_db.appJournalTags)
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .watch();
    return visits
        .combineLatest(
            entries, (List<Visit> v, List<JournalEntry> e) => (v, e))
        .combineLatest(photos, (pair, List<JournalPhoto> p) => (pair, p))
        .combineLatest(tags, (nested, List<JournalTag> t) {
      final ((visitRows, entryRows), photoRows) = nested;
      final byId = {for (final e in entryRows) e.id: e};
      return [
        for (final visit in visitRows)
          VisitWithStory(
            visit,
            entry: byId[visit.journalEntryId],
            photos: [
              for (final p in photoRows)
                if (p.entryId == visit.journalEntryId) p,
            ],
            tags: [
              for (final tag in t)
                if (tag.entryId == visit.journalEntryId) tag,
            ],
          ),
      ];
    });
  }

  /// Creates the visit (and its journal entry when there's a story)
  /// atomically; returns the visit id.
  Future<int> create(int siteId, VisitDraft d) {
    return _db.transaction(() async {
      int? entryId;
      if (d.hasStory) {
        entryId = await _journal.createEntry(JournalEntryDraft(
          notes: d.notes,
          rating: d.rating,
          photos: d.photos,
          tags: d.tags,
        ));
      }
      return _db.into(_db.visits).insert(VisitsCompanion.insert(
            siteId: siteId,
            arrive: d.arrive,
            depart: d.depart,
            costTotalCents: Value(d.costTotalCents),
            journalEntryId: Value(entryId),
          ));
    });
  }

  /// Rewrites the visit's fields and its story text/rating. Photos and
  /// tags are managed separately via the entry.
  Future<void> update(int visitId, VisitDraft d) {
    return _db.transaction(() async {
      final visit = await (_db.select(_db.visits)
            ..where((v) => v.id.equals(visitId)))
          .getSingle();
      var entryId = visit.journalEntryId;
      final hasText = d.notes != null || d.rating != null;
      if (entryId == null && hasText) {
        entryId = await _journal
            .createEntry(JournalEntryDraft(notes: d.notes, rating: d.rating));
      } else if (entryId != null) {
        await _journal.updateEntry(entryId, notes: d.notes, rating: d.rating);
      }
      await (_db.update(_db.visits)..where((v) => v.id.equals(visitId)))
          .write(VisitsCompanion(
        arrive: Value(d.arrive),
        depart: Value(d.depart),
        costTotalCents: Value(d.costTotalCents),
        journalEntryId: Value(entryId),
      ));
    });
  }

  /// The visit's entry id, creating an empty entry if none exists yet
  /// (first photo on a story-less visit).
  Future<int> ensureEntry(int visitId) async {
    final visit = await (_db.select(_db.visits)
          ..where((v) => v.id.equals(visitId)))
        .getSingle();
    if (visit.journalEntryId != null) return visit.journalEntryId!;
    final entryId = await _journal.createEntry(const JournalEntryDraft());
    await (_db.update(_db.visits)..where((v) => v.id.equals(visitId)))
        .write(VisitsCompanion(journalEntryId: Value(entryId)));
    return entryId;
  }

  Future<int> addPhoto(int visitId, JournalPhotoDraft p) async =>
      _journal.addPhoto(await ensureEntry(visitId), p);

  Future<void> removePhoto(int photoId) => _journal.removePhoto(photoId);

  /// Deletes the visit and its journal entry (photo files included).
  Future<void> delete(int visitId) async {
    final visit = await (_db.select(_db.visits)
          ..where((v) => v.id.equals(visitId)))
        .getSingleOrNull();
    await (_db.delete(_db.visits)..where((v) => v.id.equals(visitId))).go();
    final entryId = visit?.journalEntryId;
    if (entryId != null) await _journal.deleteEntries([entryId]);
  }
}
