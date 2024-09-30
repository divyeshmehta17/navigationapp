import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../components/RecentLocationData.dart';

class AddaplaceController extends GetxController {
  //TODO: Implement AddaplaceController

  final TextEditingController searchcontroller = TextEditingController();
  var recentLocations = <RecentLocationData>[].obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
