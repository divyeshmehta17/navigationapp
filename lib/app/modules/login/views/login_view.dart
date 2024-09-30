import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/services/auth.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';

import '../../../components/common_image_view.dart';
import '../../../components/navigationAppButton.dart';
import '../../../constants/image_constant.dart';
import '../../../routes/app_pages.dart';
import '../../../services/text_style_util.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          CommonImageView(
            svgPath: ImageConstant.svgwelcomescreen,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.kw))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text("Welcome",
                          style: TextStyleUtil.poppins700(
                              fontSize: 28.kh, color: Colors.black)),
                    ).paddingOnly(top: 24.kh),
                    Center(
                      child: Text("Choose one from the following options",
                          style: TextStyleUtil.poppins400(
                              fontSize: 12.kh, color: Colors.black)),
                    ),
                    NavigationAppButton(
                      onTap: () {
                        Get.find<Auth>().google();
                      },
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(36.kw),
                      border: Border.all(color: context.brandColor1),
                      svgPath: ImageConstant.svggoogle,
                      label: 'Google',
                      leadingiconpadding: EdgeInsets.only(
                          right: 100.kw,
                          left: 16.kw,
                          top: 12.kh,
                          bottom: 12.kh),
                      leadinglabelpadding: EdgeInsets.only(
                          right: 130.kw, top: 12.kh, bottom: 12.kh),
                      textStyle: TextStyleUtil.poppins600(
                          fontSize: 16.kh, color: context.brandColor1),
                    ).paddingOnly(
                      top: 24.kh,
                    ),
                    NavigationAppButton(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(36.kw),
                      border: Border.all(color: context.brandColor1),
                      svgPath: ImageConstant.svgapple,
                      label: 'Apple',
                      leadingiconpadding: EdgeInsets.only(
                          right: 100.kw,
                          left: 16.kw,
                          top: 12.kh,
                          bottom: 12.kh),
                      leadinglabelpadding: EdgeInsets.only(
                          right: 130.kw, top: 12.kh, bottom: 12.kh),
                      textStyle: TextStyleUtil.poppins600(
                          fontSize: 16.kh, color: context.brandColor1),
                    ).paddingOnly(
                      top: 16.kh,
                    ),
                    NavigationAppButton(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(36.kw),
                      border: Border.all(color: context.brandColor1),
                      svgPath: ImageConstant.svgsnapchat,
                      label: 'Snapchat',
                      leadingiconpadding: EdgeInsets.only(
                          right: 100.kw,
                          left: 16.kw,
                          top: 12.kh,
                          bottom: 12.kh),
                      leadinglabelpadding: EdgeInsets.only(
                          right: 110.kw, top: 12.kh, bottom: 12.kh),
                      textStyle: TextStyleUtil.poppins600(
                          fontSize: 16.kh, color: context.brandColor1),
                    ).paddingOnly(
                      top: 16.kh,
                    ),
                    NavigationAppButton(
                      onTap: () {
                        Get.toNamed(Routes.PHONELOGIN);
                      },
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(36.kw),
                      border: Border.all(color: context.brandColor1),
                      svgPath: ImageConstant.svgphone,
                      label: 'Phone',
                      leadingiconpadding: EdgeInsets.only(
                          right: 100.kw,
                          left: 16.kw,
                          top: 12.kh,
                          bottom: 12.kh),
                      leadinglabelpadding: EdgeInsets.only(
                          right: 130.kw, top: 12.kh, bottom: 12.kh),
                      textStyle: TextStyleUtil.poppins600(
                          fontSize: 16.kh, color: context.brandColor1),
                    ).paddingOnly(top: 16.kh, bottom: 16.kh),
                    TextButton(
                        onPressed: () {
                          Get.toNamed(Routes.CUSTOMNAVIGATIONBAR);
                        },
                        child: Text("Skip for now",
                            style: TextStyleUtil.poppins600(
                                fontSize: 14.kh, color: Colors.black))),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text:
                                  'By continuing, you automatically accept our ',
                              style: TextStyleUtil.poppins400(
                                  fontSize: 10.kh, color: Colors.black)),
                          TextSpan(
                              text:
                                  'Terms and conditions, Privacy Policy, Cookies Policy.',
                              style: TextStyleUtil.poppins400(
                                  fontSize: 10.kh,
                                  color: Colors.black,
                                  textDecoration: TextDecoration.underline)),
                        ],
                      ),
                    )
                  ],
                ).paddingOnly(left: 20.kw, right: 20.kw),
              ),
            ],
          ).paddingOnly(top: 330.kh)
        ],
      ),
    );
  }
}
