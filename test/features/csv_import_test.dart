import 'package:cc_core/cc_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hitch_post/data/database/app_database.dart';
import 'package:hitch_post/data/repositories/campground_repository.dart';
import 'package:hitch_post/data/repositories/site_repository.dart';
import 'package:hitch_post/data/repositories/visit_repository.dart';
import 'package:hitch_post/features/monetization/free_limit.dart';
import 'package:hitch_post/features/scan_import/csv_importer.dart';
import 'package:hitch_post/features/scan_import/notebook_importer.dart';

import '../helpers.dart';

void main() {
  test('guesses the Excel-crowd headers', () {
    final mapping = guessCsvMapping(
      ['Campground', 'State', 'Site #', 'Check In', 'Check Out', 'Cost',
          'Stars', 'Comments'],
      hpCsvFields,
    );
    expect(mapping, {
      'campground': 0,
      'state': 1,
      'siteNo': 2,
      'arrive': 3,
      'depart': 4,
      'cost': 5,
      'rating': 6,
      'notes': 7,
    });
  });

  test('parseCostCell reads spreadsheet money and nothing else', () {
    expect(parseCostCell(r'$96.00'), 9600);
    expect(parseCostCell('96'), 9600);
    expect(parseCostCell(r'$1,234.56'), 123456);
    expect(parseCostCell('three nights'), isNull);
  });

  group('importCsvVisits', () {
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

    final doc = parseCsv('Campground,State,Site,Arrive,Depart,Cost,'
        'Stars,Notes\n'
        'Big Pines,MI,42,6/12/2026,6/15/2026,\$96.00,4,Good shade\n'
        'Riverbend,zz,,7/1/2026,,,9,\n'
        'No Date Here,MI,7,not a date,,,,\n');
    final mapping = guessCsvMapping(doc.header, hpCsvFields);

    Future<CsvImportReport> run({bool entitled = true}) => importCsvVisits(
          campgrounds: campgrounds,
          sites: sites,
          visits: visits,
          doc: doc,
          mapping: mapping,
          entitled: entitled,
        );

    test('imports rows, validates state and rating, skips unusable rows',
        () async {
      final report = await run();
      expect(report.visitsAdded, 2);
      expect(report.campgroundsCreated, 2);
      expect(report.rowsSkipped, 1); // the unreadable-date row

      final all = await campgrounds.getAll();
      final bigPines = all.singleWhere((c) => c.name == 'Big Pines');
      expect(bigPines.state, 'MI');
      final riverbend = all.singleWhere((c) => c.name == 'Riverbend');
      expect(riverbend.state, isNull); // "zz" isn't a state

      final pinesSites = await sites.getForCampground(bigPines.id);
      expect(pinesSites.single.siteNo, '42');
      final pinesVisit =
          (await visits.watchForSite(pinesSites.single.id).first).single;
      expect(pinesVisit.visit.costTotalCents, 9600);
      expect(pinesVisit.rating, 4);
      expect(pinesVisit.notes, 'Good shade');

      final riverbendSites = await sites.getForCampground(riverbend.id);
      expect(riverbendSites.single.siteNo, unknownSiteNo);
      final riverbendVisit =
          (await visits.watchForSite(riverbendSites.single.id).first).single;
      expect(riverbendVisit.rating, isNull); // 9 isn't a rating
      // No depart: the arrive date stands in.
      expect(riverbendVisit.visit.depart, riverbendVisit.visit.arrive);
    });

    test('free users: new campgrounds stop at the cap, existing ones '
        'still import', () async {
      for (var i = 0; i < kFreeCampgroundLimit - 1; i++) {
        await campgrounds.create(campgroundDraft(name: 'Filler $i'));
      }
      await campgrounds.create(campgroundDraft(name: 'Big Pines'));
      final report = await run(entitled: false);
      // Big Pines exists -> imports; Riverbend would be a 6th
      // campground -> counted, skipped.
      expect(report.visitsAdded, 1);
      expect(report.campgroundsCreated, 0);
      expect(report.campgroundsSkippedAtCap, 1);
    });
  });
}
