import 'package:tutor_platform/sign_in_up/domain/model/login_credentials.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/remember_me_repository.dart';

class RetrieveRememberMe {
  final RememberMeRepository repository;

  RetrieveRememberMe(this.repository);

  Future<LoginCredentials?> call() async {
    return await repository.getRememberMe();
  }
}