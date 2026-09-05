import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/utils/dates.dart';
import '../monetization/monetization_providers.dart';
import '../monetization/paywall_sheet.dart';
import 'receipt_parser.dart';
import 'scan_import_providers.dart';

/// Shoots one campground receipt and transcribes the total and stay
/// dates. Resolves to the reading the user confirmed, or null (nothing
/// readable, or they backed out). The composer fills its fields from
/// the result — nothing is saved here.
///
/// Transcription only: the confirm dialog shows exactly what was read.
Future<ReceiptReading?> scanReceipt(BuildContext context, WidgetRef ref) async {
  // Scanning is a Pro feature, like in every CC app.
  final pro = await ref.read(entitlementServiceProvider).isUnlimited();
  if (!context.mounted) return null;
  if (!pro) {
    final unlocked = await showPaywallSheet(context);
    if (!unlocked || !context.mounted) return null;
  }

  final messenger = ScaffoldMessenger.of(context);

  // Capture: document scanner (auto-crop/deskew) where available,
  // otherwise the photo picker.
  final scanner = ref.read(documentScanServiceProvider);
  String? path;
  if (scanner.isSupported) {
    try {
      path = (await scanner.scanAll(pageLimit: 1)).firstOrNull;
    } on Exception {
      path = null;
    }
  } else {
    path = (await ImagePicker().pickImage(source: ImageSource.gallery))?.path;
  }
  if (path == null || !context.mounted) return null;

  final ReceiptReading? reading;
  try {
    final lines =
        await ref.read(textRecognitionServiceProvider).recognize(path);
    reading = parseReceipt(lines);
  } on Exception {
    messenger.showSnackBar(const SnackBar(
        content: Text("Couldn't read that receipt — try a closer, "
            'straighter shot.')));
    return null;
  }
  if (!context.mounted) return null;
  if (reading == null) {
    messenger.showSnackBar(const SnackBar(
        content: Text('No total or dates found on that receipt.')));
    return null;
  }

  // A new local: the closure below blocks promotion of `reading`.
  final read = reading;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => _ConfirmReceiptDialog(reading: read),
  );
  return confirmed == true ? read : null;
}

/// Shows exactly what the receipt said; the user applies it or not.
/// GUARDRAIL: values are verbatim — this dialog never suggests,
/// corrects, or flags anything.
class _ConfirmReceiptDialog extends StatelessWidget {
  const _ConfirmReceiptDialog({required this.reading});

  final ReceiptReading reading;

  @override
  Widget build(BuildContext context) {
    final lines = [
      if (reading.costTotalCents != null)
        'Total: \$${(reading.costTotalCents! / 100).toStringAsFixed(2)}',
      if (reading.arrive != null && reading.depart != null)
        'Dates: ${formatDateRange(reading.arrive!, reading.depart!)}'
      else if (reading.arrive != null)
        'Date: ${formatDate(reading.arrive!)}',
    ];
    return AlertDialog(
      title: const Text('Receipt says'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final line in lines) Text(line),
          const SizedBox(height: 12),
          Text(
            'Exactly what was read — you can still edit every field '
            'before saving.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel')),
        FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Use these')),
      ],
    );
  }
}
