import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/dates.dart';
import '../../data/providers.dart';
import '../../data/repositories/visit_repository.dart';
import '../scan_import/receipt_scan.dart';

/// Log or edit a stay: the dates, what it cost, how it rated, the
/// story, the photos — the journal entry composer over cc_core.
class VisitComposerScreen extends ConsumerStatefulWidget {
  const VisitComposerScreen({super.key, required this.siteId, this.existing});

  final int siteId;
  final VisitWithStory? existing;

  @override
  ConsumerState<VisitComposerScreen> createState() =>
      _VisitComposerScreenState();
}

class _VisitComposerScreenState extends ConsumerState<VisitComposerScreen> {
  late DateTime _arrive =
      widget.existing?.visit.arrive ?? DateTime.now();
  late DateTime _depart = widget.existing?.visit.depart ??
      DateTime.now().add(const Duration(days: 2));
  late final _cost = TextEditingController(
      text: widget.existing?.visit.costTotalCents == null
          ? null
          : (widget.existing!.visit.costTotalCents! / 100)
              .toStringAsFixed(2));
  late final _notes = TextEditingController(text: widget.existing?.notes);
  late int? _rating = widget.existing?.rating;
  final _newPhotos = <JournalPhotoDraft>[];
  var _saving = false;

  @override
  void dispose() {
    _cost.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool arrive}) async {
    final initial = arrive ? _arrive : _depart;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1990),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;
    setState(() {
      if (arrive) {
        _arrive = picked;
        if (_depart.isBefore(_arrive)) _depart = _arrive;
      } else {
        _depart = picked.isBefore(_arrive) ? _arrive : picked;
      }
    });
  }

  Future<void> _addPhoto() async {
    final source = await showModalBottomSheet<PhotoSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.of(context).pop(PhotoSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Pick from gallery'),
              onTap: () => Navigator.of(context).pop(PhotoSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final path = await ref.read(photoServiceProvider).acquire(source);
    if (path != null && mounted) {
      final existing = widget.existing;
      if (existing != null) {
        await ref
            .read(visitRepositoryProvider)
            .addPhoto(existing.visit.id, JournalPhotoDraft(path: path));
      } else {
        setState(() => _newPhotos.add(JournalPhotoDraft(path: path)));
      }
    }
  }

  /// Fills cost and dates from a scanned receipt — after the user
  /// confirmed the reading in [scanReceipt]'s dialog, and still fully
  /// editable here before saving.
  Future<void> _scanReceipt() async {
    final reading = await scanReceipt(context, ref);
    if (reading == null || !mounted) return;
    setState(() {
      if (reading.costTotalCents != null) {
        _cost.text = (reading.costTotalCents! / 100).toStringAsFixed(2);
      }
      if (reading.arrive != null) {
        _arrive = reading.arrive!;
        _depart = reading.depart ?? reading.arrive!;
        if (_depart.isBefore(_arrive)) _depart = _arrive;
      }
    });
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    final costText = _cost.text.trim().replaceFirst(r'$', '');
    final cost = costText.isEmpty
        ? null
        : (double.tryParse(costText) == null
            ? null
            : (double.parse(costText) * 100).round());
    final draft = VisitDraft(
      arrive: _arrive,
      depart: _depart,
      costTotalCents: cost,
      rating: _rating,
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      photos: List.of(_newPhotos),
    );
    final repo = ref.read(visitRepositoryProvider);
    final existing = widget.existing;
    if (existing == null) {
      await repo.create(widget.siteId, draft);
    } else {
      await repo.update(existing.visit.id, draft);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final photoService = ref.read(photoServiceProvider);
    final existingPhotos = widget.existing?.photos ?? const [];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'Log a visit' : 'Edit visit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined),
            tooltip: 'Scan receipt',
            onPressed: _scanReceipt,
          ),
          TextButton(
              onPressed: _saving ? null : _save, child: const Text('Save')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickDate(arrive: true),
                  icon: const Icon(Icons.login),
                  label: Text(formatDate(_arrive)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickDate(arrive: false),
                  icon: const Icon(Icons.logout),
                  label: Text(formatDate(_depart)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _cost,
                  decoration: const InputDecoration(
                      labelText: 'Total cost', prefixText: r'$'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(width: 16),
              const Text('Stay rating'),
              const SizedBox(width: 8),
              RatingStars(
                rating: _rating,
                onChanged: (r) => setState(() => _rating = r),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notes,
            decoration: InputDecoration(
              labelText: 'Notes for next time',
              hintText: 'What future-you needs to know before rebooking.',
              alignLabelWithHint: true,
              border: const OutlineInputBorder(),
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant),
            ),
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 12),
          PhotoAttachmentStrip(
            items: [
              for (final p in existingPhotos)
                PhotoStripItem(
                  file: photoService.fileFor(p.path),
                  caption: p.caption,
                  onRemove: () => ref
                      .read(visitRepositoryProvider)
                      .removePhoto(p.id),
                ),
              for (final p in _newPhotos)
                PhotoStripItem(
                  file: photoService.fileFor(p.path),
                  onRemove: () => setState(() => _newPhotos.remove(p)),
                ),
            ],
            onAdd: _addPhoto,
          ),
        ],
      ),
    );
  }
}
