import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/components/common_image_view.dart';
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (svgPath != null)
          Center(
            child: CommonImageView(
              svgPath: svgPath,
              fit: BoxFit.fill,
              width: 24.kw,
              height: 24.kh,
            ),
          ).paddingOnly(bottom: 12.kh),
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
