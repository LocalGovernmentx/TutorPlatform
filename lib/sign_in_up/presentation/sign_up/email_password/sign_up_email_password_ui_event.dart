sealed class SignUpEmailPasswordUiEvent {
  factory SignUpEmailPasswordUiEvent.sendEmailSuccess() = SignUpUiSendEmailSuccess;
  factory SignUpEmailPasswordUiEvent.verifyCodeSuccess() = SignUpUiEventVerifyCodeSuccess;
  factory SignUpEmailPasswordUiEvent.nextScreen() = SignUpUiEventNextScreen;
  factory SignUpEmailPasswordUiEvent.error() = SignUpUiEventError;
  factory SignUpEmailPasswordUiEvent.showSnackBar(String message) = SignUpUiEventShowSnackBar;
}

class SignUpUiSendEmailSuccess implements SignUpEmailPasswordUiEvent {}

class SignUpUiEventVerifyCodeSuccess implements SignUpEmailPasswordUiEvent {}

class SignUpUiEventNextScreen implements SignUpEmailPasswordUiEvent {}

class SignUpUiEventError implements SignUpEmailPasswordUiEvent {}

class SignUpUiEventShowSnackBar implements SignUpEmailPasswordUiEvent {
  final String message;

  SignUpUiEventShowSnackBar(this.message);
}

