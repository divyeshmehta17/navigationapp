import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mopedsafe/app/components/common_image_view.dart';
import 'package:mopedsafe/app/components/customappbar.dart';
import 'package:mopedsafe/app/components/customtextfield.dart';
import 'package:mopedsafe/app/constants/image_constant.dart';
import 'package:mopedsafe/app/routes/app_pages.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/custom_button.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';
import 'package:mopedsafe/app/services/text_style_util.dart';

import '../controllers/setprofiledetails_controller.dart';

class SetprofiledetailsView extends GetView<SetprofiledetailsController> {
  const SetprofiledetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SetprofiledetailsController());

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Set Profile Details',
        centerTile: true,
        leading: Get.previousRoute == Routes.PROFILE
            ? const SizedBox()
            : IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  Get.back();
                },
              ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Obx(() => controller.profileimage.value == null ||
                          Get.previousRoute == Routes.PROFILE
                      ? Container(
                          height: 120.kh,
                          width: 120.kw,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade300,
                              border: Border.all(
                                  width: 3.kw,
                                  color: context.profilePicBorder)),
                          child: CommonImageView(
                            svgPath: ImageConstant.svgdummyperson,
                          ).paddingAll(20.kw),
                        ).paddingOnly(top: 18.kh)
                      : Container(
                          height: 120.kh,
                          width: 120.kw,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(controller
                                    .profileimage.value!.files![0]!.url
                                    .toString())),
                          ),
                          child: controller.loading.value == true
                              ? CircularProgressIndicator()
                              : SizedBox(),
                        )).paddingOnly(top: 18.kh),
                  GestureDetector(
                    onTap: () {
                      controller.pickImage();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                              width: 3.kw, color: context.profilePicBorder)),
                      child: Icon(Icons.edit_outlined,
                              size: 20.kw, color: context.profilePicBorder)
                          .paddingAll(5.kw),
                    ),
                  ),
                ],
              ),
            ),
            20.kheightBox,
            CustomTextField(
              hintText: 'Enter your full name',
              controller: controller.nameController,
            ),
            20.kheightBox,
            CustomTextField(
              hintText: '1/1/1998',
              controller: controller.dobController,
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    controller.dobController.text = formattedDate;
                  }
                },
              ),
            ),
            20.kheightBox,
            CustomTextField(
              hintText: 'xyz@gmail.com',
              controller: controller.emailController,
              suffixIcon: TextButton(
                child: Text(
                  'Verify',
                  style: TextStyleUtil.poppins600(
                      fontSize: 14.kh, color: context.brandColor1),
                ),
                onPressed: () async {},
              ),
            ),
            250.kheightBox,
            CustomButton(
              onTap: () {
                controller.signUpApi(
                    name: controller.nameController.text,
                    dob: controller.dobController.text,
                    email: controller.emailController.text,
                    key: controller.profileimage.value == null
                        ? ''
                        : controller.profileimage.value!.files![0]!.key
                            .toString(),
                    url: controller.profileimage.value == null
                        ? ''
                        : controller.profileimage.value!.files![0]!.url
                            .toString(),
                    isEmailVerified: false);
              },
              title: 'Submit',
              textcolor: Colors.white,
              color: context.brandColor1,
            ),
          ],
        ).paddingOnly(left: 16.kw, right: 16.kw),
      ),
    );
  }
}
