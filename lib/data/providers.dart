import 'package:cc_core/cc_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/app_database.dart';
import 'repositories/campground_repository.dart';
import 'repositories/rig_repository.dart';
import 'repositories/site_repository.dart';
import 'repositories/visit_repository.dart';

/// Overridden in main() with the real on-device database, and in tests
/// with an in-memory one.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('databaseProvider must be overridden'),
);

/// Overridden in tests with [InMemoryKeyValueStore].
final kvStoreProvider = Provider<KeyValueStore>((ref) => SharedPrefsStore());

/// Campgrounds ever created on this device; feeds the free tier so a
/// slot can't be recycled by delete-and-re-add. (Rigs deliberately use
/// the live count instead — trading up your trailer shouldn't lock a
/// free user out of the garage.)
final campgroundTallyProvider = Provider<LifetimeTally>((ref) {
  final tally = LifetimeTally(ref.watch(kvStoreProvider),
      key: 'campgrounds_created_lifetime');
  ref.onDispose(tally.dispose);
  return tally;
});

/// Overridden in main() with ImagePickerPhotoService over the app's
/// visit_photos directory, and in tests with a fake.
final photoServiceProvider = Provider<PhotoService>(
  (ref) => throw UnimplementedError('photoServiceProvider must be overridden'),
);

/// cc_core's journal repository over this database's generated tables.
final journalRepositoryProvider = Provider<AppJournalRepository>(
  (ref) => ref
      .watch(databaseProvider)
      .journal(photoStore: ref.watch(photoServiceProvider)),
);

final campgroundRepositoryProvider = Provider<CampgroundRepository>(
  (ref) => CampgroundRepository(ref.watch(databaseProvider),
      journal: ref.watch(journalRepositoryProvider),
      tally: ref.watch(campgroundTallyProvider)),
);

final siteRepositoryProvider = Provider<SiteRepository>(
  (ref) => SiteRepository(ref.watch(databaseProvider),
      journal: ref.watch(journalRepositoryProvider)),
);

final visitRepositoryProvider = Provider<VisitRepository>(
  (ref) => VisitRepository(ref.watch(databaseProvider),
      journal: ref.watch(journalRepositoryProvider)),
);

final rigRepositoryProvider = Provider<RigRepository>(
  (ref) => RigRepository(ref.watch(databaseProvider),
      journal: ref.watch(journalRepositoryProvider)),
);
