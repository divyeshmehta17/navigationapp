import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mopedsafe/app/services/colors.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';

import '../services/text_style_util.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? suffixIcon;
  final TextStyle? hintStyle;
  final int? maxLines;
  final void Function()? onTap;
  final void Function()? onGestureTap;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;
  void Function(String)? onChanged;
  CustomTextField(
      {super.key,
      this.maxLines = 1,
      this.controller,
      this.onChanged,
      this.hintText,
      this.suffixIcon,
      this.hintStyle,
      this.onTap,
      this.inputFormatters,
      this.enabled,
      this.onGestureTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onGestureTap,
      child: Container(
        color: Colors.grey.shade200,
        child: TextField(
          maxLines: maxLines,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          onTap: onTap,
          enabled: enabled,
          controller: controller,
          decoration: InputDecoration(
            fillColor: context.neutralGrey,
            hintText: hintText,
            hintStyle: TextStyleUtil.poppins400(
              fontSize: 14.kh,
              color: context.darkGrey,
            ),
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: context.lightGrey),
              borderRadius: BorderRadius.circular(6.kw),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: context.lightGrey),
              borderRadius: BorderRadius.circular(6.kw),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.kw),
            ),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.kw),
                borderSide: const BorderSide(color: Colors.transparent)),
          ),
        ),
      ),
    );
  }
}
