import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart'; // Import this to convert coordinates to address
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as google_maps_places;
import 'package:image_picker/image_picker.dart';
import 'package:mopedsafe/app/modules/community/controllers/community_controller.dart';
import 'package:mopedsafe/app/routes/app_pages.dart';

import '../../../constants/image_constant.dart';
import '../../../models/reportincident.dart';
import '../../../models/uploadprofileimage.dart';
import '../../../services/dio/api_service.dart';
import '../../../services/storage.dart';

class ReportincidentController extends GetxController {
  final count = 0.obs;
  final isLoading = false.obs;
  final Rxn<CreateCommunityPost> reportincident = Rxn();
  final TextEditingController descriptioncontroller = TextEditingController();
  final TextEditingController searchcontroller = TextEditingController();
  RxString selectedLocation = ''.obs;
  var selectedImage = Rx<File?>(null);
  Rxn<UploadProfileImage> profileimage = Rxn<UploadProfileImage>();
  final google_maps_places.GoogleMapsPlaces _places;
  // List of incident types with icons
  final incidentTypes = [
    {
      'type': 'Car Crash',
      'icon': ImageConstant.svgcarcrashicon,
      'color': Colors.red
    },
    {
      'type': 'Congestion',
      'icon': ImageConstant.svgcongestionIcon,
      'color': Colors.red
    },
    {
      'type': 'Roadwork',
      'icon': ImageConstant.svgroadworkIcon,
      'color': Colors.orange
    },
    {
      'type': 'Road closed',
      'icon': ImageConstant.svgroadclosedIcon,
      'color': Colors.orange
    },
    {
      'type': 'Vehicle stalled',
      'icon': ImageConstant.svgvechilestalledIcon,
      'color': Colors.orange
    },
    {
      'type': 'Police',
      'icon': ImageConstant.svgpoliceIcon,
      'color': Colors.orange
    },
  ];

  // Selected type of incident
  final RxString selectedIncidentType = ''.obs;
  final Rx<LatLng> currentLocation = LatLng(0.0, 0.0).obs;
  final Rx<double> currentLat = 0.0.obs;
  final Rx<double> currentLng = 0.0.obs;
  final placeName = ''.obs;
  ReportincidentController()
      : _places = google_maps_places.GoogleMapsPlaces(
            apiKey: Get.find<GetStorageService>().googleApiKey);

  @override
  void onInit() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('preSelectedIncidentType')) {
      selectedIncidentType.value = args['preSelectedIncidentType'];
      print(selectedIncidentType);
    }
  }

  Future<void> getCurrentLocation() async {
    isLoading.value = true; // Start loading
    try {
      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);

      // Update current location and coordinates
      currentLocation.value = LatLng(position.latitude, position.longitude);
      currentLat.value = position.latitude;
      currentLng.value = position.longitude;

      // Fetch place name from coordinates
      await getPlaceNameFromCoordinates(position.latitude, position.longitude);

      // Update searchcontroller with fetched place name
      if (placeName.value.isNotEmpty) {
        searchcontroller.text = placeName.value;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch location: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  Future<void> getPlaceNameFromCoordinates(double lat, double lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;

      // Format the full address
      String fullAddress = '';
      if (place.name != null) fullAddress += '${place.name}, ';
      if (place.subLocality != null) fullAddress += '${place.subLocality}, ';
      if (place.locality != null) fullAddress += '${place.locality}, ';
      if (place.administrativeArea != null)
        fullAddress += '${place.administrativeArea}, ';
      if (place.country != null) fullAddress += '${place.country}';

      // Set the full address in the UI
      placeName.value = fullAddress;
      selectedLocation.value =
          fullAddress; // Update the searchcontroller with the full address
    }
  }

  Future<void> fetchPlaceDetails(String placeId) async {
    await _places.getDetailsByPlaceId(placeId).then((response) {
      placeName.value = response.result.name;
      currentLat.value = response.result.geometry!.location.lat;
      currentLng.value = response.result.geometry!.location.lng;
    });
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
      uploadImage();
    }
  }

  Future<void> postCreatePost({
    required String typeOfIncident,
    required String key,
    String url = '', // Make URL optional with a default value
    required String description,
    required String addressLine,
    required String type,
    required double latitude,
    required double longitude,
  }) async {
    await APIManager.postReportIncident(
      typeOfIncident: typeOfIncident,
      description: description,
      key: key,
      url: url, // Pass the optional URL
      type: type,
      addressLine: addressLine,
      latitude: latitude,
      longitude: longitude,
    ).then((value) {
      reportincident.value = CreateCommunityPost.fromJson(value.data);
      Get.find<CommunityController>().fetchCommunityPostApi();
      Get.snackbar('Success', 'Incident reported successfully');
      Get.offNamed(Routes.CUSTOMNAVIGATIONBAR);
    });
  }

  Future<void> uploadImage() async {
    if (selectedImage.value != null) {
      try {
        await APIManager.postuploadProfileImage(
          imageFile: selectedImage.value!,
          showSnakbar: true,
        ).then((value) {
          profileimage.value = UploadProfileImage.fromJson(value.data);
          Get.snackbar(
            'Success',
            'Image uploaded successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        });
      } catch (error) {
        Get.snackbar(
          'Error',
          'Failed to upload image',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'Error',
        'No image selected',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
