import 'package:get/get.dart';

import '../controllers/offlineroutes_controller.dart';

class OfflineroutesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OfflineroutesController>(
      () => OfflineroutesController(),
    );
  }
}
