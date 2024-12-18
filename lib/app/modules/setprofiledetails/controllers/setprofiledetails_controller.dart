import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mopedsafe/app/modules/OTPVERIFICATION/controllers/otpverification_controller.dart';
import 'package:mopedsafe/app/routes/app_pages.dart';
import 'package:mopedsafe/app/services/dio/api_service.dart';

import '../../../models/uploadprofileimage.dart';
import '../../../models/userdetails.dart';
import '../../../services/auth.dart';
import '../../../services/storage.dart';
import '../../../services/userdataservice.dart';

class SetprofiledetailsController extends GetxController {
  Rxn<UploadProfileImage> profileimage = Rxn<UploadProfileImage>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  var selectedImage = Rx<File?>(null);
  var loading = false.obs; // Add this line
  RxString selectedSpeedLimit = 'Max Speed 25kmph'.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rxn<UserDetails> userdetails = Rxn<UserDetails>();
  Future<void> sendEmailVerification() async {
    try {
      User? user = _auth.currentUser;
      print(user);
      if (user != null && !user.emailVerified) {
        await user.verifyBeforeUpdateEmail(emailController.text);
        Get.snackbar('Verification Email Sent', 'Please check your inbox.');
      } else {
        Get.snackbar('Already Verified', 'This email is already verified.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
      uploadImage();
    }
  }

  @override
  void onInit() {}

  @override
  void onClose() {
    selectedImage.value = null;
  }

  Future<void> uploadImage() async {
    if (selectedImage.value != null) {
      loading.value = true; // Show loading indicator
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
      } finally {
        loading.value = false; // Hide loading indicator
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

  Future<void> signUpApi({
    required String name,
    required String maxSpeed,
    required String email,
    required String dob,
    String? key,
    String? url,
    required bool isEmailVerified,
  }) async {
    try {
      await APIManager.postSetUserDetails(
        showSnakbar: false,
        phone:
            Get.find<OtpverificationController>().phoneArgument['phoneNumber'],
        name: name,
        dob: dob,
        email: email,
        key: key,
        url: url,
        isEmailVerified: isEmailVerified,
        maxSpeed: maxSpeed,
      ).then((value) {
        Get.snackbar(
          'Success',
          'User details submitted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        userdetails.value = UserDetails.fromJson(value.data);
        GetStorageService.appstorage.write('userdetails', userdetails.value);
        Get.find<GetStorageService>().userLoggedIn = true;
        Get.put(UserService());
        Get.find<UserService>()
            .setUserDetails(userdetails.value!)
            .then((onValue) {
          Get.offAndToNamed(Routes.CUSTOMNAVIGATIONBAR);
          Get.find<Auth>().checkLocationPermissionAndNavigate();
        });
      });
    } catch (error) {
      if (error is DioException && error.response?.statusCode == 401) {
        Get.snackbar(
          'User Already Exist',
          'Please Login With Your Registered Phone Number',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        Get.offAllNamed(Routes.PHONELOGIN);
      } else {
        Get.snackbar(
          'Error',
          'Failed to submit user details',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}
