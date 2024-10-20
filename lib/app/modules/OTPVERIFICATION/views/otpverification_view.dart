import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../components/common_image_view.dart';
import '../../../components/customappbar.dart';
import '../../../components/navigationAppButton.dart';
import '../../../constants/image_constant.dart';
import '../../../routes/app_pages.dart';
import '../../../services/text_style_util.dart';
import '../controllers/otpverification_controller.dart';

class OtpverificationView extends GetView<OtpverificationController> {
  const OtpverificationView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => OtpverificationController());
    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          TextButton(
              onPressed: () {
                Get.toNamed(Routes.PHONELOGIN);
              },
              child: Text(
                'Change Number',
                style: TextStyleUtil.poppins500(
                    fontSize: 16.kh, color: context.brandColor1),
              ))
        ],
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text("Enter authentication code",
                textAlign: TextAlign.center,
                style: TextStyleUtil.poppins700(
                    fontSize: 22.kh, color: Colors.black))
            .paddingOnly(top: 40.kh, bottom: 8.kh),
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                  style: TextStyleUtil.poppins500(
                      fontSize: 14.kh, color: Colors.black),
                  text:
                      'Enter the 6-digit code that we have sent via the phone number '),
              TextSpan(
                  style: TextStyleUtil.poppins700(
                      fontSize: 14.kh, color: Colors.black),
                  text: controller.phoneArgument['phoneNumber'])
            ])),
        PinCodeTextField(
          length: 6,
          obscureText: false,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
              shape: PinCodeFieldShape.circle,
              fieldHeight: 48.kh,
              fieldWidth: 48.kw,
              activeColor: Colors.blue,
              inactiveColor: context.lightGrey),
          animationDuration: const Duration(milliseconds: 300),
          textStyle: TextStyleUtil.poppins400(
              fontSize: 16.kh, color: context.brandColor1),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            controller.otp.value = value;
            value.length == 6
                ? controller.isEnabled.value = true
                : controller.isEnabled.value = false;
          },
          appContext: context,
        ).paddingOnly(top: 32.kh, bottom: 93.kh),
        Obx(
          () => NavigationAppButton(
            label: 'Continue',
            onTap: () async {
              if (controller.isEnabled.value == true) {
                controller.verifyOtp();
              }
            },
            color: controller.isEnabled.value == false
                ? context.lightGrey
                : context.brandColor1,
            textStyle: TextStyleUtil.poppins600(
              fontSize: 16.kh,
              color: controller.isEnabled.value == false
                  ? context.Grey
                  : Colors.white,
            ),
            leadinglabelpadding: EdgeInsets.symmetric(vertical: 12.kh),
            borderRadius: BorderRadius.circular(48.kw),
          ),
        ),
        TextButton(
            onPressed: () {},
            child: Text("Resend code",
                style: TextStyleUtil.poppins600(
                    fontSize: 16.kh, color: context.brandColor1)))
      ]).paddingOnly(left: 16.kw, right: 16.kw),
    );
  }
}

class locationAccessSplashScreen extends StatelessWidget {
  const locationAccessSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.brandColor1,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonImageView(
              svgPath: ImageConstant.svglocationaccess,
            ),
            Text("📍 Grant Location Access",
                    textAlign: TextAlign.center,
                    style: TextStyleUtil.poppins700(fontSize: 24.kh))
                .paddingOnly(top: 20.kh, bottom: 20.kh),
            Text("To tailor your route and ensure a safe journey, MopedSafe needs access to your location. We respect your privacy and only use it for navigation purposes.",
                    textAlign: TextAlign.center,
                    style: TextStyleUtil.poppins500(fontSize: 14.kh))
                .paddingOnly(bottom: 85.kh),
            NavigationAppButton(
              label: 'Allow Access',
              onTap: () {
                Permission.location
                    .request()
                    .isGranted
                    .then((value) => Get.toNamed(Routes.CUSTOMNAVIGATIONBAR));
              },
              color: Colors.white,
              borderRadius: BorderRadius.circular(48.kw),
              leadinglabelpadding: EdgeInsets.only(top: 12.kh, bottom: 12.kh),
              textStyle: TextStyleUtil.poppins600(
                  fontSize: 16.kh, color: Colors.black),
            )
          ],
        ).paddingOnly(left: 16.kw, right: 16.kw, top: 166.kh),
      ),
    );
  }
}
