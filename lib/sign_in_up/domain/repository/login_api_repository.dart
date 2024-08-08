import 'package:tutor_platform/core/user_info.dart';
import 'package:tutor_platform/core/result.dart';

abstract class LoginApiRepository {
  Future<Result<UserInfo>> login(String email, String password);
}