import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';
import 'package:mopedsafe/app/services/storage.dart';

import '../services/text_style_util.dart';

class buildLocationInputField extends StatelessWidget {
  buildLocationInputField(
      {super.key,
      this.hintText,
      required this.controller,
      required this.context,
      this.focusNode,
      this.otherFocusNode,
      this.itemClick,
      this.inputDecoration,
      this.color,
      this.textColor = Colors.black,
      this.suffixIcon,
      this.prefixIcon});
  void Function(Prediction)? itemClick;
  final String? hintText;
  final TextEditingController controller;
  final BuildContext context;
  final FocusNode? focusNode;
  final FocusNode? otherFocusNode;
  final Color? color;
  final Color textColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final InputDecoration? inputDecoration;
  @override
  Widget build(BuildContext context) {
    return GooglePlaceAutoCompleteTextField(
        textEditingController: controller,
        googleAPIKey: Get.find<GetStorageService>().googleApiKey,
        boxDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.kw),
          color: color ?? context.lightGrey,
        ),
        focusNode: focusNode,
        isLatLngRequired: false,
        inputDecoration: inputDecoration ??
            InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              contentPadding: EdgeInsets.only(left: 8.kw, top: 12.kh),
              hintStyle:
                  TextStyleUtil.poppins400(fontSize: 14.kh, color: textColor),
            ),
        itemClick: itemClick);
  }
}
