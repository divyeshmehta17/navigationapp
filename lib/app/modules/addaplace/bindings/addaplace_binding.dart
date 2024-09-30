import 'package:get/get.dart';

import '../controllers/addaplace_controller.dart';

class AddaplaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddaplaceController>(
      () => AddaplaceController(),
    );
  }
}
