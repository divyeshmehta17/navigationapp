import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_webservice/places.dart' as google_maps_places;

import '../../../components/RecentLocationData.dart';
import '../../../customwidgets/globalcontroller.dart';
import '../../../models/polylinestrack.dart';
import '../../../routes/app_pages.dart';
import '../../../services/dio/api_service.dart';
import '../../../services/storage.dart';

class SearchviewController extends GetxController {
  final count = 0.obs;
  final TextEditingController searchcontroller = TextEditingController();
  final GlobalController globalController = Get.find();
  Rxn<GetRoutes> getroutes = Rxn<GetRoutes>();
  final recentSearches =
      <RecentLocationData>[].obs; // Observable list of recent searches

  // Add a variable to store place details
  google_maps_places.PlaceDetails? placeDetails;

  @override
  void onClose() {
    searchcontroller.clear();
    searchcontroller.dispose();
    recentSearches.clear();
    super.onClose();
  }

  void increment() => count.value++;

  // Method to add a recent search
  void addRecentSearch(RecentLocationData location) {
    recentSearches.add(location);
    print(Get.find<GetStorageService>().getEncjwToken);
  }

  // Method to fetch place details and update global variables
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

  Future<void> getPolylines() async {
    await APIManager.postGetRoutes(
            sourcelatitude: globalController.currentLatitude.toString(),
            sourcelongitude: globalController.currentLongitude.toString(),
            destinationlatitude:
                globalController.destinationLatitude.toString(),
            destinationlongitude:
                globalController.destinationLongitude.toString())
        .then((value) {
      getroutes.value = GetRoutes.fromJson(value.data);
      //getDirections();
      // Pass the entire getroutes data to the next page
      Get.toNamed(Routes.DIRECTIONCARD, arguments: {
        'getroutes': getroutes.value,
        'placeID': placeDetails!.placeId,
      });
    });
  }
}
