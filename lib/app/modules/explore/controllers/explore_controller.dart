import 'package:get/get.dart';
import 'package:mopedsafe/app/services/dio/api_service.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../components/RecentLocationData.dart';
import '../../../components/SavedLocationData.dart';
import '../../../customwidgets/globalcontroller.dart';

class ExploreController extends GetxController {
  var searchText = ''.obs;
  Rxn<SavedLocation> savedLocations = Rxn();
  var recentLocations = <RecentLocationData>[].obs;
  var panelPosition = 0.0.obs;
  var showReportOptions = false.obs;

  final GlobalController globalController = Get.find();
  final panelController = PanelController();

  @override
  void onInit() {
    super.onInit();
    getSavedLocation();
    fetchRecentLocations();
  }

  Future<void> getSavedLocation() async {
    APIManager.getSavedLocation(type: 'SAVED').then((response) {
      savedLocations.value = SavedLocation.fromJson(response.data);
    });
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
