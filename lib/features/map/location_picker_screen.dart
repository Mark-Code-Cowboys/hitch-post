import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

/// What the picker resolved to: a chosen point, or an explicit removal.
/// (Backing out returns null instead.)
class PinChoice {
  const PinChoice.set(LatLng this.point) : removed = false;
  const PinChoice.removed()
      : point = null,
        removed = true;

  final LatLng? point;
  final bool removed;
}

/// Tap-to-place pin picker over OpenStreetMap tiles — the opt-in
/// moment: a campground gets coordinates only when the user drops the
/// pin here themselves.
class LocationPickerScreen extends ConsumerStatefulWidget {
  const LocationPickerScreen({super.key, this.initial});

  /// The campground's current pin, if it has one.
  final LatLng? initial;

  @override
  ConsumerState<LocationPickerScreen> createState() =>
      _LocationPickerScreenState();
}

class _LocationPickerScreenState
    extends ConsumerState<LocationPickerScreen> {
  late LatLng? _point = widget.initial;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drop the pin'),
        actions: [
          if (widget.initial != null)
            IconButton(
              icon: const Icon(Icons.location_off_outlined),
              tooltip: 'Remove pin',
              onPressed: () =>
                  Navigator.of(context).pop(const PinChoice.removed()),
            ),
          TextButton(
            onPressed: _point == null
                ? null
                : () =>
                    Navigator.of(context).pop(PinChoice.set(_point!)),
            child: const Text('Save'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _point ?? const LatLng(39.83, -98.58),
                initialZoom: _point == null ? 3.5 : 11,
                onTap: (_, latLng) => setState(() => _point = latLng),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.codecowboys.hitchpost',
                ),
                if (_point != null)
                  MarkerLayer(markers: [
                    Marker(
                      point: _point!,
                      width: 44,
                      height: 44,
                      alignment: Alignment.topCenter,
                      child: Icon(Icons.location_on,
                          size: 36, color: theme.colorScheme.primary),
                    ),
                  ]),
                const SimpleAttributionWidget(
                    source: Text('OpenStreetMap contributors')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Tap where the campground is. Map tiles load from '
              'OpenStreetMap; the pin stays on this phone.',
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
