import 'package:get/get.dart';

import '../controllers/savednavgation_controller.dart';

class SavednavgationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SavednavgationController>(
      () => SavednavgationController(),
    );
  }
}
