import 'package:flutter/material.dart';
import 'package:mopedsafe/app/services/colors.dart';

import 'responsive_size.dart';
import 'text_style_util.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final bool disabled;
  final bool isloading;
  final void Function()? onTap;
  final bool outline;
  final Widget? leading;
  final Widget? trailing;
  final LinearGradient? linearGradient;
  final Color? color;
  final Color textcolor;
  final double? borderRadius;

  const CustomButton({
    super.key,
    required this.title,
    this.disabled = false,
    this.isloading = false,
    this.onTap,
    this.leading,
    this.trailing,
    this.linearGradient,
    this.color,
    this.borderRadius,
    this.outline = false,
    this.textcolor = Colors.white,
  });

  const CustomButton.outline({
    super.key,
    required this.title,
    this.onTap,
    this.leading,
    this.trailing,
    this.linearGradient,
    this.color,
    this.borderRadius,
    this.textcolor = Colors.white,
  })  : disabled = false,
        isloading = false,
        outline = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 48.kh,
            alignment: Alignment.center,
            decoration: !outline
                ? BoxDecoration(
                    // color: !disabled ? color ?? ColorUtil.kcPrimaryColor : color ?? ColorUtil.kcMediumGreyColor,
                    borderRadius: BorderRadius.circular(borderRadius ?? 48.kh),
                    gradient: linearGradient ??
                        LinearGradient(
                            begin: const Alignment(0, 0),
                            end: const Alignment(0, 0),
                            colors: [
                              !disabled
                                  ? color ?? Colors.redAccent
                                  : color ?? Colors.grey,
                              !disabled
                                  ? color ?? Colors.redAccent
                                  : color ?? Colors.grey
                            ]),
                  )
                : BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(borderRadius ?? 48.kh),
                    border: Border.all(
                      color: color ?? context.brandColor1,
                      width: 1,
                    )),
            child: !isloading
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (leading != null) leading!,
                      if (leading != null) SizedBox(width: 5.kw),
                      Text(
                        title,
                        style: TextStyleUtil.poppins600(
                          color: textcolor,
                          fontSize: 16.kh,
                        ),
                      ),
                      if (trailing != null) SizedBox(width: 5.kw),
                      if (trailing != null) trailing!,
                    ],
                  )
                : const CircularProgressIndicator(
                    strokeWidth: 8,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
          ),
        ),
        // Material(
        //   color: Colors.transparent,
        //   child: InkWell(
        //     onTap: () {},
        //     child: Ink(
        //       width: double.infinity,
        //       height: 48.kh,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
