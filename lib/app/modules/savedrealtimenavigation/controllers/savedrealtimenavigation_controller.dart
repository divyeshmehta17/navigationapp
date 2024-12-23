import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../models/offlineroutes.dart';

class SavedrealtimenavigationController extends GetxController {
  RxList<LatLng> polylineCoordinates = <LatLng>[].obs;
  StreamSubscription<Position>? positionStreamSubscription;
  LatLng currentPosition = const LatLng(0, 0);
  RxString maneuverText = ''.obs; // Maneuver instruction to display
  RxString directionText = ''.obs; // Maneuver instruction to display
  RxString directionTurnText = ''.obs;
  final PanelController panelController = PanelController();
  RxDouble userSpeed = 0.0.obs; // Current user speed
  late OfflineRoutesData getSavedRoutes;

  @override
  void onInit() {
    super.onInit();

    // Retrieve saved routes from arguments
    getSavedRoutes = Get.arguments['getSavedRoutes'];

    // Initialize polyline coordinates
    polylineCoordinates.value = Get.arguments['polylines'] as List<LatLng>;

    // Start listening to position updates
    positionStreamSubscription =
        Geolocator.getPositionStream().listen(_onPositionUpdate);
    positionStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      _onPositionUpdate(position);
      userSpeed.value = position.speed * 3.6; // Convert m/s to km/h
    });
  }

  void _onPositionUpdate(Position position) {
    currentPosition = LatLng(position.latitude, position.longitude);

    // Find the nearest step to the user's position
    _updateManeuverInstruction();
  }

  void _updateManeuverInstruction() {
    if (getSavedRoutes.data?.results != null) {
      for (var result in getSavedRoutes.data!.results!) {
        for (var instruction in result!.instructions!) {
          for (var leg in instruction!.legs!) {
            for (var step in leg!.steps!) {
              // Calculate distance between the user's position and step start
              final distanceToStepStart = Geolocator.distanceBetween(
                currentPosition.latitude,
                currentPosition.longitude,
                step!.startLocation!.lat!,
                step!.startLocation!.lng!,
              );

              // If user is within 50 meters of the step, update instructions
              if (distanceToStepStart < 50) {
                maneuverText.value =
                    step.htmlInstructions ?? "Proceed to the route";
                directionText.value = step.maneuver ?? 'Go straight';

                // Calculate distance to the step's end location
                final distanceToStepEnd = Geolocator.distanceBetween(
                  currentPosition.latitude,
                  currentPosition.longitude,
                  step.endLocation!.lat!,
                  step.endLocation!.lng!,
                );

                directionTurnText.value =
                    '${distanceToStepEnd.toStringAsFixed(1)} m';

                return;
              }
            }
          }
        }
      }
    }
  }

  IconData getManeuverIcon(String maneuver) {
    switch (maneuver.toLowerCase()) {
      case 'turn left':
        return Icons.turn_left;
      case 'turn right':
        return Icons.turn_right;
      case 'go straight':
        return Icons.straight;
      case 'merge':
        return Icons.merge_type;
      case 'keep left':
        return Icons.arrow_left;
      case 'keep right':
        return Icons.arrow_right;
      case 'roundabout':
        return Icons.roundabout_left; // Requires a custom icon if unavailable
      case 'uturn':
        return Icons.u_turn_left; // Requires a custom icon if unavailable
      default:
        return Icons.straight; // Default icon
    }
  }

  @override
  void onClose() {
    positionStreamSubscription?.cancel();
    super.onClose();
  }
}
