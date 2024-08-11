import 'package:flutter/material.dart';

sealed class FindPasswordEvent {
  factory FindPasswordEvent.sendRequestEmail(String email) = SendRequestEmailEvent;

  factory FindPasswordEvent.sendVerificationCode(String email, String code) = SendVerificationCodeEvent;

  factory FindPasswordEvent.changePassword(String email, String password, String passwordCheck) = ChangePasswordEvent;
}

class SendRequestEmailEvent implements FindPasswordEvent {
  final String email;

  SendRequestEmailEvent(this.email);
}

class SendVerificationCodeEvent implements FindPasswordEvent {
  final String email;
  final String code;

  SendVerificationCodeEvent(this.email, this.code);
}

class ChangePasswordEvent implements FindPasswordEvent {
  final String email;
  final String password;
  final String passwordCheck;

  ChangePasswordEvent(this.email, this.password, this.passwordCheck);
}
