import 'package:tutor_platform/sign_in_up/data/data_source/remember_me_data_source.dart';
import 'package:tutor_platform/sign_in_up/domain/model/login_credentials.dart';
import 'package:tutor_platform/sign_in_up/domain/repository/remember_me_repository.dart';

class RememberMeRepositoryImpl implements RememberMeRepository {
  final RememberMeDataSource rememberMe;

  RememberMeRepositoryImpl(this.rememberMe);

  @override
  Future<LoginCredentials?> getRememberMe() async {
    return await rememberMe.read();
  }

  @override
  Future<void> setRememberMe(String email, String refreshToken) async {
    await removeRememberMe();
    await rememberMe.save(email, refreshToken);
    print("Remember me saved");
  }

  @override
  Future<void> removeRememberMe() async {
    await rememberMe.delete();
  }
}