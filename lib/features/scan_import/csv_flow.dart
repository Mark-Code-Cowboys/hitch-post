import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../monetization/monetization_providers.dart';
import 'csv_importer.dart';

/// Picks a CSV file and opens cc_core's column-mapping screen with
/// Hitch Post's fields. Free like every "your data in" path — but new
/// campgrounds never pass the free cap ([importCsvVisits]).
Future<void> runCsvImport(BuildContext context, WidgetRef ref) async {
  const typeGroup = XTypeGroup(
    label: 'Spreadsheet',
    extensions: ['csv', 'txt'],
  );
  final file = await openFile(acceptedTypeGroups: const [typeGroup]);
  if (file == null || !context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);

  final CsvDocument doc;
  try {
    doc = parseCsv(await File(file.path).readAsString());
  } on Exception {
    messenger.showSnackBar(const SnackBar(
        content: Text("Couldn't read that file as CSV.")));
    return;
  }
  if (!context.mounted) return;
  if (doc.header.isEmpty || doc.rows.isEmpty) {
    messenger.showSnackBar(
        const SnackBar(content: Text('That file has no data rows.')));
    return;
  }
  await showCsvMappingScreen(
    context,
    doc: doc,
    fields: hpCsvFields,
    title: 'Import spreadsheet',
    footnote: 'Rows without a campground name or a readable arrive date '
        'are skipped. Existing campgrounds are matched by name.',
    onImport: (mapping) async {
      final report = await importCsvVisits(
        campgrounds: ref.read(campgroundRepositoryProvider),
        sites: ref.read(siteRepositoryProvider),
        visits: ref.read(visitRepositoryProvider),
        doc: doc,
        mapping: mapping,
        entitled: await ref.read(entitlementServiceProvider).isUnlimited(),
      );
      return report.summary;
    },
  );
}
