import 'package:tutor_platform/core/models/user_info.dart';
import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/login_api_repository.dart';

class GetMyInfo {
  final LoginApiRepository _repository;

  GetMyInfo(this._repository);

  Future<Result<UserInfo, NetworkErrors>> call(String authorization) {
    return _repository.getMyInfo(authorization);
  }
}