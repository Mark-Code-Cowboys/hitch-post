import 'package:latlong2/latlong.dart';

import '../../data/database/app_database.dart';

/// A campground that has opted into a map pin.
typedef CampgroundPin = ({Campground campground, LatLng point});

/// The campgrounds with a pin set — the marker list for the pin map.
List<CampgroundPin> campgroundPins(List<Campground> campgrounds) => [
      for (final c in campgrounds)
        if (c.lat != null && c.lon != null)
          (campground: c, point: LatLng(c.lat!, c.lon!)),
    ];
