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
          child: Column(
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
                        style: TextStyleUtil.poppins400(fontSize: 14.kh)),
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
                        style: TextStyleUtil.poppins400(fontSize: 14.kh)),
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
                        style: TextStyleUtil.poppins400(fontSize: 14.kh)),
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
                        style: TextStyleUtil.poppins400(fontSize: 14.kh)),
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
                        style: TextStyleUtil.poppins400(fontSize: 14.kh)),
                  )
                ],
              ).paddingOnly(top: 24.kh),
              Text("Enjoy the full benefits of the app with MopedGPS+, start with a 07 days free trial.",
                      textAlign: TextAlign.center,
                      style: TextStyleUtil.poppins400(fontSize: 12.kh))
                  .paddingOnly(top: 28.kh, bottom: 20.kh),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: context.brandColor1),
                    borderRadius: BorderRadius.circular(8.kw)),
                child: Row(
                  children: [
                    Container(
                      height: 16.kh,
                      width: 16.kw,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: context.brandColor1, width: 2.kw)),
                    ).paddingOnly(right: 16.kw),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("6 months of MopedGPS+",
                            style: TextStyleUtil.poppins500(
                              fontSize: 14.kh,
                            )),
                        Text("\$300 at \$25 per month of service",
                            style: TextStyleUtil.poppins400(fontSize: 12.kh))
                      ],
                    )
                  ],
                ).paddingOnly(left: 16.kw, top: 8.kh, bottom: 8.kh),
              ),
              Text("or",
                  style: TextStyleUtil.poppins500(
                    fontSize: 12.kh,
                  )).paddingAll(8.kw),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: context.brandColor1),
                    borderRadius: BorderRadius.circular(8.kw)),
                child: Row(
                  children: [
                    Container(
                      height: 16.kh,
                      width: 16.kw,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: context.brandColor1, width: 2.kw)),
                    ).paddingOnly(right: 16.kw),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Monthly subscription of MopedGPS+",
                            style: TextStyleUtil.poppins500(
                              fontSize: 14.kh,
                            )),
                        Text("\$40 per month of service",
                            style: TextStyleUtil.poppins400(fontSize: 12.kh))
                      ],
                    )
                  ],
                ).paddingOnly(left: 16.kw, top: 8.kh, bottom: 8.kh),
              ),
              Obx(() {
                return controller.isSubscribed.value == false
                    ? NavigationAppButton(
                        label: 'Try Free For 7 Days',
                        onTap: () async {
                          if (controller.productList.isNotEmpty) {
                            controller
                                .buySubscription(controller.productList[0]);
                          } else {
                            print('No products available');
                          }
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
                              style: TextStyleUtil.poppins600(fontSize: 18.kh),
                            ),
                            content: Text(
                                "Are you sure you want to cancel your subscription? You will lose all the premium benefits.",
                                style:
                                    TextStyleUtil.poppins400(fontSize: 14.kh)),
                            actions: [
                              Row(
                                children: [
                                  NavigationAppButton(label: 'Stay'),
                                  NavigationAppButton(
                                    label: 'Cancel',
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(48.kw),
                                    textStyle: TextStyleUtil.poppins600(
                                        fontSize: 16.kh, color: Colors.white),
                                    leadinglabelpadding: EdgeInsets.only(
                                        left: 12.kh,
                                        right: 12.kh,
                                        top: 12.kh,
                                        bottom: 12.kh),
                                    onTap: () {
                                      Get.find<ProfileController>()
                                          .isSubscribed
                                          .value = false;
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
        ));
  }
}
