import 'package:cc_core/cc_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hitch_post/data/database/app_database.dart';
import 'package:hitch_post/data/repositories/campground_repository.dart';
import 'package:hitch_post/data/repositories/site_repository.dart';
import 'package:hitch_post/data/repositories/visit_repository.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late VisitRepository repo;
  late int siteId;

  setUp(() async {
    db = makeTestDb();
    repo = VisitRepository(db);
    final campgroundId =
        await CampgroundRepository(db).create(campgroundDraft());
    siteId = await SiteRepository(db).create(campgroundId, siteDraft());
  });

  tearDown(() => db.close());

  test('create stores the stay and its story atomically', () async {
    final id = await repo.create(
      siteId,
      visitDraft(
        arrive: DateTime(2026, 6, 12),
        depart: DateTime(2026, 6, 15),
        costTotalCents: 13500,
        rating: 5,
        notes: 'Site held the 30-footer fine. Rebook 42.',
        photos: const [JournalPhotoDraft(path: 'pad.jpg', caption: 'the pad')],
        tags: const ['summer'],
      ),
    );

    final stored = await repo.watchOne(id).first;
    expect(stored!.visit.costTotalCents, 13500);
    expect(stored.nights, 3);
    expect(stored.rating, 5);
    expect(stored.notes, contains('Rebook 42'));
    expect(stored.photos.single.caption, 'the pad');
    expect(stored.tags.single.tag, 'summer');
  });

  test('a story-less visit gets no journal entry', () async {
    await repo.create(siteId, visitDraft());
    expect(await db.select(db.appJournalEntries).get(), isEmpty);
  });

  test('visits list newest arrival first', () async {
    await repo.create(siteId,
        visitDraft(arrive: DateTime(2025, 7, 1), depart: DateTime(2025, 7, 4)));
    final newest = await repo.create(siteId, visitDraft());

    final visits = await repo.watchForSite(siteId).first;
    expect(visits.first.visit.id, newest);
    expect(visits, hasLength(2));
  });

  test('update rewrites the stay and grows a story onto a bare visit',
      () async {
    final id = await repo.create(siteId, visitDraft());
    await repo.update(
        id,
        visitDraft(
            costTotalCents: 9900, rating: 3, notes: 'Train noise at 2am.'));

    final stored = await repo.watchOne(id).first;
    expect(stored!.visit.costTotalCents, 9900);
    expect(stored.rating, 3);
    expect(stored.notes, 'Train noise at 2am.');
    expect(await db.select(db.appJournalEntries).get(), hasLength(1));
  });

  test('addPhoto ensures an entry; delete cleans it up', () async {
    final id = await repo.create(siteId, visitDraft());
    await repo.addPhoto(id, const JournalPhotoDraft(path: 'sunset.jpg'));

    var stored = await repo.watchOne(id).first;
    expect(stored!.photos, hasLength(1));

    await repo.delete(id);
    expect(await db.select(db.visits).get(), isEmpty);
    expect(await db.select(db.appJournalEntries).get(), isEmpty);
    expect(await db.select(db.appJournalPhotos).get(), isEmpty);
  });
}
