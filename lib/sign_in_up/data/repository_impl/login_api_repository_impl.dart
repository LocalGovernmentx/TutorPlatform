import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/core/user_info.dart';
import 'package:tutor_platform/sign_in_up/data/data_source/login_api_data_source.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/login_api_repository.dart';

class LoginApiRepositoryImpl implements LoginApiRepository {
  final LoginApiDataSource loginApi;

  LoginApiRepositoryImpl(this.loginApi);

  @override
  Future<Result<UserInfo>> login(String email, String password) async {
    final Result<Map<String, dynamic>> jsonCredentials =
        await loginApi.fetch(email, password);

    switch (jsonCredentials) {
      case Success<Map<String, dynamic>>():
        return Result.success(UserInfo.fromJson(jsonCredentials.value));
      case Error<Map<String, dynamic>>():
        return Result.error(jsonCredentials.message);
    }
  }
}
