import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mopedsafe/app/routes/app_pages.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';

class AddButton extends StatelessWidget {
  const AddButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.ADDAPLACE);
      },
      child: Container(
        width: 92.kw,
        height: 36.kh,
        margin: EdgeInsets.symmetric(horizontal: 10.kw),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.kw),
          color: context.brandColor1,
        ),
        child: Icon(
          size: 40.kh,
          Icons.add_circle_outline_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
