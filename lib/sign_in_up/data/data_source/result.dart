sealed class Result<T> {
  factory Result.success(T value) = Success;

  factory Result.error(String message) = Error;
}

class Success<T> implements Result<T> {
  final T value;

  Success(this.value);
}

class Error<T> implements Result<T> {
  final String message;

  Error(this.message);
}