# Hitch Post — Play monetization setup (manual checklist)

Do these in order — the products menu is hidden until Play has
processed a build containing the billing permission. Mirrors Course
Ledger's checklist; differences called out.

## 0. Payments profile (account level, one-time)

Already done for TableEncore. Skip.

## 1. Upload the AAB

Internal testing → Create release → `app-release.aab` (see
release-checklist.md for the build). The `in_app_purchase` plugin
embeds `com.android.vending.BILLING`; once Play processes the build,
**Monetize** unlocks.

## 2. One-time product (Monetize → Products → In-app products)

| Product ID | Name | Price |
| --- | --- | --- |
| `hitchpost_pro_lifetime` | Hitch Post Pro — Lifetime | $19.99 |

Id must match `lib/features/monetization/entitlements.dart` exactly.
Purchase option ID: `buy` (no underscores allowed there; the code never
reads it — keep it the backwards-compatible default). Mark **Active**.

Description (≤200 chars, shown in the purchase dialog):

> Hitch Post Pro, forever: unlimited campgrounds and rigs, trends and
> the states map, notebook and receipt scanning, and export. One
> purchase, no subscription.

## 3. Subscription (Monetize → Products → Subscriptions)

| Product ID | Base plan ID | Billing | Price |
| --- | --- | --- | --- |
| `hitchpost_pro_monthly` | `monthly` | Monthly, auto-renewing | $1.99/mo |

Single base plan — cc_core's `premiumPrice()`/`buyPremium()` use the
first (only) plan, so no `premiumPlanLabels` are configured. Enable the
base plan, mark the subscription **Active**.

Benefits list (shown on the store):
unlimited campgrounds & rigs · trends + states map · notebook import ·
CSV export & backup.

## 4. License testers

Play Console → Settings → License testing: add the test account(s) so
sandbox purchases don't charge. Verify on-device per the 11-step
paywall pass in `release-checklist.md`.

## 5. Data safety form

All "No" (no data collected, no data shared), except:
- "On-device processing only" notes for page/receipt images
- Purchases: handled by Google Play

Note the pin map's OpenStreetMap tile fetches are content the app
*downloads*, not data it collects — no disclosure row, but keep the
privacy policy's wording ("only network use besides purchases") in
sync if this ever changes.

## App Store (later, with the Codemagic iOS lane)

`hitchpost_pro_lifetime` as a non-consumable; `hitchpost_pro_monthly`
as an auto-renewable subscription in its own group. No base plans on
the App Store — one product per plan is already the shape cc_core
supports if a yearly plan is ever added (`premiumPlanProducts`).
