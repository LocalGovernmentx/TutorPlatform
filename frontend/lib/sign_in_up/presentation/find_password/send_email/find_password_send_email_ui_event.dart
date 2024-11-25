sealed class FindPasswordSendEmailUiEvent {
  factory FindPasswordSendEmailUiEvent.success() = FindPasswordSendEmailUiEventSuccess;
  factory FindPasswordSendEmailUiEvent.error() = FindPasswordSendEmailUiEventError;
  factory FindPasswordSendEmailUiEvent.showSnackBar(String message) = FindPasswordSendEmailUiEventShowSnackBar;
}

class FindPasswordSendEmailUiEventSuccess implements FindPasswordSendEmailUiEvent {}

class FindPasswordSendEmailUiEventError implements FindPasswordSendEmailUiEvent {}

class FindPasswordSendEmailUiEventShowSnackBar implements FindPasswordSendEmailUiEvent {
  final String message;

  FindPasswordSendEmailUiEventShowSnackBar(this.message);
}