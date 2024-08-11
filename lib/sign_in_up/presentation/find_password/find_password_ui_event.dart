sealed class FindPasswordUiEvent {
  factory FindPasswordUiEvent.success(String email) = FindPasswordSuccess;

  factory FindPasswordUiEvent.errorMessage(String? message) = FindPasswordErrorMessage;

  factory FindPasswordUiEvent.showSnackBar(String message) = FindPasswordShowSnackBar;

  factory FindPasswordUiEvent.validationSuccess(String email) = FindPasswordValidationSuccess;

  factory FindPasswordUiEvent.validationError(String? message) = FindPasswordValidationError;

  factory FindPasswordUiEvent.changePasswordSuccess(String email) = ChangePasswordSuccess;

  factory FindPasswordUiEvent.passwordErrorMessage(String? message) = PasswordErrorMessage;

  factory FindPasswordUiEvent.passwordCheckErrorMessage(String? message) = PasswordCheckErrorMessage;
}

class FindPasswordSuccess implements FindPasswordUiEvent {
  final String email;

  FindPasswordSuccess(this.email);
}

class FindPasswordErrorMessage implements FindPasswordUiEvent {
  final String? message;

  FindPasswordErrorMessage(this.message);
}

class FindPasswordShowSnackBar implements FindPasswordUiEvent {
  final String message;

  FindPasswordShowSnackBar(this.message);
}

class FindPasswordValidationSuccess implements FindPasswordUiEvent {
  final String email;

  FindPasswordValidationSuccess(this.email);
}

class FindPasswordValidationError implements FindPasswordUiEvent {
  final String? message;

  FindPasswordValidationError(this.message);
}

class ChangePasswordSuccess implements FindPasswordUiEvent {
  final String email;

  ChangePasswordSuccess(this.email);
}

class PasswordErrorMessage implements FindPasswordUiEvent {
  final String? message;

  PasswordErrorMessage(this.message);
}

class PasswordCheckErrorMessage implements FindPasswordUiEvent {
  final String? message;

  PasswordCheckErrorMessage(this.message);
}