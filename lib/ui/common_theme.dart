import 'package:flutter/material.dart';
import 'package:tutor_platform/ui/colors.dart';
import 'package:tutor_platform/ui/font.dart';

InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
  border: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  ),
  errorStyle: errorTextStyle,
  hintStyle: hintTextStyle,
);

TextButtonThemeData textButtonTheme = TextButtonThemeData(
  style: TextButton.styleFrom(
    foregroundColor: contentTextColor,
    textStyle: normalTextStyle,
    padding: EdgeInsets.zero,
    minimumSize: const Size(0, 0),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  ),
);