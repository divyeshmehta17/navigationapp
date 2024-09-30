import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';

import '../../../components/common_image_view.dart';
import '../../../constants/image_constant.dart';
import '../../../services/text_style_util.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return Scaffold(
      backgroundColor: context.brandColor1,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonImageView(
              svgPath: ImageConstant.svgappIcon,
            ).paddingOnly(bottom: 24.kh),
            Text("Navigation App",
                style: TextStyleUtil.poppins500(
                    fontSize: 36.kh, color: Colors.white))
          ],
        ),
      ),
    );
  }
}
