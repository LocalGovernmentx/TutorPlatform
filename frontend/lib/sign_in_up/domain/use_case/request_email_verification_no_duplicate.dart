import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/login_api_repository.dart';

class RequestEmailVerificationNoDuplicate {
  final LoginApiRepository _repository;

  RequestEmailVerificationNoDuplicate(this._repository);

  Future<Result<dynamic, NetworkErrors>> call(String email) async {
    Result<String, NetworkErrors> result = await _repository.checkEmailDuplicate(email);
    if (result case Success<String, NetworkErrors>()) {
      if (result.value == 'Email is available') {
        return await _repository.requestEmailVerification(email);
      }
      return Result.error(NetworkErrors.unknownError());
    }
    return result;
  }
}