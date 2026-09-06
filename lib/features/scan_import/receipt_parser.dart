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
