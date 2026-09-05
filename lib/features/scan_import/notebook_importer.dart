import '../../data/database/app_database.dart';
import '../../data/repositories/campground_repository.dart';
import '../../data/repositories/site_repository.dart';
import '../../data/repositories/visit_repository.dart';
import 'visit_page_parser.dart';

/// Site number recorded when a page didn't say which site it was.
const unknownSiteNo = '—';

/// What a notebook import did, for the wrap-up line.
class NotebookImportReport {
  const NotebookImportReport({
    required this.visitsAdded,
    required this.campgroundsCreated,
    required this.pagesSkipped,
  });

  final int visitsAdded;
  final int campgroundsCreated;

  /// Pages without a usable campground name.
  final int pagesSkipped;

  String get summary {
    final parts = [
      'Added $visitsAdded ${visitsAdded == 1 ? 'visit' : 'visits'}',
      if (campgroundsCreated > 0)
        '$campgroundsCreated new '
            '${campgroundsCreated == 1 ? 'campground' : 'campgrounds'}',
      if (pagesSkipped > 0)
        '$pagesSkipped ${pagesSkipped == 1 ? 'page' : 'pages'} had no '
            'campground name and were skipped',
    ];
    return parts.join(' · ');
  }
}

/// Files reviewed notebook pages as visits. Campgrounds are matched by
/// name (case-insensitive) and created when missing; sites are matched
/// by site number within the campground (pages without one share the
/// "—" site). Pages without dates are filed under today — the review
/// screen says so.
Future<NotebookImportReport> insertVisitPages({
  required CampgroundRepository campgrounds,
  required SiteRepository sites,
  required VisitRepository visits,
  required List<VisitPageDraft> drafts,
}) async {
  final existing = await campgrounds.getAll();
  final campgroundByName = {
    for (final c in existing) c.name.trim().toLowerCase(): c.id,
  };

  var added = 0, created = 0, skipped = 0;
  for (final draft in drafts) {
    final name = draft.campground?.trim();
    if (name == null || name.isEmpty) {
      skipped++;
      continue;
    }

    var campgroundId = campgroundByName[name.toLowerCase()];
    if (campgroundId == null) {
      campgroundId = await campgrounds.create(CampgroundDraft(
        name: name,
        kind: CampgroundKind.other,
        state: draft.state,
      ));
      campgroundByName[name.toLowerCase()] = campgroundId;
      created++;
    }

    final siteNo = draft.siteNo?.trim().isNotEmpty == true
        ? draft.siteNo!.trim()
        : unknownSiteNo;
    final campgroundSites = await sites.getForCampground(campgroundId);
    var siteId = campgroundSites
        .where((s) => s.siteNo.toLowerCase() == siteNo.toLowerCase())
        .firstOrNull
        ?.id;
    siteId ??= await sites.create(campgroundId, SiteDraft(siteNo: siteNo));

    final arrive = draft.arrive ?? draft.depart ?? DateTime.now();
    final depart =
        draft.depart == null || draft.depart!.isBefore(arrive)
            ? arrive
            : draft.depart!;
    await visits.create(
      siteId,
      VisitDraft(
        arrive: arrive,
        depart: depart,
        costTotalCents: draft.costTotalCents,
        notes: draft.notes,
      ),
    );
    added++;
  }
  return NotebookImportReport(
    visitsAdded: added,
    campgroundsCreated: created,
    pagesSkipped: skipped,
  );
}
