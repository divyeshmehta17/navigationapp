import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/components/common_image_view.dart';
import 'package:mopedsafe/app/constants/image_constant.dart';
import 'package:mopedsafe/app/routes/app_pages.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';
import 'package:mopedsafe/app/services/text_style_util.dart';

import '../../../customwidgets/globalalertdialog.dart';
import '../../../customwidgets/profilepagewidgets.dart';
import '../../../services/auth.dart';
import '../../../services/userdataservice.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => UserService());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: Container(),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(
                () => buildProfileInfo(
                    context,
                    controller,
                    (ctrl) => ctrl.userDetails.value?.name ?? '',
                    (ctrl) => ctrl.userDetails.value?.email ?? '',
                    (ctrl) => ctrl.userDetails.value?.profilePic?.url ?? ''),
              ),
              SizedBox(height: 16.kh),
              Text('Moped GPS+',
                      style: TextStyleUtil.poppins500(
                          fontSize: 16.kh, color: context.brandColor1))
                  .paddingOnly(bottom: 16.kh),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: context.brandColor1, width: 2.kw),
                  boxShadow: [
                    BoxShadow(
                        color: context.brandColor1.withOpacity(0.6),
                        blurRadius: 0,
                        spreadRadius: 0),
                    const BoxShadow(
                        color: Colors.white, blurRadius: 19, spreadRadius: 5),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.kw),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.kh),
                      Row(
                        children: [
                          CommonImageView(
                              svgPath: ImageConstant.svgsubscribeIcon),
                          SizedBox(width: 8.kh),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Subscribe to Moped GPS+\nwith as low as 25\$ per month',
                                style: TextStyle(
                                    fontSize: 14.kh, color: Colors.black),
                              ),
                              SizedBox(height: 8.kh),
                              Obx(() => GestureDetector(
                                    onTap: () =>
                                        Get.toNamed(Routes.SUBSCRIBESCREEN),
                                    behavior: HitTestBehavior.translucent,
                                    child: Text(
                                      controller.isSubscribed.value == false
                                          ? 'Subscribe now'
                                          : 'Manage Subscription',
                                      style: TextStyle(
                                        fontSize: 14.kh,
                                        color: controller.isSubscribed.value ==
                                                false
                                            ? context.brandColor1
                                            : Colors.purple,
                                        decoration:
                                            controller.isSubscribed.value
                                                ? TextDecoration.underline
                                                : null,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              buildSectionTitle(context, "General"),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: context.mediumGrey),
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8.kw),
                      bottom: Radius.circular(8.kw)),
                ),
                child: Column(
                  children: [
                    buildProfileOption(context, 'Saved Routes', Routes.SAVED),
                    Divider(color: context.mediumGrey),
                    buildProfileOption(
                        context, 'Offline Routes', Routes.OFFLINEROUTES),
                  ],
                ),
              ),
              buildSectionTitle(context, "Settings"),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: context.mediumGrey),
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8.kw),
                      bottom: Radius.circular(8.kw)),
                ),
                child: Column(
                  children: [
                    buildProfileOption(
                        context, 'Notification', Routes.NOTIFICATION),
                    Divider(color: context.mediumGrey),
                    buildProfileOption(
                        context, 'Reset Password', Routes.RESETPASSWORD),
                  ],
                ),
              ),
              buildSectionTitle(context, "Help"),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: context.mediumGrey),
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8.kw),
                      bottom: Radius.circular(8.kw)),
                ),
                child: Column(
                  children: [
                    buildProfileOption(context, 'Contact Us', Routes.CONTACTUS),
                    Divider(color: context.mediumGrey),
                    buildProfileOption(context, 'Feedback', Routes.FEEDBACK),
                    Divider(color: context.mediumGrey),
                    buildProfileOption(
                        context, 'Terms of Use', Routes.TERMSANDCONDITION),
                    Divider(color: context.mediumGrey),
                    buildProfileOption(
                        context, 'Privacy Policy', Routes.PRIVACYPOLICY),
                    Divider(color: context.mediumGrey),
                    buildProfileOption(context, 'FAQs', Routes.FAQ),
                  ],
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  print(controller.userDetails.value!.profilePic!.url);
                  showGlobalDialog(
                    context: context,
                    title: 'Leaving too soon?',
                    content: 'Do you want to logout?',
                    onConfirm: () => Get.find<Auth>().logOutUser(),
                    confirmText: 'Logout',
                    cancelText: 'Stay',
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: context.mediumGrey),
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(8.kw),
                        bottom: Radius.circular(8.kw)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.logout_rounded,
                              color: context.darkGrey, size: 24.kh)
                          .paddingOnly(right: 8.kw),
                      const Text('Logout'),
                    ],
                  ).paddingSymmetric(horizontal: 6.kw, vertical: 8.kh),
                ).paddingOnly(top: 16.kh, bottom: 16.kh),
              ),
            ],
          ).paddingSymmetric(horizontal: 16.kw, vertical: 16.kh),
        ),
      ),
    );
  }
}
