import 'package:google_maps_flutter/google_maps_flutter.dart';

/// a location
class GoogleMapsPlacePickerLocation {
  LatLng coordinates;

  String? formattedAddress;

  String? name;

  GoogleMapsPlacePickerLocation(
    this.coordinates, {
    this.formattedAddress,
    this.name,
  });

  /// formats the data
  String get label {
    if (formattedAddress != null) return formattedAddress!;
    if (name != null) return name!;
    return '${coordinates.latitude}, ${coordinates.longitude}';
  }
}
