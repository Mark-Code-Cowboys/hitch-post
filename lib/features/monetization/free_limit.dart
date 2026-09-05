import 'package:cc_core/cc_core.dart';

/// Free tier: this many campgrounds, forever. Adds gated only (Phase C
/// wires the gate); existing data is never locked.
const kFreeCampgroundLimit = 5;

/// Free tier: one rig.
const kFreeRigLimit = 1;

/// Campground quota with Hitch Post wording.
const campgroundFreeLimit = FreeLimit(
  kFreeCampgroundLimit,
  'campgrounds',
  detailBuilder: _campgroundDetail,
);

/// Rig quota.
const rigFreeLimit = FreeLimit(kFreeRigLimit, 'rigs');

String _campgroundDetail(int remaining) => switch (remaining) {
      0 => 'Free campgrounds all used — go Pro to keep the log growing.',
      1 => '1 more campground free — then Hitch Post Pro.',
      final n => '$n more campgrounds free — then Hitch Post Pro.',
    };
