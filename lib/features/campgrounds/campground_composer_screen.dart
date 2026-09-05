import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/labels.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/campground_repository.dart';

/// Add or edit a campground. Pass [existing] to edit.
class CampgroundComposerScreen extends ConsumerStatefulWidget {
  const CampgroundComposerScreen({super.key, this.existing});

  final Campground? existing;

  @override
  ConsumerState<CampgroundComposerScreen> createState() =>
      _CampgroundComposerScreenState();
}

class _CampgroundComposerScreenState
    extends ConsumerState<CampgroundComposerScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.existing?.name);
  late final _state = TextEditingController(text: widget.existing?.state);
  late final _notes = TextEditingController(text: widget.existing?.notes);
  late CampgroundKind _kind =
      widget.existing?.kind ?? CampgroundKind.statePark;
  late int? _rating = widget.existing?.rating;
  late bool _wouldReturn = widget.existing?.wouldReturn ?? true;

  @override
  void dispose() {
    for (final c in [_name, _state, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final state = _state.text.trim().toUpperCase();
    final draft = CampgroundDraft(
      name: _name.text.trim(),
      kind: _kind,
      state: state.isEmpty ? null : state,
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      rating: _rating,
      wouldReturn: _wouldReturn,
      lat: widget.existing?.lat,
      lon: widget.existing?.lon,
    );
    final repo = ref.read(campgroundRepositoryProvider);
    final existing = widget.existing;
    if (existing == null) {
      await repo.create(draft);
    } else {
      await repo.update(existing.id, draft);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.existing == null ? 'Add campground' : 'Edit campground'),
        actions: [TextButton(onPressed: _save, child: const Text('Save'))],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration:
                  const InputDecoration(labelText: 'Campground name'),
              textCapitalization: TextCapitalization.words,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Name the campground'
                  : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<CampgroundKind>(
                    initialValue: _kind,
                    decoration: const InputDecoration(labelText: 'Kind'),
                    items: [
                      for (final k in CampgroundKind.values)
                        DropdownMenuItem(value: k, child: Text(k.label)),
                    ],
                    onChanged: (k) => setState(() => _kind = k!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _state,
                    maxLength: 2,
                    decoration: const InputDecoration(
                        labelText: 'State', counterText: ''),
                    textCapitalization: TextCapitalization.characters,
                    validator: (v) {
                      final t = v?.trim() ?? '';
                      return (t.isEmpty || t.length == 2)
                          ? null
                          : '2 letters';
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Rating'),
                const SizedBox(width: 12),
                RatingStars(
                  rating: _rating,
                  onChanged: (r) => setState(() => _rating = r),
                ),
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Would return'),
              value: _wouldReturn,
              onChanged: (v) => setState(() => _wouldReturn = v),
            ),
            TextFormField(
              controller: _notes,
              decoration: const InputDecoration(
                  labelText: 'Notes', alignLabelWithHint: true),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
