import 'package:get/get.dart';

import '../controllers/realtimenavigation_controller.dart';

class RealtimenavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RealtimenavigationController>(
      () => RealtimenavigationController(),
    );
  }
}
