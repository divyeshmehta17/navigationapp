import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';

import '../../../constants/image_constant.dart';
import '../../../services/text_style_util.dart';
import '../controllers/customnavigationbar_controller.dart';

class CustomnavigationbarView extends GetView<CustomnavigationbarController> {
  const CustomnavigationbarView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            selectedItemColor: context.brandColor1,
            currentIndex: controller.selectedPageIndex.value,
            onTap: (index) => controller.changePage(index),
            showUnselectedLabels: true,
            showSelectedLabels: true,
            unselectedItemColor: context.lightGrey,
            selectedLabelStyle: TextStyleUtil.poppins500(
                fontSize: 10.kh, color: context.brandColor1),
            type: BottomNavigationBarType.fixed,
            unselectedLabelStyle:
                TextStyleUtil.poppins500(fontSize: 10.kh, color: Colors.red),
            items: [
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    ImageConstant.svgexploreIcon,
                  ),
                  activeIcon: SvgPicture.asset(
                    ImageConstant.svgexploreIcon,
                    color: context.brandColor1,
                  ),
                  label: 'Explore'),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    ImageConstant.svgsavedIcons,
                  ),
                  activeIcon: SvgPicture.asset(
                    ImageConstant.svgsavedIcons,
                    color: context.brandColor1,
                  ),
                  label: 'Saved'),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    ImageConstant.svgcommunityIcon,
                  ),
                  activeIcon: SvgPicture.asset(
                    ImageConstant.svgcommunityIcon,
                    color: context.brandColor1,
                  ),
                  label: 'Community'),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    ImageConstant.svgprofileIcon,
                  ),
                  activeIcon: SvgPicture.asset(
                    ImageConstant.svgprofileIcon,
                    color: context.brandColor1,
                  ),
                  label: 'Profile')
            ],
          ),
        ),
        body: Obx(() => controller.pages[controller.selectedPageIndex.value]));
  }
}
