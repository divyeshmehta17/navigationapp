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
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            Text(
              'Enter your full name',
              style: TextStyleUtil.poppins500(fontSize: 12.kh),
            ),
            SizedBox(
              height: 45.kh,
              child: CustomTextField(
                controller: controller.nameController,
                decoration: InputDecoration(
                    hintText: 'Enter your full name',
                    hintStyle: TextStyleUtil.poppins400(
                        fontSize: 14.kh, color: context.darkGrey),
                    contentPadding: EdgeInsets.only(bottom: 24.kh, left: 18.kw),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.kw)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.kw),
                        borderSide: BorderSide(color: context.textboxGrey)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.kw),
                        borderSide: BorderSide(color: context.textboxGrey)),
                    filled: true,
                    fillColor: Colors.white),
              ),
            ),
            20.kheightBox,
            Text(
              'D.O.B',
              style: TextStyleUtil.poppins500(fontSize: 12.kh),
            ),
            CustomTextField(
              controller: controller.dobController,
              decoration: InputDecoration(
                  hintText: '1/1/1998',
                  hintStyle: TextStyleUtil.poppins400(
                      fontSize: 14.kh, color: context.darkGrey),
                  contentPadding: EdgeInsets.only(bottom: 24.kh, left: 18.kw),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.calendar_month,
                    ),
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
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.kw)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.kw),
                      borderSide: BorderSide(color: context.textboxGrey)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.kw),
                      borderSide: BorderSide(color: context.textboxGrey)),
                  filled: true,
                  fillColor: Colors.white),
            ),
            Text(
              'Email',
              style: TextStyleUtil.poppins500(fontSize: 12.kh),
            ),
            20.kheightBox,
            CustomTextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                  hintText: 'xyz@gmail.com',
                  suffixIcon: TextButton(
                    onPressed: () {
                      controller.sendEmailVerification();
                    },
                    child: Text(
                      'Verify',
                      style: TextStyleUtil.poppins500(
                          fontSize: 14.kh, color: context.brandColor1),
                    ),
                  ),
                  hintStyle: TextStyleUtil.poppins400(
                      fontSize: 14.kh, color: context.darkGrey),
                  contentPadding: EdgeInsets.only(bottom: 24.kh, left: 18.kw),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.kw)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.kw),
                      borderSide: BorderSide(color: context.textboxGrey)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.kw),
                      borderSide: BorderSide(color: context.textboxGrey)),
                  filled: true,
                  fillColor: Colors.white),
              suffixIcon: TextButton(
                child: Text(
                  'Verify',
                  style: TextStyleUtil.poppins600(
                      fontSize: 14.kh, color: context.brandColor1),
                ),
                onPressed: () async {},
              ),
            ),
            Text(
              'Moped Speed Limit',
              style: TextStyleUtil.poppins500(fontSize: 12.kh),
            ),
            10.kheightBox,
            Obx(() => Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.kw),
                      color: Colors.white,
                      border: Border.all(color: context.textboxGrey)),
                  child: DropdownButton<String>(
                    value: controller.selectedSpeedLimit.value,
                    borderRadius: BorderRadius.circular(18.kw),
                    hint: Text(
                      'Select speed limit',
                      style: TextStyle(color: context.textboxGrey),
                    ),
                    padding: EdgeInsets.only(left: 18.kw),
                    items: [
                      'Max Speed 25kmph',
                      'Max Speed 30 kmph',
                      'Max Speed 45 mph'
                    ]
                        .map((speed) => DropdownMenuItem(
                              value: speed,
                              child: Text(speed,
                                  style: TextStyleUtil.poppins400(
                                      fontSize: 14.kh,
                                      color: context.darkGrey)),
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      controller.selectedSpeedLimit.value = newValue!;
                    },
                    isExpanded: true,
                  ),
                )),
            200.kheightBox,
            CustomButton(
              onTap: () {
                // Validate inputs
                if (controller.nameController.text.trim().isEmpty) {
                  Get.snackbar('Validation Error', 'Name cannot be empty',
                      backgroundColor: Colors.red, colorText: Colors.white);
                  return;
                }

                if (controller.dobController.text.trim().isEmpty) {
                  Get.snackbar(
                      'Validation Error', 'Date of Birth cannot be empty',
                      backgroundColor: Colors.red, colorText: Colors.white);
                  return;
                }

                if (controller.emailController.text.trim().isEmpty) {
                  Get.snackbar('Validation Error', 'Email cannot be empty',
                      backgroundColor: Colors.red, colorText: Colors.white);
                  return;
                }

                if (controller.selectedSpeedLimit.value.trim().isEmpty) {
                  Get.snackbar('Validation Error', 'Max speed cannot be empty',
                      backgroundColor: Colors.red, colorText: Colors.white);
                  return;
                }

                // Extracting numeric value from selected speed limit
                final numericSpeed = RegExp(r'\d+')
                        .firstMatch(controller.selectedSpeedLimit.value)
                        ?.group(0) ??
                    '0';

                // Call the signUp API
                controller.signUpApi(
                  name: controller.nameController.text,
                  maxSpeed: numericSpeed, // Pass only the numeric part
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
                  isEmailVerified: false,
                );
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
