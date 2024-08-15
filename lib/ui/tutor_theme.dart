import 'package:flutter/material.dart';
import 'package:tutor_platform/ui/colors.dart';
import 'package:tutor_platform/ui/common_theme.dart';
import 'package:tutor_platform/ui/font.dart';

ThemeData tutorTheme = ThemeData(
  colorScheme: tutorColorScheme,
  fontFamily: 'Pretendard',
  elevatedButtonTheme: tutorElevatedButtonTheme,
  textButtonTheme: textButtonTheme,
  textTheme: textTheme,
  hintColor: hintTextColor,
  inputDecorationTheme: inputDecorationTheme,
  segmentedButtonTheme: tutorSegmentedButtonTheme,
  useMaterial3: true,
);

ElevatedButtonThemeData tutorElevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: tutorPrimaryColor,
    foregroundColor: Colors.white,
    textStyle: normalTextStyle,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);

const ColorScheme tutorColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: tutorPrimaryColor,
  onPrimary: Colors.black,
  secondary: tutorSecondaryColor,
  onSecondary: Colors.black,
  error: errorTextColor,
  onError: Colors.black,
  surface: Colors.white,
  onSurface: Colors.black,
);

SegmentedButtonThemeData tutorSegmentedButtonTheme = SegmentedButtonThemeData(
  style: SegmentedButton.styleFrom(
    selectedBackgroundColor: tutorPrimaryColor,
    selectedForegroundColor: Colors.white,
    backgroundColor: Colors.white,
    foregroundColor: tutorPrimaryColor,
    textStyle: normalTextStyle,
    side: const BorderSide(
      color: tutorPrimaryColor,
      width: 1,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
