import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'csv_flow.dart';
import 'notebook_flow.dart';

/// The two ways the old log gets into Hitch Post besides typing it.
Future<void> showImportSheet(BuildContext context, WidgetRef ref) async {
  final choice = await showModalBottomSheet<_Import>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.document_scanner_outlined),
            title: const Text('Scan notebook pages'),
            subtitle: const Text(
                'Shoot the campground notebook or printed spreadsheet, '
                'review, add every stay at once.'),
            onTap: () => Navigator.of(context).pop(_Import.notebook),
          ),
          ListTile(
            leading: const Icon(Icons.table_chart_outlined),
            title: const Text('Import a spreadsheet'),
            subtitle: const Text('CSV in, visits out — map your columns.'),
            onTap: () => Navigator.of(context).pop(_Import.csv),
          ),
        ],
      ),
    ),
  );
  if (choice == null || !context.mounted) return;
  switch (choice) {
    case _Import.notebook:
      await runNotebookImport(context, ref);
    case _Import.csv:
      await runCsvImport(context, ref);
  }
}

enum _Import { notebook, csv }
