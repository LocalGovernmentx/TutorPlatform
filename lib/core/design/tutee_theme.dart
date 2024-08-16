import 'package:flutter/material.dart';
import 'package:tutor_platform/core/design/colors.dart';
import 'package:tutor_platform/core/design/common_theme.dart';
import 'package:tutor_platform/core/design/font.dart';

ThemeData tuteeTheme = ThemeData(
  colorScheme: tuteeColorScheme,
  fontFamily: 'Pretendard',
  elevatedButtonTheme: tuteeElevatedButtonTheme,
  textButtonTheme: textButtonTheme,
  textTheme: textTheme,
  hintColor: hintTextColor,
  inputDecorationTheme: inputDecorationTheme,
  segmentedButtonTheme: tuteeSegmentedButtonTheme,
  useMaterial3: true,
);

ElevatedButtonThemeData tuteeElevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: tuteePrimaryColor,
    foregroundColor: Colors.white,
    textStyle: normalTextStyle,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),

  ),
);

const ColorScheme tuteeColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: tuteePrimaryColor,
  onPrimary: Colors.black,
  secondary: tuteeSecondaryColor,
  onSecondary: Colors.black,
  error: errorTextColor,
  onError: Colors.black,
  surface: Colors.white,
  onSurface: Colors.black,
);

SegmentedButtonThemeData tuteeSegmentedButtonTheme = SegmentedButtonThemeData(
  style: SegmentedButton.styleFrom(
    selectedBackgroundColor: tuteePrimaryColor,
    selectedForegroundColor: Colors.white,
    backgroundColor: Colors.white,
    foregroundColor: tuteePrimaryColor,
    textStyle: normalTextStyle,
    side: const BorderSide(
      color: tuteePrimaryColor,
      width: 1,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
