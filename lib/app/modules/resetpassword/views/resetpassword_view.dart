import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/components/customtextfield.dart';
import 'package:mopedsafe/app/components/navigationAppButton.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';
import 'package:mopedsafe/app/services/text_style_util.dart';

import '../../../components/customappbar.dart';
import '../controllers/resetpassword_controller.dart';

class ResetpasswordView extends GetView<ResetpasswordController> {
  const ResetpasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'Push Notification',
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Old Password",
                      style: TextStyleUtil.poppins500(fontSize: 12.kh))
                  .paddingOnly(bottom: 4.kh),
              CustomTextField(
                suffixIcon: const Icon(CupertinoIcons.eye),
                controller: controller.oldPasswordController,
              ),
              Text("New Password",
                      style: TextStyleUtil.poppins500(fontSize: 12.kh))
                  .paddingOnly(top: 21.kh, bottom: 4.kh),
              CustomTextField(
                suffixIcon: const Icon(CupertinoIcons.eye),
                controller: controller.newPasswordController,
              ),
              Text("Confirm Password",
                      style: TextStyleUtil.poppins500(fontSize: 12.kh))
                  .paddingOnly(top: 21.kh, bottom: 4.kh),
              CustomTextField(
                suffixIcon: const Icon(CupertinoIcons.eye),
                controller: controller.confirmPasswordController,
              ).paddingOnly(bottom: 100.kh),
              NavigationAppButton(
                label: 'Submit',
                onTap: () async {},
                color: context.brandColor1,
                borderRadius: BorderRadius.circular(48.kw),
                textStyle: TextStyleUtil.poppins600(
                    fontSize: 16.kh, color: Colors.white),
                leadinglabelpadding: EdgeInsets.only(top: 12.kh, bottom: 12.kh),
              ),
            ],
          ).paddingOnly(left: 16.kw, right: 16.kw, top: 40.kh),
        ));
  }
}
