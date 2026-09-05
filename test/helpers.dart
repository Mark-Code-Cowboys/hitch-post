import 'package:cc_core/cc_core.dart';
import 'package:drift/native.dart';

import 'package:hitch_post/data/database/app_database.dart';
import 'package:hitch_post/data/repositories/campground_repository.dart';
import 'package:hitch_post/data/repositories/site_repository.dart';
import 'package:hitch_post/data/repositories/visit_repository.dart';

AppDatabase makeTestDb() => AppDatabase(NativeDatabase.memory());

CampgroundDraft campgroundDraft({
  String name = 'Pine Flats',
  CampgroundKind kind = CampgroundKind.statePark,
  String? state = 'MI',
  int? rating,
  bool wouldReturn = true,
}) =>
    CampgroundDraft(
        name: name,
        kind: kind,
        state: state,
        rating: rating,
        wouldReturn: wouldReturn);

SiteDraft siteDraft({
  String siteNo = '42',
  Amps amps = Amps.a30,
  bool water = true,
  bool sewer = false,
  Approach? approach = Approach.backIn,
  Level? level = Level.workable,
}) =>
    SiteDraft(
        siteNo: siteNo,
        amps: amps,
        water: water,
        sewer: sewer,
        approach: approach,
        level: level);

VisitDraft visitDraft({
  DateTime? arrive,
  DateTime? depart,
  int? costTotalCents,
  int? rating,
  String? notes,
  List<JournalPhotoDraft> photos = const [],
  List<String> tags = const [],
}) =>
    VisitDraft(
      arrive: arrive ?? DateTime(2026, 6, 12),
      depart: depart ?? DateTime(2026, 6, 15),
      costTotalCents: costTotalCents,
      rating: rating,
      notes: notes,
      photos: photos,
      tags: tags,
    );
