import 'package:get/get.dart';
import 'package:google_maps_webservice/places.dart' as google_maps_places;
import 'package:mopedsafe/app/services/dio/api_service.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../components/SavedLocationData.dart';
import '../../../customwidgets/globalcontroller.dart';
import '../../../models/locationHistory.dart';
import '../../../models/polylinestrack.dart';
import '../../../routes/app_pages.dart';
import '../../../services/storage.dart';
import '../../directioncard/controllers/directioncard_controller.dart';

class ExploreController extends GetxController {
  var searchText = ''.obs;
  Rxn<SavedLocation> savedLocations = Rxn();
  var panelPosition = 0.0.obs;
  var showReportOptions = false.obs;
  Rxn<GetRoutes> getroutes = Rxn<GetRoutes>();
  final GlobalController globalController = Get.find();
  final panelController = PanelController();
  RxBool isDraggable = true.obs;

  google_maps_places.PlaceDetails? placeDetails;
  Rxn<SearchLocationHistory> searchLocations = Rxn();
  @override
  void onInit() {
    super.onInit();
    getSavedLocation();
    getHistoryLocation();
  }

  Future<void> getSavedLocation() async {
    APIManager.getSavedLocation(type: 'SAVED').then((response) {
      savedLocations.value = SavedLocation.fromJson(response.data);
      print(savedLocations.value!.data!.results![0]!.location!.coordinates![0]);
      print(savedLocations.value!.data!.results![0]!.location!.coordinates![1]);
    });
  }

  Future<void> getHistoryLocation() async {
    APIManager.getSavedLocation(type: 'HISTORY').then((response) {
      searchLocations.value = SearchLocationHistory.fromJson(response.data);
    });
  }

  Future<void> getPolylines(
      {required String destinationlatitude,
      required String destinationlongitude}) async {
    await APIManager.postGetRoutes(
            sourcelatitude: globalController.currentLatitude.toString(),
            sourcelongitude: globalController.currentLongitude.toString(),
            destinationlatitude: destinationlatitude,
            destinationlongitude: destinationlongitude)
        .then((value) {
      getroutes.value = GetRoutes.fromJson(value.data);
      print(getroutes.value!.data!.points);

      // Manually delete the DirectioncardController if it exists
      if (Get.isRegistered<DirectioncardController>()) {
        Get.delete<DirectioncardController>();
      }

      Get.toNamed(Routes.DIRECTIONCARD, arguments: {
        'recentRoutes': getroutes.value,
        'recentPlaceId': placeDetails!.placeId,
      });
    });
  }

  Future<void> fetchPlaceDetails(
      {required String destinationlatitude,
      required String destinationlongitude,
      required String placeId}) async {
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
      getPolylines(
          destinationlatitude: destinationlatitude,
          destinationlongitude: destinationlongitude);
    }
  }

  @override
  void onReady() {}

  void toggleReportOptions() {
    showReportOptions.value = !showReportOptions.value;
  }
}
