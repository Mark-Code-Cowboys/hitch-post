import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hitch_post/core/theme/app_theme.dart';
import 'package:hitch_post/data/database/app_database.dart';
import 'package:hitch_post/data/providers.dart';
import 'package:hitch_post/features/shell/home_shell.dart';
import 'package:hitch_post/data/repositories/campground_repository.dart';
import 'package:hitch_post/data/repositories/site_repository.dart';
import 'package:hitch_post/data/repositories/visit_repository.dart';

AppDatabase makeTestDb() => AppDatabase(NativeDatabase.memory());

/// Plugin-free photo service for widget tests.
class FakeAppPhotoService implements PhotoService {
  final discarded = <String>[];

  @override
  Future<String?> acquire(PhotoSource source) async => null;

  @override
  Future<String?> acquireTransient(PhotoSource source) async => null;

  @override
  File fileFor(String photoPath) => File('/hp-test-photos/$photoPath');

  @override
  Future<void> importBytes(String photoPath, List<int> bytes) async {}

  @override
  Future<void> discard(String photoPath) async {
    discarded.add(photoPath);
  }
}

/// The app wired to an in-memory database and fake services; [home]
/// defaults to the shell.
Widget testApp({required AppDatabase db, Widget? home}) => ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        photoServiceProvider.overrideWithValue(FakeAppPhotoService()),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: home ?? const HomeShell(),
      ),
    );

/// Call at the end of every widget test that renders [testApp]; lets
/// drift stream-query cleanup timers fire inside the test zone.
Future<void> disposeApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(seconds: 1));
}

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
