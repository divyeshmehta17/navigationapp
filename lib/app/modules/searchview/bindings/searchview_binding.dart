import 'package:get/get.dart';

import '../../directioncard/bindings/directioncard_binding.dart';
import '../controllers/searchview_controller.dart';

class SearchviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchviewController>(
      () => SearchviewController(),
    );
    DirectioncardBinding().dependencies();
  }
}
