import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/src/google_maps_place_picker_controller.dart';
import 'package:google_maps_place_picker/src/google_maps_place_picker_location.dart';
import 'package:google_maps_place_picker/src/widgets/google_maps_place_picker_fab.dart';
import 'package:google_maps_place_picker/src/widgets/google_maps_place_picker_results.dart';
import 'package:google_maps_place_picker/src/widgets/google_maps_place_picker_search_field.dart';

const Duration _defaultTransitionDuration = Duration(milliseconds: 150);

/// widget for rendering the UI
class GoogleMapsPlacePicker extends StatefulWidget {
  /// api key for places api
  final String apiKey;

  /// the initial camera position to start with
  final CameraPosition initialCameraPosition;

  /// callback on back button pressed
  final Function onBackPressed;

  /// callback on complete button pressed
  final Function(GoogleMapsPlacePickerLocation) onCompletePressed;

  /// the controller

  // * config --------------------------------------------------

  /// the color of the search container
  final Color searchContainerColor;

  /// the opacity of the search container
  final double searchContainerOpacity;

  /// the amount of blur
  final double searchContainerImageFilterBlur;

  /// the animation duration for the search container's resizing
  final Duration? searchContainerAnimationDuration;

  /// the default height for the search container
  final double searchContainerDefaultHeight;

  /// the extra height for each item in the search container
  final double searchContainerExtraHeight;

  /// the padding for the content inside the container
  final EdgeInsets searchContainerContentPadding;

  /// the little header to render above the actual selected location
  final String selectedLocationSubtitle;

  /// text style for [selectedLocationSubtitle]
  final TextStyle? selectedLocationSubtitleTextStyle;

  /// text style for the text style
  final TextStyle? selectedLocationTitleTextStyle;

  /// text style for the text style
  final TextStyle? selectedLocationResultTextStyle;

  /// color for the text style
  final Color? selectedLocationTitleCursorColor;

  /// widget will be wrapped in a [BounceAnimator] with [onBackPressed]
  final Widget? closePickerButton;

  /// widget will be wrapped in a [BounceAnimator] with [onCompletePressed]
  final Widget? onCompletePickerButton;

  const GoogleMapsPlacePicker({
    super.key,
    required this.apiKey,
    required this.initialCameraPosition,
    required this.onBackPressed,
    required this.onCompletePressed,
    this.searchContainerColor = Colors.orange,
    this.searchContainerOpacity = 0.5,
    this.searchContainerImageFilterBlur = 15,
    this.searchContainerAnimationDuration,
    this.searchContainerDefaultHeight = 100,
    this.searchContainerExtraHeight = 55,
    this.searchContainerContentPadding = EdgeInsets.zero,
    this.selectedLocationSubtitle = 'Selected Location',
    this.selectedLocationSubtitleTextStyle,
    this.selectedLocationTitleTextStyle,
    this.selectedLocationResultTextStyle,
    this.selectedLocationTitleCursorColor,
    this.closePickerButton,
    this.onCompletePickerButton,
  });

  @override
  State<GoogleMapsPlacePicker> createState() => _GoogleMapsPlacePickerState();
}

class _GoogleMapsPlacePickerState extends State<GoogleMapsPlacePicker> {
  final GoogleMapsPlacePickerController controller =
      GoogleMapsPlacePickerController();

  @override
  void initState() {
    controller.rebuildGoogleMapsPlacePickerWidget = () => setState(() {});

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = widget.searchContainerDefaultHeight;
    List<GoogleMapsPlacePickerLocation> results =
        controller.searchResults[controller.currentSearch] ?? [];

    // custom heights
    switch (results.length) {
      case 0: // don't add
        break;
      case 1: // add 1
        height += widget.searchContainerExtraHeight;
        break;
      case 2: // add 2
        height += widget.searchContainerExtraHeight * 2;
        break;
      default: // add enough for 3
        height += widget.searchContainerExtraHeight * 3;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: GoogleMapsPlacePickerFab(
        controller: controller,
        onBackPressed: widget.onBackPressed,
        onCompletePressed: widget.onCompletePressed,
        closePickerButton: widget.closePickerButton,
        onCompletePickerButton: widget.onCompletePickerButton,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: (GoogleMapController googleMapController) =>
                  controller.googleMapController = googleMapController,
              mapType: MapType.normal,
              initialCameraPosition: widget.initialCameraPosition,
              zoomControlsEnabled: false,
              markers: controller.selectedLocationMarker,
              onTap: controller.onMapTapped,
            ),
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: widget.searchContainerImageFilterBlur,
                  sigmaY: widget.searchContainerImageFilterBlur,
                ),
                child: AnimatedContainer(
                  duration: widget.searchContainerAnimationDuration ??
                      _defaultTransitionDuration,
                  height: height,
                  width: double.infinity,
                  child: Card(
                    color: widget.searchContainerColor.withOpacity(
                      widget.searchContainerOpacity,
                    ),
                    margin: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    elevation: 15,
                    child: Padding(
                      padding: widget.searchContainerContentPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              widget.selectedLocationSubtitle,
                              style: widget.selectedLocationSubtitleTextStyle,
                            ),
                          ),
                          GoogleMapsPlacePickerSearchField(
                            controller: controller,
                            apiKey: widget.apiKey,
                            selectedLocationTitleTextStyle:
                                widget.selectedLocationTitleTextStyle,
                            selectedLocationTitleCursorColor:
                                widget.selectedLocationTitleCursorColor,
                          ),
                          GoogleMapsPlacePickerResults(
                            controller: controller,
                            results: results,
                            selectedLocationResultTextStyle:
                                widget.selectedLocationResultTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
