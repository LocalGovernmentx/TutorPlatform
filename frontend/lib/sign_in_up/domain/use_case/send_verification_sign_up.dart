import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/login_api_repository.dart';

class SendVerificationSignUp {
  final LoginApiRepository _repository;

  SendVerificationSignUp(this._repository);

  Future<Result<String, NetworkErrors>> call(String email, String code) async {
    return await _repository.sendVerificationSignUp(email, code);
  }
}