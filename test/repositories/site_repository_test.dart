import 'package:flutter_test/flutter_test.dart';

import 'package:hitch_post/data/database/app_database.dart';
import 'package:hitch_post/data/repositories/campground_repository.dart';
import 'package:hitch_post/data/repositories/site_repository.dart';
import 'package:hitch_post/data/repositories/visit_repository.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late SiteRepository repo;
  late int campgroundId;

  setUp(() async {
    db = makeTestDb();
    repo = SiteRepository(db);
    campgroundId =
        await CampgroundRepository(db).create(campgroundDraft());
  });

  tearDown(() => db.close());

  test('create stores the rebooking grid fields', () async {
    await repo.create(
        campgroundId,
        const SiteDraft(
          siteNo: '42',
          amps: Amps.a50,
          water: true,
          sewer: true,
          maxLengthFt: 35,
          approach: Approach.pullThru,
          shade: Shade.partial,
          level: Level.yes,
          cellBars: 3,
          cellCarrier: 'VZW',
          notes: 'Long pull-thru; utilities mid-site.',
        ));

    final sites = await repo.watchForCampground(campgroundId).first;
    final site = sites.single;
    expect(site.siteNo, '42');
    expect(site.amps, Amps.a50);
    expect(site.sewer, isTrue);
    expect(site.maxLengthFt, 35);
    expect(site.approach, Approach.pullThru);
    expect(site.shade, Shade.partial);
    expect(site.level, Level.yes);
    expect(site.cellBars, 3);
    expect(site.cellCarrier, 'VZW');
  });

  test('cellBars outside 0-5 is rejected by the schema', () async {
    expect(
      () => repo.create(campgroundId, const SiteDraft(siteNo: 'X', cellBars: 6)),
      throwsA(anything),
    );
  });

  test('sites list by site number; update keeps the campground', () async {
    final id = await repo.create(campgroundId, siteDraft(siteNo: 'B2'));
    await repo.create(campgroundId, siteDraft(siteNo: 'A1'));

    var sites = await repo.watchForCampground(campgroundId).first;
    expect(sites.map((s) => s.siteNo), ['A1', 'B2']);

    await repo.update(id, siteDraft(siteNo: 'B3', amps: Amps.a50));
    sites = await repo.watchForCampground(campgroundId).first;
    expect(sites.map((s) => s.siteNo), ['A1', 'B3']);
    expect(sites.last.campgroundId, campgroundId);
  });

  test('delete cascades visits and cleans their entries', () async {
    final siteId = await repo.create(campgroundId, siteDraft());
    final visits = VisitRepository(db);
    await visits.create(siteId, visitDraft(notes: 'Rained all weekend.'));
    expect(await repo.visitCount(siteId), 1);

    await repo.delete(siteId);

    expect(await db.select(db.visits).get(), isEmpty);
    expect(await db.select(db.appJournalEntries).get(), isEmpty);
  });
}
