import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/models/jwt_token.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/login_api_repository.dart';

class PerformLogin {
  final LoginApiRepository _repository;

  PerformLogin(this._repository);

  Future<Result<JwtToken, NetworkErrors>> call(String email, String password) {
    return _repository.login(email, password);
  }
}
