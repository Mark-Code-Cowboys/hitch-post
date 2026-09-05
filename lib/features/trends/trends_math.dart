import '../../data/database/app_database.dart';

/// A visit's nights: each night belongs to the date it starts, so a
/// Jun 12 → Jun 15 stay is the nights of the 12th, 13th, and 14th.
/// Same-day in/out is zero nights.
Iterable<DateTime> nightsOf(Visit v) sync* {
  var day = DateTime(v.arrive.year, v.arrive.month, v.arrive.day);
  final end = DateTime(v.depart.year, v.depart.month, v.depart.day);
  while (day.isBefore(end)) {
    yield day;
    day = day.add(const Duration(days: 1));
  }
}

/// Distinct camped nights per year — overlapping visits never count a
/// night twice.
Map<int, int> nightsByYear(List<Visit> visits) {
  final nights = <DateTime>{for (final v in visits) ...nightsOf(v)};
  final byYear = <int, int>{};
  for (final n in nights) {
    byYear[n.year] = (byYear[n.year] ?? 0) + 1;
  }
  return byYear;
}

/// The distinct nights camped in [year]/[month], as day-of-month dates
/// for the heatmap's cells.
Set<DateTime> nightsInMonth(List<Visit> visits, int year, int month) => {
      for (final v in visits)
        for (final n in nightsOf(v))
          if (n.year == year && n.month == month) n,
    };

/// Total nights across the log (distinct, like [nightsByYear]).
int totalNights(List<Visit> visits) =>
    {for (final v in visits) ...nightsOf(v)}.length;

/// Average cost per night in cents over the visits that recorded both
/// a cost and at least one night. Null when none have — never invented.
int? avgCostPerNightCents(List<Visit> visits) {
  var cents = 0, nights = 0;
  for (final v in visits) {
    final cost = v.costTotalCents;
    final n = nightsOf(v).length;
    if (cost == null || n == 0) continue;
    cents += cost;
    nights += n;
  }
  return nights == 0 ? null : (cents / nights).round();
}

/// The states on the log's campgrounds — the fill set for the map.
Set<String> statesRecorded(List<Campground> campgrounds) => {
      for (final c in campgrounds)
        if (c.state != null) c.state!.trim().toUpperCase(),
    };
