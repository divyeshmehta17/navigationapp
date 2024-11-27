import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_webservice/places.dart' as google_maps_places;
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../components/SavedLocationData.dart';
import '../../../customwidgets/globalcontroller.dart';
import '../../../models/locationHistory.dart';
import '../../../models/polylinestrack.dart';
import '../../../models/postSaveLocation.dart';
import '../../../routes/app_pages.dart';
import '../../../services/dio/api_service.dart';
import '../../../services/storage.dart';
import '../../directioncard/controllers/directioncard_controller.dart';

class SearchviewController extends GetxController {
  final count = 0.obs;
  final TextEditingController searchcontroller = TextEditingController();
  final GlobalController globalController = Get.find();
  Rxn<GetRoutes> getroutes = Rxn<GetRoutes>();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final google_maps_places.GoogleMapsPlaces _places =
      google_maps_places.GoogleMapsPlaces(
          apiKey: Get.find<GetStorageService>()
              .googleApiKey); // Replace with your API Key

  RxBool isListening = false.obs;
  final Rxn<postSaveLocation> postsavelocation = Rxn();
  // Add a variable to store place details
  google_maps_places.PlaceDetails? placeDetails;
  Rxn<SavedLocation> savedLocations = Rxn();
  Rxn<SearchLocationHistory> searchLocations = Rxn();
  RxList<google_maps_places.Prediction> searchSuggestions =
      <google_maps_places.Prediction>[].obs;
  RxBool isLoadingSuggestions = false.obs;

  @override
  void onInit() {
    getSavedLocation();
    getHistoryLocation();
    searchcontroller.addListener(() {
      final query = searchcontroller.text;
      if (query.isNotEmpty) {
        fetchSearchSuggestions(query);
      } else {
        searchSuggestions.clear();
      }
    });
  } // Method to fetch place details and update global variables

  @override
  void onClose() {
    searchcontroller.clear();
    searchcontroller.dispose();
    _speech.stop();
    super.onClose();
  }

  Future<void> startListening() async {
    isListening.value = true; // Show the "Listening" overlay
    final available = await _speech.initialize(
      onStatus: (status) {
        print('Speech Status: $status'); // Debug print
        if (status == 'done' || status == 'notListening') {
          isListening.value = false; // Hide the "Listening" overlay
        }
      },
      onError: (error) {
        print('Speech Error: $error'); // Debug print
        isListening.value = false; // Hide the "Listening" overlay on error
      },
      finalTimeout: const Duration(seconds: 2),
    );

    if (available) {
      print('Speech recognition started'); // Debug print
      _speech.listen(
        onResult: (result) {
          print('Recognized Words: ${result.recognizedWords}'); // Debug print
          searchcontroller.text = result.recognizedWords;
          isListening.value = false; // Hide the "Listening" overlay
          fetchSearchSuggestions(searchcontroller.text);
        },
      );
    } else {
      isListening.value = false; // Hide the "Listening" overlay
      print('Speech recognition not available');
    }
  }

  Future<void> fetchSearchSuggestions(String query) async {
    if (query.isEmpty) {
      print('Empty query.'); // Debug print
      searchSuggestions.clear();
      return;
    }

    print('Fetching suggestions for query: $query'); // Debug print
    isLoadingSuggestions.value = true;
    final response = await _places.autocomplete(query);
    isLoadingSuggestions.value = false;

    if (response.isOkay) {
      print('Suggestions received: ${response.predictions}'); // Debug print
      searchSuggestions.assignAll(response.predictions);
    } else {
      print('API Error: ${response.errorMessage}'); // Debug print
      searchSuggestions.clear();
    }
  }

// Stop Listening
  void stopListening() {
    isListening.value = false;
    _speech.stop();
  }

  Future<void> getPolylinesRecent(
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
        'getroutes': getroutes.value,
        'placeID': placeDetails!.placeId,
      });
    });
  }

  Future<void> fetchPlaceDetailsRecent(
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
      getPolylinesRecent(
          destinationlatitude: destinationlatitude,
          destinationlongitude: destinationlongitude);
    }
  }

  Future<void> saveSearchedLocation(
      {required String addressLine,
      required double lat,
      required double lng,
      required String placeId}) async {
    APIManager.postSaveLocation(
      type: 'HISTORY',
      locationtype: 'Point',
      addressLine: addressLine,
      lat: lat,
      lng: lng,
      title: 'History',
      placeId: placeId,
    ).then((response) {
      postsavelocation.value = postSaveLocation.fromJson(response.data);

      print(postsavelocation.value!.data!.type);
    });
  }

  Future<void> getSavedLocation() async {
    APIManager.getSavedLocation(type: 'SAVED').then((response) {
      savedLocations.value = SavedLocation.fromJson(response.data);
    });
  }

  Future<void> fetchSavedPlaceDetails(
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
      getSavedPolylines(
          destinationlatitude: destinationlatitude,
          destinationlongitude: destinationlongitude);
    }
  }

  Future<void> getSavedPolylines(
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
        'searchedRoutes': getroutes.value,
        'searchedPlaceId': placeDetails!.placeId,
      });
    });
  }

  Future<void> fetchPlaceDetails(String placeId) async {
    final google_maps_places.GoogleMapsPlaces _places =
        google_maps_places.GoogleMapsPlaces(
            apiKey: Get.find<GetStorageService>().googleApiKey);

    await _places.getDetailsByPlaceId(placeId).then((response) {
      placeDetails = response.result; // Store details globally
      globalController.destinationLatitude.value =
          placeDetails!.geometry!.location.lat;
      globalController.destinationLongitude.value =
          placeDetails!.geometry!.location.lng;
      getPolylines();
      saveSearchedLocation(
          addressLine: response.result.name,
          lat: globalController.destinationLatitude.value,
          lng: globalController.destinationLongitude.value,
          placeId: placeId);
    });
  }

  Future<void> getHistoryLocation() async {
    APIManager.getSavedLocation(type: 'HISTORY').then((response) {
      searchLocations.value = SearchLocationHistory.fromJson(response.data);
      print('aaaaaaaaaaaaaaa');
      print(searchLocations.value!.data!.results![0]!.type);
      print(searchLocations.value!.data!.results![0]!.location!.addressLine);
    });
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
      saveSearchedLocation(
          addressLine: placeDetails!.formattedAddress.toString(),
          lat: globalController.destinationLatitude.toDouble(),
          lng: globalController.destinationLongitude.toDouble(),
          placeId: placeDetails!.placeId.toString());
      print(getroutes.value!.data!.points);

      // Manually delete the DirectioncardController if it exists
      if (Get.isRegistered<DirectioncardController>()) {
        Get.delete<DirectioncardController>();
      }
      print('placedtails ${placeDetails!.placeId}');
      Get.offNamed(Routes.DIRECTIONCARD, arguments: {
        'searchedPlaceId': placeDetails!.placeId,
        'searchedRoutes': getroutes.value
      });
    });
  }
}
