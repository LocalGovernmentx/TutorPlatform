import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/login_api_repository.dart';

class SendRequestEmail {
  final LoginApiRepository _repository;

  SendRequestEmail(this._repository);

  Future<Result<dynamic, NetworkErrors>> call(String email) async {
    return await _repository.requestEmailVerify(email);
  }
}