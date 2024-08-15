import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/request_email_verification.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/send_email/find_password_send_email_ui_event.dart';

class FindPasswordSendEmailViewModel extends ChangeNotifier {
  final RequestEmailVerification requestEmailVerification;

  final _eventController = StreamController<FindPasswordSendEmailUiEvent>.broadcast();

  Stream get eventStream => _eventController.stream;

  FindPasswordSendEmailViewModel(this.requestEmailVerification);

  String? _emailError;
  String? get emailError => _emailError;

  void sendEmail(String email) async {
    if (_validateEmail(email)) {
      _eventController.add(FindPasswordSendEmailUiEvent.error());
      notifyListeners();
    }
  }

  bool _validateEmail(String email) {
    if (email.isEmpty) {
      _emailError = '이메일을 입력해주세요';
      return false;
    }
    if (!(RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email))) {
      _emailError = '이메일 형식이 올바르지 않습니다';
      return false;
    }
    if (email.length > 320) {
      _emailError = '이메일은 320자 이하이어야 합니다';
      return false;
    }
    return true;
  }
}