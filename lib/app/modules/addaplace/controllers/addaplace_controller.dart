import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart'; // Import this to convert coordinates to address
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as google_maps_places;
import 'package:mopedsafe/app/modules/explore/controllers/explore_controller.dart';
import 'package:mopedsafe/app/services/dio/api_service.dart';
import 'package:mopedsafe/app/services/storage.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../components/SavedLocationData.dart';
import '../../../models/locationHistory.dart';
import '../../../models/postSaveLocation.dart';

class AddaplaceController extends GetxController {
  final TextEditingController searchcontroller = TextEditingController();

  final google_maps_places.GoogleMapsPlaces _places;
  final stt.SpeechToText _speech = stt.SpeechToText();
  final placeName = ''.obs; // Observable to store place name
  final Rx<LatLng> currentLocation = LatLng(0.0, 0.0).obs;
  final Rx<double> currentLat = 0.0.obs;
  final Rx<double> currentLng = 0.0.obs;
  final Rx<double> searchedLat = 0.0.obs;
  final Rx<double> searchedLng = 0.0.obs;
  final Rxn<postSaveLocation> postsavelocation = Rxn();
  final RxString placeId = ''.obs;
  final RxString savedLocationType =
      ''.obs; // Observable to store the selected location type
  final RxBool isLoading = false.obs; // Observable to track loading status
  Rxn<SavedLocation> savedLocations = Rxn();
  Rxn<SearchLocationHistory> searchLocationsHistory = Rxn();
  RxBool isListening = false.obs;
  RxList<google_maps_places.Prediction> searchSuggestions =
      <google_maps_places.Prediction>[].obs;
  RxBool isLoadingSuggestions = false.obs;

  AddaplaceController()
      : _places = google_maps_places.GoogleMapsPlaces(
            apiKey: Get.find<GetStorageService>()
                .googleApiKey); // Replace with your actual API key

  @override
  void onInit() {
    super.onInit();
    getSavedLocation();
    getHistoryLocation();
  }

  @override
  void onClose() {
    searchcontroller.dispose();
    _speech.stop();
    Get.find<ExploreController>().getSavedLocation();
    super.onClose();
  }

  Future<void> getHistoryLocation() async {
    APIManager.getSavedLocation(type: 'HISTORY').then((response) {
      searchLocationsHistory.value =
          SearchLocationHistory.fromJson(response.data);
      print('aaaaaaaaaaaaaaa');
      print(searchLocationsHistory.value!.data!.results![0]!.type);
      print(searchLocationsHistory
          .value!.data!.results![0]!.location!.addressLine);
    });
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
      finalTimeout: Duration(seconds: 2),
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
      print(searchSuggestions.length);
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

  Future<void> getCurrentLocation() async {
    isLoading.value = true; // Start loading
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      currentLocation.value = LatLng(position.latitude, position.longitude);
      currentLat.value = position.latitude;
      currentLng.value = position.longitude;

      // Fetch place name from coordinates
      await getPlaceNameFromCoordinates(position.latitude, position.longitude);
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  Future<void> getPlaceNameFromCoordinates(double lat, double lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      placeName.value = "${place.name}";

      // Use Google Places API to fetch place details based on coordinates
      final response = await _places.searchNearbyWithRadius(
        google_maps_places.Location(
            lat: lat, lng: lng), // Location object with lat/lng
        1000, // radius in meters
        language: "en", // Optional, specify language
      );

      if (response.isOkay && response.results.isNotEmpty) {
        placeId.value =
            response.results.first.placeId ?? ''; // Store the placeId
        print('placeIDD: $placeId');
      }

      print(placeName);
    }
  }

  Future<void> fetchPlaceDetails(String placeId) async {
    await _places.getDetailsByPlaceId(placeId).then((response) {
      placeName.value = response.result.name;
      searchedLat.value = response.result.geometry!.location.lat;
      searchedLng.value = response.result.geometry!.location.lng;
    });
  }

  Future<void> saveCurrentLocation() async {
    final locationTitle = savedLocationType.value.isNotEmpty
        ? savedLocationType.value
        : 'MY HOME';

    APIManager.postSaveLocation(
      type: 'SAVED',
      locationtype: 'Point',
      addressLine: placeName.value,
      lat: currentLat.value,
      lng: currentLng.value,
      title: locationTitle,
      placeId: placeId.value,
    ).then((response) {
      postsavelocation.value = postSaveLocation.fromJson(response.data);
      print(postsavelocation.value!.data!.title);
    });
  }

  Future<void> saveSearchedLocation() async {
    final locationTitle = savedLocationType.value.isNotEmpty
        ? savedLocationType.value
        : 'MY HOME';

    APIManager.postSaveLocation(
      type: 'SAVED',
      locationtype: 'Point',
      addressLine: placeName.value,
      lat: searchedLat.value,
      lng: searchedLng.value,
      title: locationTitle,
      placeId: placeId.value,
    ).then((response) {
      postsavelocation.value = postSaveLocation.fromJson(response.data);

      print(postsavelocation.value!.data!.placeId);
    });
  }

  Future<void> getSavedLocation() async {
    APIManager.getSavedLocation(type: 'SAVED').then((response) {
      savedLocations.value = SavedLocation.fromJson(response.data);
      print(savedLocations.value!.data!.results![0]!.title);
    });
  }
}
