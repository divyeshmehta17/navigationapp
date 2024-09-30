import 'package:flutter/material.dart';

import 'hexColorToFlutterColor.dart';

extension ColorUtil on BuildContext {
  Color dynamicColor({required int light, required int dark}) {
    return (Theme.of(this).brightness == Brightness.light)
        ? Color(light)
        : Color(dark);
  }

  Color dynamicColour({required Color light, required Color dark}) {
    return (Theme.of(this).brightness == Brightness.light) ? light : dark;
  }

  Color get brandColor1 =>
      dynamicColour(light: HexColor("#6B4EFF"), dark: HexColor("#000000"));
  Color get profilePicBorder =>
      dynamicColour(light: HexColor("#6A6A6A"), dark: HexColor("#000000"));
  Color get inactiveColor =>
      dynamicColour(light: HexColor("#DBD5FF"), dark: HexColor("#000000"));
  Color get neutralGrey =>
      dynamicColour(light: HexColor("#F0F0F0"), dark: HexColor("#000000"));
  Color get lightGrey =>
      dynamicColour(light: HexColor("#D9D9D9"), dark: HexColor("#000000"));
  Color get mediumGrey =>
      dynamicColour(light: HexColor("#BFBFBF"), dark: HexColor("#000000"));
  Color get darkGrey =>
      dynamicColour(light: HexColor("#8C8C8C"), dark: HexColor("#000000"));
  Color get Grey =>
      dynamicColour(light: HexColor("#595959"), dark: HexColor("#000000"));
}
