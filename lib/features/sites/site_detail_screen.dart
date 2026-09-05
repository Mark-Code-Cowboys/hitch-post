import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/dates.dart';
import '../../core/utils/labels.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/visit_repository.dart';
import '../visits/visit_composer_screen.dart';
import 'site_composer_screen.dart';

final siteProvider = StreamProvider.family<Site?, int>(
  (ref, id) => ref.watch(siteRepositoryProvider).watchOne(id),
);

final visitsProvider = StreamProvider.family<List<VisitWithStory>, int>(
  (ref, siteId) => ref.watch(visitRepositoryProvider).watchForSite(siteId),
);

/// THE screen: the glanceable rebooking grid. Can the rig get in, hook
/// up, sit level, and reach the outside world — answered in one look.
class SiteDetailScreen extends ConsumerWidget {
  const SiteDetailScreen({super.key, required this.siteId});

  final int siteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final site = ref.watch(siteProvider(siteId)).value;
    if (site == null) return const Scaffold(body: SizedBox.shrink());
    final visits = ref.watch(visitsProvider(siteId)).value;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Site ${site.siteNo}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit site',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => SiteComposerScreen(
                    campgroundId: site.campgroundId, existing: site),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete site',
            onPressed: () => _confirmDelete(context, ref, site),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => VisitComposerScreen(siteId: siteId),
            fullscreenDialog: true,
          ),
        ),
        icon: const Icon(Icons.night_shelter_outlined),
        label: const Text('Log a visit'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 88),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.6,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                _GridTile(
                    icon: Icons.power_outlined,
                    label: 'Power',
                    value: site.amps.label),
                _GridTile(
                    icon: Icons.water_drop_outlined,
                    label: 'Water',
                    value: site.water ? 'Yes' : 'No'),
                _GridTile(
                    icon: Icons.cleaning_services_outlined,
                    label: 'Sewer',
                    value: site.sewer ? 'Yes' : 'No'),
                _GridTile(
                    icon: Icons.straighten_outlined,
                    label: 'Max length',
                    value: site.maxLengthFt == null
                        ? '—'
                        : '${site.maxLengthFt} ft'),
                _GridTile(
                    icon: Icons.u_turn_left_outlined,
                    label: 'Approach',
                    value: site.approach?.label ?? '—'),
                _GridTile(
                    icon: Icons.park_outlined,
                    label: 'Shade',
                    value: site.shade?.label ?? '—'),
                _GridTile(
                    icon: Icons.architecture_outlined,
                    label: 'Level',
                    value: site.level?.label ?? '—'),
                _GridTile(
                    icon: Icons.signal_cellular_alt_outlined,
                    label: 'Cell',
                    value: site.cellBars == null
                        ? '—'
                        : '${site.cellBars} bars'
                            '${site.cellCarrier == null ? '' : ' ${site.cellCarrier}'}'),
              ],
            ),
          ),
          if (site.notes != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(site.notes!, style: theme.textTheme.bodyMedium),
            ),
          const Divider(height: 24),
          if (visits != null && visits.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'No visits logged. The first stay makes this site part '
                'of your history.',
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ),
          if (visits != null)
            for (final v in visits) _VisitTile(entry: v),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, Site site) async {
    final repo = ref.read(siteRepositoryProvider);
    final visits = await repo.visitCount(site.id);
    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete site ${site.siteNo}?'),
        content: Text(visits == 0
            ? 'This cannot be undone.'
            : '$visits visit${visits == 1 ? '' : 's'} go with it. '
                'This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true) return;
    await repo.delete(site.id);
    if (context.mounted) Navigator.of(context).pop();
  }
}

class _GridTile extends StatelessWidget {
  const _GridTile(
      {required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelSmall),
                Text(value,
                    style: theme.textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VisitTile extends StatelessWidget {
  const _VisitTile({required this.entry});

  final VisitWithStory entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visit = entry.visit;
    final details = [
      '${entry.nights} night${entry.nights == 1 ? '' : 's'}',
      if (visit.costTotalCents != null)
        '\$${(visit.costTotalCents! / 100).toStringAsFixed(2)}',
    ].join(' · ');
    return ListTile(
      isThreeLine: entry.notes != null,
      title: Text(formatDateRange(visit.arrive, visit.depart)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(details),
          if (entry.notes != null)
            Text(
              entry.notes!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
      trailing: entry.rating == null
          ? null
          : RatingStars(rating: entry.rating, size: 14),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => VisitComposerScreen(
              siteId: visit.siteId, existing: entry),
          fullscreenDialog: true,
        ),
      ),
    );
  }
}
