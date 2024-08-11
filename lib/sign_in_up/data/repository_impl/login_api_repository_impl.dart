import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/core/user_info.dart';
import 'package:tutor_platform/sign_in_up/data/data_source/login_api_data_source.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/login_api_repository.dart';

class LoginApiRepositoryImpl implements LoginApiRepository {
  final LoginApiDataSource loginApi;

  LoginApiRepositoryImpl(this.loginApi);

  @override
  Future<Result<UserInfo, NetworkErrors>> login(String email, String password) async {
    final Result<Map<String, dynamic>, NetworkErrors> jsonCredentials =
        await loginApi.fetchLogin(email, password);

    switch (jsonCredentials) {
      case Success<Map<String, dynamic>, NetworkErrors>():
        return Result.success(UserInfo.fromJson(jsonCredentials.value));
      case Error<Map<String, dynamic>, NetworkErrors>():
        return Result.error(jsonCredentials.error);
    }
  }

  @override
  Future<Result<dynamic, NetworkErrors>> requestEmailVerify(String email) async {
    return await loginApi.requestEmailVerify(email);
  }

  @override
  Future<Result<String, NetworkErrors>> sendVerificationCode(String email, String code) async {
    return await loginApi.sendVerificationCode(email, code);
  }

  @override
  Future<Result<dynamic, NetworkErrors>> changePassword(String email, String password) async {
    return await loginApi.changePassword(email, password);
  }

}
