import 'package:tutor_platform/core/models/user_info.dart';
import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/result.dart';
import 'package:tutor_platform/core/models/jwt_token.dart';
import 'package:tutor_platform/sign_in_up/data/data_source/login_api_data_source.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/login_api_repository.dart';

class LoginApiRepositoryImpl implements LoginApiRepository {
  final LoginApiDataSource loginApi;

  LoginApiRepositoryImpl(this.loginApi);

  @override
  Future<Result<JwtToken, NetworkErrors>> autoLogin(String email, String refreshToken) async {
    return await loginApi.autoLogin(email, refreshToken);
  }

  @override
  Future<Result<String, NetworkErrors>> checkNickname(String nickname) async {
    return await loginApi.checkNickname(nickname);
  }

  @override
  Future<Result<JwtToken, NetworkErrors>> login(String email, String password) async {
    return await loginApi.login(email, password);
  }

  @override
  Future<Result<String, NetworkErrors>> requestEmailVerification(String email) async {
    return await loginApi.requestEmailVerification(email);
  }

  @override
  Future<Result<String, NetworkErrors>> sendVerificationSignUp(String email, String code) async {
    return await loginApi.sendVerificationSignUp(email, code);
  }

  @override
  Future<Result<String, NetworkErrors>> register(UserInfo userInfo) async {
    return await loginApi.register(userInfo);
  }

}
