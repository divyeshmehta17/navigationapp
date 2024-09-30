import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';

import '../../../components/common_image_view.dart';
import '../../../components/navigationAppButton.dart';
import '../../../constants/image_constant.dart';
import '../../../services/auth.dart';
import '../../../services/text_style_util.dart';
import '../controllers/phonelogin_controller.dart';

class PhoneloginView extends GetView<PhoneloginController> {
  const PhoneloginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonImageView(
              imagePath: ImageConstant.pngsmartphone,
            ),
            Text(
              "Let’s start with your number",
              style: TextStyleUtil.poppins700(
                fontSize: 22.kh,
                color: Colors.black,
              ),
            ).paddingOnly(top: 8.kh, bottom: 8.kh),
            Text(
              "We’ll check if you already have an account. If not we’ll create a new one.",
              textAlign: TextAlign.center,
              style: TextStyleUtil.poppins400(
                fontSize: 14.kh,
                color: Colors.black,
              ),
            ),
            IntlPhoneField(
              showCountryFlag: true,
              showDropdownIcon: false,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Phone Number',
                hintStyle: TextStyleUtil.poppins400(
                  fontSize: 16.kh,
                  color: context.mediumGrey,
                ),
                filled: true,
                contentPadding: EdgeInsets.all(13.kw),
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: context.lightGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: context.lightGrey),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
              initialCountryCode: 'IN',
              onChanged: (number) {
                controller.phoneNumber.value = number.completeNumber;
                number.completeNumber.isNotEmpty &&
                        number.completeNumber != '${number.countryCode}'
                    ? controller.isEnabled.value = true
                    : controller.isEnabled.value = false;
              },
            ).paddingOnly(top: 16.kh),
            Obx(
              () => NavigationAppButton(
                label: 'Continue',
                onTap: () {
                  // controller.isEnabled.value == true
                  //     ?
                  Get.find<Auth>().mobileLoginOtp(
                      phoneno: controller.phoneNumber.value,
                      showLoading: true,
                      arguments: {'phoneNumber': controller.phoneNumber.value});
                  //     : null;
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
              ).paddingOnly(top: 50.kh),
            ),
          ],
        ).paddingOnly(left: 16.kw, right: 16.kw),
      ),
    );
  }
}
