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
      journal: ref.watch(journalRepositoryProvider)),
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
