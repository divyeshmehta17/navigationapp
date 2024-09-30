import 'package:get/get.dart';

import '../controllers/phonelogin_controller.dart';

class PhoneloginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PhoneloginController>(
      () => PhoneloginController(),
    );
  }
}
