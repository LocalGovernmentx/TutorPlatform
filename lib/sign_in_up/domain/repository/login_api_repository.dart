import 'package:tutor_platform/core/models/user_info.dart';
import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/models/jwt_token.dart';
import 'package:tutor_platform/core/result.dart';

abstract class LoginApiRepository {
  Future<Result<JwtToken, NetworkErrors>> login(String email, String password);
  Future<Result<JwtToken, NetworkErrors>> autoLogin(String email, String refreshToken);
  Future<Result<String, NetworkErrors>> requestEmailVerification(String email);
  Future<Result<String, NetworkErrors>> sendVerificationSignUp(String email, String code);
  Future<Result<String, NetworkErrors>> checkNickname(String nickname);
  Future<Result<String, NetworkErrors>> register(UserInfo userInfo);
}
