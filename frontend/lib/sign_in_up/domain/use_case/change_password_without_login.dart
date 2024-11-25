import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/login_api_repository.dart';

class ChangePasswordWithoutLogin {
  final LoginApiRepository _repository;

  ChangePasswordWithoutLogin(this._repository);

  Future<Result<String, NetworkErrors>> call(String email, String password) async {
    return await _repository.changePassword(email, password);
  }
}