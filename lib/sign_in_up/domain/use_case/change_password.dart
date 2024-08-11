import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/login_api_repository.dart';

class ChangePassword {
  final LoginApiRepository _repository;

  ChangePassword(this._repository);

  Future<Result<dynamic, NetworkErrors>> call(String email, String password) async {
    return _repository.changePassword(email, password);
  }
}