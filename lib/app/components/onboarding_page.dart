import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';

import '../modules/onboarding/controllers/onboarding_controller.dart';
import '../services/text_style_util.dart';
import 'common_image_view.dart';

class OnBoardingPage extends StatelessWidget {
  final OnBoardingModel model;
  const OnBoardingPage({super.key, required this.model});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonImageView(
            fit: BoxFit.fill,
            svgPath: model.svg,
            width: 312.42.kw,
            height: 246.17.kh),
        Text(model.title,
                textAlign: TextAlign.center,
                style: TextStyleUtil.poppins600(
                    fontSize: 24.kh, color: Colors.white))
            .paddingOnly(top: 47.kh, bottom: 20.kh),
        Text(
          model.description,
          textAlign: TextAlign.center,
          style: TextStyleUtil.poppins500(fontSize: 14.kh, color: Colors.white),
        ).paddingOnly(left: 22.kw, right: 22.kw),
      ],
    );
  }
}
