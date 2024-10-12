import 'package:flutter/material.dart';
import 'package:tutor_platform/core/design/colors.dart';
import 'package:tutor_platform/core/design/font.dart';

ButtonStyle uncheckedButtonStyle = ButtonStyle(
  backgroundColor: WidgetStateProperty.all<Color>(uncheckedColor),
  foregroundColor: WidgetStateProperty.all<Color>(uncheckedTextColor),
  overlayColor: WidgetStateProperty.all<Color>(uncheckedBorderColor),
  textStyle: WidgetStateProperty.all<TextStyle>(normalTextStyle),
  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  side: WidgetStateProperty.all<BorderSide>(
    const BorderSide(
      color: uncheckedBorderColor,
    ),
  ),
);

ButtonStyle uncheckedSmallButtonStyle = uncheckedButtonStyle.copyWith(
  textStyle: WidgetStateProperty.all<TextStyle>(smallTextStyle),
);

ButtonStyle faintButtonStyle(Color color) => ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: contentTextColor,
      padding: EdgeInsets.zero,
    );

ButtonStyle tutorFaintButtonStyle =
    faintButtonStyle(tutorSecondaryColor).copyWith(
  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
    const EdgeInsets.symmetric(horizontal: 16),
  ),
);

ButtonStyle tuteeFaintButtonStyle = faintButtonStyle(tuteeSecondaryColor).copyWith(
  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
    const EdgeInsets.symmetric(horizontal: 16),
  ),
);

ButtonStyle unfilledOutlinedButtonStyle = ButtonStyle(
  backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
  overlayColor: WidgetStateProperty.all<Color>(uncheckedBorderColor),
  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  side: WidgetStateProperty.all<BorderSide>(
    const BorderSide(
      color: uncheckedBorderColor,
    ),
  ),
);