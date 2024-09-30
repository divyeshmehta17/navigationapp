import 'package:flutter/material.dart';

import 'common_image_view.dart';

class NavigationAppButton extends StatelessWidget {
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final String? svgPath;
  final TextStyle? textStyle;
  final String label;
  final bool? isEnabled;
  final BoxBorder? border;
  final EdgeInsetsGeometry? leadingiconpadding;
  final EdgeInsetsGeometry? leadinglabelpadding;
  final void Function()? onTap;
  const NavigationAppButton(
      {super.key,
      this.color,
      this.borderRadius,
      this.svgPath,
      this.textStyle,
      required this.label,
      this.border,
      this.leadingiconpadding,
      this.leadinglabelpadding,
      this.onTap,
      this.isEnabled = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: isEnabled == true ? onTap : null,
        child: Container(
          decoration: BoxDecoration(
              color: color, borderRadius: borderRadius, border: border),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: leadingiconpadding ?? const EdgeInsets.all(0.0),
                child: CommonImageView(
                  svgPath: svgPath,
                ),
              ),
              Padding(
                  padding: leadinglabelpadding ?? const EdgeInsets.all(0.0),
                  child: Text(
                    label,
                    style: textStyle,
                  )),
            ],
          ),
        ));
  }
}
