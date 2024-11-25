sealed class NetworkErrors {
  factory NetworkErrors.timeout() = TimeoutError;

  factory NetworkErrors.serverError(int statusCode, String message) = ServerError;

  factory NetworkErrors.clientError(int statusCode, String message) = ClientError;

  factory NetworkErrors.unknownStatusCode(int statusCode, String message) = UnknownStatusCode;

  factory NetworkErrors.credentialsError(String message) = CredentialsError;

  factory NetworkErrors.unknownError() = UnknownError;
}

class TimeoutError implements NetworkErrors {}

class ServerError implements NetworkErrors {
  final int statusCode;
  final String message;

  ServerError(this.statusCode, this.message);
}

class ClientError implements NetworkErrors {
  final int statusCode;
  final String message;

  ClientError(this.statusCode, this.message);
}

class UnknownStatusCode implements NetworkErrors {
  final int statusCode;
  final String message;

  UnknownStatusCode(this.statusCode, this.message);
}

class CredentialsError implements NetworkErrors {
  final String message;

  CredentialsError(this.message);
}

class UnknownError implements NetworkErrors {}