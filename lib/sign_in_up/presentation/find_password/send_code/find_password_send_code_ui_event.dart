sealed class FindPasswordSendCodeUiEvent {
  factory FindPasswordSendCodeUiEvent.success() = FindPasswordSendCodeSuccess;
  factory FindPasswordSendCodeUiEvent.error() = FindPasswordSendCodeError;
  factory FindPasswordSendCodeUiEvent.showSnackBar(String message) = FindPasswordSendCodeShowSnackBar;
}

class FindPasswordSendCodeSuccess implements FindPasswordSendCodeUiEvent {}

class FindPasswordSendCodeError implements FindPasswordSendCodeUiEvent {}

class FindPasswordSendCodeShowSnackBar implements FindPasswordSendCodeUiEvent {
  final String message;

  FindPasswordSendCodeShowSnackBar(this.message);
}