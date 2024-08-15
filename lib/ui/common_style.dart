import 'package:flutter/material.dart';
import 'package:tutor_platform/ui/colors.dart';
import 'package:tutor_platform/ui/font.dart';

ButtonStyle uncheckedButtonStyle = ButtonStyle(
  backgroundColor: WidgetStateProperty.all<Color>(uncheckedColor),
  foregroundColor: WidgetStateProperty.all<Color>(uncheckedTextColor),
  textStyle: WidgetStateProperty.all<TextStyle>(
      normalTextStyle),
  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
