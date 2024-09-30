import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mopedsafe/app/routes/app_pages.dart';

import '../../../models/reportincident.dart';
import '../../../models/uploadprofileimage.dart';
import '../../../services/dio/api_service.dart';

class ReportincidentController extends GetxController {
  final count = 0.obs;
  final isLoading = false.obs;
  final Rxn<CreateCommunityPost> reportincident = Rxn();
  final TextEditingController descriptioncontroller = TextEditingController();
  var selectedImage = Rx<File?>(null);
  Rxn<UploadProfileImage> profileimage = Rxn<UploadProfileImage>();

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
    required String url,
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
      url: url,
      type: type,
      addressLine: addressLine,
      latitude: latitude,
      longitude: longitude,
    ).then((value) {
      reportincident.value = CreateCommunityPost.fromJson(value.data);
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
