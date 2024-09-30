import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../services/storage.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), () => decideRouting());
  }

  decideRouting() {
    Get.find<GetStorageService>().userLoggedIn
        ? Get.offNamed(Routes.CUSTOMNAVIGATIONBAR)
        : Get.offNamed(Routes.ONBOARDING);
  }
}
