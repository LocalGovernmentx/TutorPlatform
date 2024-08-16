import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/login_api_repository.dart';

class SendVerificationFindPassword {
  final LoginApiRepository _repository;

  SendVerificationFindPassword(this._repository);

  Future<Result<String, NetworkErrors>> call(String email, String code) async {
    return await _repository.sendVerificationFindPassword(email, code);
  }
}