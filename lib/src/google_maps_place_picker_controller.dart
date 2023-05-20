import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/src/google_maps_place_picker_location.dart';

/// controller for [GoogleMapsPlacePicker]
class GoogleMapsPlacePickerController {
  /// update this on widget init
  late final Function rebuildGoogleMapsPlacePickerWidget;

  /// controller for google maps widget, update this on widget init
  late GoogleMapController googleMapController;

  /// the current selected location
  GoogleMapsPlacePickerLocation? selectedLocation;

  /// the [TextEditingController] for searching
  TextEditingController searchController = TextEditingController();

  /// the [FocusNode] for searching
  FocusNode searchFocusNode = FocusNode();

  /// a set containing the current selected location's marker
  Set<Marker> selectedLocationMarker = Set<Marker>();

  /// the current search
  String currentSearch = '';

  /// maps a text input search result to its actual results
  Map<String, List<GoogleMapsPlacePickerLocation>> searchResults = {};

  /// updates the marker displaying the current selected location
  void _updateSelectedLocationMarker(LatLng coordinates) {
    selectedLocationMarker.clear();
    selectedLocationMarker.add(
      Marker(
        markerId: const MarkerId('selected_location'),
        position: coordinates,
      ),
    );
  }

  /// updates [selectedLocation] and the state associated with it
  void updateSelectedLocation(
    GoogleMapsPlacePickerLocation newSelectedLocation,
  ) {
    selectedLocation = newSelectedLocation;

    _updateSelectedLocationMarker(newSelectedLocation.coordinates);

    googleMapController.animateCamera(
      CameraUpdate.newLatLng(newSelectedLocation.coordinates),
    );

    // clear search
    currentSearch = '';
    searchController.text = '';

    rebuildGoogleMapsPlacePickerWidget();
  }

  /// callback on the google maps widget tapped
  void onMapTapped(LatLng coordinates) {
    updateSelectedLocation(GoogleMapsPlacePickerLocation(coordinates));
  }

  /// callback on the current search changed
  void onCurrentSearchChanged(String input, String apiKey) {
    currentSearch = input;
    if (searchResults[input] != null) {
      rebuildGoogleMapsPlacePickerWidget(); // don't search input but rebuild anyways
      return;
    }

    if (input.trim() == '') {
      rebuildGoogleMapsPlacePickerWidget(); // don't search blank but rebuild anyways
      return;
    }

    _searchPlace(input, apiKey);
  }

  /// searches based on [input] and fills [searchResults]
  Future<void> _searchPlace(
    String input,
    String apiKey,
  ) async {
    const String endpoint =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json';

    final url = Uri.parse(
        '$endpoint?input=$input&inputtype=textquery&key=$apiKey&locationbias=ipbias&fields=name,formatted_address,geometry/location');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List candidates = data['candidates'];
      List<GoogleMapsPlacePickerLocation> results = [];

      for (int i = 0; i < candidates.length; i++) {
        Map candidate = candidates[i];
        Map? location = candidate['geometry']['location'];
        if (location != null) {
          // only add if location is present
          LatLng coordinates = LatLng(location['lat'], location['lng']);

          String? formattedAddress;
          String? name;

          formattedAddress = candidate['formatted_address'];
          name = candidate['name'];

          results.add(
            GoogleMapsPlacePickerLocation(
              coordinates,
              formattedAddress: formattedAddress,
              name: name,
            ),
          );
        }
      }

      searchResults[input] = results;

      // rebuild if the input matches the current search
      if (input == currentSearch) {
        rebuildGoogleMapsPlacePickerWidget();
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  /// callback to dispose current controller
  void dispose() {
    googleMapController.dispose();
    searchController.dispose();
    searchFocusNode.dispose();
  }
}
