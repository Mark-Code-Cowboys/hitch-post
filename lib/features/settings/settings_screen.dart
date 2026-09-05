import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../monetization/monetization_providers.dart';
import '../monetization/paywall_sheet.dart';

/// Settings: today just the upgrade path and the privacy promise;
/// backup/restore joins in Phase E.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pro = ref.watch(isProProvider).value ?? false;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(pro ? Icons.star_rounded : Icons.star_outline),
            title: Text(pro ? 'Hitch Post Pro — active' : 'Hitch Post Pro'),
            subtitle: Text(pro
                ? 'Unlimited campgrounds and rigs, trends, export.'
                : 'Upgrade for unlimited campgrounds and rigs, trends '
                    'and the states map, export and backup.'),
            trailing: pro ? null : const Icon(Icons.chevron_right),
            onTap: pro ? null : () => showPaywallSheet(context),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.lock_outline),
            title: Text('Your data stays here'),
            subtitle: Text('No account, no cloud, no analytics. The log '
                'never leaves this phone.'),
          ),
        ],
      ),
    );
  }
}
