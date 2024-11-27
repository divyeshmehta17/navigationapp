import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/components/customtextfield.dart';
import 'package:mopedsafe/app/components/navigationAppButton.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';
import 'package:mopedsafe/app/services/text_style_util.dart';

import '../../../components/customappbar.dart';
import '../../../customwidgets/globalalertdialog.dart';
import '../controllers/contactus_controller.dart';

class ContactusView extends GetView<ContactusController> {
  const ContactusView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'Contact Us',
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'Title?',
                        style: TextStyleUtil.poppins500(fontSize: 12.kh)),
                    TextSpan(
                        text: '*',
                        style: TextStyleUtil.poppins500(
                            fontSize: 12.kh, color: Colors.red))
                  ])),
                  Obx(
                    () => Text(
                      '${controller.titleText.value.length}/20',
                      style: TextStyleUtil.poppins500(
                        fontSize: 12.kh,
                        color: context.darkGrey,
                      ),
                    ),
                  ),
                ],
              ).paddingOnly(top: 40.kh, bottom: 8.kh),
              CustomTextField(
                maxLines: 1, //or null
                controller: controller.titleController,
                hintText: 'Eg. Wrong route shown',
                hintStyle: TextStyleUtil.poppins500(
                  fontSize: 14.kh,
                  color: context.darkGrey,
                ),
                onChanged: (value) {
                  controller.titleText.value = value;
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                      20), // set limit according to your requirment
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'What do you want to say?',
                        style: TextStyleUtil.poppins500(fontSize: 12.kh)),
                    TextSpan(
                        text: '*',
                        style: TextStyleUtil.poppins500(
                            fontSize: 12.kh, color: Colors.red))
                  ])),
                  Obx(
                    () => Text(
                      '${controller.descriptionText.value.length}/150',
                      style: TextStyleUtil.poppins500(
                        fontSize: 12.kh,
                        color: context.darkGrey,
                      ),
                    ),
                  ),
                ],
              ).paddingOnly(top: 21.kh, bottom: 8.kh),
              CustomTextField(
                maxLines: 5,
                controller: controller.questionController,
                hintText: 'Write here',
                hintStyle: TextStyleUtil.poppins500(
                  fontSize: 14.kh,
                  color: context.darkGrey,
                ),
                onChanged: (value) {
                  controller.descriptionText.value = value;
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                      150), // set limit according to your requirment
                ],
              ),
              NavigationAppButton(
                label: 'Submit',
                onTap: () {
                  showGlobalDialog(
                      title: controller.titleController.text,
                      content: 'Are You Sure You Want to Submit',
                      onConfirm: () {
                        controller.ContactUsApi(
                            title: controller.titleController.text,
                            context: context,
                            description: controller.questionController.text);
                      },
                      context: context);
                },
                textStyle: TextStyleUtil.poppins500(
                  fontSize: 16.kh,
                  color: Colors.white,
                ),
                color: context.brandColor1,
                leadinglabelpadding: EdgeInsets.symmetric(vertical: 12.kh),
                borderRadius: BorderRadius.circular(48.kw),
              ).paddingOnly(top: 100.kh, bottom: 8.kh),
            ],
          ).paddingOnly(left: 16.kw, right: 16.kw),
        ));
  }
}
