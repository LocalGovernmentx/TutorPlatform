import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/change_password.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/send_request_email.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/send_verification_code.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/find_password_ui_event.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/find_password_event.dart';

class FindPasswordViewModel extends ChangeNotifier {
  final SendRequestEmail _sendRequestEmail;
  final SendVerificationCode _sendVerificationCode;
  final ChangePassword _changePassword;

  final _eventController = StreamController<FindPasswordUiEvent>.broadcast();

  Stream<FindPasswordUiEvent> get eventStream => _eventController.stream;

  FindPasswordViewModel(
    this._sendRequestEmail,
    this._sendVerificationCode,
    this._changePassword,
  );

  void onEvent(FindPasswordEvent event) {
    switch (event) {
      case SendRequestEmailEvent():
        sendRequestEmail(event.email);
      case SendVerificationCodeEvent():
        sendVerificationCode(event.email, event.code);
      case ChangePasswordEvent():
        changePassword(event.email, event.password, event.passwordCheck);
    }
  }

  void sendRequestEmail(String email) async {
    // validation
    bool validation = true;
    if (email.isEmpty) {
      validation = false;
      _eventController
          .add(FindPasswordUiEvent.errorMessage('Email cannot be empty'));
    }
    // else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
    //   validation = false;
    //   _eventController
    //       .add(LoginUiEvent.errorMessageEmail('Invalid email format'));
    // }
    if (!validation) {
      notifyListeners();
      return;
    }

    Result<dynamic, NetworkErrors> result = await _sendRequestEmail(email);
    _eventController
        .add(FindPasswordUiEvent.errorMessage(null));

    switch (result) {
      case Success():
        _eventController.add(FindPasswordUiEvent.success(email));
      case Error():
        NetworkErrors error = result.error;
        switch (error) {
          case CredentialsError():
            _eventController
                .add(FindPasswordUiEvent.errorMessage('이메일이 존재하지 않습니다'));
          case TimeoutError():
            _eventController
                .add(FindPasswordUiEvent.showSnackBar('불안정한 네트워크 : 다시 시도해주세요'));
          case ServerError():
            _eventController.add(FindPasswordUiEvent.showSnackBar(
                '${error.statusCode} : 서버 에러'));
          case ClientError():
            _eventController.add(FindPasswordUiEvent.showSnackBar(
                '${error.statusCode} : 프런트 구현 에러'));
          case UnknownError():
            _eventController
                .add(FindPasswordUiEvent.showSnackBar('에러가 발생하였습니다'));
        }
    }
    notifyListeners();
  }

  void sendVerificationCode(String email, String code) async {
    _eventController
        .add(FindPasswordUiEvent.validationError(null));

    Result<String, NetworkErrors> result =
        await _sendVerificationCode(email, code);
    switch (result) {
      case Success<String, NetworkErrors>():
        _eventController.add(FindPasswordUiEvent.validationSuccess(email));
      case Error<String, NetworkErrors>():
        NetworkErrors error = result.error;
        switch (error) {
          case CredentialsError():
            _eventController
                .add(FindPasswordUiEvent.validationError('인증번호가 일치하지 않습니다'));
          case TimeoutError():
            _eventController
                .add(FindPasswordUiEvent.showSnackBar('불안정한 네트워크 : 다시 시도해주세요'));
          case ServerError():
            _eventController.add(FindPasswordUiEvent.showSnackBar(
                '${error.statusCode} : 서버 에러'));
          case ClientError():
            _eventController.add(FindPasswordUiEvent.showSnackBar(
                '${error.statusCode} : 프런트 구현 에러'));
          case UnknownError():
            _eventController
                .add(FindPasswordUiEvent.showSnackBar('에러가 발생하였습니다'));
        }
    }
    notifyListeners();
  }

  void changePassword(String email, String password, String passwordCheck) async {
    // validation
    bool validation = true;
    _eventController
        .add(FindPasswordUiEvent.passwordErrorMessage(null));
    _eventController.add(
        FindPasswordUiEvent.passwordCheckErrorMessage(null));
    if (password.isEmpty) {
      validation = false;
      _eventController
          .add(FindPasswordUiEvent.passwordErrorMessage('비밀번호를 입력해주세요'));
    }
    else if (password.length < 8) {
      validation = false;
      _eventController.add(FindPasswordUiEvent.passwordErrorMessage('비밀번호는 8자 이상이어야 합니다'));
    }
    else if (password.length > 64) {
      validation = false;
      _eventController.add(FindPasswordUiEvent.passwordErrorMessage('비밀번호는 64자 이하이어야 합니다'));
    }
    else if (!RegExp(r'^(?=.*[a-zA-Z])').hasMatch(password)) {
      validation = false;
      _eventController.add(FindPasswordUiEvent.passwordErrorMessage('비밀번호는 영문 문자를 포함해야 합니다'));
    }
    else if (!RegExp(r'^(?=.*[0-9])(?=.*[!@#\$&*~])').hasMatch(password)) {
      validation = false;
      _eventController.add(FindPasswordUiEvent.passwordErrorMessage('비밀번호는 숫자와 특수문자를 포함해야 합니다'));
    }
    if (passwordCheck.isEmpty) {
      validation = false;
      _eventController
          .add(FindPasswordUiEvent.passwordCheckErrorMessage('비밀번호 확인을 입력해주세요'));
    }
    else if (password != passwordCheck) {
      validation = false;
      _eventController.add(
          FindPasswordUiEvent.passwordCheckErrorMessage('비밀번호가 일치하지 않습니다'));
    }
    if (!validation) {
      notifyListeners();
      return;
    }

    Result<dynamic, NetworkErrors> result = await _changePassword(email, password);
    switch (result) {
      case Success():
        _eventController.add(FindPasswordUiEvent.changePasswordSuccess(email));
      case Error():
        NetworkErrors error = result.error;
        switch (error) {
          case CredentialsError():
            _eventController
                .add(FindPasswordUiEvent.showSnackBar('비밀번호 변경에 실패하였습니다'));
          case TimeoutError():
            _eventController
                .add(FindPasswordUiEvent.showSnackBar('불안정한 네트워크 : 다시 시도해주세요'));
          case ServerError():
            _eventController.add(FindPasswordUiEvent.showSnackBar(
                '${error.statusCode} : 서버 에러'));
          case ClientError():
            _eventController.add(FindPasswordUiEvent.showSnackBar(
                '${error.statusCode} : 프런트 구현 에러'));
          case UnknownError():
            _eventController
                .add(FindPasswordUiEvent.showSnackBar('에러가 발생하였습니다'));
        }
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _eventController.close();
    super.dispose();
  }
}
