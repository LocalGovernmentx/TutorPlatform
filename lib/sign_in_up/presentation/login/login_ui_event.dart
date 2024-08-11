import 'package:tutor_platform/core/user_info.dart';

sealed class LoginUiEvent {
  factory LoginUiEvent.successful(UserInfo userInfo) = SuccessfulLogin;
  factory LoginUiEvent.errorMessagePassword(String? message) = LoginErrorMessagePassword;
  factory LoginUiEvent.errorMessageEmail(String? message) = LoginErrorMessageEmail;
  factory LoginUiEvent.showSnackBar(String message) = LoginShowSnackBar;
}

class SuccessfulLogin implements LoginUiEvent {
  final UserInfo userInfo;

  SuccessfulLogin(this.userInfo);
}

class LoginErrorMessagePassword implements LoginUiEvent {
  final String? message;

  LoginErrorMessagePassword(this.message);
}

class LoginErrorMessageEmail implements LoginUiEvent {
  final String? message;

  LoginErrorMessageEmail(this.message);
}

class LoginShowSnackBar implements LoginUiEvent {
  final String message;

  LoginShowSnackBar(this.message);
}