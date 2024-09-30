import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../services/storage.dart';
import '../../community/views/community_view.dart';
import '../../explore/views/explore_view.dart';
import '../../profile/views/profile_view.dart';
import '../../saved/views/saved_view.dart';

class CustomnavigationbarController extends GetxController {
  //TODO: Implement CustomnavigationbarController

  final List<Widget> pages = [
    const ExploreView(),
    const SavedView(),
    const CommunityView(),
    const ProfileView()
  ];
  var selectedPageIndex = 0.obs;
  changePage(int index) {
    selectedPageIndex.value = index;
  }

  @override
  void onInit() {
    print(Get.find<GetStorageService>().getEncjwToken);
  }
}
