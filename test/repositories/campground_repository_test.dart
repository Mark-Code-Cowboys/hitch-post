import 'package:flutter_test/flutter_test.dart';

import 'package:hitch_post/data/database/app_database.dart';
import 'package:hitch_post/data/repositories/campground_repository.dart';
import 'package:hitch_post/data/repositories/site_repository.dart';
import 'package:hitch_post/data/repositories/visit_repository.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late CampgroundRepository repo;

  setUp(() {
    db = makeTestDb();
    repo = CampgroundRepository(db);
  });

  tearDown(() => db.close());

  test('create stores fields and count feeds the free limit', () async {
    await repo.create(campgroundDraft(name: 'Pine Flats', rating: 4));
    await repo.create(campgroundDraft(
        name: 'Mirror Lake COE',
        kind: CampgroundKind.coe,
        state: 'WI',
        wouldReturn: false));

    expect(await repo.count(), 2);
    final all = await repo.watchAll().first;
    expect(all.map((c) => c.name), ['Mirror Lake COE', 'Pine Flats']);
    final pine = all.singleWhere((c) => c.name == 'Pine Flats');
    expect(pine.kind, CampgroundKind.statePark);
    expect(pine.rating, 4);
    expect(pine.wouldReturn, isTrue);
    expect(all.first.wouldReturn, isFalse);
  });

  test('rating outside 1-5 is rejected by the schema', () async {
    expect(() => repo.create(campgroundDraft(rating: 6)), throwsA(anything));
  });

  test('update rewrites fields', () async {
    final id = await repo.create(campgroundDraft());
    await repo.update(
        id, campgroundDraft(name: 'Pine Flats SP', rating: 5,
            wouldReturn: false));
    final stored = await repo.watchOne(id).first;
    expect(stored!.name, 'Pine Flats SP');
    expect(stored.rating, 5);
    expect(stored.wouldReturn, isFalse);
  });

  test('dependentCounts reports sites and visits before a delete',
      () async {
    final id = await repo.create(campgroundDraft());
    final sites = SiteRepository(db);
    final visits = VisitRepository(db);
    final a = await sites.create(id, siteDraft(siteNo: 'A1'));
    final b = await sites.create(id, siteDraft(siteNo: 'B2'));
    await visits.create(a, visitDraft());
    await visits.create(a, visitDraft(arrive: DateTime(2025, 7, 1),
        depart: DateTime(2025, 7, 3)));
    await visits.create(b, visitDraft());

    final deps = await repo.dependentCounts(id);
    expect(deps.sites, 2);
    expect(deps.visits, 3);
  });

  test('delete cascades sites and visits and cleans their entries',
      () async {
    final id = await repo.create(campgroundDraft());
    final sites = SiteRepository(db);
    final visits = VisitRepository(db);
    final siteId = await sites.create(id, siteDraft());
    await visits.create(siteId,
        visitDraft(notes: 'First trip out.', rating: 5));

    expect(await db.select(db.appJournalEntries).get(), hasLength(1));

    await repo.delete(id);

    expect(await repo.count(), 0);
    expect(await db.select(db.sites).get(), isEmpty);
    expect(await db.select(db.visits).get(), isEmpty);
    expect(await db.select(db.appJournalEntries).get(), isEmpty);
  });
}
