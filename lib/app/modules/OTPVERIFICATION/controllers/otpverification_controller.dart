import 'package:dio/dio.dart'; // Import DioError
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/services/colors.dart';

import '../../../models/userdetails.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth.dart';
import '../../../services/dio/api_service.dart';
import '../../../services/storage.dart';
import '../../../services/userdataservice.dart'; // Import for showing SnackBar

class OtpverificationController extends GetxController {
  RxString otp = ''.obs;
  RxBool isEnabled = false.obs;
  final Map<String, dynamic> phoneArgument = Get.arguments;
  Rxn<UserDetails> userdetails = Rxn<UserDetails>();
  @override
  @override
  void onInit() {
    super.onInit();
    isEnabled.value = false;

    // Check if the user is logged in and retrieve user details from storage
    final storedUserDetails = GetStorageService.appstorage.read('userdetails');
    if (storedUserDetails != null) {
      userdetails.value = UserDetails.fromJson(storedUserDetails);
      Get.find<GetStorageService>().userLoggedIn = true;
      Get.put(UserService());
      Get.find<UserService>().setUserDetails(userdetails.value!);
      Get.offAndToNamed(Routes.CUSTOMNAVIGATIONBAR);
    }
  }

  void verifyOtp(BuildContext context) async {
    final isOtpValid = await Get.find<Auth>().verifyMobileOtp(otp: otp.value);
    if (isOtpValid) {
      loginApi();
    } else {
      // Display an error message without additional actions that could restart the app.
      Get.snackbar(
        'Invalid OTP',
        'The OTP you entered is incorrect. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: context.brandColor1,
        colorText: Colors.white,
      );
    }
  }

  Future<void> loginApi() async {
    try {
      await APIManager.postLogin(showSnakbar: false).then((value) {
        // Convert API response to UserDetails
        userdetails.value = UserDetails.fromJson(value.data);

        // Serialize UserDetails to JSON and write to storage
        GetStorageService.appstorage
            .write('userdetails', userdetails.value!.toJson());

        // Update the app state
        Get.find<GetStorageService>().userLoggedIn = true;
        Get.put(UserService());
        Get.find<UserService>().setUserDetails(userdetails.value!);

        // Navigate to the home screen
        Get.offAndToNamed(Routes.CUSTOMNAVIGATIONBAR);
        Get.find<Auth>().checkLocationPermissionAndNavigate();
      });
    } catch (error) {
      if (error is DioException && error.response?.statusCode == 404) {
        Get.toNamed(Routes.SETPROFILEDETAILS);
      } else {
        Get.snackbar(
          'Error',
          'An unexpected error occurred. Please try again later.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}
