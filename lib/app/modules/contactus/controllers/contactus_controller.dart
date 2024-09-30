import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/services/dio/api_service.dart';

import '../../../models/contactus.dart';

class ContactusController extends GetxController {
  var titleController = TextEditingController();
  var questionController = TextEditingController();
  var titleText = ''.obs;
  var descriptionText = ''.obs;
  Rxn<ContactUs> contactus = Rxn<ContactUs>();
  @override
  void onInit() {
    super.onInit();
    titleController.addListener(() {
      titleText.value = titleController.text;
    });
    questionController.addListener(() {
      descriptionText.value = questionController.text;
    });
  }

  Future<void> ContactUsApi(
      {required String title, required String description}) async {
    await APIManager.postContactUs(title: title, description: description)
        .then((value) {
      contactus.value = ContactUs.fromJson(value.data);
      print(contactus.value!.title);
    });
  }
}
