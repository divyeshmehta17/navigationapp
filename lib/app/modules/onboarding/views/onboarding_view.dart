import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../components/onboarding_page.dart';
import '../../../services/custom_button.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.brandColor1,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: controller.pageController,
                children: List.generate(
                  controller.pages.length,
                  (index) => OnBoardingPage(
                    model: controller.pages[index],
                  ),
                ),
              ),
            ),
            Center(
              child: SmoothPageIndicator(
                controller: controller.pageController,
                count: controller.pages.length,
                effect: WormEffect(
                  activeDotColor: Colors.white,
                  dotColor: const Color(0xFFBFBFBF),
                  dotHeight: 8.kh,
                  spacing: 8.kw,
                  dotWidth: 8.kw,
                ),
                onDotClicked: (index) {
                  controller.pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.bounceIn,
                  );
                },
              ),
            ),
            Obx(
              () => CustomButton(
                title: controller.currentPage.value == 0
                    ? 'Let\'s Get Started'
                    : 'Next',
                outline: false,
                color: Colors.white,
                textcolor: context.brandColor1,
                disabled: false,
                onTap: () {
                  if (controller.currentPage.value ==
                      controller.pages.length - 1) {
                    controller.loginPage(); // Go to login on the last page
                  } else {
                    controller.pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.bounceIn,
                    );
                  }
                },
              ).paddingOnly(left: 22.kw, right: 22, top: 24.kh, bottom: 12.kh),
            ),
            CustomButton(
              title: 'Skip',
              outline: true,
              color: Colors.white,
              onTap: controller.loginPage,
            ).paddingOnly(left: 22.kw, right: 22, bottom: 58.kh),
          ],
        ),
      ),
    );
  }
}
