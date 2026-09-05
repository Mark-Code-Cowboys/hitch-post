import 'package:cc_core/cc_core.dart';

import '../../data/database/app_database.dart';
import '../../data/repositories/campground_repository.dart';
import '../../data/repositories/site_repository.dart';
import '../../data/repositories/visit_repository.dart';
import '../monetization/free_limit.dart';
import 'notebook_importer.dart';
import 'visit_page_parser.dart';

/// The columns Hitch Post can take from a spreadsheet, with the guess
/// wording the Excel crowd actually uses, for cc_core's
/// [CsvMappingScreen].
const hpCsvFields = [
  CsvField('campground',
      label: 'Campground (required)',
      isRequired: true,
      guessTiers: [
        ['campground', 'park', 'location'],
        ['name', 'place'],
      ]),
  CsvField('state', label: 'State', guessTiers: [
    ['state', 'province'],
  ]),
  CsvField('siteNo', label: 'Site number', guessTiers: [
    ['site', 'spot', 'space', 'lot'],
  ]),
  CsvField('arrive',
      label: 'Arrive date (required)',
      isRequired: true,
      guessTiers: [
        ['arrive', 'check in', 'check-in', 'checkin', 'start', 'from'],
        ['date'],
      ]),
  CsvField('depart', label: 'Depart date', guessTiers: [
    ['depart', 'check out', 'check-out', 'checkout', 'leave', 'end', 'to'],
  ]),
  CsvField('cost', label: 'Total cost', guessTiers: [
    ['cost', 'total', 'price', 'paid', 'amount', 'rate'],
  ]),
  CsvField('rating', label: 'Rating (1-5)', guessTiers: [
    ['rating', 'stars'],
  ]),
  CsvField('notes', label: 'Notes', guessTiers: [
    ['note', 'comment', 'story', 'memo', 'remark'],
  ]),
];

/// What a spreadsheet import did, for the wrap-up line.
class CsvImportReport {
  const CsvImportReport({
    required this.visitsAdded,
    required this.campgroundsCreated,
    required this.rowsSkipped,
    required this.campgroundsSkippedAtCap,
  });

  final int visitsAdded;
  final int campgroundsCreated;

  /// Rows without a usable campground name or arrive date.
  final int rowsSkipped;

  /// Rows for new campgrounds a free-tier user had no slots left for.
  final int campgroundsSkippedAtCap;

  String get summary {
    final parts = [
      'Imported $visitsAdded ${visitsAdded == 1 ? 'visit' : 'visits'}',
      if (campgroundsCreated > 0)
        '$campgroundsCreated new '
            '${campgroundsCreated == 1 ? 'campground' : 'campgrounds'}',
      if (rowsSkipped > 0) '$rowsSkipped unusable rows skipped',
      if (campgroundsSkippedAtCap > 0)
        '$campgroundsSkippedAtCap rows past the free campground limit',
    ];
    return parts.join(' · ');
  }
}

/// "$84.00" / "84.00" / "84" spreadsheet cells to cents; null when the
/// cell isn't a number — never invented.
int? parseCostCell(String cell) {
  final cleaned = cell.replaceAll(RegExp(r'[$,\s]'), '');
  final value = double.tryParse(cleaned);
  return value == null ? null : (value * 100).round();
}

/// Imports spreadsheet rows as visits. Campgrounds are matched by name
/// (case-insensitive); new ones are created — but never past the
/// free-tier cap for a free user: those rows are counted and skipped,
/// existing-campground rows still import (existing data is never
/// gated). Sites match by site number within the campground; rows
/// without one share the "—" site.
Future<CsvImportReport> importCsvVisits({
  required CampgroundRepository campgrounds,
  required SiteRepository sites,
  required VisitRepository visits,
  required CsvDocument doc,
  required Map<String, int?> mapping,
  required bool entitled,
}) async {
  final existing = await campgrounds.getAll();
  final campgroundByName = {
    for (final c in existing) c.name.trim().toLowerCase(): c.id,
  };

  var added = 0, created = 0, skipped = 0, atCap = 0;
  for (final row in doc.rows) {
    String? cell(String key) {
      final column = mapping[key];
      return column == null ? null : doc.rowCell(row, column);
    }

    final name = cell('campground');
    final arrive = switch (cell('arrive')) {
      null => null,
      final text => parseLooseDate(text),
    };
    if (name == null || arrive == null) {
      skipped++;
      continue;
    }
    final depart = switch (cell('depart')) {
      null => null,
      final text => parseLooseDate(text),
    };

    var campgroundId = campgroundByName[name.toLowerCase()];
    if (campgroundId == null) {
      if (!entitled &&
          campgroundFreeLimit
              .isReached(await campgrounds.lifetimeCreated())) {
        atCap++;
        continue;
      }
      final state = cell('state')?.trim().toUpperCase();
      campgroundId = await campgrounds.create(CampgroundDraft(
        name: name,
        kind: CampgroundKind.other,
        state: state != null && usStateCodes.contains(state) ? state : null,
      ));
      campgroundByName[name.toLowerCase()] = campgroundId;
      created++;
    }

    final siteNo = cell('siteNo')?.trim().isNotEmpty == true
        ? cell('siteNo')!.trim()
        : unknownSiteNo;
    final campgroundSites = await sites.getForCampground(campgroundId);
    var siteId = campgroundSites
        .where((s) => s.siteNo.toLowerCase() == siteNo.toLowerCase())
        .firstOrNull
        ?.id;
    siteId ??= await sites.create(campgroundId, SiteDraft(siteNo: siteNo));

    final rating = switch (cell('rating')) {
      null => null,
      final text => switch (int.tryParse(text.trim())) {
          final r? when r >= 1 && r <= 5 => r,
          _ => null,
        },
    };
    await visits.create(
      siteId,
      VisitDraft(
        arrive: arrive,
        depart: depart == null || depart.isBefore(arrive) ? arrive : depart,
        costTotalCents: switch (cell('cost')) {
          null => null,
          final text => parseCostCell(text),
        },
        rating: rating,
        notes: cell('notes'),
      ),
    );
    added++;
  }
  return CsvImportReport(
    visitsAdded: added,
    campgroundsCreated: created,
    rowsSkipped: skipped,
    campgroundsSkippedAtCap: atCap,
  );
}
