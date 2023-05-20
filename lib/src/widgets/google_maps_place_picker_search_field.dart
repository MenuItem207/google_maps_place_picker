import 'package:flutter/material.dart';
import 'package:bounce_animator/bounce_animator.dart';
import 'package:google_maps_place_picker/src/google_maps_place_picker_controller.dart';

/// the search field
class GoogleMapsPlacePickerSearchField extends StatelessWidget {
  final GoogleMapsPlacePickerController controller;
  final String apiKey;
  final TextStyle? selectedLocationTitleTextStyle;
  final Color? selectedLocationTitleCursorColor;
  const GoogleMapsPlacePickerSearchField({
    super.key,
    required this.controller,
    required this.apiKey,
    required this.selectedLocationTitleTextStyle,
    required this.selectedLocationTitleCursorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            focusNode: controller.searchFocusNode,
            controller: controller.searchController,
            scrollPadding: EdgeInsets.zero,
            onChanged: (userInput) => controller.onCurrentSearchChanged(
              userInput,
              apiKey,
            ),
            decoration: InputDecoration(
              hintText: controller.selectedLocation == null
                  ? 'Search somewhere'
                  : controller.selectedLocation!.label,
              border: InputBorder.none,
              hintStyle: selectedLocationTitleTextStyle,
              contentPadding: const EdgeInsets.only(right: 10),
            ),
            maxLines: 1,
            style: selectedLocationTitleTextStyle,
            textAlign: TextAlign.left,
            cursorColor: selectedLocationTitleCursorColor,
            textCapitalization: TextCapitalization.sentences,
            onTapOutside: (event) => controller.searchFocusNode.unfocus(),
          ),
        ),
        BounceAnimator(
          onPressed: () => controller.searchFocusNode.requestFocus(),
          child: const Icon(
            Icons.search_rounded,
            size: 25,
          ),
        )
      ],
    );
  }
}
