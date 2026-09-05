import 'package:cc_core/cc_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hitch_post/features/scan_import/receipt_parser.dart';

OcrLine line(String text, {double top = 0}) =>
    OcrLine(text, left: 0, top: top, height: 20);

void main() {
  group('parseCostCents', () {
    test('takes the amount after the best label, not the first row', () {
      // Same lesson as the scorecard gross/net bug: a labeled subtotal
      // row must not beat the grand total printed lower down.
      expect(
        parseCostCents([
          'Amount 30.00',
          'Tax 2.40',
          'Grand Total \$92.40',
        ]),
        9240,
      );
    });

    test('prefers the number after the label over the rightmost', () {
      expect(parseCostCents(['Total 84.00 deposit 20.00']), 8400);
    });

    test('handles thousands separators', () {
      expect(parseCostCents(['Total \$1,234.56']), 123456);
    });

    test('falls back to the largest explicit-\$ amount when unlabeled',
        () {
      expect(parseCostCents(['\$12.00 firewood', '\$96.00 3 nights']), 9600);
    });

    test('never invents money from bare numbers', () {
      expect(parseCostCents(['Site 42', '3 nights', 'June 15 2026']), isNull);
    });
  });

  group('parseReceipt', () {
    test('reads total plus arrive/depart, sorted', () {
      final reading = parseReceipt([
        line('BIG PINES RV PARK', top: 0),
        line('Check out 6/15/2026', top: 30),
        line('Check in 6/12/2026', top: 60),
        line('Total \$84.00', top: 90),
      ])!;
      expect(reading.costTotalCents, 8400);
      expect(reading.arrive, DateTime(2026, 6, 12));
      expect(reading.depart, DateTime(2026, 6, 15));
    });

    test('a single date becomes arrive only', () {
      final reading = parseReceipt([line('Paid 6/12/2026 total \$50.00')])!;
      expect(reading.arrive, DateTime(2026, 6, 12));
      expect(reading.depart, isNull);
    });

    test('null when nothing usable was read', () {
      expect(parseReceipt([]), isNull);
      expect(parseReceipt([line('THANK YOU COME AGAIN')]), isNull);
    });
  });
}
