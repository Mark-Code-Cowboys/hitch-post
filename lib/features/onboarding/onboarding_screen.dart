import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../campgrounds/campground_composer_screen.dart';
import '../scan_import/import_sheet.dart';

/// First run seen? Refreshed after onboarding completes.
final firstRunSeenProvider = FutureProvider<bool>(
  (ref) => FirstRunFlag(ref.watch(kvStoreProvider)).seen(),
);

/// The first thing a new user reads is the positioning — this is the
/// campground book, not a booking app — then the privacy promise, then
/// the fork: notebook and spreadsheet keepers start with the importer,
/// everyone else with a campground or a look around.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  Future<void> _finish(WidgetRef ref) async {
    await FirstRunFlag(ref.read(kvStoreProvider)).markSeen();
    ref.invalidate(firstRunSeenProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingScaffold(
      icon: Icons.signpost_outlined,
      positioning: 'Every site you\'d book again, in one book.',
      subtitle: 'Not a booking app. Not a review site. Hitch Post is the '
          'notebook RVers keep — campgrounds, sites, what they cost, '
          'whether the rig fit, and what future-you should know.',
      actions: [
        FilledButton.icon(
          icon: const Icon(Icons.download_outlined),
          label: const Text('Import my old log'),
          onPressed: () async {
            // Run the flow first so this screen stays alive under it,
            // then swap to the shell.
            await showImportSheet(context, ref);
            await _finish(ref);
          },
        ),
        OutlinedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add my first campground'),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const CampgroundComposerScreen(),
                fullscreenDialog: true,
              ),
            );
            await _finish(ref);
          },
        ),
        TextButton(
          onPressed: () => _finish(ref),
          child: const Text('Just look around'),
        ),
      ],
    );
  }
}
