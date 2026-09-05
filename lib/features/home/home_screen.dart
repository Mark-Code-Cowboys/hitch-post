import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/labels.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../campgrounds/campground_detail_screen.dart';
import '../monetization/free_limit.dart';

enum CampgroundSort { name, recent, rating }

/// Live campground list.
final campgroundsProvider = StreamProvider<List<Campground>>(
  (ref) => ref.watch(campgroundRepositoryProvider).watchAll(),
);

/// [all] filtered by [query] (name or state) and re-sorted for [sort].
List<Campground> filterAndSort(
    List<Campground> all, String query, CampgroundSort sort) {
  final q = query.trim().toLowerCase();
  final filtered = [
    for (final c in all)
      if (q.isEmpty ||
          c.name.toLowerCase().contains(q) ||
          (c.state?.toLowerCase() == q))
        c,
  ];
  switch (sort) {
    case CampgroundSort.name:
      break; // repository order is already A-Z
    case CampgroundSort.recent:
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    case CampgroundSort.rating:
      filtered.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
  }
  return filtered;
}

/// The campground log — Hitch Post's home tab.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  var _sort = CampgroundSort.name;
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final campgrounds = ref.watch(campgroundsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Hitch Post')),
      body: campgrounds.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (all) => all.isEmpty ? _empty(context) : _list(context, all),
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
            Icon(Icons.forest_outlined,
                size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text('Your campground spreadsheet, on your phone.',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              "Add the first campground you'd want to rebook.",
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _list(BuildContext context, List<Campground> all) {
    final theme = Theme.of(context);
    final usage = campgroundFreeLimit.usage(all.length);
    final shown = filterAndSort(all, _search.text, _sort);
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          // Phase C swaps this for the tappable FreeTierCounter that
          // hides for Pro owners.
          child: Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              avatar: const Icon(Icons.forest_outlined, size: 18),
              label: Text(usage.label),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TextField(
            controller: _search,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search name or state',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: SegmentedButton<CampgroundSort>(
            segments: const [
              ButtonSegment(value: CampgroundSort.name, label: Text('Name')),
              ButtonSegment(
                  value: CampgroundSort.recent, label: Text('Recent')),
              ButtonSegment(
                  value: CampgroundSort.rating, label: Text('Rating')),
            ],
            selected: {_sort},
            onSelectionChanged: (s) => setState(() => _sort = s.single),
          ),
        ),
        if (shown.isEmpty)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Nothing matches "${_search.text}".',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center),
          ),
        for (final campground in shown) _CampgroundCard(campground),
        const SizedBox(height: 88), // keep the FAB off the last card
      ],
    );
  }
}

class _CampgroundCard extends StatelessWidget {
  const _CampgroundCard(this.campground);

  final Campground campground;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(campground.name),
        subtitle: Text([
          campground.kind.label,
          if (campground.state != null) campground.state!,
        ].join(' · ')),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (campground.rating != null)
              RatingStars(rating: campground.rating, size: 14),
            Text(
              campground.wouldReturn ? 'Would return' : "Wouldn't return",
              style: theme.textTheme.labelSmall?.copyWith(
                color: campground.wouldReturn
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error,
              ),
            ),
          ],
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) =>
                CampgroundDetailScreen(campgroundId: campground.id),
          ),
        ),
      ),
    );
  }
}
