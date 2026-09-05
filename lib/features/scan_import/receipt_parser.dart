import 'package:cc_core/cc_core.dart';

/// What one campground receipt photo transcribed to. Every field is
/// exactly what the camera saw — the user confirms before any composer
/// field is filled.
class ReceiptReading {
  ReceiptReading({this.costTotalCents, this.arrive, this.depart});

  int? costTotalCents;
  DateTime? arrive;
  DateTime? depart;

  bool get isEmpty =>
      costTotalCents == null && arrive == null && depart == null;
}

// In preference order: the bottom-line total beats intermediate
// amounts — same label-priority lesson as Course Ledger's gross/net
// scorecard fix.
const _costWords = [
  'grand total',
  'amount due',
  'total',
  'balance',
  'amount',
  'paid',
];

// "$84.00", "$1,234.56", "84.00" — cents required so site numbers and
// dates never read as money.
final _money = RegExp(r'\$?\s?(\d{1,3}(?:,\d{3})*|\d+)\.(\d{2})\b');
final _explicitMoney = RegExp(r'\$\s?(\d{1,3}(?:,\d{3})*|\d+)\.(\d{2})\b');

int _centsOf(RegExpMatch m) =>
    int.parse(m.group(1)!.replaceAll(',', '')) * 100 + int.parse(m.group(2)!);

/// Transcribes the cost off merged OCR [rows]: the amount printed on
/// the best-labeled row (grand total > amount due > total > balance >
/// amount > paid, taking the amount after the label else the rightmost
/// on the row); with no labeled row, the largest amount printed with an
/// explicit `$`. Null when the page shows no money — never invented.
int? parseCostCents(List<String> rows) {
  int? cents;
  var costPriority = _costWords.length;
  for (final row in rows) {
    final lower = row.toLowerCase();
    final priority = _costWords.indexWhere(lower.contains);
    if (priority == -1 || priority >= costPriority) continue;
    final amounts = _money.allMatches(row).toList();
    if (amounts.isEmpty) continue;
    final labelEnd = lower.indexOf(_costWords[priority]) +
        _costWords[priority].length;
    final afterLabel = amounts.where((m) => m.start >= labelEnd).toList();
    cents = _centsOf(afterLabel.isNotEmpty ? afterLabel.first : amounts.last);
    costPriority = priority;
    if (priority == 0) break;
  }
  if (cents != null) return cents;
  int? largest;
  for (final row in rows) {
    for (final m in _explicitMoney.allMatches(row)) {
      final value = _centsOf(m);
      if (largest == null || value > largest) largest = value;
    }
  }
  return largest;
}

/// The first [max] distinct dates printed on the page, in print order —
/// a range row like "6/12/2026 - 6/15/2026" yields both.
List<DateTime> parsePageDates(List<String> rows, {int max = 2}) {
  final dates = <DateTime>[];
  for (final row in rows) {
    for (final date in parseLooseDates(row)) {
      if (!dates.contains(date)) dates.add(date);
      if (dates.length == max) return dates;
    }
  }
  return dates;
}

/// Transcribes one receipt photo's OCR into a [ReceiptReading]: the
/// labeled total and the first two dates (sorted into arrive/depart; a
/// single date becomes arrive only). Null when nothing usable was read.
ReceiptReading? parseReceipt(List<OcrLine> lines) {
  if (lines.isEmpty) return null;
  final rows = mergeOcrRows(lines);
  final dates = parsePageDates(rows)..sort();
  final reading = ReceiptReading(
    costTotalCents: parseCostCents(rows),
    arrive: dates.isNotEmpty ? dates.first : null,
    depart: dates.length > 1 ? dates.last : null,
  );
  return reading.isEmpty ? null : reading;
}
