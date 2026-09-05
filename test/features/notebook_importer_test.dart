import 'package:flutter_test/flutter_test.dart';
import 'package:hitch_post/data/database/app_database.dart';
import 'package:hitch_post/data/repositories/campground_repository.dart';
import 'package:hitch_post/data/repositories/site_repository.dart';
import 'package:hitch_post/data/repositories/visit_repository.dart';
import 'package:hitch_post/features/scan_import/notebook_importer.dart';
import 'package:hitch_post/features/scan_import/visit_page_parser.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late CampgroundRepository campgrounds;
  late SiteRepository sites;
  late VisitRepository visits;

  setUp(() {
    db = makeTestDb();
    campgrounds = CampgroundRepository(db);
    sites = SiteRepository(db);
    visits = VisitRepository(db);
  });

  tearDown(() => db.close());

  Future<NotebookImportReport> run(List<VisitPageDraft> drafts) =>
      insertVisitPages(
          campgrounds: campgrounds,
          sites: sites,
          visits: visits,
          drafts: drafts);

  test('creates campground, site, and visit from a full page', () async {
    final report = await run([
      VisitPageDraft(
        campground: 'Big Pines RV Park',
        state: 'MI',
        siteNo: '42',
        arrive: DateTime(2026, 6, 12),
        depart: DateTime(2026, 6, 15),
        costTotalCents: 9600,
        notes: 'Tight pull-thru',
      ),
    ]);
    expect(report.visitsAdded, 1);
    expect(report.campgroundsCreated, 1);

    final all = await campgrounds.getAll();
    expect(all.single.name, 'Big Pines RV Park');
    expect(all.single.state, 'MI');
    expect(all.single.kind, CampgroundKind.other);
    final campgroundSites = await sites.getForCampground(all.single.id);
    expect(campgroundSites.single.siteNo, '42');
    final story = await visits
        .watchForSite(campgroundSites.single.id)
        .first;
    expect(story.single.visit.costTotalCents, 9600);
    expect(story.single.notes, 'Tight pull-thru');
  });

  test('matches existing campgrounds case-insensitively and shares the '
      'unknown site', () async {
    final id = await campgrounds.create(campgroundDraft(name: 'Pine Flats'));
    await run([
      VisitPageDraft(campground: 'PINE FLATS', arrive: DateTime(2026, 5, 1)),
      VisitPageDraft(campground: 'pine flats', arrive: DateTime(2026, 7, 1)),
    ]);
    expect((await campgrounds.getAll()).length, 1);
    final campgroundSites = await sites.getForCampground(id);
    // Both dateless-site pages share the one "—" site.
    expect(campgroundSites.single.siteNo, unknownSiteNo);
  });

  test('pages without a campground name are skipped and counted',
      () async {
    final report = await run([
      VisitPageDraft(notes: 'no header on this page'),
      VisitPageDraft(campground: 'Riverbend'),
    ]);
    expect(report.pagesSkipped, 1);
    expect(report.visitsAdded, 1);
  });

  test('a page without dates is filed under today', () async {
    await run([VisitPageDraft(campground: 'Riverbend')]);
    final all = await campgrounds.getAll();
    final campgroundSites = await sites.getForCampground(all.single.id);
    final story =
        await visits.watchForSite(campgroundSites.single.id).first;
    final now = DateTime.now();
    expect(story.single.visit.arrive.year, now.year);
    expect(story.single.visit.depart, story.single.visit.arrive);
  });
}
