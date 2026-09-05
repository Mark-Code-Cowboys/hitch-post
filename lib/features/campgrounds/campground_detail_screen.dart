import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/labels.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../sites/site_composer_screen.dart';
import '../sites/site_detail_screen.dart';
import 'campground_composer_screen.dart';

final campgroundProvider = StreamProvider.family<Campground?, int>(
  (ref, id) => ref.watch(campgroundRepositoryProvider).watchOne(id),
);

final sitesProvider = StreamProvider.family<List<Site>, int>(
  (ref, campgroundId) =>
      ref.watch(siteRepositoryProvider).watchForCampground(campgroundId),
);

class CampgroundDetailScreen extends ConsumerWidget {
  const CampgroundDetailScreen({super.key, required this.campgroundId});

  final int campgroundId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campground = ref.watch(campgroundProvider(campgroundId)).value;
    if (campground == null) {
      return const Scaffold(body: SizedBox.shrink());
    }
    final sites = ref.watch(sitesProvider(campgroundId)).value;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(campground.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit campground',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    CampgroundComposerScreen(existing: campground),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete campground',
            onPressed: () => _confirmDelete(context, ref, campground),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => SiteComposerScreen(campgroundId: campgroundId),
            fullscreenDialog: true,
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add site'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 88),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Chip(label: Text(campground.kind.label)),
                    if (campground.state != null)
                      Chip(label: Text(campground.state!)),
                    if (campground.rating != null)
                      RatingStars(rating: campground.rating),
                    Chip(
                      label: Text(campground.wouldReturn
                          ? 'Would return'
                          : "Wouldn't return"),
                    ),
                  ],
                ),
                if (campground.notes != null) ...[
                  const SizedBox(height: 12),
                  Text(campground.notes!,
                      style: theme.textTheme.bodyMedium),
                ],
              ],
            ),
          ),
          const Divider(height: 32),
          if (sites != null && sites.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'No sites yet. Add the sites you stayed at — the grid '
                'is what future-you rebooks from.',
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ),
          if (sites != null)
            for (final site in sites) _SiteTile(site: site),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, Campground campground) async {
    final repo = ref.read(campgroundRepositoryProvider);
    final deps = await repo.dependentCounts(campground.id);
    if (!context.mounted) return;
    final what = [
      if (deps.sites > 0) '${deps.sites} site${deps.sites == 1 ? '' : 's'}',
      if (deps.visits > 0)
        '${deps.visits} visit${deps.visits == 1 ? '' : 's'}',
    ].join(' and ');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete ${campground.name}?'),
        content: Text(what.isEmpty
            ? 'This cannot be undone.'
            : '$what go with it. This cannot be undone.'),
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
    await repo.delete(campground.id);
    if (context.mounted) Navigator.of(context).pop();
  }
}

class _SiteTile extends StatelessWidget {
  const _SiteTile({required this.site});

  final Site site;

  @override
  Widget build(BuildContext context) {
    final summary = [
      site.amps.label,
      if (site.water) 'Water',
      if (site.sewer) 'Sewer',
      if (site.approach != null) site.approach!.label,
      if (site.level != null) site.level!.label,
    ].join(' · ');
    return ListTile(
      leading: CircleAvatar(child: Text(site.siteNo)),
      title: Text('Site ${site.siteNo}'),
      subtitle: Text(summary),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => SiteDetailScreen(siteId: site.id),
        ),
      ),
    );
  }
}
