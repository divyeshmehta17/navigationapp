import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../constants/image_constant.dart';
import '../../../routes/app_pages.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  RxInt currentPage = 0.obs; // Observable to track the current page
  List<OnBoardingModel> pages = [
    OnBoardingModel(
        svg: ImageConstant.svgwelcomesplash,
        title: '🛵 Welcome to MopedSafe!',
        description:
            'Navigate your way with safety in mind. Join us for a secure and enjoyable ride on your moped.'),
    OnBoardingModel(
        svg: ImageConstant.svgfindmopedsplash,
        title: '🗺️ Find Moped-Safe Routes',
        description:
            'No high-speed worries! MopedSafe guides you through safe routes, avoiding highways for a smooth ride. Let\'s roll!'),
    OnBoardingModel(
        svg: ImageConstant.svgcustomizesplash,
        title: '🎨 Customize Your Profile',
        description:
            'Let\'s make your MopedSafe experience uniquely yours! Share a bit about yourself, your moped, and preferences. Ready to hit the road in style?')
  ];

  OnboardingController() {
    pageController.addListener(() {
      currentPage.value = pageController.page!.toInt() ?? 0;
    });
  }

  void increment() => currentPage.value++;

  void loginPage() {
    Get.toNamed(Routes.PHONELOGIN);
  }

  @override
  void onInit() {
    pageController.addListener(() {
      // Update currentPage whenever the page changes
      currentPage.value = pageController.page?.round() ?? 0;
    });
  }
}

class OnBoardingModel {
  final String svg;
  final String title;
  final String description;

  OnBoardingModel({
    this.svg = '',
    this.title = '',
    this.description = '',
  });
}
