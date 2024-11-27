import 'package:dio/dio.dart';
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
      {required String title,
      required String description,
      required BuildContext context}) async {
    await APIManager.postContactUs(title: title, description: description)
        .then((value) {
      contactus.value = ContactUs.fromJson(value.data);
      titleController.clear();
      questionController.clear();
      print(contactus.value!.title);

      // Show success dialog
      _showSuccessDialog(context);
    }).catchError((error) {
      // Extract error message from the API response
      String errorMessage = _getErrorMessage(error);

      // Show error dialog with the message from the API
      _showErrorDialog(context, errorMessage);
    });
  }

  // Success dialog
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text('Your query has been successfully submitted!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Error dialog
  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Method to extract the error message from the API response
  String _getErrorMessage(dynamic error) {
    // Check if error is a DioError and contains response data
    if (error is DioException &&
        error.response != null &&
        error.response!.data != null) {
      // You can modify this based on how the API sends errors
      return error.response!.data['message'] ?? 'An unknown error occurred.';
    } else {
      return 'An error occurred while submitting your query.';
    }
  }
}
