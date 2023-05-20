import 'package:flutter/material.dart';
import 'package:bounce_animator/bounce_animator.dart';
import 'package:google_maps_place_picker/src/google_maps_place_picker_controller.dart';
import 'package:google_maps_place_picker/src/google_maps_place_picker_location.dart';

/// floating action button UI
class GoogleMapsPlacePickerFab extends StatelessWidget {
  final GoogleMapsPlacePickerController controller;
  final Function onBackPressed;
  final Function(GoogleMapsPlacePickerLocation) onCompletePressed;

  final Widget? closePickerButton;

  final Widget? onCompletePickerButton;

  const GoogleMapsPlacePickerFab({
    super.key,
    required this.controller,
    required this.onBackPressed,
    required this.onCompletePressed,
    required this.closePickerButton,
    required this.onCompletePickerButton,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BounceAnimator(
            onPressed: onBackPressed,
            child: closePickerButton ??
                const Icon(
                  Icons.close_rounded,
                  size: 50,
                ),
          ),
          controller.selectedLocation != null
              ? BounceAnimator(
                  onPressed: () =>
                      onCompletePressed(controller.selectedLocation!),
                  child: onCompletePickerButton ??
                      const Icon(
                        Icons.save_rounded,
                        size: 50,
                      ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
