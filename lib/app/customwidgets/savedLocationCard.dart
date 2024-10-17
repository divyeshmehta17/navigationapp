import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/components/RecentLocationData.dart';
import 'package:mopedsafe/app/components/common_image_view.dart';
import 'package:mopedsafe/app/constants/image_constant.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';
import 'package:mopedsafe/app/services/text_style_util.dart';

Widget savedLocationCard(
    {String? svgPath, String? name, String? distance, BuildContext? context}) {
  return Container(
    width: 92.kw,
    height: 36.kh,
    margin: EdgeInsets.symmetric(horizontal: 8.kw),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.kw),
        color: Colors.grey.shade200),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (svgPath != null)
          Center(
            child: CommonImageView(
              svgPath: svgPath,
              width: 24.kw,
              height: 26.kh,
            ),
          ),
        if (name != null)
          Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: TextStyleUtil.poppins400(
              fontSize: 12.kh,
            ),
          ),
        if (distance != null)
          Text(
            distance,
            overflow: TextOverflow.ellipsis,
            style: TextStyleUtil.poppins500(
              fontSize: 12.kh,
            ),
          ),
      ],
    ).paddingSymmetric(horizontal: 6.kw, vertical: 6.kh),
  );
}

Widget recentLocationList(
    RecentLocationData locationdata, BuildContext context) {
  return Row(
    children: [
      CommonImageView(
        svgPath: ImageConstant.svgrefreshclock,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locationdata.name,
            style: TextStyleUtil.poppins500(fontSize: 14.kh),
          ),
          if (locationdata.description != null)
            Text(
              locationdata.description!,
              style: TextStyleUtil.poppins400(
                  fontSize: 11.kh, color: context.darkGrey),
            )
        ],
      ).paddingOnly(left: 8.kw)
    ],
  ).paddingOnly(bottom: 9.kh);
}
