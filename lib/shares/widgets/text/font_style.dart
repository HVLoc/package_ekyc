import 'package:package_ekyc/core/core.src.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontStyleUtils {
  static TextStyle fontStyleSans({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.colorBlack,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.nunitoSans().copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      decoration: decoration ?? TextDecoration.none,
    );
  }

  static TextStyle fontStyle(
      {double fontSize = 16,
      FontWeight fontWeight = FontWeight.w400,
      Color color = AppColors.colorBlack}) {
    return GoogleFonts.greatVibes().copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
