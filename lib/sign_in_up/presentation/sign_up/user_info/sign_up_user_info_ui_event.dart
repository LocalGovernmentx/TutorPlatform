sealed class SignUpUserInfoUiEvent {
  factory SignUpUserInfoUiEvent.nicknameVerifySuccess() = SignUpUiEventNicknameVerifySuccess;
  factory SignUpUserInfoUiEvent.signUpSuccess() = SignUpUiEventSignUpSuccess;
  factory SignUpUserInfoUiEvent.error() = SignUpUiEventError;
  factory SignUpUserInfoUiEvent.showSnackBar(String message) = SignUpUiEventShowSnackBar;
}

class SignUpUiEventNicknameVerifySuccess implements SignUpUserInfoUiEvent {}

class SignUpUiEventSignUpSuccess implements SignUpUserInfoUiEvent {}

class SignUpUiEventError implements SignUpUserInfoUiEvent {}

class SignUpUiEventShowSnackBar implements SignUpUserInfoUiEvent {
  final String message;

  SignUpUiEventShowSnackBar(this.message);
}
