import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationController extends GetxController {
  var myLocationEnabled = false.obs;
  final Location _location = Location();

  @override
  void onInit() {
    super.onInit();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    var permissionStatus = await _location.hasPermission();
    if (permissionStatus == PermissionStatus.granted) {
      myLocationEnabled.value = true;
    } else if (permissionStatus == PermissionStatus.denied) {
      await _location.requestPermission();
      var newStatus = await _location.hasPermission();
      myLocationEnabled.value = newStatus == PermissionStatus.granted;
    }
  }
}

class GoogleMapWidget extends StatelessWidget {
  final double latitude;
  final double longitude;
  final Set<Polyline> polylines;
  final Set<Marker> markers;
  final Function(GoogleMapController) onMapCreated;

  const GoogleMapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.polylines,
    required this.markers,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    final LocationController locationController =
        Get.find<LocationController>();

    return Obx(() {
      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 14.0,
        ),
        compassEnabled: true,
        myLocationEnabled: locationController.myLocationEnabled.value,
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController mapController) {
          onMapCreated(mapController);
        },
        polylines: polylines,
        markers: markers,
      );
    });
  }
}
