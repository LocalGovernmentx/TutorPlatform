import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/login_api_repository.dart';

class CheckNickname {
  final LoginApiRepository _repository;

  CheckNickname(this._repository);

  Future<Result<dynamic, NetworkErrors>> call(String nickname) async {
    return await _repository.checkNickname(nickname);
  }
}