import 'package:get/get.dart';

import '../../community/bindings/community_binding.dart';
import '../../explore/bindings/explore_binding.dart';
import '../../profile/bindings/profile_binding.dart';
import '../../saved/bindings/saved_binding.dart';
import '../controllers/customnavigationbar_controller.dart';

class CustomnavigationbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomnavigationbarController>(
      () => CustomnavigationbarController(),
    );
    ExploreBinding().dependencies();
    SavedBinding().dependencies();
    CommunityBinding().dependencies();
    ProfileBinding().dependencies();
  }
}
