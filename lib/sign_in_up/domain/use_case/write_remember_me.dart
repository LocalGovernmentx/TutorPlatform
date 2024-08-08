import 'package:tutor_platform/sign_in_up/domain/repository/remember_me_repository.dart';

class WriteRememberMe {
  final RememberMeRepository repository;

  WriteRememberMe(this.repository);

  Future<void> call(String email, String password) async {
    await repository.setRememberMe(email, password);
  }
}