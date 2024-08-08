import 'package:tutor_platform/core/user_info.dart';

sealed class LoginUiEvent {
  factory LoginUiEvent.successful(UserInfo userInfo) = Successful;
  factory LoginUiEvent.errorMessagePassword(String message) = ErrorMessagePassword;
  factory LoginUiEvent.errorMessageEmail(String message) = ErrorMessageEmail;
  factory LoginUiEvent.showSnackBar(String message) = ShowSnackBar;
}

class Successful implements LoginUiEvent {
  final UserInfo userInfo;

  Successful(this.userInfo);
}

class ErrorMessagePassword implements LoginUiEvent {
  final String message;

  ErrorMessagePassword(this.message);
}

class ErrorMessageEmail implements LoginUiEvent {
  final String message;

  ErrorMessageEmail(this.message);
}

class ShowSnackBar implements LoginUiEvent {
  final String message;

  ShowSnackBar(this.message);
}