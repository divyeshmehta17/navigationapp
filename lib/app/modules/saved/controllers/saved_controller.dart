import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as google_maps_places;
import 'package:mopedsafe/app/models/saveroutes.dart';
import 'package:mopedsafe/app/services/dio/api_service.dart';

import '../../../customwidgets/globalcontroller.dart';
import '../../../models/directioncarddata.dart';
import '../../../models/getsavedroutes.dart';
import '../../../models/polylinestrack.dart';
import '../../../routes/app_pages.dart';
import '../../../services/storage.dart';
import '../../directioncard/controllers/directioncard_controller.dart';

class SavedController extends GetxController {
  Rxn<SaveRoutes> savedRoutes = Rxn();
  Rxn<GetSavedRoutes> getsavedRoutes = Rxn();
  Rxn<GetRoutes> getroutes = Rxn();
  google_maps_places.PlaceDetails? placeDetails;
  final GlobalController globalController = Get.find();
  @override
  void onInit() {
    fetchSavedRoutes();
  }

  void deleteSavedRoute(String routeId) async {
    try {
      final response = await APIManager.deleteRoute(routeId: routeId);
      if (response.statusCode == 200) {
        // Successfully deleted route
        fetchSavedRoutes();
        print("Route deleted successfully");
      } else {
        // Handle failure
        print("Failed to delete route");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> postSaveRoute(
      String points,
      String type,
      int time,
      String startName,
      String endName,
      double distance,
      List<GetRoutesDataInstructions> instructions) async {
    APIManager.postSaveRoutes(
            points: points,
            time: time,
            distance: distance,
            type: type,
            instructions: instructions,
            startName: startName,
            endName: endName)
        .then((value) {
      savedRoutes.value = SaveRoutes.fromJson(value.data);
      print('saved time ${savedRoutes.value!.data!.distance}');
    });
  }

  Future<void> fetchSavedRoutes() async {
    await APIManager.getFetchSavedRoutes(type: 'SAVED').then((response) {
      getsavedRoutes.value = GetSavedRoutes.fromJson(response.data);
      print('saved time ${getsavedRoutes.value!.data!.results![0]!.distance}');
    });
  }

  Future<void> getPolylines(int index) async {
    await APIManager.postGetRoutes(
            sourcelatitude: globalController.currentLatitude.toString(),
            sourcelongitude: globalController.currentLongitude.toString(),
            destinationlatitude:
                globalController.destinationLatitude.toString(),
            destinationlongitude:
                globalController.destinationLongitude.toString())
        .then((response) {
      getroutes.value = GetRoutes.fromJson(response.data);
      print(getroutes.value!.data!.points);
      if (getroutes.value != null) {
        // Find the first non-empty streetName
        String firstNonEmptyStreetName = getroutes.value!.data!.instructions!
                .firstWhere(
                  (instruction) => instruction?.streetName!.isNotEmpty ?? false,
                )
                ?.streetName ??
            'Unknown Street';

        // Convert GetRoutes data into DirectioncardData
        final routeData = DirectioncardData(
            points: getsavedRoutes.value!.data!.results![index]!.points!,
            name: firstNonEmptyStreetName,
            rating: 3.0,
            status: 'test',
            closingTime: 'test',
            location: 'test',
            imageUrls: [],
            placeID: placeDetails?.placeId ?? '',
            distance: getsavedRoutes.value!.data!.results![index]!.distance!
                .toDouble());

        // Save the route data for use in the Directioncard screen
        globalController.directionCardData.value = routeData;

        // Navigate to the Directioncard screen
        if (Get.isRegistered<DirectioncardController>()) {
          Get.delete<DirectioncardController>();
        }
        Get.toNamed(
          Routes.DIRECTIONCARD,
        );
      } else {
        print('Error: No routes data found.');
      }
    });
  }

  final polylineCoordinates = RxList<LatLng>();
  final startPoint = Rxn<LatLng>();
  final endPoint = Rxn<LatLng>();
  Future<void> decodePolyline() async {
    final points = PolylinePoints().decodePolyline(
        getsavedRoutes.value!.data!.results![0]!.points.toString());

    polylineCoordinates.value =
        points.map((point) => LatLng(point.latitude, point.longitude)).toList();
    if (polylineCoordinates.isNotEmpty) {
      startPoint.value = polylineCoordinates.first;
      endPoint.value = polylineCoordinates.last;

      print(
          'Start Point: ${startPoint.value!.latitude}, ${startPoint.value!.longitude}');
      print(
          'End Point: ${endPoint.value!.latitude}, ${endPoint.value!.longitude}');
    }
  }

  Future<void> fetchPlaceDetails(String placeId, int index) async {
    final google_maps_places.GoogleMapsPlaces _places =
        google_maps_places.GoogleMapsPlaces(
            apiKey: Get.find<GetStorageService>().googleApiKey);

    final details = await _places.getDetailsByPlaceId(placeId);
    if (details.result.geometry != null) {
      placeDetails = details.result; // Store details globally
      globalController.destinationLatitude.value =
          placeDetails!.geometry!.location.lat;
      globalController.destinationLongitude.value =
          placeDetails!.geometry!.location.lng;
      getPolylines(index);
    }
  }
}
