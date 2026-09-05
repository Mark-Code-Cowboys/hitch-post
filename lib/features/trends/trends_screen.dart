import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/backup/backup_service.dart';
import '../../core/export/export_service.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../home/home_screen.dart';
import '../monetization/monetization_providers.dart';
import '../monetization/paywall_sheet.dart';
import 'trends_math.dart';

/// Every visit in the log, raw, for the trends math.
final allVisitsProvider = StreamProvider<List<Visit>>(
  (ref) => ref.watch(visitRepositoryProvider).watchAllRaw(),
);

/// The long arc of the road: nights, dollars, the states map. Pro-only
/// (the paywall's second benefit); restore is never gated.
class TrendsScreen extends ConsumerWidget {
  const TrendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pro = ref.watch(isProProvider).value ?? false;
    return Scaffold(
      appBar: AppBar(title: const Text('Trends')),
      body: pro ? const _TrendsContent() : const _ProTeaser(),
    );
  }
}

/// Free users see the pitch — and the restore button, because getting
/// your own log back is never gated.
class _ProTeaser extends ConsumerWidget {
  const _ProTeaser();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_outlined,
                size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text('The long arc of the road.',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'The states map, nights by year, cost per night, the '
              'camped calendar, and export — all part of Hitch Post Pro.',
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => showPaywallSheet(context),
              child: const Text('See Hitch Post Pro'),
            ),
            const SizedBox(height: 24),
            const Divider(),
            TextButton.icon(
              icon: const Icon(Icons.settings_backup_restore),
              label: const Text('Restore a backup'),
              onPressed: () => restoreBackupFlow(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendsContent extends ConsumerStatefulWidget {
  const _TrendsContent();

  @override
  ConsumerState<_TrendsContent> createState() => _TrendsContentState();
}

class _TrendsContentState extends ConsumerState<_TrendsContent> {
  late DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July',
    'August', 'September', 'October', 'November', 'December',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final campgrounds = ref.watch(campgroundsProvider).value;
    final visits = ref.watch(allVisitsProvider).value;
    if (campgrounds == null || visits == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final states = statesRecorded(campgrounds);
    final byYear = nightsByYear(visits);
    final nights = totalNights(visits);
    final avgCents = avgCostPerNightCents(visits);
    final camped = nightsInMonth(visits, _month.year, _month.month);
    final now = DateTime.now();

    Widget section(String title, Widget child) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              child,
            ],
          ),
        );

    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        section(
          'The log so far',
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatChip(count: campgrounds.length, one: 'campground'),
              _StatChip(count: visits.length, one: 'visit'),
              _StatChip(count: nights, one: 'night'),
              _StatChip(count: states.length, one: 'state'),
            ],
          ),
        ),
        if (avgCents != null)
          section(
            'Cost per night',
            Text(
              '\$${(avgCents / 100).toStringAsFixed(2)} average, over the '
              'visits with a recorded cost.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        section(
          'The states map',
          RegionTileGrid(tiles: usStateTiles, filled: states),
        ),
        if (byYear.isNotEmpty)
          section('Nights by year', YearlyBars(countsByYear: byYear)),
        section(
          'The camped calendar',
          Column(
            children: [
              TrendWindowNav(
                label: '${_monthNames[_month.month - 1]} ${_month.year}',
                onPrev: () => setState(() =>
                    _month = DateTime(_month.year, _month.month - 1)),
                onNext: () => setState(() =>
                    _month = DateTime(_month.year, _month.month + 1)),
                nextEnabled: _month.isBefore(DateTime(now.year, now.month)),
              ),
              const SizedBox(height: 4),
              CalendarMonthGrid(
                year: _month.year,
                month: _month.month,
                dayBuilder: (context, date) => _DayCell(
                    day: date.day, camped: camped.contains(date)),
              ),
            ],
          ),
        ),
        section(
          'Your log, portable',
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.table_chart_outlined),
                label: const Text('Share visits as CSV'),
                onPressed: () => _shareCsv(context),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.archive_outlined),
                label: const Text('Back up the whole log'),
                onPressed: () => _shareBackup(context),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.settings_backup_restore),
                label: const Text('Restore a backup'),
                onPressed: () => restoreBackupFlow(context, ref),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ExportService _exporter() => ExportService(
        ref.read(databaseProvider),
        ref.read(shareLauncherProvider),
        ref.read(tempDirProvider),
        photos: ref.read(photoServiceProvider),
      );

  Future<void> _shareCsv(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await _exporter().shareVisitsCsv();
    } on Exception catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
  }

  Future<void> _shareBackup(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await _exporter().shareBackup(
          lifetimeCampgrounds:
              await ref.read(campgroundRepositoryProvider).lifetimeCreated());
    } on Exception catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Backup failed: $e')));
    }
  }
}

/// One calendar day: filled when a night was camped. Transcription of
/// the log, no judgement.
class _DayCell extends StatelessWidget {
  const _DayCell({required this.day, required this.camped});

  final int day;
  final bool camped;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: camped ? scheme.primary : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(
        '$day',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: camped ? scheme.onPrimary : scheme.onSurfaceVariant),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.count, required this.one, String? many})
      : many = many ?? '${one}s';

  final int count;
  final String one;
  final String many;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      label: Text('$count ${count == 1 ? one : many}'),
      labelStyle: theme.textTheme.bodyMedium,
    );
  }
}

/// Pick a .zip backup, confirm the replace, restore, raise the tally.
/// Available to free users — restoring your own log is never gated.
Future<void> restoreBackupFlow(BuildContext context, WidgetRef ref) async {
  const typeGroup = XTypeGroup(label: 'Backup', extensions: ['zip']);
  final picked = await openFile(acceptedTypeGroups: const [typeGroup]);
  if (picked == null || !context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Restore this backup?'),
      content: const Text(
          'The log on this phone is replaced with the backup — '
          'campgrounds, sites, visits, and the rig. This cannot be '
          'undone.'),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel')),
        FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Restore')),
      ],
    ),
  );
  if (confirmed != true) return;

  try {
    final contents = readBackupArchive(await File(picked.path).readAsBytes());
    final lifetime = await restoreFromExportData(
        ref.read(databaseProvider), contents.exportData);
    // Photo files ride along in the archive; put them back in the store.
    final store = ref.read(photoServiceProvider);
    for (final entry in contents.media.entries) {
      await store.importBytes(entry.key, entry.value);
    }
    await ref.read(campgroundTallyProvider).raiseTo(lifetime);
    messenger
        .showSnackBar(const SnackBar(content: Text('Backup restored.')));
  } on InvalidBackupException catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(e.message)));
  } on Exception catch (e) {
    messenger.showSnackBar(SnackBar(content: Text('Restore failed: $e')));
  }
}
