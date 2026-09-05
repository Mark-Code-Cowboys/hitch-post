import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../campgrounds/campground_composer_screen.dart';
import '../home/home_screen.dart';
import '../rig/rig_composer_screen.dart';
import '../rig/rig_screen.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  var _index = 0;

  static const _screens = [HomeScreen(), RigScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      floatingActionButton: switch (_index) {
        // Phase C wraps both adds in their FreeLimit gates.
        0 => FloatingActionButton.extended(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const CampgroundComposerScreen(),
                fullscreenDialog: true,
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add campground'),
          ),
        _ => FloatingActionButton.extended(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const RigComposerScreen(),
                fullscreenDialog: true,
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add rig'),
          ),
      },
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.forest_outlined), label: 'Campgrounds'),
          NavigationDestination(
              icon: Icon(Icons.rv_hookup_outlined), label: 'Rig'),
        ],
      ),
    );
  }
}
