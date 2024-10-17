import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart'; // Import this to convert coordinates to address
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as google_maps_places;
import 'package:mopedsafe/app/services/dio/api_service.dart';
import 'package:mopedsafe/app/services/storage.dart';

import '../../../components/RecentLocationData.dart';
import '../../../components/SavedLocationData.dart';
import '../../../models/postSaveLocation.dart';

class AddaplaceController extends GetxController {
  final TextEditingController searchcontroller = TextEditingController();
  var recentLocations = <RecentLocationData>[].obs;
  final google_maps_places.GoogleMapsPlaces _places;
  final placeName = ''.obs; // Observable to store place name
  final Rx<LatLng> currentLocation = LatLng(0.0, 0.0).obs;
  final Rx<double> currentLat = 0.0.obs;
  final Rx<double> currentLng = 0.0.obs;
  final Rx<double> searchedLat = 0.0.obs;
  final Rx<double> searchedLng = 0.0.obs;
  final Rxn<postSaveLocation> postsavelocation = Rxn();
  Rxn<SavedLocation> savedLocations = Rxn();
  AddaplaceController()
      : _places = google_maps_places.GoogleMapsPlaces(
            apiKey: Get.find<GetStorageService>()
                .googleApiKey); // Replace with your actual API key

  @override
  void onInit() {
    super.onInit();
    getSavedLocation();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentLocation.value = LatLng(position.latitude, position.longitude);
    currentLat.value = position.latitude;
    currentLng.value = position.latitude;
    // Fetch place name from coordinates
    await getPlaceNameFromCoordinates(position.latitude, position.longitude);
  }

  Future<void> getPlaceNameFromCoordinates(double lat, double lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      placeName.value = "${place.name}";
    }
  }

  Future<void> fetchPlaceDetails(String placeId) async {
    await _places.getDetailsByPlaceId(placeId).then((response) {
      placeName.value = response.result.name;
      searchedLat.value = response.result.geometry!.location.lat;
      searchedLng.value = response.result.geometry!.location.lng;
      saveSearchedLocation();
    });
  }

  Future<void> saveCurrentLocation() async {
    APIManager.postSaveLocation(
            type: 'SAVED',
            locationtype: 'Point',
            addressLine: placeName.value,
            lat: currentLat.value,
            lng: currentLng.value,
            title: 'MY HOME')
        .then((response) {
      postsavelocation.value = postSaveLocation.fromJson(response.data);
      print(postsavelocation.value!.data!.title);
    });
  }

  Future<void> saveSearchedLocation() async {
    APIManager.postSaveLocation(
            type: 'SAVED',
            locationtype: 'Point',
            addressLine: placeName.value,
            lat: searchedLat.value,
            lng: searchedLng.value,
            title: 'MY HOME')
        .then((response) {
      postsavelocation.value = postSaveLocation.fromJson(response.data);
      print(postsavelocation.value!.data!.title);
    });
  }

  Future<void> getSavedLocation() async {
    APIManager.getSavedLocation(type: 'SAVED').then((response) {
      savedLocations.value = SavedLocation.fromJson(response.data);
      print(savedLocations.value!.data!.results![0]!.title);
    });
  }
}
