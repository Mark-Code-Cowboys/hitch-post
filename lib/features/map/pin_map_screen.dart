import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../campgrounds/campground_detail_screen.dart';
import '../home/home_screen.dart';
import 'map_pins.dart';

/// Geographic center of the lower 48 — the empty-map view.
const _usCenter = LatLng(39.83, -98.58);

/// The opt-in pin map: every campground the user has dropped a pin
/// for, over OpenStreetMap tiles. Tiles are the one network fetch in
/// the app — the log itself never leaves the phone, and campgrounds
/// only appear here after an explicit "set map pin".
class PinMapScreen extends ConsumerWidget {
  const PinMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final campgrounds = ref.watch(campgroundsProvider).value ?? const [];
    final pins = campgroundPins(campgrounds);

    return Scaffold(
      appBar: AppBar(title: const Text('The pin map')),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter:
                    pins.length == 1 ? pins.single.point : _usCenter,
                initialZoom: pins.length == 1 ? 9 : 3.5,
                initialCameraFit: pins.length > 1
                    ? CameraFit.bounds(
                        bounds: LatLngBounds.fromPoints(
                            [for (final p in pins) p.point]),
                        padding: const EdgeInsets.all(48),
                      )
                    : null,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.codecowboys.hitchpost',
                ),
                MarkerLayer(
                  markers: [
                    for (final pin in pins)
                      Marker(
                        point: pin.point,
                        width: 44,
                        height: 44,
                        alignment: Alignment.topCenter,
                        child: Tooltip(
                          message: pin.campground.name,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => CampgroundDetailScreen(
                                    campgroundId: pin.campground.id),
                              ),
                            ),
                            child: Icon(Icons.location_on,
                                size: 36,
                                color: theme.colorScheme.primary),
                          ),
                        ),
                      ),
                  ],
                ),
                const SimpleAttributionWidget(
                    source: Text('OpenStreetMap contributors')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              pins.isEmpty
                  ? 'No pins yet — drop one from a campground\'s page. '
                      'Map tiles load from OpenStreetMap; your log never '
                      'leaves the phone.'
                  : '${pins.length} of ${campgrounds.length} campgrounds '
                      'pinned. Map tiles load from OpenStreetMap; your '
                      'log never leaves the phone.',
              style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
