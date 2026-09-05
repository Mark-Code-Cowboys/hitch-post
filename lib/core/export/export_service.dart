import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';

import '../../data/database/app_database.dart';
import '../backup/backup_service.dart';
import '../utils/labels.dart';

/// Writes exports to temp files and hands them to the share sheet.
/// The temp directory is injected so tests stay plugin-free.
class ExportService {
  ExportService(this._db, this._share, this._tempDir,
      {PhotoService? photos})
      : _photos = photos; // ignore: prefer_initializing_formals

  final AppDatabase _db;
  final ShareLauncher _share;
  final Future<Directory> Function() _tempDir;
  final PhotoService? _photos;

  static String _stamp(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  /// Every visit as one flattened CSV row joined with its site and
  /// campground — the spreadsheet the Excel crowd came from, back out.
  /// Returns the written file (mainly for tests).
  Future<File> shareVisitsCsv({DateTime? now}) async {
    final campgrounds = {
      for (final c in await _db.select(_db.campgrounds).get()) c.id: c,
    };
    final sites = {
      for (final s in await _db.select(_db.sites).get()) s.id: s,
    };
    final visits = await (_db.select(_db.visits)
          ..orderBy([(t) => OrderingTerm.asc(t.arrive)]))
        .get();
    final entries = {
      for (final e in await _db.select(_db.appJournalEntries).get()) e.id: e,
    };

    final csv = buildCsv([
      [
        'campground', 'kind', 'state', 'would_return', 'site', 'power',
        'water', 'sewer', 'arrive', 'depart', 'nights', 'cost_total',
        'rating', 'notes',
      ],
      for (final v in visits)
        [
          campgrounds[sites[v.siteId]?.campgroundId]?.name,
          campgrounds[sites[v.siteId]?.campgroundId]?.kind.label,
          campgrounds[sites[v.siteId]?.campgroundId]?.state,
          campgrounds[sites[v.siteId]?.campgroundId]?.wouldReturn,
          sites[v.siteId]?.siteNo,
          sites[v.siteId]?.amps.label,
          sites[v.siteId]?.water,
          sites[v.siteId]?.sewer,
          v.arrive.toIso8601String().substring(0, 10),
          v.depart.toIso8601String().substring(0, 10),
          v.depart.difference(v.arrive).inDays,
          v.costTotalCents == null
              ? null
              : (v.costTotalCents! / 100).toStringAsFixed(2),
          entries[v.journalEntryId]?.rating,
          entries[v.journalEntryId]?.notes,
        ],
    ]);

    final stamp = _stamp(now ?? DateTime.now());
    final file =
        File('${(await _tempDir()).path}/hitchpost-visits-$stamp.csv');
    await file.writeAsString(csv);
    await _share.shareFile(file.path,
        mimeType: 'text/csv', text: 'Hitch Post visits ($stamp)');
    return file;
  }

  /// The full log as one zip: export JSON plus journal photo files.
  Future<File> shareBackup(
      {required int lifetimeCampgrounds, DateTime? now}) async {
    final store = _photos;
    final bytes = buildBackupArchive(
      exportData: await buildExportData(_db,
          lifetimeCampgrounds: lifetimeCampgrounds, now: now),
      media: store == null
          ? const {}
          : await _db.journal().collectMedia(store),
    );
    final stamp = _stamp(now ?? DateTime.now());
    final file =
        File('${(await _tempDir()).path}/hitchpost-backup-$stamp.zip');
    await file.writeAsBytes(bytes);
    await _share.shareFile(file.path,
        mimeType: 'application/zip', text: 'Hitch Post backup ($stamp)');
    return file;
  }
}
