import 'package:flutter/material.dart';
import 'package:tutor_platform/ui/colors.dart';

TextTheme textTheme = TextTheme(
  headlineLarge: titleTextStyle,
  headlineMedium: subTitleTextStyle,
  bodyLarge: emphasisTextStyle,
  bodyMedium: normalTextStyle,
);

TextStyle titleTextStyle = const TextStyle(
  fontWeight: FontWeight.w600,
  color: titleColor,
  fontSize: 24,
);

TextStyle subTitleTextStyle = const TextStyle(
  fontWeight: FontWeight.w600,
  color: titleColor,
  fontSize: 22,
);

TextStyle emphasisTextStyle = const TextStyle(
  fontWeight: FontWeight.w600,
  color: contentTextColor,
  fontSize: 18,
);

TextStyle normalTextStyle = const TextStyle(
  color: contentTextColor,
  fontSize: 16,
);

TextStyle errorTextStyle = const TextStyle(
  color: errorTextColor,
  fontSize: 16,
);

TextStyle hintTextStyle = const TextStyle(
  color: hintTextColor,
  fontSize: 16,
);
