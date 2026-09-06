import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/dates.dart';
import '../../data/providers.dart';
import '../monetization/monetization_providers.dart';
import '../monetization/paywall_sheet.dart';
import 'notebook_importer.dart';
import 'scan_import_providers.dart';
import 'visit_page_parser.dart';

/// The onboarding converter: photograph the campground notebook or the
/// printed spreadsheet (up to 20 pages in one session), review what
/// each page transcribed to, fix anything the camera misread, and file
/// them all at once.
///
/// Transcription only: the review screen shows exactly what was read —
/// missing fields stay blank for the user, never guessed.
Future<void> runNotebookImport(BuildContext context, WidgetRef ref) async {
  // The converter is a Pro feature, like scanning in every CC app.
  final pro = await ref.read(entitlementServiceProvider).isUnlimited();
  if (!context.mounted) return;
  if (!pro) {
    final unlocked = await showPaywallSheet(context);
    if (!unlocked || !context.mounted) return;
  }

  final messenger = ScaffoldMessenger.of(context);

  final paths = await captureDocumentPages(
      ref.read(documentScanServiceProvider),
      pageLimit: 20);
  if (paths.isEmpty || !context.mounted) return;

  final transcription = await batchTranscribe<VisitPageDraft>(
    imagePaths: paths,
    recognizer: ref.read(textRecognitionServiceProvider),
    parse: parseVisitPage,
  );
  if (!context.mounted) return;
  if (transcription.items.isEmpty) {
    messenger.showSnackBar(const SnackBar(
        content: Text("Couldn't read those pages — try closer, "
            'straighter shots.')));
    return;
  }
  if (transcription.failedCount > 0) {
    messenger.showSnackBar(SnackBar(
        content: Text('${transcription.failedCount} '
            '${transcription.failedCount == 1 ? 'page was' : 'pages were'} '
            'unreadable and skipped.')));
  }

  final kept = await showBatchReviewScreen<VisitPageDraft>(
    context,
    items: transcription.items,
    title: 'Scanned pages',
    subtitle: 'Exactly what each page says — fix anything the camera '
        'misread, uncheck pages that don\'t belong. Pages without a date '
        'are filed under today.',
    confirmLabel: (n) => n == 1 ? 'Add 1 visit' : 'Add $n visits',
    itemBuilder: (context, item, onChanged) =>
        _VisitPageRow(item: item, onChanged: onChanged),
  );
  if (kept == null || kept.isEmpty || !context.mounted) return;

  final report = await insertVisitPages(
    campgrounds: ref.read(campgroundRepositoryProvider),
    sites: ref.read(siteRepositoryProvider),
    visits: ref.read(visitRepositoryProvider),
    drafts: [for (final item in kept) item.value],
  );
  messenger.showSnackBar(SnackBar(content: Text(report.summary)));
}

class _VisitPageRow extends StatelessWidget {
  const _VisitPageRow({required this.item, required this.onChanged});

  final BatchScanItem<VisitPageDraft> item;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final draft = item.value;
    final details = [
      if (draft.state != null) draft.state!,
      draft.siteNo == null ? 'No site' : 'Site ${draft.siteNo}',
      if (draft.arrive == null)
        'No date'
      else if (draft.depart == null)
        formatDate(draft.arrive!)
      else
        formatDateRange(draft.arrive!, draft.depart!),
      if (draft.costTotalCents != null)
        '\$${(draft.costTotalCents! / 100).toStringAsFixed(2)}',
    ].join(' · ');
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(draft.campground ?? 'No campground name',
          style: draft.campground == null
              ? theme.textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurfaceVariant)
              : null),
      subtitle: Text(details),
      trailing: IconButton(
        icon: const Icon(Icons.edit_outlined),
        tooltip: 'Edit page',
        onPressed: () async {
          await showDialog<void>(
            context: context,
            builder: (_) => _EditVisitPageDialog(draft: draft),
          );
          onChanged();
        },
      ),
    );
  }
}

/// Edits one transcribed page in place. Fields start as what the camera
/// saw; the dialog never suggests values.
class _EditVisitPageDialog extends StatefulWidget {
  const _EditVisitPageDialog({required this.draft});

  final VisitPageDraft draft;

  @override
  State<_EditVisitPageDialog> createState() => _EditVisitPageDialogState();
}

class _EditVisitPageDialogState extends State<_EditVisitPageDialog> {
  late final _campground =
      TextEditingController(text: widget.draft.campground);
  late final _state = TextEditingController(text: widget.draft.state);
  late final _siteNo = TextEditingController(text: widget.draft.siteNo);
  late final _cost = TextEditingController(
      text: widget.draft.costTotalCents == null
          ? null
          : (widget.draft.costTotalCents! / 100).toStringAsFixed(2));
  late final _notes = TextEditingController(text: widget.draft.notes);
  late DateTime? _arrive = widget.draft.arrive;
  late DateTime? _depart = widget.draft.depart;

  @override
  void dispose() {
    _campground.dispose();
    _state.dispose();
    _siteNo.dispose();
    _cost.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool arrive}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (arrive ? _arrive : _depart) ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;
    setState(() {
      if (arrive) {
        _arrive = picked;
      } else {
        _depart = picked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String? emptyToNull(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();
    return AlertDialog(
      title: const Text('Edit page'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _campground,
              decoration: const InputDecoration(labelText: 'Campground'),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _state,
                    decoration: const InputDecoration(labelText: 'State'),
                    textCapitalization: TextCapitalization.characters,
                    maxLength: 2,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _siteNo,
                    decoration:
                        const InputDecoration(labelText: 'Site number'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickDate(arrive: true),
                    child: Text(_arrive == null
                        ? 'Arrive'
                        : formatDate(_arrive!)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickDate(arrive: false),
                    child: Text(_depart == null
                        ? 'Depart'
                        : formatDate(_depart!)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cost,
              decoration: const InputDecoration(
                  labelText: 'Total cost', prefixText: r'$'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notes,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final state = emptyToNull(_state)?.toUpperCase();
            widget.draft
              ..campground = emptyToNull(_campground)
              ..state = state != null && usStateCodes.contains(state)
                  ? state
                  : null
              ..siteNo = emptyToNull(_siteNo)
              ..arrive = _arrive
              ..depart = _depart
              ..costTotalCents = switch (emptyToNull(_cost)) {
                null => null,
                final text =>
                  switch (double.tryParse(text.replaceFirst(r'$', ''))) {
                    null => widget.draft.costTotalCents,
                    final value => (value * 100).round(),
                  },
              }
              ..notes = emptyToNull(_notes);
            Navigator.of(context).pop();
          },
          child: const Text('Done'),
        ),
      ],
    );
  }
}
