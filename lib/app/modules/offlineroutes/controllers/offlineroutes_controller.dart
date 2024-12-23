import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as google_maps_places;

import '../../../customwidgets/globalcontroller.dart';
import '../../../models/offlineroutes.dart';
import '../../../models/polylinestrack.dart';
import '../../../routes/app_pages.dart';
import '../../../services/dio/api_service.dart';
import '../../../services/storage.dart';

class OfflineroutesController extends GetxController {
  Rxn<OfflineRoutesData> getsavedOfflineRoutes = Rxn();
  google_maps_places.PlaceDetails? placeDetails;
  final GlobalController globalController = Get.find();
  Rxn<GetRoutes> getroutes = Rxn();
  final polylines = RxSet<Polyline>();
  final polylineCoordinates = RxList<LatLng>();
  final startPoint = Rxn<LatLng>();
  final endPoint = Rxn<LatLng>();
  final markers = RxSet<Marker>();
  BitmapDescriptor? userLocationIcon;

  @override
  void onInit() {
    loadOfflineRoutes();
  }

  Future<void> fetchSavedRoutes() async {
    APIManager.getFetchSavedRoutes(type: 'OFFLINE').then((response) {
      final fetchedRoutes = OfflineRoutesData.fromJson(response.data);
      getsavedOfflineRoutes.value = fetchedRoutes;
      print("Saved routes offline: ${fetchedRoutes}");
      // Save fetched routes locally
      //   _saveRoutesOffline(fetchedRoutes);
    });
  }

  void loadOfflineRoutes() {
    final routesJson = GetStorageService.appstorage.read('offlineRoutes');
    if (routesJson != null) {
      getsavedOfflineRoutes.value =
          OfflineRoutesData.fromJson(jsonDecode(routesJson));
      print('Loaded offline routes: ${getsavedOfflineRoutes.value}');
    }
  }

  void decodePolyline(String encodedString) {
    // clearPlaceDetails();

    //placeID = globalController.directionCardData.value!.placeID;
    print(encodedString);
    final points = PolylinePoints().decodePolyline(encodedString);
    polylineCoordinates.value =
        points.map((point) => LatLng(point.latitude, point.longitude)).toList();

    if (polylineCoordinates.isNotEmpty) {
      startPoint.value = polylineCoordinates.first;
      endPoint.value = polylineCoordinates.last;
      updateMap();
    }
  }

  Future<void> updateMap() async {
    polylines.clear();
    polylines.add(Polyline(
      polylineId: const PolylineId('navigation_polyline'),
      points: polylineCoordinates,
      color: Colors.blue,
      width: 5,
    ));

    markers.clear();
    if (startPoint.value != null) {
      markers.add(Marker(
        markerId: const MarkerId('start'),
        position: startPoint.value!,
        infoWindow: const InfoWindow(title: 'Start Point'),
        icon: userLocationIcon ?? BitmapDescriptor.defaultMarker,
      ));
    }

    if (endPoint.value != null) {
      markers.add(Marker(
        markerId: const MarkerId('end'),
        position: endPoint.value!,
        infoWindow: const InfoWindow(title: 'End Point'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    }
    Get.toNamed(Routes.SAVEDREALTIMENAVIGATION, arguments: {
      'getSavedRoutes': getsavedOfflineRoutes.value,
      'polylines': polylineCoordinates
    });
  }
  // Future<void> fetchPlaceDetails(String placeId, int index) async {
  //   final google_maps_places.GoogleMapsPlaces _places =
  //       google_maps_places.GoogleMapsPlaces(
  //           apiKey: Get.find<GetStorageService>().googleApiKey);
  //
  //   final details = await _places.getDetailsByPlaceId(placeId);
  //   if (details.result.geometry != null) {
  //     placeDetails = details.result; // Store details globally
  //     globalController.destinationLatitude.value =
  //         placeDetails!.geometry!.location.lat;
  //     globalController.destinationLongitude.value =
  //         placeDetails!.geometry!.location.lng;
  //     getPolylines(index);
  //   }
  // }
  //
  // Future<void> getPolylines(int index) async {
  //   await APIManager.postGetRoutes(
  //           sourcelatitude: globalController.currentLatitude.toString(),
  //           sourcelongitude: globalController.currentLongitude.toString(),
  //           destinationlatitude:
  //               globalController.destinationLatitude.toString(),
  //           destinationlongitude:
  //               globalController.destinationLongitude.toString())
  //       .then((response) {
  //     getroutes.value = GetRoutes.fromJson(response.data);
  //     print(getroutes.value!.data!.points);
  //     if (getroutes.value != null) {
  //       // Find the first non-empty streetName
  //       String firstNonEmptyStreetName = getroutes.value!.data!.instructions!
  //               .firstWhere(
  //                 (instruction) => instruction?.streetName!.isNotEmpty ?? false,
  //               )
  //               ?.streetName ??
  //           'Unknown Street';
  //
  //       // Convert GetRoutes data into DirectioncardData
  //       final routeData = DirectioncardData(
  //           points: getsavedRoutes.value!.data!.results![index]!.points!,
  //           name: firstNonEmptyStreetName,
  //           rating: 3.0,
  //           status: 'test',
  //           closingTime: 'test',
  //           location: 'test',
  //           imageUrls: [],
  //           placeID: placeDetails?.placeId ?? '',
  //           distance: getsavedRoutes.value!.data!.results![index]!.distance!
  //               .toDouble());
  //
  //       // Save the route data for use in the Directioncard screen
  //       globalController.directionCardData.value = routeData;
  //
  //       // Navigate to the Directioncard screen
  //       if (Get.isRegistered<DirectioncardController>()) {
  //         Get.delete<DirectioncardController>();
  //       }
  //       Get.toNamed(
  //         Routes.DIRECTIONCARD,
  //       );
  //     } else {
  //       print('Error: No routes data found.');
  //     }
  //   });
  // }
}
