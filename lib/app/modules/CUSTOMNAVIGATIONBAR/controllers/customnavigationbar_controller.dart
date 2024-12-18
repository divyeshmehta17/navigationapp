import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../models/getsavedroutes.dart';
import '../../../services/auth.dart';
import '../../../services/dio/api_service.dart';
import '../../../services/storage.dart';
import '../../community/views/community_view.dart';
import '../../explore/views/explore_view.dart';
import '../../profile/views/profile_view.dart';
import '../../saved/views/saved_view.dart';

class CustomnavigationbarController extends GetxController {
  final List<Widget> pages = [
    const ExploreView(),
    const SavedView(),
    const CommunityView(),
    const ProfileView()
  ];

  Rxn<GetSavedRoutes> getsavedRoutes = Rxn();
  RxInt selectedPageIndex = 0.obs;

  final GetStorageService storageService = Get.find<GetStorageService>();

  changePage(int index) {
    selectedPageIndex.value = index;
    print(selectedPageIndex);
  }

  @override
  void onInit() {
    super.onInit();
    Get.find<Auth>().checkLocationPermissionAndNavigate();
    _loadOfflineRoutes();
    fetchSavedRoutes();
    print(storageService.getEncjwToken);
  }

  /// Fetch saved routes from API and save offline
  Future<void> fetchSavedRoutes() async {
    APIManager.getFetchSavedRoutes(type: 'OFFLINE').then((response) {
      final fetchedRoutes = GetSavedRoutes.fromJson(response.data);
      getsavedRoutes.value = fetchedRoutes;
      print(
          "Saved routes offline: ${getsavedRoutes.value!.data!.results![0]!.instructions![0]}");
      // Save fetched routes locally
      _saveRoutesOffline(fetchedRoutes);
    });
  }

  /// Save routes to local storage
  void _saveRoutesOffline(GetSavedRoutes routes) {
    final routesJson = jsonEncode(routes.toJson());
    GetStorageService.appstorage.write('offlineRoutes', routesJson);
  }

  /// Load routes from local storage
  void _loadOfflineRoutes() {
    final routesJson = GetStorageService.appstorage.read('offlineRoutes');
    if (routesJson != null) {
      getsavedRoutes.value = GetSavedRoutes.fromJson(jsonDecode(routesJson));
    }
  }
}
