import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'free_limit.dart';
import 'monetization_providers.dart';

/// Shows the Pro pitch. Resolves true if the user owns Pro when the
/// sheet closes (purchase or restore completed while it was open).
Future<bool> showPaywallSheet(BuildContext context) async {
  final result = await showPaywallModal<bool>(
    context,
    builder: (context) => const _PaywallSheet(),
  );
  return result ?? false;
}

class _PaywallSheet extends ConsumerWidget {
  const _PaywallSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyPrice = ref.watch(_monthlyPriceProvider).value;
    final lifetimePrice = ref.watch(_lifetimePriceProvider).value;
    final usage = ref.watch(freeTierUsageProvider);
    final service = ref.read(entitlementServiceProvider);

    // Close with success the moment the entitlement lands.
    ref.listen(isProProvider, (_, next) {
      if (next.value == true && context.mounted) {
        Navigator.of(context).pop(true);
      }
    });

    // Purchase-stream failures land asynchronously; show them so
    // "nothing happened" always has a visible reason (offline taps
    // included, via runStoreAction).
    ref.listen(storeErrorsProvider, (_, next) {
      final message = next.value;
      if (message != null && context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    });

    return PaywallSheetScaffold(
      icon: Icons.rv_hookup_outlined,
      title: 'Hitch Post Pro',
      highlight: usage?.label,
      body: 'The free log keeps your first $kFreeCampgroundLimit '
          'campgrounds and your rig forever — nothing you\'ve recorded '
          'is ever locked away. Pro is the whole map. No account, and '
          'your log still never leaves this phone.',
      benefits: const [
        PaywallBenefit(
          icon: Icons.all_inclusive,
          title: 'Unlimited campgrounds and rigs',
          detail: 'The log grows as far as the road does.',
        ),
        PaywallBenefit(
          icon: Icons.map_outlined,
          title: 'Trends and the states map',
          detail: 'Nights per year, cost per night, states filled in.',
        ),
        PaywallBenefit(
          icon: Icons.ios_share_outlined,
          title: 'Export and backup',
          detail: 'Your spreadsheet back out — CSV and full backup.',
        ),
      ],
      primaryLabel: 'Go Pro · ${monthlyPrice ?? r'$1.99'} / month',
      onPrimary: () => runStoreAction(context, service.buyPremium),
      restoreLabel: 'Restore purchase',
      onRestore: () => runStoreAction(context, service.restorePurchases),
      extraActions: [
        TextButton(
          onPressed: () => runStoreAction(context, service.buyUnlimited),
          child: Text('Or yours forever · ${lifetimePrice ?? r'$19.99'}'),
        ),
      ],
      onLater: () => Navigator.of(context).pop(false),
    );
  }
}

final _monthlyPriceProvider = FutureProvider.autoDispose<String?>(
  (ref) => ref.watch(entitlementServiceProvider).premiumPrice(),
);

final _lifetimePriceProvider = FutureProvider.autoDispose<String?>(
  (ref) => ref.watch(entitlementServiceProvider).unlimitedPrice(),
);
