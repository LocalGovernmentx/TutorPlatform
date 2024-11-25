import 'package:tutor_platform/sign_in_up/domain/repository/remember_me_repository.dart';

class RemoveRememberMe{
  final RememberMeRepository _repository;

  RemoveRememberMe(this._repository);

  Future<void> call() async {
    return await _repository.removeRememberMe();
  }
}