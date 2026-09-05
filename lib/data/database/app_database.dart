// Drift's `check(column...)` idiom trips this lint on rating columns.
// ignore_for_file: recursive_getters
import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// This database's concrete journal repository type (cc_core's
/// JournalRepository is generic over the generated table classes).
typedef AppJournalRepository = JournalRepository<$AppJournalEntriesTable,
    $AppJournalPhotosTable, $AppJournalTagsTable>;

// Thin local registrations of cc_core's journal tables (drift can't
// analyze table classes across package boundaries in the default build
// mode). Names pinned to the shared schema.
@UseRowClass(JournalEntry)
class AppJournalEntries extends JournalEntries {
  @override
  String get tableName => 'journal_entries';
}

@UseRowClass(JournalPhoto)
class AppJournalPhotos extends JournalPhotos {
  @override
  String get tableName => 'journal_photos';
}

@UseRowClass(JournalTag)
class AppJournalTags extends JournalTags {
  @override
  String get tableName => 'journal_tags';
}

/// What kind of place a campground is — drives the list chip and, one
/// day, filters.
enum CampgroundKind {
  public,
  private,
  statePark,
  nationalPark,
  coe,
  boondock,
  other,
}

/// Electric hookup at a site.
enum Amps { none, a15, a30, a50 }

/// How the rig gets into the site.
enum Approach { pullThru, backIn }

/// Site shade cover.
enum Shade { full, partial, none }

/// Whether the pad is level enough.
enum Level { yes, workable, no }

/// What the user tows or drives.
enum RigKind { travelTrailer, fifthWheel, motorhome, camperVan, truckCamper }

class Campgrounds extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get kind => textEnum<CampgroundKind>()();
  // 2-char US state; null for non-US or unknown.
  TextColumn get state => text().withLength(min: 2, max: 2).nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get rating =>
      integer().nullable().check(rating.isBetweenValues(1, 5))();
  BoolColumn get wouldReturn => boolean().withDefault(const Constant(true))();
  // Opt-in only; never captured without an explicit user action.
  RealColumn get lat => real().nullable()();
  RealColumn get lon => real().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// The rebooking record: everything that matters when deciding whether
/// site 42 fits the rig again.
class Sites extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get campgroundId =>
      integer().references(Campgrounds, #id, onDelete: KeyAction.cascade)();
  TextColumn get siteNo => text().withLength(min: 1, max: 20)();
  TextColumn get amps => textEnum<Amps>()();
  BoolColumn get water => boolean().withDefault(const Constant(false))();
  BoolColumn get sewer => boolean().withDefault(const Constant(false))();
  IntColumn get maxLengthFt => integer().nullable()();
  TextColumn get approach => textEnum<Approach>().nullable()();
  TextColumn get shade => textEnum<Shade>().nullable()();
  TextColumn get level => textEnum<Level>().nullable()();
  IntColumn get cellBars =>
      integer().nullable().check(cellBars.isBetweenValues(0, 5))();
  TextColumn get cellCarrier => text().nullable()();
  TextColumn get notes => text().nullable()();
}

/// A stay at a site. The story — notes, the stay rating, photos, tags —
/// lives in the shared cc_core journal tables; a visit without any of
/// those has no entry. VisitRepository owns the entry lifecycle.
class Visits extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get siteId =>
      integer().references(Sites, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get arrive => dateTime()();
  DateTimeColumn get depart => dateTime()();
  // Total cost in cents; null when the user didn't record it.
  IntColumn get costTotalCents => integer().nullable()();
  // Raw-SQL FK for the same cross-package reason as the journal tables.
  IntColumn get journalEntryId => integer().nullable()();

  @override
  List<String> get customConstraints => [
        'FOREIGN KEY (journal_entry_id) REFERENCES journal_entries (id) '
            'ON DELETE SET NULL',
      ];
}

/// The tow rig and the settings re-derived every season. Notes and
/// photos ride on a journal entry like a visit's story.
class Rigs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get kind => textEnum<RigKind>()();
  IntColumn get lengthFt => integer().nullable()();
  IntColumn get gvwrLbs => integer().nullable()();
  TextColumn get ballSizeIn => text().nullable()();
  IntColumn get hitchDropIn => integer().nullable()();
  TextColumn get wdBarSetting => text().nullable()();
  IntColumn get tirePsiFront => integer().nullable()();
  IntColumn get tirePsiRear => integer().nullable()();
  IntColumn get brakeGain => integer().nullable()();
  DateTimeColumn get bearingServiceDate => dateTime().nullable()();
  DateTimeColumn get tireDate => dateTime().nullable()();
  IntColumn get journalEntryId => integer().nullable()();

  @override
  List<String> get customConstraints => [
        'FOREIGN KEY (journal_entry_id) REFERENCES journal_entries (id) '
            'ON DELETE SET NULL',
      ];
}

@DriftDatabase(tables: [
  Campgrounds,
  Sites,
  Visits,
  Rigs,
  AppJournalEntries,
  AppJournalPhotos,
  AppJournalTags,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Opens the on-device database. All data stays local; nothing leaves
  /// the phone.
  factory AppDatabase.open() => AppDatabase(driftDatabase(name: 'hitchpost'));

  @override
  int get schemaVersion => 1;

  /// The journal repository over this database's generated tables.
  AppJournalRepository journal({PhotoFileStore? photoStore}) =>
      JournalRepository(this,
          entries: appJournalEntries,
          photos: appJournalPhotos,
          tags: appJournalTags,
          photoStore: photoStore);

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
