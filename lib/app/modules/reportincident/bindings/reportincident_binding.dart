import 'package:get/get.dart';

import '../controllers/reportincident_controller.dart';

class ReportincidentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportincidentController>(
      () => ReportincidentController(),
    );
  }
}
