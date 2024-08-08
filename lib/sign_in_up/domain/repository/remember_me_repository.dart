import 'package:tutor_platform/sign_in_up/domain/model/login_credentials.dart';

abstract class RememberMeRepository {
  Future<LoginCredentials?> getRememberMe();
  Future<void> setRememberMe(String email, String password);
}