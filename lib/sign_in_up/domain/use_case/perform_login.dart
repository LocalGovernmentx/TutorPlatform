import 'package:tutor_platform/core/user_info.dart';
import 'package:tutor_platform/sign_in_up/data/data_source/result.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/login_api_repository.dart';

class PerformLogin {
  final LoginApiRepository loginApiRepository;

  PerformLogin(this.loginApiRepository);

  Future<Result<UserInfo>> call(String email, String password) {
    return loginApiRepository.login(email, password);
  }
}
