import 'package:get/get.dart';

import '../controllers/setprofiledetails_controller.dart';

class SetprofiledetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SetprofiledetailsController>(
      () => SetprofiledetailsController(),
    );
  }
}
