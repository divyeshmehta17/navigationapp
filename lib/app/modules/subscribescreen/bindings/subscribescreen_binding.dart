import 'package:get/get.dart';

import '../../profile/bindings/profile_binding.dart';
import '../controllers/subscribescreen_controller.dart';

class SubscribescreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscribescreenController>(
      () => SubscribescreenController(),
    );
    ProfileBinding().dependencies();
  }
}
