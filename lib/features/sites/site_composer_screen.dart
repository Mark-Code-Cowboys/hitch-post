import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/labels.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/site_repository.dart';

/// Add or edit a site — the rebooking grid's data entry.
class SiteComposerScreen extends ConsumerStatefulWidget {
  const SiteComposerScreen(
      {super.key, required this.campgroundId, this.existing});

  final int campgroundId;
  final Site? existing;

  @override
  ConsumerState<SiteComposerScreen> createState() =>
      _SiteComposerScreenState();
}

class _SiteComposerScreenState extends ConsumerState<SiteComposerScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _siteNo = TextEditingController(text: widget.existing?.siteNo);
  late final _maxLength = TextEditingController(
      text: widget.existing?.maxLengthFt?.toString());
  late final _carrier =
      TextEditingController(text: widget.existing?.cellCarrier);
  late final _notes = TextEditingController(text: widget.existing?.notes);
  late Amps _amps = widget.existing?.amps ?? Amps.a30;
  late bool _water = widget.existing?.water ?? false;
  late bool _sewer = widget.existing?.sewer ?? false;
  late Approach? _approach = widget.existing?.approach;
  late Shade? _shade = widget.existing?.shade;
  late Level? _level = widget.existing?.level;
  late int? _cellBars = widget.existing?.cellBars;

  @override
  void dispose() {
    for (final c in [_siteNo, _maxLength, _carrier, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final draft = SiteDraft(
      siteNo: _siteNo.text.trim(),
      amps: _amps,
      water: _water,
      sewer: _sewer,
      maxLengthFt: int.tryParse(_maxLength.text.trim()),
      approach: _approach,
      shade: _shade,
      level: _level,
      cellBars: _cellBars,
      cellCarrier:
          _carrier.text.trim().isEmpty ? null : _carrier.text.trim(),
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
    );
    final repo = ref.read(siteRepositoryProvider);
    final existing = widget.existing;
    if (existing == null) {
      await repo.create(widget.campgroundId, draft);
    } else {
      await repo.update(existing.id, draft);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'Add site' : 'Edit site'),
        actions: [TextButton(onPressed: _save, child: const Text('Save'))],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                SizedBox(
                  width: 120,
                  child: TextFormField(
                    controller: _siteNo,
                    decoration: const InputDecoration(labelText: 'Site #'),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Required'
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _maxLength,
                    decoration: const InputDecoration(
                        labelText: 'Max length (ft)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Power', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<Amps>(
              segments: [
                for (final a in Amps.values)
                  ButtonSegment(value: a, label: Text(a.label)),
              ],
              selected: {_amps},
              onSelectionChanged: (s) => setState(() => _amps = s.single),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Water'),
              value: _water,
              onChanged: (v) => setState(() => _water = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Sewer'),
              value: _sewer,
              onChanged: (v) => setState(() => _sewer = v),
            ),
            const SizedBox(height: 8),
            Text('Approach', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<Approach>(
              emptySelectionAllowed: true,
              segments: [
                for (final a in Approach.values)
                  ButtonSegment(value: a, label: Text(a.label)),
              ],
              selected: {?_approach},
              onSelectionChanged: (s) =>
                  setState(() => _approach = s.isEmpty ? null : s.single),
            ),
            const SizedBox(height: 12),
            Text('Shade', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<Shade>(
              emptySelectionAllowed: true,
              segments: [
                for (final s in Shade.values)
                  ButtonSegment(value: s, label: Text(s.label)),
              ],
              selected: {?_shade},
              onSelectionChanged: (s) =>
                  setState(() => _shade = s.isEmpty ? null : s.single),
            ),
            const SizedBox(height: 12),
            Text('Level', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<Level>(
              emptySelectionAllowed: true,
              segments: [
                for (final l in Level.values)
                  ButtonSegment(value: l, label: Text(l.label)),
              ],
              selected: {?_level},
              onSelectionChanged: (s) =>
                  setState(() => _level = s.isEmpty ? null : s.single),
            ),
            const SizedBox(height: 16),
            Text('Cell signal', style: theme.textTheme.titleSmall),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: (_cellBars ?? 0).toDouble(),
                    max: 5,
                    divisions: 5,
                    label: _cellBars == null ? '—' : '$_cellBars bars',
                    onChanged: (v) =>
                        setState(() => _cellBars = v.round()),
                  ),
                ),
                SizedBox(
                  width: 110,
                  child: TextFormField(
                    controller: _carrier,
                    decoration:
                        const InputDecoration(labelText: 'Carrier'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notes,
              decoration: const InputDecoration(
                  labelText: 'Site notes', alignLabelWithHint: true),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
