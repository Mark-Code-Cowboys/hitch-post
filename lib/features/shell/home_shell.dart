import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../campgrounds/campground_composer_screen.dart';
import '../home/home_screen.dart';
import '../monetization/free_limit.dart';
import '../monetization/monetization_providers.dart';
import '../monetization/paywall_sheet.dart';
import '../rig/rig_composer_screen.dart';
import '../rig/rig_screen.dart';
import '../trends/trends_screen.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  var _index = 0;

  static const _screens = [HomeScreen(), RigScreen(), TrendsScreen()];

  /// Adding a campground past the free five (lifetime creations, so
  /// deletes don't refund slots) opens the paywall instead; unlocking
  /// mid-flow continues to the composer.
  Future<void> _addCampground() async {
    final entitled =
        await ref.read(entitlementServiceProvider).isUnlimited();
    final used =
        await ref.read(campgroundRepositoryProvider).lifetimeCreated();
    try {
      campgroundFreeLimit.guard(used: used, entitled: entitled);
    } on FreeLimitReachedException {
      if (!mounted) return;
      final unlocked = await showPaywallSheet(context);
      if (!unlocked) return;
    }
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const CampgroundComposerScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  /// The rig gate counts the garage, not history: free users keep one
  /// rig at a time, and trading up (delete, add) stays free.
  Future<void> _addRig() async {
    final entitled =
        await ref.read(entitlementServiceProvider).isUnlimited();
    final used = await ref.read(rigRepositoryProvider).count();
    try {
      rigFreeLimit.guard(used: used, entitled: entitled);
    } on FreeLimitReachedException {
      if (!mounted) return;
      final unlocked = await showPaywallSheet(context);
      if (!unlocked) return;
    }
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const RigComposerScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      floatingActionButton: switch (_index) {
        0 => FloatingActionButton.extended(
            onPressed: _addCampground,
            icon: const Icon(Icons.add),
            label: const Text('Add campground'),
          ),
        1 => FloatingActionButton.extended(
            onPressed: _addRig,
            icon: const Icon(Icons.add),
            label: const Text('Add rig'),
          ),
        _ => null, // trends is a reading tab
      },
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.forest_outlined), label: 'Campgrounds'),
          NavigationDestination(
              icon: Icon(Icons.rv_hookup_outlined), label: 'Rig'),
          NavigationDestination(
              icon: Icon(Icons.insights_outlined), label: 'Trends'),
        ],
      ),
    );
  }
}
