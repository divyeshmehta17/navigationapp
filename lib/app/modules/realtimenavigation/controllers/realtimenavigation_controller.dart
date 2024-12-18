import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mopedsafe/app/services/dio/api_service.dart';
import 'package:mopedsafe/app/services/storage.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:share_plus/share_plus.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../customwidgets/globalcontroller.dart';
import '../../../models/googledirectionapiresponse.dart';

class RealtimenavigationController extends GetxController {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  StreamSubscription<CompassEvent>? compassStreamSubscription;
  StreamSubscription<Position>? positionStreamSubscription;
  Timer? locationUpdateTimer; // Timer to trigger location updates every minute
  RxString maneuverText = 'Head Straight'.obs;
  RxList<LatLng> polylineCoordinates = RxList<LatLng>();
  RxList<LatLng> passedSegments = RxList<LatLng>(); // Track passed segments
  Rx<LatLng?> sharedUserLocation = Rx<LatLng?>(null);
  RxString? sessionId;
  Rxn<GoogleDIrectionApiResponseRoutesLegsSteps> currentStep = Rxn();
  RxDouble totalDistance = 0.0.obs; // Total distance in kilometers
  RxDouble userSpeed = 0.0.obs;

  late List<LatLng> cachedReducedWaypoints;
  final TextEditingController currentLocationcontroller =
      TextEditingController();
  final TextEditingController destinationLocationcontroller =
      TextEditingController();
  RxList<LatLng> navigationPolylineCoordinates = RxList<LatLng>();
  Rx<LatLng?> startPoint = Rx<LatLng?>(null);
  Rx<LatLng?> endPoint = Rx<LatLng?>(null);
  final GlobalController globalController = Get.find();
  Rxn<GoogleDIrectionApiResponse> googledirectionApiResponse = Rxn();
  Rxn<GoogleDIrectionApiResponseRoutesLegsDistance> googledirectionLegDistance =
      Rxn();
  Rxn<GoogleDIrectionApiResponseRoutesLegsSteps> googleManuvers = Rxn();
  final PanelController panelController = PanelController();
  GoogleMapController? mapController;
  dynamic getroutes;
  // final GetRoutes getroutes = Get.arguments['getroutes'];
  RxString waypointsStr = ''.obs;
  RxDouble currentHeading = 0.0.obs;
  RxDouble totalDurationInSeconds = 0.0.obs;
  RxDouble totalduration = 0.0.obs;
  Rx<DateTime> estimatedTime =
      Rx<DateTime>(DateTime.now()); // or any specific DateTime

  LatLng currentPosition = const LatLng(0, 0);
  RxString currentPlaceName = ''.obs;

  RxList<String> placeImages = [''].obs;
  final RxSet<Polyline> polylines = RxSet();
  final RxSet<Marker> markers = RxSet();
  var showLocationOptions = false.obs;

  BitmapDescriptor? userLocationIcon;

  RxDouble currentZoom = 18.5.obs; // Default zoom level
  //RxDouble currentHeading = 0.0.obs; // Default heading
  RxDouble tilt = 90.0.obs; // Default tilt
  @override
  void onInit() {
    super.onInit();
    final previousRoute = Get.previousRoute;
    print('Previous Route: $previousRoute');

    if (Get.arguments['sessionId'] != null) {
      sessionId = Get.arguments['sessionId'];
    } else {
      sessionId = RxString(DateTime.now().millisecondsSinceEpoch.toString());
    }

    decodePolyline();
    totalduration.listen((duration) {
      estimatedTime.value =
          DateTime.now().add(Duration(minutes: duration.toInt()));
    });
    polylines.value = Get.arguments['polylines'];
    updateMap();
    fetchCurrentLocationPlaceName();
    startCompassListener();
    startTrackingPosition();
    //  _loadCustomChevronIcon();
  }

  final Duration debounceDurationNavigation = const Duration(milliseconds: 500);

  void startPeriodicLocationUpdates() {
    if (sessionId != null) {
      locationUpdateTimer =
          Timer.periodic(const Duration(seconds: 5), (timer) async {
        await _updateLocation();
      });
    }
  }

  void stopPeriodicLocationUpdates() {
    locationUpdateTimer?.cancel();
    locationUpdateTimer = null;
  }

  String formatEstimatedTime(DateTime dateTime) {
    String twoDigits(int n) => n >= 10 ? "$n" : "0$n";
    int hour = dateTime.hour % 12; // Convert to 12-hour format
    hour = hour == 0 ? 12 : hour; // Handle midnight and noon
    String minute = twoDigits(dateTime.minute);
    String period = dateTime.hour >= 12 ? "PM" : "AM"; // Determine AM/PM
    return "$hour:$minute $period";
  }

  // void _loadCustomChevronIcon() async {
  //   userLocationIcon =
  //       await _getBitmapDescriptorFromAsset(ImageConstant.pngnavigation);
  //   updateMap(); // Update the map with the new marker once loaded
  // }

  // void startTrackingPosition() {
  //   positionStreamSubscription =
  //       Geolocator.getPositionStream().listen((Position position) {
  //     currentPosition = LatLng(position.latitude, position.longitude);
  //     currentHeading.value = position.heading;
  //     _updateCamera(); // Automatically update the camera with real-time heading
  //   });
  // }
  void startTrackingPosition() {
    positionStreamSubscription = Geolocator.getPositionStream()
        .debounceTime(debounceDurationNavigation)
        .listen((Position position) {
      currentPosition = LatLng(position.latitude, position.longitude);
      //  _animateChevronMovement(newPosition);
      _smoothCameraTransition(LatLng(position.latitude, position.longitude));
      currentHeading.value = position.heading;
      _updateCamera();
      filterPolylineCoordinates();
      updateCurrentStep(); // Check for maneuvers after updating the position

      // Update the user's speed (in km/h)
      userSpeed.value = position.speed * 3.6; // speed in km/h
      print('userspeed $userSpeed');
    });
  }

  void filterPolylineCoordinates() {
    if (polylineCoordinates.isEmpty) {
      print('objectttttttttt');
    }
    ;

    // Find the closest point to the user's current position
    int closestIndex = -1;
    double minDistance = double.infinity;

    for (int i = 0; i < polylineCoordinates.length; i++) {
      double distance = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
      );
      if (distance < minDistance) {
        minDistance = distance;
        closestIndex = i;
      }
    }

    // If a close point is found, remove all points before it
    if (closestIndex != -1) {
      polylineCoordinates.removeRange(0, closestIndex);
      updatePolyline(); // Update the polyline on the map
    }
  }

  void updatePolyline() {
    polylines.clear();
    polylines.add(Polyline(
      polylineId: const PolylineId('navigation'),
      points: polylineCoordinates.toList(),
      color: Colors.blue, // Adjust color as needed
      width: 5, // Adjust width as needed
    ));
  }

  void _updateCamera() {
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentPosition,
            zoom: currentZoom.value,
            tilt: tilt.value,
            bearing: currentHeading.value,
          ),
        ),
      );
    }
  }

  // Future<BitmapDescriptor> _getBitmapDescriptorFromAsset(
  //     String assetPath) async {
  //   final Completer<BitmapDescriptor> bitmapDescriptor = Completer();
  //   const ImageConfiguration config = ImageConfiguration(devicePixelRatio: 2.5);
  //   BitmapDescriptor.asset(config, assetPath).then((icon) {
  //     bitmapDescriptor.complete(icon);
  //   });
  //   return bitmapDescriptor.future;
  // }

// This function ensures the camera moves smoothly over time
  void _smoothCameraTransition(LatLng newPosition) {
    if (mapController == null) return;

    CameraPosition newCameraPosition = CameraPosition(
      target: newPosition,
      zoom: 17.0, // Adjust based on your needs
      tilt: 90.0, // Optional: tilt for better perspective
      bearing: currentHeading.value - 180, // Rotate based on the heading
    );

    // Use animateCamera for smoother movement
    mapController!.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPosition),
    );
  }

  // Future<void> _animateChevronMovement(LatLng newPosition) async {
  //   if (mapController == null) return;
  //
  //   LatLng currentLatLng = LatLng(
  //     globalController.currentLatitude.value,
  //     globalController.currentLongitude.value,
  //   );
  //
  //   // Smooth transition between the positions over 1 second
  //   int animationDuration = 1000; // Animation duration in milliseconds
  //   for (double t = 0; t <= 1.0; t += 0.05) {
  //     double lat = lerp(currentLatLng.latitude, newPosition.latitude, t);
  //     double lng = lerp(currentLatLng.longitude, newPosition.longitude, t);
  //     LatLng animatedPosition = LatLng(lat, lng);
  //
  //     // Move the camera with the user’s position smoothly
  //
  //     // Update the position every few milliseconds for smooth animation
  //     await Future.delayed(
  //         Duration(milliseconds: (animationDuration * 0.05).toInt()));
  //   }
  //
  //   // Finally, update the global controller's position to the new position
  //   globalController.currentLatitude.value = newPosition.latitude;
  //   globalController.currentLongitude.value = newPosition.longitude;
  //   _updateUserMarker(
  //       newPosition); // Update the user location marker on the map
  // }
  //
  // // A linear interpolation function for latitude/longitude
  // double lerp(double start, double end, double t) {
  //   return start + t * (end - start);
  // }

  Future<void> decodePolyline() async {
    List<PointLatLng> points = PolylinePoints()
        .decodePolyline(globalController.directionCardData.value!.points);
    polylineCoordinates.value =
        points.map((point) => LatLng(point.latitude, point.longitude)).toList();
    fetchAndDisplayDirections(polylineCoordinates);
    if (polylineCoordinates.isNotEmpty) {
      startPoint.value = polylineCoordinates.first;
      endPoint.value = polylineCoordinates.last;
    }
  }

  Future<void> fetchAndDisplayDirections(List<LatLng> waypoints) async {
    print('fetchAndDisplayDirections $waypoints');
    try {
      print('lllllllllllllllll');
      Map<String, dynamic> directions = await getDirections(waypoints);
      parseDirections(directions);

      // Reset total distance
      totalDurationInSeconds.value = 0.0; // Reset before recalculating duration
      if (googledirectionApiResponse.value?.routes != null) {
        for (var route in googledirectionApiResponse.value!.routes!) {
          for (var leg in route.legs!) {
            for (var step in leg!.steps!) {
              if (step?.duration != null && step?.duration?.value != null) {
                totalDurationInSeconds.value +=
                    step!.duration!.value!.toDouble();
              }
            }
          }
        }

        // Now format the total duration and print it
        String formattedDuration =
            formatTotalDuration(totalDurationInSeconds.value);
        print('Total Duration: $formattedDuration');
      }

      print('Corrected total distance: ${totalDistance.value} km');
    } catch (e) {
      print('Error fetching directions: $e');
    }
  }

  String formatTotalDuration(double totalSeconds) {
    int hours = (totalSeconds / 3600).floor(); // Convert total seconds to hours
    int minutes =
        ((totalSeconds % 3600) / 60).floor(); // Convert remainder to minutes
    int seconds = (totalSeconds % 60).floor(); // Remaining seconds

    return '${hours}h ${minutes}m '; // Format as 'Xh Xm Xs'
  }

  Future<Map<String, dynamic>> getDirections(List<LatLng> waypoints) async {
    List<LatLng> reducedWaypoints =
        reduceWaypoints(waypoints, maxWaypoints: 25);
    waypointsStr.value = formatWaypoints(reducedWaypoints);

    final response = await APIManager.getGoogleDirections(
      waypoints: waypoints,
      currentLatitude: globalController.currentLatitude.value,
      currentLongitude: globalController.currentLongitude.value,
      destinationLatitude: globalController.destinationLatitude.value,
      destinationLongitude: globalController.destinationLongitude.value,
      waypointsStr: waypointsStr.value,
      googleApiKey: Get.find<GetStorageService>().googleApiKey,
    );

    print('Response from API: ${response.data}'); // Log the entire response

    googledirectionApiResponse.value =
        GoogleDIrectionApiResponse.fromJson(response.data);

    // Safely sum up durations
    totalDistance.value = globalController.directionCardData.value!.distance!;
    if (googledirectionApiResponse.value?.routes != null) {
      for (var route in googledirectionApiResponse.value!.routes!) {
        for (var leg in route!.legs!) {
          for (var step in leg!.steps!) {
            totalDurationInSeconds.value += step!.duration!.value!.toDouble();
            totalduration.value = totalDurationInSeconds.value / 60;
          }
          print(
              'totalssss ${googledirectionApiResponse.value?.routes![0]!.legs![0]!.steps![0]!.htmlInstructions}');
        }
      }
    }

    return response.data;
  }

  Rx<IconData> maneuverIcon = Icons.straight.obs;
  IconData getManeuverIcon(String? maneuver) {
    switch (maneuver) {
      case 'turn-right':
        return Icons.arrow_forward; // Right arrow icon
      case 'turn-left':
        return Icons.arrow_back; // Left arrow icon
      case 'uturn-right':
        return Icons.u_turn_right_outlined;
      case 'uturn-left':
        return Icons.u_turn_left_rounded;
      case 'ramp-left':
        return Icons.ramp_left_rounded;
      case 'ramp-right':
        return Icons.ramp_right_rounded;

      default:
        return Icons.straight; // Default straight arrow
    }
  }

  String getManeuverText(String? maneuver) {
    switch (maneuver) {
      case 'turn-right':
        return "Take Right";
      case 'turn-left':
        return "Take Left";
      case 'uturn-right':
        return "U-Turn Right";
      case 'ramp-left':
        return "Ramp Left";
      case 'ramp-right':
        return "Ramp Right";
      case 'uturn-left':
        return "U-Turn Left";
      default:
        return "Head straight"; // Default text for straight maneuvers
    }
  }

  List<LatLng> reduceWaypoints(List<LatLng> waypoints,
      {int maxWaypoints = 25}) {
    int step = (waypoints.length / maxWaypoints).ceil();
    return List<LatLng>.generate(maxWaypoints, (i) => waypoints[i * step]);
  }

  String formatWaypoints(List<LatLng> waypoints) {
    return waypoints
        .map((point) => '${point.latitude},${point.longitude}')
        .join('|');
  }

  void parseDirections(Map<String, dynamic> directions) {
    googledirectionApiResponse.value =
        GoogleDIrectionApiResponse.fromJson(directions);
    if (googledirectionApiResponse.value != null) {
      googledirectionLegDistance.value = googledirectionApiResponse
          .value!.routes!.first!.legs!.first!.distance;
    }
  }

  void _updateUserMarker(LatLng position) {
    markers.removeWhere((m) => m.markerId == MarkerId('user_location'));
    markers.add(Marker(
      markerId: MarkerId('user_location'),
      position: position,
      icon: userLocationIcon ?? BitmapDescriptor.defaultMarker,
      rotation: currentHeading.value,
    ));
  }

  @override
  void onClose() {
    compassStreamSubscription?.cancel();
    positionStreamSubscription?.cancel();
    stopPeriodicLocationUpdates(); // Stop updates when the controller is closed

    if (sessionId != null) {
      DatabaseReference locationRef =
          _database.ref().child('shared_locations').child(sessionId!.value);
      locationRef.onDisconnect();
    }

    super.onClose();
  }

  Future<void> _updateLocation() async {
    if (sessionId == null) return;

    final DatabaseReference userRef =
        _database.ref('users/${sessionId!.value}/location');
    // Update the location in the database
    await userRef.set({
      'latitude': currentPosition.latitude,
      'longitude': currentPosition.longitude,
      'speed': userSpeed.value,
      'timestamp': ServerValue.timestamp,
    });
    sharedUserLocation.value =
        LatLng(currentPosition.latitude, currentPosition.longitude);
  }

  // void _updateLocationInDatabase(LatLng location, double speed) {
  //   if (sessionId != null) {
  //     DatabaseReference locationRef =
  //         _database.ref().child('shared_locations').child(sessionId!.value);
  //     locationRef.set({
  //       'latitude': location.latitude,
  //       'longitude': location.longitude,
  //       'userspeed': speed,
  //     }).then((_) {
  //       print('Location and speed updated successfully in Firebase.');
  //     }).catchError((error) {
  //       print('Failed to update Firebase: $error');
  //     });
  //   }
  // }

  List<GoogleDIrectionApiResponseRoutesLegsSteps> extractSteps(
      GoogleDIrectionApiResponse response) {
    List<GoogleDIrectionApiResponseRoutesLegsSteps> steps = [];
    if (response.routes != null) {
      for (var route in response.routes!) {
        if (route.legs != null) {
          for (var leg in route.legs!) {
            if (leg?.steps != null) {
              // Filter out null steps
              steps.addAll(leg!.steps!
                  .whereType<GoogleDIrectionApiResponseRoutesLegsSteps>());
            }
          }
        }
      }
    }
    print('steps ${steps[0].maneuver}');
    return steps;
  }

  void updateCurrentStep() {
    if (googledirectionApiResponse.value != null) {
      List<GoogleDIrectionApiResponseRoutesLegsSteps> steps =
          extractSteps(googledirectionApiResponse.value!);

      for (var step in steps) {
        // Calculate the distance to the maneuver's end location (where the turn happens)
        double distanceToManeuver = Geolocator.distanceBetween(
          currentPosition.latitude,
          currentPosition.longitude,
          step.endLocation!.lat!.toDouble(),
          step.endLocation!.lng!.toDouble(),
        );

        // Check if the user is approaching this maneuver (distance less than 200 meters)
        if (distanceToManeuver < 200) {
          // Update the current step with this step
          currentStep.value = step;

          // Display maneuver instructions along with the distance remaining
          displayManeuverInstructions(step, distanceToManeuver);
          break;
        }
      }
    }
  }

  void displayManeuverInstructions(
      GoogleDIrectionApiResponseRoutesLegsSteps step,
      double distanceToManeuver) {
    // Get the maneuver text, like "Take right" or "Take left"
    print('object ${step.maneuver}');
    String maneuverText = getManeuverText(step.maneuver);

    // Show remaining distance in meters
    String distanceText = "${distanceToManeuver.toStringAsFixed(0)} meters";

    // Update the observable with both the maneuver and distance
    this.maneuverText.value = "$maneuverText in $distanceText";

    // Get the appropriate icon for the maneuver
    IconData maneuverIcon = getManeuverIcon(step.maneuver);

    // Print for debug or use it in the UI
    print('Upcoming Maneuver: ${this.maneuverText.value}');
    print('Maneuver Icon: $maneuverIcon');
  }

  // Future<void> _updateLocation() async {
  //   Position position = await Geolocator.getCurrentPosition();
  //   LatLng currentLocation = LatLng(position.latitude, position.longitude);
  //   _updateLocationInDatabase(currentLocation);
  // }
  //
  // void _updateLocationInDatabase(LatLng location) {
  //   if (sessionId != null) {
  //     DatabaseReference locationRef =
  //         _database.ref().child('shared_locations').child(sessionId!.value);
  //     locationRef.set({
  //       'latitude': location.latitude,
  //       'longitude': location.longitude,
  //     });
  //   }
  // }

  void shareLocation() async {
    String shareableUrl = await generateShareableUrl(sessionId!.value);
    Share.share('Track my location: $shareableUrl').then((shareResult) {
      print(shareResult);
      locationUpdateTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
        await _updateLocation();
      });
      print('Location shared successfully');
    });
  }

  Future<String> generateShareableUrl(String sessionId) async {
    DatabaseReference locationRef =
        _database.ref().child('shared_locations').child(sessionId);
    LatLng userLocation = LatLng(globalController.currentLatitude.value,
        globalController.currentLongitude.value);
    await locationRef.set({
      'latitude': userLocation.latitude,
      'longitude': userLocation.longitude,
      'userspeed': userSpeed.value
    });
    return 'https://yourapp.com/location/$sessionId';
  }

  void startCompassListener() {
    compassStreamSubscription =
        FlutterCompass.events!.listen((CompassEvent compassEvent) {
      currentHeading.value = compassEvent.heading ?? 0.0;

      print('currentHeading $currentHeading');
    });
  }

  Future<void> fetchCurrentLocationPlaceName() async {
    double currentLatitude = globalController.currentLatitude.value;
    double currentLongitude = globalController.currentLongitude.value;

    List<Placemark> placemarks =
        await placemarkFromCoordinates(currentLatitude, currentLongitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      currentPlaceName.value =
          "${place.locality}, ${place.administrativeArea}, ${place.country}";
    }
  }

  void updateMap() {
    if (mapController != null) {
      mapController!.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(globalController.currentLatitude.value,
                globalController.currentLongitude.value),
            zoom: 14.0,
          ),
        ),
      );
    }
    updateCurrentStep();
  }
}
