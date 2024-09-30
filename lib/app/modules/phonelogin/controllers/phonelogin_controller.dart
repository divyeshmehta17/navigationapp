import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PhoneloginController extends GetxController {
  //TODO: Implement PhoneloginController

  final TextEditingController phoneNumberController = TextEditingController();
  RxString phoneNumber = ''.obs;
  RxBool isEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
  }
}
