import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/send_verification_find_password.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/send_code/find_password_send_code_ui_event.dart';

class FindPasswordSendCodeViewModel extends ChangeNotifier {
  final SendVerificationFindPassword sendVerificationFindPassword;

  final _eventController =
      StreamController<FindPasswordSendCodeUiEvent>.broadcast();

  Stream get eventStream => _eventController.stream;

  FindPasswordSendCodeViewModel(this.sendVerificationFindPassword);

  String? _codeError;

  String? get codeError => _codeError;

  @override
  void dispose() {
    _eventController.close();

    super.dispose();
  }

  void timeOut() {
    _codeError = '인증코드가 만료되었습니다. 다시 요청해주세요.';
    _eventController.add(FindPasswordSendCodeUiEvent.error());
    notifyListeners();
  }

  void sendCode(String email, String code) async {
    email = email.trim();
    _codeError = null;
    if (!_validateCode(code)) {
      _eventController.add(FindPasswordSendCodeUiEvent.error());
      notifyListeners();
      return;
    }

    final Result<String, NetworkErrors> result = await sendVerificationFindPassword(email, code);
    switch (result) {
      case Success<String, NetworkErrors>():
        _eventController.add(FindPasswordSendCodeUiEvent.success());
        break;
      case Error<String, NetworkErrors>():
        _eventController.add(_handleNetworkError(result.error));
        break;
    }
    notifyListeners();
  }

  bool _validateCode(String code) {
    if (code.isEmpty) {
      _codeError = '코드를 입력해주세요';
      return false;
    }
    return true;
  }

  FindPasswordSendCodeUiEvent _handleNetworkError(NetworkErrors error) {
    switch (error) {
      case TimeoutError():
        return FindPasswordSendCodeUiEvent.showSnackBar('네트워크가 불안정합니다');
      case ServerError():
        return FindPasswordSendCodeUiEvent.showSnackBar('${error.statusCode} : 서버 오류가 발생했습니다');
      case ClientError():
        return FindPasswordSendCodeUiEvent.showSnackBar('${error.statusCode} : 클라이언트 오류가 발생했습니다');
      case UnknownStatusCode():
        return FindPasswordSendCodeUiEvent.showSnackBar('${error.statusCode} : 알 수 없는 오류가 발생했습니다');
      case CredentialsError():
        if (error.message == 'Invalid email format') {
          return FindPasswordSendCodeUiEvent.showSnackBar('이메일 형식이 올바르지 않습니다\n이전으로 돌아가서 다시 입력해주십시오');
        }
        if (error.message == 'Email not found') {
          return FindPasswordSendCodeUiEvent.showSnackBar('가입되지 않은 이메일입니다\n이전으로 돌아가서 다시 입력해주십시오');
        }
        if (error.message == 'Invalid verification code') {
          _codeError = '코드가 올바르지 않습니다';
          return FindPasswordSendCodeUiEvent.error();
        }
        return FindPasswordSendCodeUiEvent.showSnackBar(error.message);
      case UnknownError():
        return FindPasswordSendCodeUiEvent.showSnackBar('알 수 없는 오류가 발생했습니다');
    }
  }

  void clear() {
    _codeError = null;
  }
}
