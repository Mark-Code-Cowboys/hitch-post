import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hitch_post/core/backup/backup_service.dart';
import 'package:hitch_post/core/export/export_service.dart';
import 'package:hitch_post/data/repositories/campground_repository.dart';
import 'package:hitch_post/data/repositories/rig_repository.dart';
import 'package:hitch_post/data/repositories/site_repository.dart';
import 'package:hitch_post/data/repositories/visit_repository.dart';
import 'package:hitch_post/data/database/app_database.dart';

import '../helpers.dart';

void main() {
  test('backup archive round-trips the whole log and the tally', () async {
    final source = makeTestDb();
    addTearDown(source.close);
    final campgrounds = CampgroundRepository(source);
    final sites = SiteRepository(source);
    final visits = VisitRepository(source);
    final rigs = RigRepository(source);

    final pinesId = await campgrounds.create(campgroundDraft(
        name: 'Big Pines', state: 'MI', rating: 4));
    await campgrounds.create(campgroundDraft(name: 'Riverbend', state: 'OH'));
    final siteId = await sites.create(pinesId, siteDraft(siteNo: '42'));
    await visits.create(
      siteId,
      visitDraft(
        arrive: DateTime(2026, 6, 12),
        depart: DateTime(2026, 6, 15),
        costTotalCents: 9600,
        rating: 5,
        notes: 'Back in next June.',
        photos: const [
          JournalPhotoDraft(path: 'visit-1.jpg', caption: 'the view'),
        ],
      ),
    );
    await rigs.create(const RigDraft(
        name: 'The Ark',
        kind: RigKind.travelTrailer,
        lengthFt: 28,
        notes: 'WD bars on setting 4.'));

    // Lifetime figure larger than the row count (a deleted campground).
    final bytes = buildBackupArchive(
      exportData: await buildExportData(source,
          lifetimeCampgrounds: 7, now: DateTime(2026, 9, 5)),
      media: {
        'visit-1.jpg': [1, 2, 3],
      },
    );

    // Restore into a fresh database, as after a reinstall.
    final target = makeTestDb();
    addTearDown(target.close);
    final tally = LifetimeTally(InMemoryKeyValueStore(),
        key: 'campgrounds_created_lifetime');
    addTearDown(tally.dispose);

    final contents = readBackupArchive(bytes);
    expect(contents.media['visit-1.jpg'], [1, 2, 3]);
    final lifetime = await restoreFromExportData(target, contents.exportData);
    await tally.raiseTo(lifetime);

    expect(await tally.value(), 7);
    final restored = await buildExportData(target,
        lifetimeCampgrounds: 7, now: DateTime(2026, 9, 5));
    expect(restored, contents.exportData);

    // Spot checks through the repositories.
    expect(await CampgroundRepository(target).count(), 2);
    final restoredVisit =
        (await VisitRepository(target).watchForSite(siteId).first).single;
    expect(restoredVisit.visit.costTotalCents, 9600);
    expect(restoredVisit.rating, 5);
    expect(restoredVisit.notes, 'Back in next June.');
    expect(restoredVisit.photos.single.caption, 'the view');
    final restoredRig =
        (await RigRepository(target).watchAll().first).single;
    expect(restoredRig.rig.name, 'The Ark');
    expect(restoredRig.notes, 'WD bars on setting 4.');
  });

  test('restore rejects foreign or malformed exports', () async {
    final db = makeTestDb();
    addTearDown(db.close);
    expect(
      () => restoreFromExportData(db, {'app': 'CourseLedger', 'format': 1}),
      throwsA(isA<InvalidBackupException>()),
    );
    expect(
      () => restoreFromExportData(
          db, {'app': 'HitchPost', 'format': 1, 'campgrounds': 'nope'}),
      throwsA(isA<InvalidBackupException>()),
    );
  });

  test('CSV export flattens campground + site + visit into one row',
      () async {
    final db = makeTestDb();
    addTearDown(db.close);
    final campgrounds = CampgroundRepository(db);
    final sites = SiteRepository(db);
    final visits = VisitRepository(db);
    final pinesId = await campgrounds.create(
        campgroundDraft(name: 'Big Pines', state: 'MI'));
    final siteId = await sites.create(pinesId, siteDraft(siteNo: '42'));
    await visits.create(
        siteId,
        visitDraft(
            arrive: DateTime(2026, 6, 12),
            depart: DateTime(2026, 6, 15),
            costTotalCents: 9600,
            notes: 'Good shade'));

    final share = FakeShareLauncher();
    final temp = await Directory.systemTemp.createTemp('hp-export');
    addTearDown(() => temp.delete(recursive: true));
    final file = await ExportService(db, share, () async => temp)
        .shareVisitsCsv(now: DateTime(2026, 9, 5));

    expect(share.sharedFiles, [file.path]);
    expect(file.path, endsWith('hitchpost-visits-2026-09-05.csv'));
    final doc = parseCsv(await file.readAsString());
    expect(doc.header.first, 'campground');
    final row = doc.rows.single;
    expect(doc.rowCell(row, 0), 'Big Pines');
    expect(doc.rowCell(row, doc.header.indexOf('site')), '42');
    expect(doc.rowCell(row, doc.header.indexOf('nights')), '3');
    expect(doc.rowCell(row, doc.header.indexOf('cost_total')), '96.00');
    expect(doc.rowCell(row, doc.header.indexOf('notes')), 'Good shade');
  });
}
