import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tutor_platform/core/user_info.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/sign_in_up/domain/model/login_credentials.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/perform_login.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/remove_remember_me.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/retrieve_remember_me.dart';
import 'package:tutor_platform/sign_in_up/domain/use_case/write_remember_me.dart';
import 'package:tutor_platform/sign_in_up/presentation/login/login_event.dart';
import 'package:tutor_platform/sign_in_up/presentation/login/login_ui_event.dart';

class LoginViewModel extends ChangeNotifier {
  final PerformLogin performLogin;
  final WriteRememberMe writeRememberMe;
  final RetrieveRememberMe retrieveRememberMe;
  final RemoveRememberMe removeRememberMe;

  final _eventController = StreamController<LoginUiEvent>.broadcast();

  Stream<LoginUiEvent> get eventStream => _eventController.stream;

  LoginViewModel({
    required this.performLogin,
    required this.writeRememberMe,
    required this.retrieveRememberMe,
    required this.removeRememberMe,
  });

  void onEvent(LoginEvent event) {
    switch (event) {
      case Login():
        _login(event.email, event.password);
      case AutoLogin():
        _autoLogin();
      case StopRememberMe():
        _removeRememberMe();
    }
  }

  void _login(String email, String password) async {
    // validation
    bool validation = true;
    if (email.isEmpty) {
      validation = false;
      _eventController
          .add(LoginUiEvent.errorMessageEmail('Email cannot be empty'));
    }
    // else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
    //   validation = false;
    //   _eventController
    //       .add(LoginUiEvent.errorMessageEmail('Invalid email format'));
    // }
    if (password.isEmpty) {
      validation = false;
      _eventController
          .add(LoginUiEvent.errorMessagePassword('Password cannot be empty'));
    }
    // else if (password.length < 6) {
    //   validation = false;
    //   _eventController.add(LoginUiEvent.errorMessagePassword(
    //       'Password must be at least 6 characters'));
    // }
    if (!validation) {
      notifyListeners();
      return;
    }

    // perform login
    Result<UserInfo> result = await performLogin(email, password);
    switch (result) {
      case Success<UserInfo>():
        writeRememberMe(email, password);
        _eventController.add(LoginUiEvent.successful(result.value));
      case Error<UserInfo>():
        switch (result.message) {
          // ToDo: Implement this
          case 'Invalid email or password':
            _eventController.add(
                LoginUiEvent.errorMessagePassword('Invalid email or password'));
            _eventController.add(
                LoginUiEvent.errorMessageEmail('Invalid email or password'));
          case 'Networking error':
            _eventController.add(LoginUiEvent.showSnackBar('Networking error'));
          default:
            _eventController
                .add(LoginUiEvent.showSnackBar('An error occurred'));
        }
    }
    notifyListeners();
  }

  void _autoLogin() async {
    LoginCredentials? loginCredentials = await retrieveRememberMe();
    if (loginCredentials != null) {
      _login(loginCredentials.email, loginCredentials.password);
    }
  }

  void _removeRememberMe() async {
    await removeRememberMe();
  }
}
