sealed class Result<S, E> {
  factory Result.success(S value) = Success;

  factory Result.error(E error) = Error;
}

class Success<S, E> implements Result<S, E> {
  final S value;

  Success(this.value);
}

class Error<S, E> implements Result<S, E> {
  final E error;

  Error(this.error);
}