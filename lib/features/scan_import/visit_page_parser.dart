import 'package:cc_core/cc_core.dart';

/// What one notebook page or spreadsheet-printout row transcribed to —
/// the onboarding converter's schema. Every field is exactly what the
/// camera saw; the user confirms and edits on the review screen before
/// anything is saved.
class VisitPageDraft {
  VisitPageDraft({
    this.campground,
    this.state,
    this.siteNo,
    this.arrive,
    this.depart,
    this.costTotalCents,
    this.notes,
  });

  String? campground;
  String? state;
  String? siteNo;
  DateTime? arrive;
  DateTime? depart;
  int? costTotalCents;
  String? notes;
}

/// The US postal codes Hitch Post knows, straight off the trends map so
/// the two features can never disagree.
final usStateCodes = {for (final tile in usStateTiles) tile.code};

final _siteRow = RegExp(r'\b(?:site|spot|space|lot)\s*#?\s*([\w-]{1,20})\b',
    caseSensitive: false);
final _loneState = RegExp(r'\b([A-Z]{2})\b');
// Rows that are page plumbing, never a campground name.
final _nameNoise = RegExp(
    r'\b(site|spot|space|lot|date|arrive|depart|check.?in|check.?out|'
    r'total|amount|paid|cost|balance|night|nights)\b',
    caseSensitive: false);

/// Transcribes one notebook page's OCR into a [VisitPageDraft].
///
/// Campground: the tallest text in the top third that isn't row
/// plumbing. State: the first standalone US postal code. Site: a
/// "Site 42"-style row. Dates: the first two on the page, sorted into
/// arrive/depart. Cost: the labeled amount ([parseCostCents]). Notes:
/// the leftover prose rows, verbatim.
///
/// Null when the photo had no text at all. No field is ever invented —
/// missing stays null for the user to fill in.
VisitPageDraft? parseVisitPage(List<OcrLine> lines) {
  if (lines.isEmpty) return null;

  // --- campground name ---
  String? campground;
  final bottom =
      lines.map((l) => l.top + l.height).reduce((a, b) => a > b ? a : b);
  final topThird = lines.where((l) => l.top < bottom / 3).toList()
    ..sort((a, b) => b.height.compareTo(a.height));
  for (final line in topThird) {
    final text = line.text.trim();
    if (text.length < 4 || _nameNoise.hasMatch(text)) continue;
    if (!RegExp(r'[a-zA-Z]{3}').hasMatch(text)) continue;
    if (parseLooseDate(text) != null) continue;
    campground = titleCaseShouted(text);
    break;
  }

  final rows = mergeOcrRows(lines);

  // --- state ---
  String? state;
  for (final row in rows) {
    final code = _loneState
        .allMatches(row)
        .map((m) => m.group(1)!)
        .where(usStateCodes.contains)
        .firstOrNull;
    if (code != null) {
      state = code;
      break;
    }
  }

  // --- site number ---
  String? siteNo;
  for (final row in rows) {
    final m = _siteRow.firstMatch(row);
    if (m != null) {
      siteNo = m.group(1);
      break;
    }
  }

  // --- dates and cost ---
  final dates = parsePageDates(rows)..sort();
  final cost = parseCostCents(rows);

  // --- notes: the prose rows nothing above claimed, verbatim ---
  final claimed = campground?.toLowerCase();
  final noteRows = [
    for (final row in rows)
      if (row.trim().length >= 4 &&
          RegExp(r'[a-zA-Z]{3}').hasMatch(row) &&
          row.trim().toLowerCase() != claimed &&
          parseLooseDate(row) == null &&
          !_siteRow.hasMatch(row) &&
          !RegExp(r'\$?\d+\.\d{2}\b').hasMatch(row) &&
          !_nameNoise.hasMatch(row))
        row.trim(),
  ];
  final notes = noteRows.isEmpty ? null : noteRows.join('\n');

  if (campground == null &&
      siteNo == null &&
      dates.isEmpty &&
      cost == null &&
      notes == null) {
    return null;
  }
  return VisitPageDraft(
    campground: campground,
    state: state,
    siteNo: siteNo,
    arrive: dates.isNotEmpty ? dates.first : null,
    depart: dates.length > 1 ? dates.last : null,
    costTotalCents: cost,
    notes: notes,
  );
}
