import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/components/navigationAppButton.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';
import 'package:mopedsafe/app/services/text_style_util.dart';

void showGlobalDialog({
  required String title,
  required String content,
  required VoidCallback onConfirm,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  VoidCallback? onCancel,
  required BuildContext context,
}) {
  Get.dialog(
    AlertDialog(
      title: Text(title),
      content: Text(content),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            NavigationAppButton(
              label: cancelText,
              textStyle: TextStyleUtil.poppins600(
                  fontSize: 16.kh, color: context.brandColor1),
              onTap: () {
                if (onCancel != null) {
                  onCancel();
                }
                Get.back();
              },
            ).paddingOnly(right: 16.kw),
            NavigationAppButton(
              label: confirmText,
              color: Colors.red,
              textStyle: TextStyleUtil.poppins600(
                  fontSize: 16.kh, color: Colors.white),
              leadinglabelpadding: EdgeInsetsDirectional.symmetric(
                  horizontal: 36.kw, vertical: 12.kh),
              borderRadius: BorderRadius.circular(16.kw),
              onTap: () {
                onConfirm();
                Get.back();
              },
            ),
          ],
        ),
      ],
    ),
  );
}
