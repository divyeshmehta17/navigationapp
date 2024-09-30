import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';
import 'package:mopedsafe/app/services/text_style_util.dart';

import '../../../components/customappbar.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Push Notification',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Navigational",
                    style: TextStyleUtil.poppins400(fontSize: 14.kh)),
                SizedBox(
                  height: 28.kh,
                  width: 40.kw,
                  child: Obx(() => FittedBox(
                        fit: BoxFit.fill,
                        child: Switch(
                          value: controller.navigational.value,
                          inactiveTrackColor: context.inactiveColor,
                          onChanged: (value) => controller.toggleNavigational(),
                        ),
                      )),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Promotional",
                    style: TextStyleUtil.poppins400(fontSize: 14.kh)),
                SizedBox(
                  height: 28.kh,
                  width: 40.kw,
                  child: Obx(() => FittedBox(
                        fit: BoxFit.fill,
                        child: Switch(
                          value: controller.promotional.value,
                          inactiveTrackColor: context.inactiveColor,
                          onChanged: (value) => controller.togglePromotional(),
                        ),
                      )),
                ),
              ],
            ).paddingOnly(top: 24.kh, bottom: 24.kh),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Alerts",
                    style: TextStyleUtil.poppins400(fontSize: 14.kh)),
                SizedBox(
                  height: 28.kh,
                  width: 40.kw,
                  child: Obx(() => FittedBox(
                        fit: BoxFit.fill,
                        child: Switch(
                          value: controller.alerts.value,
                          inactiveTrackColor: context.inactiveColor,
                          onChanged: (value) => controller.toggleAlerts(),
                        ),
                      )),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Community",
                    style: TextStyleUtil.poppins400(fontSize: 14.kh)),
                SizedBox(
                  height: 28.kh,
                  width: 40.kw,
                  child: Obx(() => FittedBox(
                        fit: BoxFit.fill,
                        child: Switch(
                          value: controller.community.value,
                          inactiveTrackColor: context.inactiveColor,
                          onChanged: (value) => controller.toggleCommunity(),
                        ),
                      )),
                ),
              ],
            ).paddingOnly(top: 24.kh, bottom: 24.kh),
          ],
        ).paddingOnly(left: 16.kw, right: 16.kw, top: 8.kh),
      ),
    );
  }
}
