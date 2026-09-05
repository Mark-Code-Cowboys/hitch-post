import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/dates.dart';
import '../../core/utils/labels.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/rig_repository.dart';

/// Add or edit the rig — grouped Setup / Pressures / Service dates.
class RigComposerScreen extends ConsumerStatefulWidget {
  const RigComposerScreen({super.key, this.existing});

  final RigWithStory? existing;

  @override
  ConsumerState<RigComposerScreen> createState() =>
      _RigComposerScreenState();
}

class _RigComposerScreenState extends ConsumerState<RigComposerScreen> {
  final _formKey = GlobalKey<FormState>();
  Rig? get _rig => widget.existing?.rig;
  late final _name = TextEditingController(text: _rig?.name);
  late final _length =
      TextEditingController(text: _rig?.lengthFt?.toString());
  late final _gvwr = TextEditingController(text: _rig?.gvwrLbs?.toString());
  late final _ball = TextEditingController(text: _rig?.ballSizeIn);
  late final _drop =
      TextEditingController(text: _rig?.hitchDropIn?.toString());
  late final _wdBar = TextEditingController(text: _rig?.wdBarSetting);
  late final _psiFront =
      TextEditingController(text: _rig?.tirePsiFront?.toString());
  late final _psiRear =
      TextEditingController(text: _rig?.tirePsiRear?.toString());
  late final _gain =
      TextEditingController(text: _rig?.brakeGain?.toString());
  late final _notes = TextEditingController(text: widget.existing?.notes);
  late RigKind _kind = _rig?.kind ?? RigKind.travelTrailer;
  late DateTime? _bearings = _rig?.bearingServiceDate;
  late DateTime? _tires = _rig?.tireDate;

  @override
  void dispose() {
    for (final c in [
      _name, _length, _gvwr, _ball, _drop, _wdBar,
      _psiFront, _psiRear, _gain, _notes,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate(bool bearings) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (bearings ? _bearings : _tires) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => bearings ? _bearings = picked : _tires = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    int? num(TextEditingController c) => int.tryParse(c.text.trim());
    String? str(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();
    final draft = RigDraft(
      name: _name.text.trim(),
      kind: _kind,
      lengthFt: num(_length),
      gvwrLbs: num(_gvwr),
      ballSizeIn: str(_ball),
      hitchDropIn: num(_drop),
      wdBarSetting: str(_wdBar),
      tirePsiFront: num(_psiFront),
      tirePsiRear: num(_psiRear),
      brakeGain: num(_gain),
      bearingServiceDate: _bearings,
      tireDate: _tires,
      notes: str(_notes),
    );
    final repo = ref.read(rigRepositoryProvider);
    final existing = widget.existing;
    if (existing == null) {
      await repo.create(draft);
    } else {
      await repo.update(existing.rig.id, draft);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget numField(TextEditingController c, String label) => Expanded(
          child: TextFormField(
            controller: c,
            decoration: InputDecoration(labelText: label),
            keyboardType: TextInputType.number,
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'Add rig' : 'Edit rig'),
        actions: [TextButton(onPressed: _save, child: const Text('Save'))],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Rig name'),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name the rig' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<RigKind>(
              initialValue: _kind,
              decoration: const InputDecoration(labelText: 'Kind'),
              items: [
                for (final k in RigKind.values)
                  DropdownMenuItem(value: k, child: Text(k.label)),
              ],
              onChanged: (k) => setState(() => _kind = k!),
            ),
            const SizedBox(height: 16),
            Text('Setup', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(children: [
              numField(_length, 'Length (ft)'),
              const SizedBox(width: 12),
              numField(_gvwr, 'GVWR (lbs)'),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: TextFormField(
                  controller: _ball,
                  decoration:
                      const InputDecoration(labelText: 'Ball size (in)'),
                ),
              ),
              const SizedBox(width: 12),
              numField(_drop, 'Hitch drop (in)'),
            ]),
            const SizedBox(height: 12),
            TextFormField(
              controller: _wdBar,
              decoration:
                  const InputDecoration(labelText: 'WD bar setting'),
            ),
            const SizedBox(height: 16),
            Text('Pressures', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(children: [
              numField(_psiFront, 'Front (psi)'),
              const SizedBox(width: 12),
              numField(_psiRear, 'Rear (psi)'),
              const SizedBox(width: 12),
              numField(_gain, 'Brake gain'),
            ]),
            const SizedBox(height: 16),
            Text('Service dates', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _pickDate(true),
                  child: Text(_bearings == null
                      ? 'Bearings: —'
                      : 'Bearings: ${formatDate(_bearings!)}'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _pickDate(false),
                  child: Text(_tires == null
                      ? 'Tires: —'
                      : 'Tires: ${formatDate(_tires!)}'),
                ),
              ),
            ]),
            const SizedBox(height: 16),
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
