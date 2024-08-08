import 'package:tutor_platform/sign_in_up/domain/repository/remember_me_repository.dart';

class RemoveRememberMe{
  final RememberMeRepository repository;

  RemoveRememberMe(this.repository);

  Future<void> call() async {
    return await repository.removeRememberMe();
  }
}