import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 3) {
        buffer.write('-');
      }
      else if (text.length == 11 && i == 7) {
        buffer.write('-');
      }
      else if (text.length != 11 && i == 6) {
        buffer.write('-');
      }
      buffer.write(text[i]);
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}