import 'package:flutter_test/flutter_test.dart';
import 'package:hitch_post/data/database/app_database.dart';
import 'package:hitch_post/data/repositories/campground_repository.dart';
import 'package:hitch_post/features/map/map_pins.dart';

import '../helpers.dart';

void main() {
  test('setLocation is opt-in, movable, and clearable; only pinned '
      'campgrounds map', () async {
    final db = makeTestDb();
    addTearDown(db.close);
    final repo = CampgroundRepository(db);
    final pinesId = await repo.create(campgroundDraft(name: 'Big Pines'));
    await repo.create(campgroundDraft(name: 'Riverbend'));

    Future<List<Campground>> all() => repo.getAll();
    expect(campgroundPins(await all()), isEmpty);

    await repo.setLocation(pinesId, lat: 44.76, lon: -85.62);
    var pins = campgroundPins(await all());
    expect(pins.single.campground.name, 'Big Pines');
    expect(pins.single.point.latitude, 44.76);

    // Editing other fields must not touch the pin.
    await repo.update(pinesId, campgroundDraft(name: 'Big Pines', rating: 5));
    expect(campgroundPins(await all()), hasLength(1));

    await repo.setLocation(pinesId);
    expect(campgroundPins(await all()), isEmpty);
  });
}
