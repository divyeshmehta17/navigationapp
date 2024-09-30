import 'package:get/get.dart';
import 'package:mopedsafe/app/constants/image_constant.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../components/RecentLocationData.dart';
import '../../../components/SavedLocationData.dart';
import '../../../customwidgets/globalcontroller.dart';

class ExploreController extends GetxController {
  var searchText = ''.obs;
  var savedLocations = <SavedLocationData>[].obs;
  var recentLocations = <RecentLocationData>[].obs;
  var panelPosition = 0.0.obs;
  var showReportOptions = false.obs;

  final GlobalController globalController = Get.find();
  final panelController = PanelController();

  @override
  void onInit() {
    super.onInit();
    fetchSavedLocations();
    fetchRecentLocations();
  }

  void fetchSavedLocations() {
    savedLocations.assignAll([
      SavedLocationData(
          name: 'Home', icon: ImageConstant.svghomeIcon, distance: '5 km'),
      SavedLocationData(
          name: 'Office', icon: ImageConstant.svgofficeIcon, distance: '10 km'),
      SavedLocationData(
          name: 'Urban Plaza',
          icon: ImageConstant.svgsavedIconsblack,
          distance: '15 km'),
    ]);
  }

  void fetchRecentLocations() {
    recentLocations.assignAll([
      RecentLocationData(
          name: 'Hanging Garden', description: 'Nemo enim ipsam voluptatem'),
      RecentLocationData(name: 'Hanging Garden', description: null),
      RecentLocationData(name: 'Hanging Garden', description: null),
      RecentLocationData(name: 'Hanging Garden', description: 'null'),
      RecentLocationData(name: 'Hanging Garden', description: 'null'),
      RecentLocationData(name: 'Hanging Garden', description: 'resrs'),
      RecentLocationData(name: 'Hanging Garden', description: 'null'),
      RecentLocationData(name: 'Hanging Garden', description: 'null'),
      RecentLocationData(name: 'Hanging Garden', description: 'null'),
    ]);
  }

  @override
  void onReady() {
    fetchRecentLocations();
  }

  void toggleReportOptions() {
    showReportOptions.value = !showReportOptions.value;
  }
}
