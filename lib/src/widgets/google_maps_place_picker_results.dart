import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/src/google_maps_place_picker_controller.dart';
import 'package:google_maps_place_picker/src/google_maps_place_picker_location.dart';

/// results for the search
class GoogleMapsPlacePickerResults extends StatelessWidget {
  final GoogleMapsPlacePickerController controller;
  final List<GoogleMapsPlacePickerLocation> results;
  final TextStyle? selectedLocationResultTextStyle;
  const GoogleMapsPlacePickerResults({
    super.key,
    required this.controller,
    required this.results,
    required this.selectedLocationResultTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          itemCount: results.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: GestureDetector(
              onTap: () => controller.updateSelectedLocation(results[index]),
              child: SizedBox(
                height: 40,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    results[index].label,
                    style: selectedLocationResultTextStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
