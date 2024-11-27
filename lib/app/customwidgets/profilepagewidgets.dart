import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/components/common_image_view.dart';
import 'package:mopedsafe/app/constants/image_constant.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';
import 'package:mopedsafe/app/services/text_style_util.dart';

import '../routes/app_pages.dart';

Widget buildSectionTitle(BuildContext context, String title) {
  return Text(title, style: TextStyleUtil.poppins500(fontSize: 16.kh))
      .paddingOnly(top: 16.kh, bottom: 4.kh);
}

Widget buildProfileOption(BuildContext context, String title, String route) {
  return GestureDetector(
    onTap: () => Get.toNamed(route),
    behavior: HitTestBehavior.translucent,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyleUtil.poppins500(
              fontSize: 14.kh, fontWeight: FontWeight.normal),
        ),
        Icon(
          Icons.arrow_forward_ios,
          size: 16.kw,
          color: context.darkGrey,
        ),
      ],
    ).paddingOnly(top: 8.kh, left: 6.kw, right: 6.kw, bottom: 8.kh),
  );
}

// Refactored to accept any controller
Widget buildProfileInfo(
  BuildContext context,
  dynamic controller,
  String Function(dynamic) getName,
  String Function(dynamic) getEmail,
  String Function(dynamic) getImageUrl,
) {
  return Row(
    children: [
      CircleAvatar(
        radius: 40.kw,
        backgroundImage: getImageUrl(controller).isNotEmpty
            ? NetworkImage(getImageUrl(controller))
            : null,
        child: getImageUrl(controller).isEmpty
            ? CommonImageView(
                svgPath: ImageConstant.svgdummyperson,
                height: 20.kh,
                width: 20.kw,
              )
            : null,
      ),
      SizedBox(width: 16.kw),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getName(controller),
            style: TextStyle(
              fontSize: 18.kh,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            getEmail(controller),
            style: TextStyle(
              fontSize: 14.kh,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      const Spacer(),
      GestureDetector(
        onTap: () {
          Get.toNamed(Routes.SETPROFILEDETAILS);
        },
        child: CommonImageView(
          imagePath: ImageConstant.pngpencilIcon,
        ),
      ),
    ],
  );
}
