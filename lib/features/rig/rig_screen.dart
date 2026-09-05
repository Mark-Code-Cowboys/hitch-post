import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/dates.dart';
import '../../core/utils/labels.dart';
import '../../data/providers.dart';
import '../../data/repositories/rig_repository.dart';
import 'rig_composer_screen.dart';

final rigsProvider = StreamProvider<List<RigWithStory>>(
  (ref) => ref.watch(rigRepositoryProvider).watchAll(),
);

/// The rig tab: the tow settings re-derived every season, written down
/// once. Free tier keeps one rig; Phase C gates the second.
class RigScreen extends ConsumerWidget {
  const RigScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rigs = ref.watch(rigsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Rig')),
      body: rigs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (all) =>
            all.isEmpty ? _empty(context) : _list(context, ref, all),
      ),
    );
  }

  Widget _empty(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.rv_hookup_outlined,
                size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text('Write the rig down once.',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Ball size, hitch drop, bar setting, pressures — stop '
              're-deriving them every season.',
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _list(
      BuildContext context, WidgetRef ref, List<RigWithStory> all) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 88),
      children: [for (final rig in all) _RigCard(entry: rig)],
    );
  }
}

class _RigCard extends ConsumerWidget {
  const _RigCard({required this.entry});

  final RigWithStory entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final rig = entry.rig;

    Widget row(String label, String? value) => value == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                SizedBox(
                    width: 140,
                    child: Text(label, style: theme.textTheme.bodySmall)),
                Expanded(
                    child:
                        Text(value, style: theme.textTheme.bodyMedium)),
              ],
            ),
          );

    Widget section(String title, List<Widget> rows) {
      final visible =
          rows.where((w) => w is! SizedBox).toList(growable: false);
      if (visible.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(title, style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          ...visible,
        ],
      );
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(rig.name,
                      style: theme.textTheme.titleMedium),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Edit rig',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => RigComposerScreen(existing: entry),
                      fullscreenDialog: true,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              [
                rig.kind.label,
                if (rig.lengthFt != null) '${rig.lengthFt} ft',
                if (rig.gvwrLbs != null) '${rig.gvwrLbs} lbs GVWR',
              ].join(' · '),
              style: theme.textTheme.bodySmall,
            ),
            section('Setup', [
              row('Ball size', rig.ballSizeIn),
              row('Hitch drop',
                  rig.hitchDropIn == null ? null : '${rig.hitchDropIn} in'),
              row('WD bar setting', rig.wdBarSetting),
            ]),
            section('Pressures', [
              row('Tires front',
                  rig.tirePsiFront == null ? null : '${rig.tirePsiFront} psi'),
              row('Tires rear',
                  rig.tirePsiRear == null ? null : '${rig.tirePsiRear} psi'),
              row('Brake gain',
                  rig.brakeGain == null ? null : '${rig.brakeGain}'),
            ]),
            section('Service dates', [
              row(
                  'Bearings',
                  rig.bearingServiceDate == null
                      ? null
                      : formatDate(rig.bearingServiceDate!)),
              row('Tires',
                  rig.tireDate == null ? null : formatDate(rig.tireDate!)),
            ]),
            if (entry.notes != null) ...[
              const SizedBox(height: 12),
              Text(entry.notes!,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontStyle: FontStyle.italic)),
            ],
          ],
        ),
      ),
    );
  }
}
