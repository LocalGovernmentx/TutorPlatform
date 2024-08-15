import 'package:tutor_platform/core/models/jwt_token.dart';

sealed class LoginUiEvent {
  factory LoginUiEvent.success(JwtToken jwtToken) = LoginUiEventSuccess;
  factory LoginUiEvent.error() = LoginUiEventError;
  factory LoginUiEvent.showSnackBar(String message) = LoginUiEventShowSnackBar;
}

class LoginUiEventSuccess implements LoginUiEvent {
  final JwtToken jwtToken;

  LoginUiEventSuccess(this.jwtToken);
}

class LoginUiEventError implements LoginUiEvent {}

class LoginUiEventShowSnackBar implements LoginUiEvent {
  final String message;

  LoginUiEventShowSnackBar(this.message);
}