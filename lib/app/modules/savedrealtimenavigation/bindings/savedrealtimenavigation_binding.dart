import 'package:get/get.dart';

import '../controllers/savedrealtimenavigation_controller.dart';

class SavedrealtimenavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SavedrealtimenavigationController>(
      () => SavedrealtimenavigationController(),
    );
  }
}
