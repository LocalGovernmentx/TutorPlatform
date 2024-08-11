import 'package:tutor_platform/core/network_errors.dart';
import 'package:tutor_platform/core/user_info.dart';
import 'package:tutor_platform/core/result.dart';

abstract class LoginApiRepository {
  Future<Result<UserInfo, NetworkErrors>> login(String email, String password);

  Future<Result<dynamic, NetworkErrors>> requestEmailVerify(String email);

  Future<Result<String, NetworkErrors>> sendVerificationCode(String email, String code);

  Future<Result<dynamic, NetworkErrors>> changePassword(String email, String password);
}
