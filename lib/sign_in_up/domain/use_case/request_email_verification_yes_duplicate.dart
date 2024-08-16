import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/login_api_repository.dart';

class RequestEmailVerificationYesDuplicate {
  final LoginApiRepository _repository;

  RequestEmailVerificationYesDuplicate(this._repository);

  Future<Result<dynamic, NetworkErrors>> call(String email) async {
    Result<String, NetworkErrors> result = await _repository.checkEmailDuplicate(email);
    switch (result) {
      case Success<String, NetworkErrors>():
        if (result.value == 'Email is available') {
          return Result.error(NetworkErrors.credentialsError(result.value));
        }
        return Result.error(NetworkErrors.unknownError());
      case Error<String, NetworkErrors>():
        final error = result.error;
        if (error case CredentialsError()) {
          if (error.message == 'Email is already in use') {
            return await _repository.requestEmailVerification(email);
          }
        }
        return Result.error(NetworkErrors.unknownError());
    }
  }
}