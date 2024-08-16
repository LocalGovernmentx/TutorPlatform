sealed class FindPasswordChangePasswordUiEvent {
  factory FindPasswordChangePasswordUiEvent.success() = FindPasswordChangePasswordUiEventSuccess;
  factory FindPasswordChangePasswordUiEvent.error() = FindPasswordChangePasswordUiEventError;
  factory FindPasswordChangePasswordUiEvent.showSnackBar(String message) = FindPasswordChangePasswordUiEventShowSnackBar;
}

class FindPasswordChangePasswordUiEventSuccess implements FindPasswordChangePasswordUiEvent {}

class FindPasswordChangePasswordUiEventError implements FindPasswordChangePasswordUiEvent {}

class FindPasswordChangePasswordUiEventShowSnackBar implements FindPasswordChangePasswordUiEvent {
  final String message;

  FindPasswordChangePasswordUiEventShowSnackBar(this.message);
}