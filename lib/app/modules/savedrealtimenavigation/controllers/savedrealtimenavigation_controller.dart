import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SavedrealtimenavigationController extends GetxController {
  RxList<LatLng> polylinecoordinates = <LatLng>[].obs;
  RxList<LatLng> updatedPolylineCoordinates = <LatLng>[].obs;
  final PanelController panelController = PanelController();

  StreamSubscription<Position>? positionStreamSubscription;
  LatLng currentPosition = const LatLng(0, 0); // Initial current position
  LatLng startPoint = const LatLng(0, 0); // For storing the start point
  RxDouble userSpeed = 0.0.obs;
  RxString maneuverText = ''.obs;
  final getSavedRoutes = Get.arguments['getSavedRoutes'];

  // Marker for user start point icon
  Rx<Marker> userStartMarker = Marker(
    markerId: MarkerId('userStart'),
    position: const LatLng(0, 0), // Default position, will update later
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
  ).obs;

  @override
  void onInit() {
    super.onInit();

    // Initialize the polyline coordinates and the start point
    polylinecoordinates.value = Get.arguments['polylines'] as List<LatLng>;
    updatedPolylineCoordinates.value = polylinecoordinates;
    startPoint = polylinecoordinates.first;

    // Set the user icon marker at the start point
    userStartMarker.value = Marker(
      markerId: MarkerId('userStart'),
      position: startPoint,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );

    startTrackingPosition(); // Start tracking
  }

  @override
  void onClose() {
    positionStreamSubscription?.cancel();
    super.onClose();
  }

  // Function to calculate distance between two points
  double calculateDistance(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
        start.latitude, start.longitude, end.latitude, end.longitude);
  }

  // Position tracking (for future updates)
  void startTrackingPosition() {
    positionStreamSubscription = Geolocator.getPositionStream()
        .debounceTime(Duration(milliseconds: 500))
        .listen((Position position) {
      LatLng newPosition = LatLng(position.latitude, position.longitude);
      currentPosition = newPosition;
      userSpeed.value = position.speed * 3.6; // speed in km/h

      // Check proximity to the next point in the polyline and update the route
      if (updatedPolylineCoordinates.isNotEmpty) {
        double distanceToNextPoint = calculateDistance(
            currentPosition, updatedPolylineCoordinates.first);

        // If the user is within 10 meters of the next point, remove it from the polyline
        if (distanceToNextPoint < 10) {
          updatedPolylineCoordinates.removeAt(0);
          updateManeuverText(); // Update maneuver text
        }
      }
    });
  }

  void updateManeuverText() {
    if (updatedPolylineCoordinates.length > 1) {
      LatLng nextPoint = updatedPolylineCoordinates[0];
      LatLng afterNextPoint = updatedPolylineCoordinates[1];

      if (nextPoint.latitude < afterNextPoint.latitude) {
        maneuverText.value = 'Head North';
      } else if (nextPoint.latitude > afterNextPoint.latitude) {
        maneuverText.value = 'Head South';
      } else if (nextPoint.longitude < afterNextPoint.longitude) {
        maneuverText.value = 'Turn Right';
      } else {
        maneuverText.value = 'Turn Left';
      }
    } else {
      maneuverText.value = 'Destination Reached';
    }
  }
}
