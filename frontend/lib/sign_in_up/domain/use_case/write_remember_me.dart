import 'package:tutor_platform/sign_in_up/domain/repository/remember_me_repository.dart';

class WriteRememberMe {
  final RememberMeRepository _repository;

  WriteRememberMe(this._repository);

  Future<void> call(String email, String password) async {
    await _repository.setRememberMe(email, password);
  }
}