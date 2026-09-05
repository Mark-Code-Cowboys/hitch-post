# Hitch Post — Release checklist

Work top to bottom; nothing ships with an unchecked box above it.

## Code

- [x] `pubspec.yaml` version bumped (`1.0.0+1` for the first release)
- [x] cc_core pinned to a pushed tag (currently `v0.16.1`) —
      `pubspec_overrides.yaml` is git-ignored and must NOT influence the
      release build: `flutter pub get` on a clean checkout resolves
- [x] `flutter analyze` — zero issues
- [x] `flutter test` — all green (72)
- [x] `dart run flutter_launcher_icons` output committed (android/ios)

## The 11-step paywall pass (both platforms, sandbox/license testers)

Run in order on a fresh install. Same pass on iOS once the Codemagic
lane exists — steps identical, StoreKit sandbox account instead.

1. [ ] Fresh install → onboarding → "Just look around": counter reads
       "0 of 5 campgrounds", Trends shows the Pro teaser
2. [ ] Add 5 campgrounds → each add ticks the counter; the 6th add
       opens the paywall instead of the composer
3. [ ] Dismiss ("Not now") → no campground added, gate still closed
4. [ ] Delete a campground → still gated (lifetime tally — slots are
       never refunded)
5. [ ] Add a rig, then a 2nd rig → paywall; delete the rig → 2nd rig
       now allowed free (live count — trading up stays free)
6. [ ] Notebook import and receipt scan as free user → paywall first
7. [ ] Buy monthly (sandbox) → sheet closes itself, counter gone,
       6th campground composer opens, Trends content live
8. [ ] Kill + relaunch offline → still Pro (entitlement cache)
9. [ ] Cancel the subscription → after sandbox expiry + relaunch,
       gates return; log data all still readable and editable
10. [ ] Buy lifetime on a second tester → same entitlement; "Or yours
        forever" price shown correctly beforehand
11. [ ] Uninstall → reinstall → Restore purchase → Pro returns; then
        restore a backup → log AND free-tier tally intact

## On-device (Pixel), release build

- [ ] `flutter run --release` cold start < 2s, no red screens
- [ ] Onboarding shows once; kill/relaunch skips it
- [ ] Notebook import with 3 real pages: scanner opens, review shows
      transcriptions verbatim, edit one, bulk insert lands
- [ ] Receipt scan on a real receipt: total + dates read, confirm
      dialog, fields filled
- [ ] CSV import: a Sheets export maps and lands
- [ ] Pin map: drop a pin, move it, remove it; tiles load; pin
      survives editing the campground
- [ ] Backup → share to Drive → wipe app data → restore → log, photos,
      and free-tier tally intact
- [ ] DEMO_SEED build only for screenshots — never the uploaded AAB
- [ ] Dark theme spot-check: home, site grid, composer, paywall,
      trends, pin map

## Store

- [ ] Privacy policy live at code-cowboys.com/privacy/hitchpost
      (source: `docs/privacy-policy.md`)
- [ ] Listing fields pasted from `docs/play-store-listing.md`
- [ ] Screenshots: 6 per the listing doc (5 from DEMO_SEED, #6 from a
      fresh non-demo install)
- [ ] Feature graphic + 512 store icon exported
- [ ] Products created per `docs/play-monetization-setup.md`, Active
- [ ] Data safety form matches the privacy policy

## Build & upload

- [ ] `android/key.properties` + keystore in place (never committed)
- [ ] `flutter build appbundle --release`
- [ ] Internal testing release; license testers run the 11-step pass
- [ ] Promote to closed → production when the boxes above are checked

## Post-launch

- [ ] Tag the app repo `v1.0.0`
- [ ] Note any cc_core friction found during release in
      course-ledger's `docs/cc-core-gaps.md` (the fleet ledger)
- [ ] Backlog: pin map clustering if logs grow past ~100 pins; visit
      photo captions UI; per-carrier cell-signal trends
