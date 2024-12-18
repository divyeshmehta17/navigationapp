import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../models/directioncarddata.dart';
import '../models/polylinestrack.dart';

class GlobalController extends GetxController {
  var currentLatitude = 0.0.obs;
  var currentLongitude = 0.0.obs;
  var destinationLatitude = 0.0.obs;
  var destinationLongitude = 0.0.obs;

  Location location = Location();
  GoogleMapController? mapController;
  Rx<GetRoutes?> routes = Rx<GetRoutes?>(null);
  Timer? locationServiceChecker;
  Rxn<DirectioncardData> directionCardData = Rxn<DirectioncardData>();

  @override
  void onInit() async {
    super.onInit();
    await _checkLocationPermission();

    // Check if location service is enabled initially
    _startLocationServiceChecker();
    print('dddddddddddddddddddddddddddddddd');
    // Listen for location changes
    location.onLocationChanged.listen((locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        currentLatitude.value = locationData.latitude!;
        currentLongitude.value = locationData.longitude!;
        if (mapController != null) {
          goToCurrentLocation(mapController!);
        }
      }
    });
  }

  @override
  void onClose() {
    // Cancel the timer when the controller is closed
    locationServiceChecker?.cancel();
    super.onClose();
  }

  void setRoutes(GetRoutes? newRoutes) {
    routes.value = newRoutes;
  }

  void _startLocationServiceChecker() {
    locationServiceChecker =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      bool isServiceEnabled = await location.serviceEnabled();
      if (isServiceEnabled) {
        final locationData = await location.getLocation();
        currentLatitude.value = locationData.latitude!;
        currentLongitude.value = locationData.longitude!;
        if (mapController != null) {
          goToCurrentLocation(mapController!);
        }
        timer
            .cancel(); // Stop checking once the service is enabled and location is retrieved
      }
    });
  }

  Future<void> _checkLocationPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<void> goToCurrentLocation(GoogleMapController controller) async {
    final currentLatLng = LatLng(currentLatitude.value, currentLongitude.value);
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: currentLatLng, zoom: 17.0, tilt: 30),
      ),
    );
  }

  void setMapController(GoogleMapController controller) {
    mapController = controller;
    goToCurrentLocation(mapController!);
  }
}
