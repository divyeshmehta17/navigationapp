import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mopedsafe/app/constants/image_constant.dart';
import 'package:mopedsafe/app/models/fetchcommunitypost.dart';
import 'package:mopedsafe/app/services/dio/api_service.dart';

class CommunityController extends GetxController {
  Rxn<FetchCommunityPost> fetchCommunityPost = Rxn<FetchCommunityPost>();
  final ImagePicker picker = ImagePicker();
  RxInt selectedTimeFilter = 0.obs;
  Rx<XFile?> imageFile = Rx<XFile?>(null);
  final distanceRange = RangeValues(0, 10).obs;
  // Get reversed list of community posts from API response
  List<dynamic>? get reversedCommunityPosts =>
      fetchCommunityPost.value?.data?.reversed.toList();

  // Method to pick an image
  Future<void> pickImage(ImageSource source) async {
    try {
      final selectedImage = await picker.pickImage(source: source);
      imageFile.value = selectedImage;
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  updateSelectedTimeFilter(int index) {
    selectedTimeFilter.value = index;
  }

  updateDistanceRange(RangeValues newRange) {
    distanceRange.value = newRange;
  }

  double roundToStep(double value) {
    // Define your predefined steps
    const List<double> steps = [0.0, 2.0, 4.0, 6.0, 8.0, 10.0];

    // Find the closest step
    double closestStep =
        steps.reduce((a, b) => (value - a).abs() < (value - b).abs() ? a : b);
    return closestStep;
  }

  // Method to fetch community posts from API
  // Method to fetch community posts from API with filters
  Future<void> fetchCommunityPostApi() async {
    try {
      // Applying the selected time filter and distance range
      int days = 7; // Default to 0, if no time filter is selected

      if (selectedTimeFilter.value == 0) {
        days = 1; // Example: 1 day filter
      } else if (selectedTimeFilter.value == 1) {
        days = 3; // Example: 7 days filter
      } else if (selectedTimeFilter.value == 2) {
        days = 7; // Example: 30 days filter
      }

      // Fetch community posts with the current filters
      final response = await APIManager.getFetchCommunityPost(
        latitude: 40.712776,
        longitude: -73.947974,
        distance:
            distanceRange.value.end, // Use the end value of the distance range
        days: days, // Pass the selected time filter
      );

      // Update the fetchCommunityPost value with the API response
      fetchCommunityPost.value = FetchCommunityPost.fromJson(response.data);
      print(fetchCommunityPost.value!.data![0]!.postMedia!);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch community posts: $e');
    }
  }

  // Helper to get icon path based on type of incident
  String getIncidentIconPath(String? incidentType) {
    switch (incidentType) {
      case 'Vehicle stalled':
        return ImageConstant.svgvechilestalledIcon;
      case 'Congestion':
        return ImageConstant.svgcongestionIcon;
      case 'Road closed':
        return ImageConstant.svgroadclosedIcon;
      case 'Roadwork':
        return ImageConstant.svgroadworkIcon;
      case 'Car crash':
        return ImageConstant.svgcarcrashicon;
      default:
        return ImageConstant.svgpoliceIcon;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchCommunityPostApi();
  }
}
