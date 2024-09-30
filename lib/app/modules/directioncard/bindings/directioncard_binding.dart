import 'package:get/get.dart';

import '../controllers/directioncard_controller.dart';

class DirectioncardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DirectioncardController>(
      () => DirectioncardController(),
    );
  }
}
