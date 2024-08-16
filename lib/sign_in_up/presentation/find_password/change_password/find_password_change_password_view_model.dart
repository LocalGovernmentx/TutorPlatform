import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/change_password_without_login.dart';
import 'package:tutor_platform/sign_in_up/presentation/find_password/change_password/find_password_change_password_ui_event.dart';

class FindPasswordChangePasswordViewModel extends ChangeNotifier {
  final ChangePasswordWithoutLogin changePasswordWithoutLogin;

  final _eventController = StreamController<FindPasswordChangePasswordUiEvent>.broadcast();

  Stream get eventStream => _eventController.stream;

  FindPasswordChangePasswordViewModel(this.changePasswordWithoutLogin);

  String? _passwordError;

  String? get passwordError => _passwordError;

  String? _passwordCheckError;

  String? get passwordCheckError => _passwordCheckError;

  @override
  void dispose() {
    _eventController.close();

    super.dispose();
  }

  void changePassword(String email, String password, String passwordCheck) async {
    email = email.trim();
    _passwordError = null;
    _passwordCheckError = null;
    if (!_validatePassword(password, passwordCheck)) {
      _eventController.add(FindPasswordChangePasswordUiEvent.error());
      notifyListeners();
      return;
    }

    final Result<String, NetworkErrors> result = await changePasswordWithoutLogin(email, password);
    switch (result) {
      case Success<String, NetworkErrors>():
        _eventController.add(FindPasswordChangePasswordUiEvent.success());
      case Error<String, NetworkErrors>():
        _eventController.add(_handleNetworkError(result.error));
    }
    notifyListeners();
  }

  bool _validatePassword(String password, String passwordCheck) {
    if (password.isEmpty) {
      _passwordError = '비밀번호를 입력해주세요';
      return false;
    }
    if (passwordCheck.isEmpty) {
      _passwordCheckError = '비밀번호 확인을 입력해주세요';
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
    if (password != passwordCheck) {
      _passwordCheckError = '비밀번호가 일치하지 않습니다';
      return false;
    }

    return true;
  }

  FindPasswordChangePasswordUiEvent _handleNetworkError(NetworkErrors error) {
    switch (error) {
      case TimeoutError():
        return FindPasswordChangePasswordUiEvent.showSnackBar('네트워크가 불안정합니다');
      case ServerError():
        return FindPasswordChangePasswordUiEvent.showSnackBar('${error.statusCode} : 서버 오류가 발생했습니다');
      case ClientError():
        return FindPasswordChangePasswordUiEvent.showSnackBar('${error.statusCode} : 클라이언트 오류가 발생했습니다');
      case UnknownStatusCode():
        return FindPasswordChangePasswordUiEvent.showSnackBar('${error.statusCode} : 알 수 없는 오류가 발생했습니다');
      case CredentialsError():
        if (error.message == 'Invalid email format') {
          return FindPasswordChangePasswordUiEvent.showSnackBar('이메일 형식이 올바르지 않습니다\n이전으로 돌아가서 다시 입력해주십시오');
        }
        if (error.message == 'Email not found') {
          return FindPasswordChangePasswordUiEvent.showSnackBar('가입되지 않은 이메일입니다\n이전으로 돌아가서 다시 입력해주십시오');
        }
        if (error.message == 'Password change failed') {
          return FindPasswordChangePasswordUiEvent.showSnackBar('비밀번호 변경에 실패했습니다');
        }
        return FindPasswordChangePasswordUiEvent.showSnackBar(error.message);
      case UnknownError():
        return FindPasswordChangePasswordUiEvent.showSnackBar('알 수 없는 오류가 발생했습니다');
    }
  }

  void clear() {
    _passwordError = null;
    _passwordCheckError = null;
  }
}