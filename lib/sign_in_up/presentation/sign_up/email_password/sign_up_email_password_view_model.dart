import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/request_email_verification_no_duplicate.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/send_verification_sign_up.dart';
import 'package:tutor_platform/sign_in_up/presentation/sign_up/email_password/sign_up_email_password_ui_event.dart';

class SignUpEmailPasswordViewModel extends ChangeNotifier {
  final RequestEmailVerificationNoDuplicate _requestEmailVerificationNoDuplicate;
  final SendVerificationSignUp _sendVerificationSignUp;

  SignUpEmailPasswordViewModel(
    this._requestEmailVerificationNoDuplicate,
    this._sendVerificationSignUp,
  );

  String? _emailError;
  String? _verificationCodeError;
  String? _passwordError;
  String? _confirmPasswordError;

  String? get emailError => _emailError;

  String? get verificationCodeError => _verificationCodeError;

  String? get passwordError => _passwordError;

  String? get confirmPasswordError => _confirmPasswordError;

  String? validatedEmail;

  bool _isEmailValidated = false;
  bool _isEmailValidating = false;

  bool get isEmailValidated => _isEmailValidated;

  bool get isEmailValidating => _isEmailValidating;

  final _eventController =
      StreamController<SignUpEmailPasswordUiEvent>.broadcast();

  Stream get eventStream => _eventController.stream;

  @override
  void dispose() {
    _eventController.close();

    super.dispose();
  }

  void requestEmailVerification(String email) async {
    validatedEmail = null;
    _emailError = null;
    _verificationCodeError = null;
    _isEmailValidated = false;
    _isEmailValidating = false;
    if (!_validateEmail(email)) {
      notifyListeners();
      _eventController.add(SignUpEmailPasswordUiEvent.error());
      return;
    }

    final Result<dynamic, NetworkErrors> result =
        await _requestEmailVerificationNoDuplicate(email);
    switch (result) {
      case Success<dynamic, NetworkErrors>():
        validatedEmail = email;
        _isEmailValidating = true;
        _eventController.add(SignUpEmailPasswordUiEvent.sendEmailSuccess());
      case Error<dynamic, NetworkErrors>():
        _eventController.add(_handleRequestEmailNetworkError(result.error));
    }
    notifyListeners();
  }

  void sendVerificationCode(String email, String code) async {
    assert(_isEmailValidating && !_isEmailValidated);
    _emailError = null;
    _verificationCodeError = null;
    if (validatedEmail != email) {
      _emailError = '입력하신 이메일 주소가 이전과 일치하지 않습니다. \n 재인증을 바라시면 인증번호 재전송을 해주세요.';
      _eventController.add(SignUpEmailPasswordUiEvent.error());
      notifyListeners();
      return;
    }
    final Result<String, NetworkErrors> result =
        await _sendVerificationSignUp(email, code);
    switch (result) {
      case Success<String, NetworkErrors>():
        _isEmailValidated = true;
        _isEmailValidating = false;
        _eventController.add(SignUpEmailPasswordUiEvent.verifyCodeSuccess());
      case Error<String, NetworkErrors>():
        _eventController.add(_handleVerifyCodeNetworkError(result.error));
    }
    notifyListeners();
  }

  void nextScreen(String email, String password, String passwordCheck) {
    _passwordError = null;
    _confirmPasswordError = null;
    print(1);
    if (validatedEmail != email) {
      _emailError =
          '입력하신 이메일 주소가 이전과 일치하지 않습니다. \n 입력하신 이메일 주소로 회원가입을 진행해주십시오.';
      _eventController.add(SignUpEmailPasswordUiEvent.error());
      notifyListeners();
      return;
    }
    if (!_isEmailValidated) {
      _emailError = '이메일 인증을 진행해주세요';
      _eventController.add(SignUpEmailPasswordUiEvent.error());
      notifyListeners();
      return;
    }
    if (!_validatePassword(password, passwordCheck)) {
      _eventController.add(SignUpEmailPasswordUiEvent.error());
      notifyListeners();
      return;
    }
    _eventController.add(SignUpEmailPasswordUiEvent.nextScreen());
    notifyListeners();
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

  bool _validatePassword(String password, String passwordCheck) {
    if (password.isEmpty) {
      _passwordError = '비밀번호를 입력해주세요';
      return false;
    }
    if (passwordCheck.isEmpty) {
      _confirmPasswordError = '비밀번호 확인을 입력해주세요';
      return false;
    }
    if (password.length < 8) {
      _passwordError = '비밀번호는 8자 이상이어야 합니다';
      return false;
    }
    if (password.length > 128) {
      _passwordError = '비밀번호는 128자 이하이어야 합니다';
      return false;
    }
    // if (!RegExp(r'^(?=.*[a-zA-Z])').hasMatch(password)) {
    //   _passwordError = '비밀번호는 영문 문자를 포함해야 합니다';
    //   return false;
    // }
    // if (!RegExp(r'^(?=.*[0-9])(?=.*[!@#\$&*~])').hasMatch(password)) {
    //   _passwordError = '비밀번호는 숫자와 특수문자를 포함해야 합니다';
    //   return false;
    // }
    if (password != passwordCheck) {
      _confirmPasswordError = '비밀번호가 일치하지 않습니다';
      return false;
    }

    return true;
  }

  SignUpEmailPasswordUiEvent _handleRequestEmailNetworkError(
      NetworkErrors error) {
    switch (error) {
      case TimeoutError():
        return SignUpEmailPasswordUiEvent.showSnackBar('네트워크가 불안정합니다');
      case ServerError():
        return SignUpEmailPasswordUiEvent.showSnackBar(
            '${error.statusCode} : 서버 오류가 발생했습니다');
      case ClientError():
        return SignUpEmailPasswordUiEvent.showSnackBar(
            '${error.statusCode} : 클라이언트 오류가 발생했습니다');
      case UnknownStatusCode():
        return SignUpEmailPasswordUiEvent.showSnackBar(
            '${error.statusCode} : 알 수 없는 오류가 발생했습니다');
      case CredentialsError():
        if (error.message == 'Invalid email format') {
          _emailError = '이메일 형식이 틀렸습니다';
          return SignUpEmailPasswordUiEvent.error();
        }
        if (error.message == 'Email is already in use') {
          _emailError = '이메일이 이미 사용중입니다';
          return SignUpEmailPasswordUiEvent.error();
        }
        return SignUpEmailPasswordUiEvent.showSnackBar(error.message);
      case UnknownError():
        return SignUpEmailPasswordUiEvent.showSnackBar('알 수 없는 오류가 발생했습니다');
    }
  }

  SignUpEmailPasswordUiEvent _handleVerifyCodeNetworkError(
      NetworkErrors error) {
    switch (error) {
      case TimeoutError():
        return SignUpEmailPasswordUiEvent.showSnackBar('네트워크가 불안정합니다');
      case ServerError():
        return SignUpEmailPasswordUiEvent.showSnackBar(
            '${error.statusCode} : 서버 오류가 발생했습니다');
      case ClientError():
        return SignUpEmailPasswordUiEvent.showSnackBar(
            '${error.statusCode} : 프런트 구현 오류가 발생했습니다');
      case UnknownStatusCode():
        return SignUpEmailPasswordUiEvent.showSnackBar(
            '${error.statusCode} : 알 수 없는 오류가 발생했습니다');
      case CredentialsError():
        if (error.message == 'Email is already in use') {
          _emailError = '이미 사용 중인 이메일입니다';
          _isEmailValidating = false;
          return SignUpEmailPasswordUiEvent.error();
        }
        if (error.message == 'Invalid email format') {
          _emailError = '이메일 형식이 틀렸습니다';
          _isEmailValidating = false;
          return SignUpEmailPasswordUiEvent.error();
        }
        if (error.message == 'Invalid verification code') {
          _verificationCodeError = '인증번호가 일치하지 않습니다';
          return SignUpEmailPasswordUiEvent.error();
        }
        return SignUpEmailPasswordUiEvent.showSnackBar(error.message);
      case UnknownError():
        return SignUpEmailPasswordUiEvent.showSnackBar('알 수 없는 오류가 발생했습니다');
    }
  }

  void clean() {
    print('clean');
    _emailError = null;
    _verificationCodeError = null;
    _passwordError = null;
    _confirmPasswordError = null;
    _isEmailValidated = false;
    _isEmailValidating = false;
    validatedEmail = null;
    notifyListeners();
  }
}
