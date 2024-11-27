import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/components/common_image_view.dart';
import 'package:mopedsafe/app/components/customappbar.dart';
import 'package:mopedsafe/app/constants/image_constant.dart';
import 'package:mopedsafe/app/modules/profile/controllers/profile_controller.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';
import 'package:mopedsafe/app/services/text_style_util.dart';

import '../../../components/navigationAppButton.dart';
import '../controllers/subscribescreen_controller.dart';

class SubscribescreenView extends GetView<SubscribescreenController> {
  const SubscribescreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(Get.find<ProfileController>().isSubscribed);
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Buy Moped GPS+',
        ),
        body: SingleChildScrollView(
          child: Obx(
            () => controller.productList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      CommonImageView(
                        svgPath: ImageConstant.svgsubscribe,
                      ),
                      Row(
                        children: [
                          CommonImageView(
                            svgPath: ImageConstant.svgLocationIcon,
                          ).paddingOnly(right: 8.kw),
                          Expanded(
                            child: Text(
                                "Access to optimized routes specifically tailored for moped drivers",
                                style:
                                    TextStyleUtil.poppins400(fontSize: 14.kh)),
                          )
                        ],
                      ).paddingOnly(top: 24.kh),
                      Row(
                        children: [
                          CommonImageView(
                            svgPath: ImageConstant.svgLocationIcon,
                          ).paddingOnly(right: 8.kw),
                          Expanded(
                            child: Text(
                                "Access to optimized routes specifically tailored for moped drivers",
                                style:
                                    TextStyleUtil.poppins400(fontSize: 14.kh)),
                          )
                        ],
                      ).paddingOnly(top: 24.kh),
                      Row(
                        children: [
                          CommonImageView(
                            svgPath: ImageConstant.svgLocationIcon,
                          ).paddingOnly(right: 8.kw),
                          Expanded(
                            child: Text(
                                "Get turn by turn navigation with voice assistance.",
                                style:
                                    TextStyleUtil.poppins400(fontSize: 14.kh)),
                          )
                        ],
                      ).paddingOnly(top: 24.kh),
                      Row(
                        children: [
                          CommonImageView(
                            svgPath: ImageConstant.svgLocationIcon,
                          ).paddingOnly(right: 8.kw),
                          Expanded(
                            child: Text(
                                "Access to community, including the ability to post or report incident in the community",
                                style:
                                    TextStyleUtil.poppins400(fontSize: 14.kh)),
                          )
                        ],
                      ).paddingOnly(top: 24.kh),
                      Row(
                        children: [
                          CommonImageView(
                            svgPath: ImageConstant.svgLocationIcon,
                          ).paddingOnly(right: 8.kw),
                          Expanded(
                            child: Text("Ability to make offline routes.",
                                style:
                                    TextStyleUtil.poppins400(fontSize: 14.kh)),
                          )
                        ],
                      ).paddingOnly(top: 24.kh),
                      Text("Enjoy the full benefits of the app with MopedGPS+, start with a 07 days free trial.",
                              textAlign: TextAlign.center,
                              style: TextStyleUtil.poppins400(fontSize: 12.kh))
                          .paddingOnly(top: 28.kh, bottom: 20.kh),
                      Obx(() {
                        return Column(
                          children: [
                            // First subscription option (index 0)
                            GestureDetector(
                              onTap: () {
                                controller.selectedSubscriptionIndex.value = 0;
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: context.brandColor1),
                                  borderRadius: BorderRadius.circular(8.kw),
                                ),
                                child: Row(
                                  children: [
                                    controller.selectedSubscriptionIndex
                                                .value ==
                                            0
                                        ? Icon(
                                            Icons.radio_button_checked_outlined,
                                            color: context.brandColor1,
                                          ).paddingOnly(right: 16.kw)
                                        : Icon(
                                            Icons.radio_button_off_rounded,
                                            color: context.brandColor1,
                                          ).paddingOnly(right: 16.kw),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            controller.productList[0].productId
                                                .toString(),
                                            style: TextStyleUtil.poppins500(
                                              fontSize: 14.kh,
                                            )),
                                        Text(
                                            "${controller.productList[0].localizedPrice} at ${controller.getFormattedDividedPrice(controller.productList[0], 6)} per month of service",
                                            style: TextStyleUtil.poppins400(
                                                fontSize: 12.kh))
                                      ],
                                    ),
                                  ],
                                ).paddingOnly(
                                    left: 16.kw, top: 8.kh, bottom: 8.kh),
                              ),
                            ),
                            Text("or",
                                style: TextStyleUtil.poppins500(
                                  fontSize: 12.kh,
                                )).paddingAll(8.kw),

                            // Second subscription option (index 1)
                            GestureDetector(
                              onTap: () {
                                controller.selectedSubscriptionIndex.value = 1;
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: context.brandColor1),
                                  borderRadius: BorderRadius.circular(8.kw),
                                ),
                                child: Row(
                                  children: [
                                    controller.selectedSubscriptionIndex
                                                .value ==
                                            1
                                        ? Icon(
                                            Icons.radio_button_checked_outlined,
                                            color: context.brandColor1,
                                          ).paddingOnly(right: 16.kw)
                                        : Icon(
                                            Icons.radio_button_off_rounded,
                                            color: context.brandColor1,
                                          ).paddingOnly(right: 16.kw),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            controller.productList[1].productId
                                                .toString(),
                                            style: TextStyleUtil.poppins500(
                                              fontSize: 14.kh,
                                            )),
                                        Text(
                                            "${controller.productList[1].localizedPrice} per month of service",
                                            style: TextStyleUtil.poppins400(
                                                fontSize: 12.kh))
                                      ],
                                    ),
                                  ],
                                ).paddingOnly(
                                    left: 16.kw, top: 8.kh, bottom: 8.kh),
                              ),
                            ),
                          ],
                        );
                      }),

                      // Buy button
                      Obx(() {
                        return controller.isSubscribed.value == false
                            ? NavigationAppButton(
                                label: 'Try Free For 7 Days',
                                onTap: () async {
                                  // Use the selected subscription index to buy the appropriate subscription
                                  String selectedProductId = controller
                                      .productList[controller
                                          .selectedSubscriptionIndex.value]
                                      .productId
                                      .toString();
                                  print(selectedProductId);
                                  controller.buySubscription(selectedProductId);
                                },
                                color: context.brandColor1,
                                borderRadius: BorderRadius.circular(48.kw),
                                textStyle: TextStyleUtil.poppins600(
                                    fontSize: 16.kh, color: Colors.white),
                                leadinglabelpadding:
                                    EdgeInsets.only(top: 12.kh, bottom: 12.kh),
                              ).paddingOnly(top: 20.kh, bottom: 20.kh)
                            : NavigationAppButton(
                                label: 'Cancel Subscription',
                                textStyle: TextStyleUtil.poppins600(
                                    fontSize: 16.kh, color: Colors.red),
                                onTap: () async {
                                  Get.dialog(AlertDialog(
                                    title: Text(
                                      'Cancel subscription ?',
                                      style: TextStyleUtil.poppins600(
                                          fontSize: 18.kh),
                                    ),
                                    content: Text(
                                        "Are you sure you want to cancel your subscription? You will lose all the premium benefits.",
                                        style: TextStyleUtil.poppins400(
                                            fontSize: 14.kh)),
                                    actions: [
                                      Row(
                                        children: [
                                          const NavigationAppButton(
                                              label: 'Stay'),
                                          NavigationAppButton(
                                            label: 'Cancel',
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(48.kw),
                                            textStyle: TextStyleUtil.poppins600(
                                                fontSize: 16.kh,
                                                color: Colors.white),
                                            leadinglabelpadding:
                                                EdgeInsets.only(
                                                    left: 12.kh,
                                                    right: 12.kh,
                                                    top: 12.kh,
                                                    bottom: 12.kh),
                                            onTap: () {
                                              Get.find<ProfileController>()
                                                  .isSubscribed
                                                  .value = false;
                                              Get.back();
                                              controller.cancelSubscription();
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ));
                                },
                              ).paddingOnly(top: 20.kh, bottom: 20.kh);
                      }),
                    ],
                  ).paddingOnly(left: 16.kw, right: 16.kw),
          ),
        ));
  }
}
