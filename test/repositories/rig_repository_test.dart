import 'package:cc_core/cc_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hitch_post/data/database/app_database.dart';
import 'package:hitch_post/data/repositories/rig_repository.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late RigRepository repo;

  setUp(() {
    db = makeTestDb();
    repo = RigRepository(db);
  });

  tearDown(() => db.close());

  test('create stores the tow setup and count feeds FreeLimit(1)',
      () async {
    await repo.create(const RigDraft(
      name: 'Grey Wolf 26DBH',
      kind: RigKind.travelTrailer,
      lengthFt: 30,
      gvwrLbs: 7700,
      ballSizeIn: '2-5/16',
      hitchDropIn: 3,
      wdBarSetting: 'Chain link 5',
      tirePsiFront: 65,
      tirePsiRear: 65,
      brakeGain: 6,
      notes: 'Sways above 65 mph unloaded.',
    ));

    expect(await repo.count(), 1);
    final rig = (await repo.watchAll().first).single;
    expect(rig.rig.kind, RigKind.travelTrailer);
    expect(rig.rig.ballSizeIn, '2-5/16');
    expect(rig.rig.brakeGain, 6);
    expect(rig.notes, contains('Sways'));
  });

  test('update rewrites settings and the note entry', () async {
    final id = await repo.create(
        const RigDraft(name: 'Van', kind: RigKind.camperVan));
    await repo.update(
        id,
        const RigDraft(
            name: 'Van',
            kind: RigKind.camperVan,
            tirePsiFront: 55,
            bearingServiceDate: null,
            notes: 'Rotated tires.'));

    final rig = (await repo.watchOne(id).first)!;
    expect(rig.rig.tirePsiFront, 55);
    expect(rig.notes, 'Rotated tires.');
  });

  test('delete cleans the journal entry and photo rows', () async {
    final id = await repo.create(RigDraft(
        name: 'Fiver',
        kind: RigKind.fifthWheel,
        notes: 'Hitch photo attached.',
        photos: const [JournalPhotoDraft(path: 'hitch.jpg')]));

    await repo.delete(id);

    expect(await repo.count(), 0);
    expect(await db.select(db.appJournalEntries).get(), isEmpty);
    expect(await db.select(db.appJournalPhotos).get(), isEmpty);
  });
}
