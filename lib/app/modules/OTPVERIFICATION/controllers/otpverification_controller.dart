import 'package:dio/dio.dart'; // Import DioError
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  void onInit() {
    isEnabled.value = false;
  }

  void verifyOtp() async {
    Get.find<Auth>().verifyMobileOtp(otp: otp.value).then((value) {
      loginApi();
    });
  }

  Future<void> loginApi() async {
    try {
      await APIManager.postLogin(showSnakbar: false).then((value) {
        userdetails.value = UserDetails.fromJson(value.data);
        Get.find<GetStorageService>().userLoggedIn = true;
        Get.put(UserService());
        Get.find<UserService>().setUserDetails(userdetails.value!);
        Get.offAndToNamed(Routes.CUSTOMNAVIGATIONBAR);
        Get.find<Auth>().checkLocationPermissionAndNavigate();
      });
    } catch (error) {
      if (error is DioException && error.response?.statusCode == 404) {
        // Handle 404 error specifically
        Get.toNamed(Routes.SETPROFILEDETAILS);
      } else {
        // Handle other errors
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
