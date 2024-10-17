import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as google_maps_places;
import 'package:mopedsafe/app/models/saveroutes.dart';
import 'package:mopedsafe/app/services/dio/api_service.dart';

import '../../../customwidgets/globalcontroller.dart';
import '../../../models/getsavedroutes.dart';
import '../../../models/polylinestrack.dart';
import '../../../routes/app_pages.dart';
import '../../../services/storage.dart';

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
      print('saved time ${savedRoutes.value!.data!.time}');
    });
  }

  Future<void> fetchSavedRoutes() async {
    await APIManager.getFetchSavedRoutes(type: 'SAVED').then((response) {
      getsavedRoutes.value = GetSavedRoutes.fromJson(response.data);
    });
  }

  Future<void> getPolylines({
    required String sourcelatitude,
    required String sourcelongitude,
    required String destinationlatitude,
    required String destinationlongitude,
    required String placeId,
  }) async {
    await APIManager.postGetRoutes(
            sourcelatitude: sourcelatitude,
            sourcelongitude: sourcelongitude,
            destinationlatitude: destinationlatitude,
            destinationlongitude: destinationlongitude)
        .then((value) {
      //getDirections();
      Get.toNamed(Routes.DIRECTIONCARD, arguments: {
        'getroutes': getroutes.value,
        'placeID': placeId,
      });
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

  Future<void> fetchPlaceDetails(String placeId) async {
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
    }
  }
}
