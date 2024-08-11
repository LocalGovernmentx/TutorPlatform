import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/login_api_repository.dart';

class SendVerificationCode {
  final LoginApiRepository _repository;

  SendVerificationCode(this._repository);

  Future<Result<String, NetworkErrors>> call(String email, String code) async {
    return await _repository.sendVerificationCode(email, code);
  }
}