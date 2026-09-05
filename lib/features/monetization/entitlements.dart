import 'package:cc_core/cc_core.dart';

// The billing wrapper, entitlement cache, and store types live in
// cc_core; this file keeps Hitch Post's product catalog and re-exports
// the shared types for app import sites.
export 'package:cc_core/cc_core.dart'
    show
        EntitlementService,
        FakeEntitlementService,
        StoreEntitlementService,
        StoreProducts,
        StoreUnavailableException;

/// Store product ids. Must match the products configured in Play
/// Console (and later App Store Connect) exactly.
abstract final class ProductIds {
  static const proMonthly = 'hitchpost_pro_monthly';
  static const proLifetime = 'hitchpost_pro_lifetime';
  static const all = [proMonthly, proLifetime];
}

/// Hitch Post's catalog: one Pro entitlement, sold as a monthly
/// subscription or a lifetime unlock. cc_core's `isUnlimited()` is true
/// for either, so the whole app gates on that single answer.
const hpStoreProducts = StoreProducts(
  lifetimeUnlock: ProductIds.proLifetime,
  premiumSubscription: ProductIds.proMonthly,
);
