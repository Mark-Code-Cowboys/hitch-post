# Hitch Post — Google Play Store Listing

Copy-paste source for the Play Console listing. Character limits noted
per field; counts verified at draft time (2026-09-05).

---

## App name (max 30 chars)

> Hitch Post: RV Campground Log

(29 chars. Alternatives: "Hitch Post" alone (10); "Hitch Post — Camping
Journal" (28).)

## Short description (max 80 chars)

> The campground log RVers keep — every site you'd book again, on your phone.

(75 chars — campground log is the lead keyword.)

## Full description (max 4000 chars)

> **Every site you'd book again, in one book.**
>
> Hitch Post is the campground log RVers keep: not a booking app, not a
> review site — your own record of every campground and site you've
> stayed at, what it cost, whether the rig fit, and what future-you
> should know before rebooking.
>
> **The campground log**
> • Campgrounds A-Z, by state, by rating — with your would-return
>   verdict on every card
> • Site pages built for rebooking: power, water, sewer, max length,
>   pull-thru or back-in, shade, level, cell bars by carrier
> • Visits with dates, nights, total cost, a star rating, notes for
>   next time, and photos
>
> **The rig garage**
> The numbers you re-derive every season, kept: ball size, hitch drop,
> weight-distribution bar setting, tire pressures, brake gain, bearing
> service and tire dates.
>
> **The notebook import**
> Kept the log in a spiral notebook or a spreadsheet printout? Shoot
> the pages 20 at a time. Hitch Post reads each one — campground, site,
> dates, cost — you confirm every value, and your history files itself.
> Spreadsheet keeper instead? The CSV importer maps your columns. And
> the receipt scanner fills a visit's cost and dates straight off the
> campground receipt.
>
> **Trends (Pro)**
> The states map — everywhere you've camped, filled in. Nights by year,
> average cost per night, the camped calendar. An optional pin map
> shows your campgrounds on a real map — pins exist only where you
> drop them. Export your log as CSV or a full backup.
>
> **Private by construction**
> No account. No cloud. No analytics. Your log stays on your phone —
> page and receipt reading happens on-device, and the app requests no
> location permission. Your first 5 campgrounds and your rig are free
> forever; Hitch Post Pro (monthly or one-time lifetime) removes the
> cap.
>
> The log is yours. We never see it.

## Keywords (App Store keyword field; woven into Play description above)

campground log, RV site tracker, camping journal, campground tracker,
RV trip log, campsite notes, camping log book, RV journal

## Category

Travel & Local (secondary consideration: Lifestyle)

## Privacy policy URL

https://code-cowboys.com/privacy/hitchpost
(Source text: `docs/privacy-policy.md` — publish before submission.)

---

## Screenshots (phone, 1080×2400, DEMO_SEED data)

Run `flutter run --dart-define=DEMO_SEED=true` on the Pixel; the seed
plants 8 campgrounds / 2 rigs / 20 visits across 6 states with notes
written for these shots. Order tells the product story:

1. **The campground log** — Home, A-Z, with ratings and would-return
   verdicts ("Thumb Shores — Wouldn't return" sells honesty). Caption:
   "Every site you'd book again."
2. **Site detail** — Big Pines site 42: the eight-tile grid (50A ·
   sewer · pull-thru · 3 bars VZW) over the visit list. Caption:
   "The rebooking record."
3. **The rig garage** — The Ark: hitch, pressures, service dates.
   Caption: "The numbers you re-derive every season, kept."
4. **The states map + trends** — Trends tab: chips, states filled,
   nights by year. Caption: "Six states and counting."
5. **The notebook import** — batch review screen mid-import (stage 2-3
   pages; screenshot the review list). Caption: "Shoot the old
   notebook. Confirm. Done."
6. **The free-tier paywall** — home with the "3 of 5 campgrounds"
   counter visible (fresh non-demo install, three adds), or the
   paywall sheet itself. Caption: "First 5 campgrounds free forever.
   Pro is the whole map."

Shot 6 needs a NON-demo build (demo fakes Pro and hides the counter).

Feature graphic (1024×500) and 512px store icon: derive from
`assets/icon/` art — forest green, the signpost-over-ball-hitch mark,
wordmark right. TODO alongside first upload.
