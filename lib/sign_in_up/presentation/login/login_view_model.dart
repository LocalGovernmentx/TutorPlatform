import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tutor_platform/core/models/jwt_token.dart';
import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/perform_login.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/write_remember_me.dart';
import 'package:tutor_platform/sign_in_up/presentation/login/login_ui_event.dart';

class LoginViewModel extends ChangeNotifier {
  String? _emailError;
  String? _passwordError;

  String? get emailError => _emailError;

  String? get passwordError => _passwordError;

  final PerformLogin _performLogin;
  final WriteRememberMe _writeRememberMe;

  final _eventController = StreamController<LoginUiEvent>.broadcast();

  Stream get eventStream => _eventController.stream;

  LoginViewModel(this._performLogin, this._writeRememberMe);

  @override
  void dispose() {
    _eventController.close();

    super.dispose();
  }

  void login(String email, String password) async {
    _emailError = null;
    _passwordError = null;

    if (!_validateEmail(email) || !_validatePassword(password)) {
      _eventController.add(LoginUiEvent.error());
      notifyListeners();
      return;
    }

    final Result<JwtToken, NetworkErrors> result =
        await _performLogin(email, password);
    switch (result) {
      case Success<JwtToken, NetworkErrors>():
        _writeRememberMe(email, result.value.refreshToken);
        _eventController.add(LoginUiEvent.success(result.value));
      case Error<JwtToken, NetworkErrors>():
        _eventController.add(_handleNetworkError(result.error));
    }
    notifyListeners();
  }

  bool _validateEmail(String email) {
    if (email.isEmpty) {
      _emailError = '이메일을 입력해주세요';
      return false;
    }
    return true;
  }

  bool _validatePassword(String password) {
    if (password.isEmpty) {
      _passwordError = '비밀번호를 입력해주세요';
      return false;
    }
    return true;
  }

  LoginUiEvent _handleNetworkError(NetworkErrors error) {
    switch (error) {
      case TimeoutError():
        return LoginUiEvent.showSnackBar('네트워크가 불안정합니다');
      case ServerError():
        return LoginUiEvent.showSnackBar('${error.statusCode} : 서버 오류가 발생했습니다');
      case ClientError():
        return LoginUiEvent.showSnackBar(
            '${error.statusCode} : 클라이언트 오류가 발생했습니다');
      case UnknownStatusCode():
        return LoginUiEvent.showSnackBar(
            '${error.statusCode} : 알 수 없는 오류가 발생했습니다');
      case CredentialsError():
        if (error.message == 'Member not found') {
          _emailError = '존재하지 않는 이메일입니다';
          return LoginUiEvent.error();
        } else if (error.message == 'Invalid password') {
          _passwordError = '비밀번호가 일치하지 않습니다';
          return LoginUiEvent.error();
        }
        return LoginUiEvent.showSnackBar(error.message);
      case UnknownError():
        return LoginUiEvent.showSnackBar('알 수 없는 오류가 발생했습니다');
    }
  }

  void clear() {
    _emailError = null;
    _passwordError = null;
  }
}
