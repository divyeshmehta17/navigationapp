import 'package:flutter/material.dart';

class TextStyleUtil {
  static TextStyle poppins300({
    Color color = Colors.black,
    required double fontSize,
  }) {
    return TextStyle(
      fontFamily: 'Poppins',
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle poppins400({
    Color color = Colors.black,
    required double fontSize,
    TextDecoration? textDecoration,
  }) {
    return TextStyle(
        fontFamily: 'Poppins',
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        decoration: textDecoration);
  }

  static TextStyle poppins500({
    Color color = Colors.black,
    required double fontSize,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return TextStyle(
      fontFamily: 'Poppins',
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  static TextStyle poppins600({
    Color color = Colors.black,
    required double fontSize,
  }) {
    return TextStyle(
      fontFamily: 'Poppins',
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle poppins700({
    Color color = Colors.black,
    required double fontSize,
  }) {
    return TextStyle(
      fontFamily: 'Poppins',
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
    );
  }
}

extension AppText on String {
  String get string => this;

  Widget text300(double fontSize,
          {Color color = Colors.black, TextAlign? textAlign}) =>
      Text(
        string,
        textAlign: textAlign,
        style: TextStyle(
          fontFamily: 'Poppins',
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w300,
        ),
      );

  Widget text400(double fontSize,
          {Color color = Colors.black, TextAlign? textAlign}) =>
      Text(
        string,
        textAlign: textAlign,
        style: TextStyle(
          fontFamily: 'Poppins',
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
        ),
      );

  Widget text500(double fontSize,
          {Color color = Colors.black, TextAlign? textAlign}) =>
      Text(
        string,
        textAlign: textAlign,
        style: TextStyle(
          fontFamily: 'Poppins',
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      );

  Widget text600(double fontSize,
          {Color color = Colors.black,
          TextAlign? textAlign,
          TextStyle? style}) =>
      Text(
        string,
        textAlign: textAlign,
        style: style ??
            TextStyle(
              fontFamily: 'Poppins',
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
      );
}
